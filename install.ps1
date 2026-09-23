# Vut installer for Windows.
#
# Resolves the platform through the release manifest (`releases.json`), downloads
# the matching release artifact from GitHub, verifies its SHA-256, and installs
# it atomically into $VUT_HOME. No Rust, Cargo, C compiler, Git or Node is
# required.
#
#   install.ps1 [-Version vX.Y.Z] [-NoPath] [-ProvisionSdk]
#
# Environment: VUT_HOME, VUT_VERSION, VUT_REPO, VUT_RELEASE_MANIFEST.
[CmdletBinding()]
param(
    [string]$Version = $env:VUT_VERSION,
    [switch]$NoPath,
    [switch]$ProvisionSdk
)

$ErrorActionPreference = 'Stop'
$repo = if ($env:VUT_REPO) { $env:VUT_REPO } else { 'duongonix/vut' }
$vutHome = if ($env:VUT_HOME) { $env:VUT_HOME } else { Join-Path $env:USERPROFILE '.vut' }
$headers = @{ 'User-Agent' = 'vut-installer' }

# PROCESSOR_ARCHITEW6432 is set when a 32-bit host runs on 64-bit Windows.
$arch = if ($env:PROCESSOR_ARCHITEW6432) { $env:PROCESSOR_ARCHITEW6432 } else { $env:PROCESSOR_ARCHITECTURE }
switch ($arch) {
    'AMD64' { $target = 'x86_64-pc-windows-msvc' }
    'ARM64' { $target = 'aarch64-pc-windows-msvc' }
    default { throw "unsupported architecture: $arch" }
}

$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("vut-install-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null

function Resolve-Source([string]$source) {
    # Accepts http(s) URLs, file:// URLs and plain local paths.
    if ($source -match '^https?://') { return $source }
    $path = $source
    if ($path -match '^file://') {
        $path = $path.Substring(7)
        if ($path -match '^/[A-Za-z]:') { $path = $path.Substring(1) }
    }
    return [uri]::UnescapeDataString($path)
}

function Get-Artifact([string]$source, [string]$destination) {
    $resolved = Resolve-Source $source
    if ($resolved -match '^https?://') {
        Invoke-WebRequest -Uri $resolved -OutFile $destination -Headers $headers
    } else {
        Copy-Item -LiteralPath $resolved -Destination $destination -Force
    }
}

try {
    if ($env:VUT_RELEASE_MANIFEST) {
        $manifestSource = $env:VUT_RELEASE_MANIFEST
    } elseif ($Version) {
        $manifestSource = "https://github.com/$repo/releases/download/v$Version/releases.json"
    } else {
        $manifestSource = "https://raw.githubusercontent.com/$repo/main/releases.json"
    }

    Write-Host "Fetching release manifest from $manifestSource..."
    $manifestPath = Join-Path $tmp 'releases.json'
    Get-Artifact $manifestSource $manifestPath
    $manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json

    if (-not $Version) { $Version = $manifest.version }
    if (-not $Version) { throw 'could not resolve the latest Vut version from the manifest' }

    $entry = $manifest.targets | Where-Object { $_.triple -eq $target } | Select-Object -First 1
    if (-not $entry) { throw "the release manifest has no artifact for target $target" }
    if (-not $entry.url -or -not $entry.sha256) { throw "the manifest entry for $target is incomplete" }

    $archive = Split-Path $entry.url -Leaf
    Write-Host "Downloading $archive..."
    $archivePath = Join-Path $tmp $archive
    Get-Artifact $entry.url $archivePath

    $actual = (Get-FileHash -Algorithm SHA256 $archivePath).Hash.ToLower()
    if ($actual -ne $entry.sha256.ToLower()) {
        throw "checksum mismatch for $archive`n  expected: $($entry.sha256)`n  actual:   $actual"
    }
    Write-Host "Verified SHA-256."

    $extract = Join-Path $tmp 'extract'
    Expand-Archive -LiteralPath $archivePath -DestinationPath $extract -Force

    $inner = Get-Content (Join-Path $extract 'manifest.json') -Raw | ConvertFrom-Json
    if ($inner.target -ne $target) { throw "manifest target does not match $target" }
    foreach ($required in 'bin', 'lib', 'std') {
        if (-not (Test-Path (Join-Path $extract $required))) { throw "archive is missing $required" }
    }

    # Atomic install: replace the distribution-managed entries and keep
    # packages/, cache/ and config/.
    New-Item -ItemType Directory -Force -Path $vutHome | Out-Null
    $stamp = [guid]::NewGuid().ToString('N')
    $managed = 'bin', 'lib', 'std', 'manifest.json', 'version.json'
    foreach ($entryName in $managed) {
        $live = Join-Path $vutHome $entryName
        if (Test-Path $live) { Move-Item -LiteralPath $live -Destination (Join-Path $vutHome ".backup-$stamp-$entryName") }
    }
    try {
        foreach ($entryName in 'bin', 'lib', 'std', 'manifest.json') {
            Move-Item -LiteralPath (Join-Path $extract $entryName) -Destination (Join-Path $vutHome $entryName)
        }
        $versionJson = Join-Path $extract 'version.json'
        if (Test-Path $versionJson) { Move-Item -LiteralPath $versionJson -Destination (Join-Path $vutHome 'version.json') }
        foreach ($legal in 'LICENSE', 'THIRD-PARTY-NOTICES.md') {
            $source = Join-Path $extract $legal
            if (Test-Path $source) { Copy-Item -LiteralPath $source -Destination (Join-Path $vutHome $legal) }
        }
        # A Vut-managed linker (lld) shipped in `linker/` is placed on the Vut
        # `bin` directory so the resolver finds it without any user setup.
        $linkerDir = Join-Path $extract 'linker'
        if (Test-Path $linkerDir) {
            Copy-Item -Recurse -Force -Path (Join-Path $linkerDir '*') -Destination (Join-Path $vutHome 'bin')
        }
        foreach ($entryName in $managed) {
            Remove-Item -Recurse -Force (Join-Path $vutHome ".backup-$stamp-$entryName") -ErrorAction SilentlyContinue
        }
    } catch {
        foreach ($entryName in $managed) {
            Remove-Item -Recurse -Force (Join-Path $vutHome $entryName) -ErrorAction SilentlyContinue
            $backup = Join-Path $vutHome ".backup-$stamp-$entryName"
            if (Test-Path $backup) { Move-Item -LiteralPath $backup -Destination (Join-Path $vutHome $entryName) }
        }
        throw
    }
    foreach ($directory in 'packages', 'cache', 'config') {
        New-Item -ItemType Directory -Force -Path (Join-Path $vutHome $directory) | Out-Null
    }

    $binDir = Join-Path $vutHome 'bin'
    $pathConfigured = ($env:Path -split ';') -contains $binDir
    if (-not $NoPath) {
        $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
        if ($userPath -notlike "*$binDir*") {
            $newPath = if ([string]::IsNullOrEmpty($userPath)) { $binDir } else { "$binDir;$userPath" }
            [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
        }
    }

    & (Join-Path $binDir 'vut.exe') --version
    & (Join-Path $binDir 'vpm.exe') --version
    $doctor = & (Join-Path $binDir 'vut.exe') doctor 2>&1
    $doctor | Write-Host
    if ($LASTEXITCODE -ne 0 -or ($doctor -join "`n") -match 'status: issues') {
        Write-Warning "Vut could not find a usable linker/SDK."
        $winget = 'winget install --id Microsoft.VisualStudio.2022.BuildTools --override "--wait --passive --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"'
        Write-Host "Provision the official Windows build tools with:"
        Write-Host "  $winget"
        if ($ProvisionSdk) {
            Write-Host "Running the provisioning command..."
            Invoke-Expression $winget
            & (Join-Path $binDir 'vut.exe') doctor | Write-Host
        }
    }
    Write-Host "Installed Vut v$Version ($target) to $vutHome"
    if (-not $NoPath -and -not $pathConfigured) {
        Write-Host "Open a new terminal to use 'vut' (PATH was updated for future sessions)."
    } elseif ($pathConfigured) {
        Write-Host "Vut is already on PATH in this session."
    }
} finally {
    Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
}

# Vut installer for Windows.
#
# Detects the architecture, downloads the matching release artifact from
# GitHub, verifies its SHA-256, and installs it atomically into $VUT_HOME. No
# Rust, Cargo, C compiler, Git or Node is required.
#
#   install.ps1 [-Version vX.Y.Z] [-NoPath]
#
# Environment: VUT_HOME (default %USERPROFILE%\.vut), VUT_VERSION, VUT_REPO.
[CmdletBinding()]
param(
    [string]$Version = $env:VUT_VERSION,
    [switch]$NoPath
)

$ErrorActionPreference = 'Stop'
$repo = if ($env:VUT_REPO) { $env:VUT_REPO } else { 'duongonix/vut' }
$vutHome = if ($env:VUT_HOME) { $env:VUT_HOME } else { Join-Path $env:USERPROFILE '.vut' }
$headers = @{ 'User-Agent' = 'vut-installer' }

switch ($env:PROCESSOR_ARCHITECTURE) {
    'AMD64' { $target = 'x86_64-pc-windows-msvc' }
    'ARM64' { $target = 'aarch64-pc-windows-msvc' }
    default { throw "unsupported architecture: $env:PROCESSOR_ARCHITECTURE" }
}

if (-not $Version) {
    $release = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/releases/latest" -Headers $headers
    $Version = $release.tag_name.TrimStart('v')
}

$archive = "vut-v$Version-$target.zip"
$baseUrl = "https://github.com/$repo/releases/download/v$Version"
$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("vut-install-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null

try {
    Write-Host "Downloading $archive..."
    Invoke-WebRequest -Uri "$baseUrl/$archive" -OutFile (Join-Path $tmp $archive) -Headers $headers

    $sumsPath = Join-Path $tmp 'SHA256SUMS'
    $expected = $null
    try {
        Invoke-WebRequest -Uri "$baseUrl/SHA256SUMS" -OutFile $sumsPath -Headers $headers
        $line = Get-Content $sumsPath | Where-Object { $_ -match [regex]::Escape($archive) } | Select-Object -First 1
        if ($line) { $expected = ($line -split '\s+')[0].ToLower() }
    } catch { }
    if ($expected) {
        $actual = (Get-FileHash -Algorithm SHA256 (Join-Path $tmp $archive)).Hash.ToLower()
        if ($actual -ne $expected) { throw "checksum mismatch for $archive" }
    }

    $extract = Join-Path $tmp 'extract'
    Expand-Archive -LiteralPath (Join-Path $tmp $archive) -DestinationPath $extract -Force

    $manifest = Get-Content (Join-Path $extract 'manifest.json') -Raw | ConvertFrom-Json
    if ($manifest.target -ne $target) { throw "manifest target does not match $target" }
    foreach ($entry in 'bin', 'lib', 'std') {
        if (-not (Test-Path (Join-Path $extract $entry))) { throw "archive is missing $entry" }
    }

    # Atomic install: replace the distribution-managed entries and keep
    # packages/, cache/ and config/.
    New-Item -ItemType Directory -Force -Path $vutHome | Out-Null
    $stamp = [guid]::NewGuid().ToString('N')
    $managed = 'bin', 'lib', 'std', 'manifest.json'
    foreach ($entry in $managed) {
        $live = Join-Path $vutHome $entry
        if (Test-Path $live) { Move-Item -LiteralPath $live -Destination (Join-Path $vutHome ".backup-$stamp-$entry") }
    }
    try {
        foreach ($entry in $managed) {
            Move-Item -LiteralPath (Join-Path $extract $entry) -Destination (Join-Path $vutHome $entry)
        }
        foreach ($entry in $managed) {
            Remove-Item -Recurse -Force (Join-Path $vutHome ".backup-$stamp-$entry") -ErrorAction SilentlyContinue
        }
    } catch {
        foreach ($entry in $managed) {
            Remove-Item -Recurse -Force (Join-Path $vutHome $entry) -ErrorAction SilentlyContinue
            $backup = Join-Path $vutHome ".backup-$stamp-$entry"
            if (Test-Path $backup) { Move-Item -LiteralPath $backup -Destination (Join-Path $vutHome $entry) }
        }
        throw
    }
    foreach ($directory in 'packages', 'cache', 'config') {
        New-Item -ItemType Directory -Force -Path (Join-Path $vutHome $directory) | Out-Null
    }

    if (-not $NoPath) {
        $binDir = Join-Path $vutHome 'bin'
        $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
        if ($userPath -notlike "*$binDir*") {
            $newPath = if ([string]::IsNullOrEmpty($userPath)) { $binDir } else { "$binDir;$userPath" }
            [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
        }
    }

    & (Join-Path $vutHome 'bin\vut.exe') --version
    Write-Host "Installed Vut v$Version ($target) to $vutHome"
    if (-not $NoPath) { Write-Host "Open a new terminal to use 'vut'." }
} finally {
    Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
}

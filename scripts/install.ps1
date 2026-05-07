$ErrorActionPreference = "Stop"

$Repo = "duongonix/vut"
$Version = if ($env:VUT_VERSION) { $env:VUT_VERSION } else { "v0.1.1" }

$VutHome = if ($env:VUT_HOME) {
    $env:VUT_HOME
} else {
    Join-Path $env:USERPROFILE ".vut"
}

$InstallDir = if ($env:VUT_INSTALL_DIR) {
    $env:VUT_INSTALL_DIR
} else {
    Join-Path $VutHome "bin"
}

$Platform = "windows"
$Arch = if ([Environment]::Is64BitOperatingSystem) { "x86_64" } else {
    Write-Error "Only Windows x86_64 is supported"
}

$Asset = "vut-vpm-$Platform-$Arch.zip"
$BaseUrl = "https://github.com/$Repo/releases/download/$Version"
$Url = "$BaseUrl/$Asset"
$ShaUrl = "$Url.sha256"

$TempDir = Join-Path $env:TEMP ("vut-install-" + [Guid]::NewGuid().ToString())

Write-Host "Installing Vut $Version"
Write-Host "Platform: $Platform-$Arch"
Write-Host "Vut home: $VutHome"
Write-Host "Install dir: $InstallDir"
Write-Host ""

New-Item -ItemType Directory -Force -Path $TempDir | Out-Null

try {
    Write-Host "Creating Vut home structure..."

    New-Item -ItemType Directory -Force -Path $VutHome | Out-Null
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $VutHome "std") | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $VutHome "packages") | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $VutHome "cache") | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $VutHome "registry") | Out-Null

    $ConfigPath = Join-Path $VutHome "config.toml"

    if (!(Test-Path $ConfigPath)) {
        @"
[global]
home = "$VutHome"

[paths]
bin = "$InstallDir"
std = "$($VutHome)\std"
packages = "$($VutHome)\packages"
cache = "$($VutHome)\cache"
registry = "$($VutHome)\registry"
"@ | Set-Content -Encoding UTF8 $ConfigPath
    }

    $ZipPath = Join-Path $TempDir $Asset
    $ShaPath = Join-Path $TempDir "$Asset.sha256"

    Write-Host "Downloading:"
    Write-Host "  $Url"

    Invoke-WebRequest -Uri $Url -OutFile $ZipPath
    Invoke-WebRequest -Uri $ShaUrl -OutFile $ShaPath

    Write-Host "Verifying checksum..."

    $ExpectedLine = Get-Content $ShaPath | Select-Object -First 1
    $ExpectedHash = ($ExpectedLine -split "\s+")[0].ToLower()
    $ActualHash = (Get-FileHash $ZipPath -Algorithm SHA256).Hash.ToLower()

    if ($ExpectedHash -ne $ActualHash) {
        Write-Error "Checksum mismatch. Expected $ExpectedHash but got $ActualHash"
    }

    Write-Host "Extracting..."

    Expand-Archive -Path $ZipPath -DestinationPath $InstallDir -Force

    $VutExe = Join-Path $InstallDir "vut.exe"
    $VpmExe = Join-Path $InstallDir "vpm.exe"

    if (!(Test-Path $VutExe)) {
        Write-Error "vut.exe was not found after extraction"
    }

    if (!(Test-Path $VpmExe)) {
        Write-Error "vpm.exe was not found after extraction"
    }

    Write-Host "Adding Vut to user PATH..."

    $UserPath = [Environment]::GetEnvironmentVariable("Path", "User")

    if ($UserPath -notlike "*$InstallDir*") {
        $NewPath = if ([string]::IsNullOrWhiteSpace($UserPath)) {
            $InstallDir
        } else {
            "$UserPath;$InstallDir"
        }

        [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")

        $env:Path = "$env:Path;$InstallDir"

        Write-Host "PATH updated."
    } else {
        Write-Host "PATH already contains Vut install dir."
    }

    Write-Host ""
    Write-Host "Vut installed successfully."
    Write-Host ""
    Write-Host "Installed files:"
    Write-Host "  $VutExe"
    Write-Host "  $VpmExe"
    Write-Host ""
    Write-Host "Vut home:"
    Write-Host "  $VutHome"
    Write-Host ""
    Write-Host "Test:"
    Write-Host "  vut --version"
    Write-Host "  vpm --version"
    Write-Host ""
    Write-Host "If commands are not recognized, close and reopen PowerShell."
}
finally {
    if (Test-Path $TempDir) {
        Remove-Item -Recurse -Force $TempDir
    }
}
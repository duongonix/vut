$ErrorActionPreference = "Stop"

$Repo = "duongonix/vut"

# Tự động lấy version mới nhất từ GitHub API nếu không có biến môi trường
if ($env:VUT_VERSION) {
    $Version = $env:VUT_VERSION
} else {
    try {
        Write-Host "Fetching latest version from GitHub..." -ForegroundColor Cyan
        $ReleaseInfo = Invoke-RestMethod -Uri "https://api.github.com/repos/$Repo/releases/latest" -UseBasicParsing
        $Version = $ReleaseInfo.tag_name
        Write-Host "Latest version found: $Version"
    } catch {
        Write-Warning "Could not fetch latest version, falling back to v0.1.1"
        $Version = "v0.1.1"
    }
}

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

Write-Host "Installing Vut $Version" -ForegroundColor Green
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
home = "$($VutHome -replace '\\', '/')"

[paths]
bin = "$($InstallDir -replace '\\', '/')"
std = "$($VutHome -replace '\\', '/')/std"
packages = "$($VutHome -replace '\\', '/')/packages"
cache = "$($VutHome -replace '\\', '/')/cache"
registry = "$($VutHome -replace '\\', '/')/registry"
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
        throw "Checksum mismatch. Expected $ExpectedHash but got $ActualHash"
    }

    Write-Host "Extracting..."
    # Force giải nén để ghi đè nếu đã tồn tại
    Expand-Archive -Path $ZipPath -DestinationPath $InstallDir -Force

    $VutExe = Join-Path $InstallDir "vut.exe"
    $VpmExe = Join-Path $InstallDir "vpm.exe"

    if (!(Test-Path $VutExe)) { throw "vut.exe was not found after extraction" }
    if (!(Test-Path $VpmExe)) { throw "vpm.exe was not found after extraction" }

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
        Write-Host "PATH updated." -ForegroundColor Yellow
    } else {
        Write-Host "PATH already contains Vut install dir."
    }

    Write-Host ""
    Write-Host "Vut installed successfully!" -ForegroundColor Green
    Write-Host "---------------------------"
    Write-Host "Vut executable: $VutExe"
    Write-Host "Vpm executable: $VpmExe"
    Write-Host "Vut config:     $ConfigPath"
    Write-Host ""
    Write-Host "Test by running: vut --version"
    Write-Host "Note: You might need to restart your terminal for PATH changes to take effect."
}
catch {
    Write-Error "Installation failed: $($_.Exception.Message)"
}
finally {
    if (Test-Path $TempDir) {
        Remove-Item -Recurse -Force $TempDir
    }
}
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$vut = Join-Path $root "target\release\vut.exe"
$source = Join-Path $root "benchmarks\prime_count.vut"
$output = Join-Path $root "target\benchmarks\incremental.exe"

Push-Location $root
try {
    cargo build --release -p vut-cli | Out-Null
    $cold = (Measure-Command { & $vut build $source --release --output $output | Out-Null }).TotalMilliseconds
    $warm = (Measure-Command { & $vut build $source --release --output $output | Out-Null }).TotalMilliseconds
    Write-Host ("Cold build: {0:N2} ms" -f $cold)
    Write-Host ("Warm no-change build: {0:N2} ms" -f $warm)
    Write-Host ("Speedup: {0:N2}x" -f ($cold / $warm))
}
finally {
    Pop-Location
}

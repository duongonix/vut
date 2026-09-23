$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$output = Join-Path $root "target\benchmarks"
New-Item -ItemType Directory -Force -Path $output | Out-Null

Push-Location $root
try {
    cargo build --release -p vut-cli
    & ".\target\release\vut.exe" build ".\benchmarks\prime_count.vut" --release --output "$output\prime_count_vut.exe"
    rustc ".\benchmarks\prime_count.rs" -C opt-level=3 -C debuginfo=0 -o "$output\prime_count_rust.exe"

    $vutResult = (& "$output\prime_count_vut.exe" | Out-String).Trim()
    $rustResult = (& "$output\prime_count_rust.exe" | Out-String).Trim()
    if ($vutResult -ne $rustResult) {
        throw "Result mismatch: Vut='$vutResult', Rust='$rustResult'"
    }

    # Warm both executables before collecting samples.
    & "$output\prime_count_vut.exe" | Out-Null
    & "$output\prime_count_rust.exe" | Out-Null

    $runs = 5
    $vutTimes = 1..$runs | ForEach-Object {
        (Measure-Command { & "$output\prime_count_vut.exe" | Out-Null }).TotalMilliseconds
    }
    $rustTimes = 1..$runs | ForEach-Object {
        (Measure-Command { & "$output\prime_count_rust.exe" | Out-Null }).TotalMilliseconds
    }

    $vutAverage = ($vutTimes | Measure-Object -Average).Average
    $rustAverage = ($rustTimes | Measure-Object -Average).Average
    $ratio = $vutAverage / $rustAverage

    Write-Host "Verified result: $vutResult"
    Write-Host ("Vut  average ({0} runs): {1:N2} ms" -f $runs, $vutAverage)
    Write-Host ("Rust average ({0} runs): {1:N2} ms" -f $runs, $rustAverage)
    Write-Host ("Vut/Rust runtime ratio: {0:N2}x" -f $ratio)
}
finally {
    Pop-Location
}

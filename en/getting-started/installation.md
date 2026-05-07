# Installing Vut

## Goal

This page explains how to build the two main Vut CLIs: `vut` for running programs and `vpm` for package management.

## Requirements

- Rust stable
- Cargo
- Git if you use GitHub packages

Check them:

```powershell
rustc --version
cargo --version
git --version
```

## Build From Source

Inside the repository:

```powershell
cargo build -p vut -p vpm --release
```

Outputs:

```text
target/release/vut
target/release/vpm
```

On Windows:

```text
target/release/vut.exe
target/release/vpm.exe
```

## Verify Installation

```powershell
target/release/vut --version
target/release/vpm --version
```

## Add to PATH

You can copy both binaries into a directory already in `PATH`, or add `target/release` to `PATH` during development.

## Multi-Platform Releases

The repository includes a GitHub Actions workflow for Windows, Linux, macOS Intel, and macOS Apple Silicon. Pushing a tag such as `v0.1.0` creates a GitHub Release with downloadable artifacts.

## Notes

Vut does not require a separate runtime. Native plugins may require dynamic libraries such as `.dll`, `.so`, or `.dylib` inside a package.


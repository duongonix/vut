# Vut

The Vut programming language: a compiled, statically typed, native language
with a small runtime and a package manager.

This repository hosts Vut **releases** and **installers** only. It does not
contain the compiler source.

## Install

Linux / macOS:

```sh
curl -fsSL https://raw.githubusercontent.com/duongonix/vut/main/install.sh | sh
```

Windows (PowerShell):

```powershell
irm https://raw.githubusercontent.com/duongonix/vut/main/install.ps1 | iex
```

The installer detects your platform, downloads the matching release, verifies
its SHA-256, and installs Vut into `~/.vut` (`%USERPROFILE%\.vut` on Windows).
It requires no Rust, Cargo, C compiler, Git or Node.

Options:

```text
install.sh   --version=vX.Y.Z   --no-path
install.ps1  -Version vX.Y.Z    -NoPath
```

## Verify

```sh
vut --version
```

## Layout

```text
~/.vut/
├── manifest.json
├── bin/                 vut, vpm, vut-lsp
├── lib/runtime/<target>/  vut-core, vut-stdlib, vut-startup
├── std/                 official standard library
├── packages/            VPM packages (user-managed)
├── cache/               build cache
└── config/              user configuration
```

## Releases

Prebuilt distributions and `SHA256SUMS` are published under
[Releases](https://github.com/duongonix/vut/releases). Supported targets:

```text
x86_64-pc-windows-msvc
aarch64-pc-windows-msvc
x86_64-unknown-linux-gnu
aarch64-unknown-linux-gnu
x86_64-apple-darwin
aarch64-apple-darwin
```

## License

MIT. See [LICENSE](LICENSE).

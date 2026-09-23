# Vut

Vut is a compiled, statically typed, native programming language with a small
runtime and a package manager.

This repository (`duongonix/vut`) is the **public distribution repository**. It
hosts releases, installers and end-user documentation. It does **not** contain
the compiler source; development happens in `duongonix/vut_repo`.

## Install

Linux / macOS:

```sh
curl -fsSL https://raw.githubusercontent.com/duongonix/vut/main/install.sh | sh
```

Windows (PowerShell 5.1+):

```powershell
irm https://raw.githubusercontent.com/duongonix/vut/main/install.ps1 | iex
```

The installer detects your platform, resolves the matching release through
`releases.json`, verifies its SHA-256, and installs Vut into `~/.vut`
(`%USERPROFILE%\.vut` on Windows). It requires no Rust, Cargo, C compiler, Git or
Node.

Options:

```text
install.sh   --version=vX.Y.Z   --no-path   --provision
install.ps1  -Version vX.Y.Z    -NoPath     -ProvisionSdk
```

## Verify

```sh
vut --version
vpm --version
vut doctor
```

`vut doctor` compiles, links and runs a small program and prints
`status: ok (READY)` when the toolchain is ready.

## Quick start

Create `hello.vut`:

```vut
fn main():
  out("hello, world")
```

Then:

```sh
vut run hello.vut
```

## Layout

```text
~/.vut/
├── manifest.json
├── version.json
├── bin/                 vut, vpm, vut-lsp
├── lib/runtime/<target>/  vut-core, vut-stdlib, vut-startup
├── std/                 official standard library
├── packages/            VPM packages (user-managed)
├── cache/               build cache
└── config/              user configuration
```

## Releases

Prebuilt distributions, `releases.json`, `SHA256SUMS` and build-provenance
attestations are published under
[Releases](https://github.com/duongonix/vut/releases). Supported targets:

```text
x86_64-pc-windows-msvc        aarch64-pc-windows-msvc
x86_64-unknown-linux-gnu      aarch64-unknown-linux-gnu
x86_64-unknown-linux-musl     aarch64-unknown-linux-musl
x86_64-apple-darwin           aarch64-apple-darwin
```

## Documentation

See [`docs/`](docs/):

- [Installation](docs/installation.md)
- [Getting started](docs/getting-started.md)
- [Command line](docs/cli.md)
- [Language guide](docs/language.md)
- [Standard library](docs/stdlib.md)
- [Troubleshooting](docs/troubleshooting.md)

## License

MIT. See [LICENSE](LICENSE).

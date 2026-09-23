# Changelog

All notable changes to Vut are recorded here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project aims to
follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.1.0]

### Added

- Compiler pipeline: lexer, parser, resolver, type checker, HIR, MIR,
  ownership/drop lowering, async state machines, and a Cranelift backend.
- Release optimizer: SCCP, CSE, inlining, LICM, SROA, RC/drop/memory passes,
  escape analysis, and a fail-safe pass manager with verification.
- Native linking without Rust/Cargo: `link.exe` (MSVC), `cc` (GNU/Darwin) and
  LLVM `lld`, with MSVC/Windows SDK discovery via `vswhere`.
- Standard library: `io`, `path`, `fs`, `os`, `env`, `time`, `process`, `json`,
  `http`, and `math` (constants, float/int utilities, native transcendentals,
  and a reproducible pseudo-random generator).
- VPM package manager: project lifecycle, lockfile v2, per-target native
  artifacts, global CLI install/exec, and review-gated publishing.
- `vut` CLI: `build`, `run`, and `doctor` (with `--json`).
- Distribution tooling (`vut-dist`): per-target artifacts, `releases.json`,
  SHA-256 checksums, license/version metadata.
- Installers (`install.sh`, `install.ps1`): manifest-driven resolution, mandatory
  SHA-256 verification, atomic install, PATH configuration, and `vut doctor`.
- Supported targets: `x86_64`/`aarch64` for Windows (MSVC), Linux (glibc and
  musl), and macOS.

[Unreleased]: https://github.com/duongonix/vut_repo/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/duongonix/vut_repo/releases/tag/v0.1.0

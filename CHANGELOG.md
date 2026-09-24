# Changelog

All notable changes to Vut are recorded here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project aims to
follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.2.0]

### Added

- WebAssembly (WASI) backend (preview): `vut build --target wasm32-wasip1` and
  `vut run --target wasm32-wasip1` emit a validated `.wasm` module and run it
  under a discovered WASI runtime, with an actionable error when the runtime is
  missing.
- WASM codegen: scalars, arithmetic, control flow, functions, locals and calls;
  linear memory with an allocator and `memory.grow`; bounds and panic traps;
  `str`, `bytes` and `list` with real RC/COW; optionals, results, data/enums,
  arrays, maps, iterators, closures and higher-order operations.
- WASM async: target-independent state-machine lowering with a single-threaded
  cooperative executor (`StartFuture`, `AwaitFuture`, `FrameState`, resume
  thunks).
- WASM ABI/exports: explicit export surface plus function-level dead-code
  elimination that retains reachable roots.
- WASM standard-library subset (WASI): `math` (all native transcendentals) and
  the `count`/`env`/`time`/`io`/`os`/`random` infrastructure; unsupported
  native-runtime modules produce explicit diagnostics instead of failing
  silently.
- VPM target integration and a basic `-Os` size optimization for WASM.

### Notes

- The WebAssembly target is a preview: WASM.14 production certification is not
  complete. See `specs/roadmap/wasm.md` for phase status. Native semantics and
  ABI are unchanged.

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

[Unreleased]: https://github.com/duongonix/vut_repo/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/duongonix/vut_repo/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/duongonix/vut_repo/releases/tag/v0.1.0

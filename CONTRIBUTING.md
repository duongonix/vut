# Contributing to Vut

Thanks for your interest. This repository (`duongonix/vut_repo`) is the source of
truth; the public `duongonix/vut` repository receives only release artifacts and
end-user files.

## Prerequisites

- a stable Rust toolchain (the repository builds with edition 2024);
- a native linker for your platform (MSVC Build Tools + Windows SDK, Xcode
  Command Line Tools, or `cc`/binutils);
- `vut doctor` should report `READY` before you run the native test suites.

## Build and test

```sh
cargo build --workspace
cargo fmt --all --check
cargo clippy --workspace --all-targets -- -D warnings
cargo test --workspace --all-targets
```

Run a program from the tree:

```sh
cargo run -p vut-cli -- run examples/math.vut
```

## Guidelines

- Read the relevant files under `specs/` before changing behavior; specs are the
  source of truth for syntax, semantics, ABI and architecture.
- Keep modules focused and small; do not grow monolithic files (see
  `AGENTS.md`).
- Every substantial change needs tests (unit, type-system, runtime, E2E or
  compile-fail as appropriate).
- Modified Rust must pass `cargo fmt` and `cargo clippy`.
- Do not silently change language semantics, ABI, or diagnostics.

## Commit and pull requests

- Write concise commit messages describing the change.
- Keep a pull request scoped to one change; explain the motivation and the tests
  you added.
- CI must be green: formatting, clippy, workspace tests, ABI tests, and the
  package smoke tests.

## Releasing

Maintainers follow `RELEASING.md` and `specs/deploy/`.

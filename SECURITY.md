# Security Policy

## Supported versions

Vut is pre-1.0. Security fixes are applied to the latest released version; older
releases are not maintained.

## Reporting a vulnerability

Do not open a public issue for a security problem. Instead, use GitHub's private
vulnerability reporting on `duongonix/vut_repo` (Security → Report a
vulnerability), or email the maintainers listed on the repository.

Please include:

- a description of the issue and its impact;
- the affected version(s) and platform(s);
- a minimal reproduction if possible.

We will acknowledge the report, investigate, and coordinate a fix and disclosure
timeline with you.

## Scope

In scope:

- the compiler, runtime, standard library and `vpm`;
- the distribution installers (`install.sh`, `install.ps1`) and release
  artifacts;
- the native ABI boundary (`extern "C"`, `resource[T]`).

Out of scope:

- third-party crates (report upstream);
- the platform linker/SDK (report to the platform vendor);
- `math` randomness, which is explicitly **not** cryptographically secure.

## Integrity

Release artifacts are published with a SHA-256 checksum in `releases.json` and
`SHA256SUMS`, and with GitHub build-provenance attestations. The installers
verify the SHA-256 before installing. See `docs/installation.md`.

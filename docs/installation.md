# Installation

## One-command install

Linux / macOS:

```sh
curl -fsSL https://raw.githubusercontent.com/duongonix/vut/main/install.sh | sh
```

Windows (PowerShell 5.1+):

```powershell
irm https://raw.githubusercontent.com/duongonix/vut/main/install.ps1 | iex
```

The installer detects your OS and architecture, resolves the correct artifact
through the release manifest, verifies its SHA-256, and installs Vut into
`~/.vut` (`%USERPROFILE%\.vut` on Windows).

Installing Vut requires only tools already present on a normal system:

```text
Linux/macOS:  curl, tar
Windows:      PowerShell 5.1+
```

No Rust, Cargo, C compiler, Git or Node is required.

## Verify

```sh
vut --version
vpm --version
vut doctor
```

`vut doctor` checks the compiler, `vpm`, the standard library, the runtime and
native runtime archives, the runtime ABI, the linker, the platform SDK, search
paths and `PATH`, and then compiles, links and runs a small program. It prints
`status: ok (READY)` when everything works, or an actionable list of issues.

If the installer added `~/.vut/bin` to your `PATH`, open a new shell (or run the
`export PATH=...` line it prints) before using `vut` by name.

## Options

```text
install.sh   --version=vX.Y.Z   --no-path   --provision   -h/--help
install.ps1  -Version vX.Y.Z    -NoPath     -ProvisionSdk
```

- `--version` installs a specific release instead of the latest.
- `--no-path` does not modify shell startup files / the user `PATH`.
- `--provision` / `-ProvisionSdk` attempts official provisioning of a missing
  platform SDK/toolchain (never silently).

Environment overrides: `VUT_HOME`, `VUT_VERSION`, `VUT_REPO`,
`VUT_RELEASE_MANIFEST`.

## Install layout

```text
~/.vut/
├── manifest.json        distribution metadata (version, target, ABI)
├── version.json         build provenance (commit, Cranelift, profile)
├── bin/                 vut, vpm, vut-lsp
├── lib/runtime/<target>/
│   ├── vut-core.*       language/runtime primitives
│   ├── vut-stdlib.*     native standard library
│   └── vut-startup.*    platform entry point
├── std/                 official standard library (.vut source)
├── packages/            VPM packages (user-managed)
├── cache/               build cache
└── config/              user configuration
```

Set `VUT_HOME` to install elsewhere.

## Platform prerequisites

Compiling programs needs a native linker and its platform SDK. Vut discovers
these automatically; you should not have to edit `PATH`, `LIB` or `INCLUDE`, or
run `vcvars`.

- **Windows** — the Windows SDK / Build Tools (C++ workload). `vut doctor`
  detects them via `vswhere`. If missing, install them with:

  ```powershell
  winget install --id Microsoft.VisualStudio.2022.BuildTools --override "--wait --passive --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"
  ```

- **macOS** — the Xcode Command Line Tools: `xcode-select --install`.
- **Linux** — a C toolchain (`cc` and binutils) and the matching libc
  development files. Use your distribution's package manager.

## Upgrading

Run the installer again (optionally with `--version`) to upgrade in place.
Distribution-managed files (`bin/`, `lib/`, `std/`, `manifest.json`,
`version.json`) are replaced atomically; `packages/`, `cache/` and `config/` are
preserved. A failed download or install restores the previous installation.

## Uninstalling

Remove the install directory and the `PATH` entry the installer added:

```sh
rm -rf ~/.vut
```

## Integrity

Every artifact is published with a SHA-256 checksum in `releases.json` (and
`SHA256SUMS`) and with a GitHub build-provenance attestation. The installer
verifies the checksum before extracting, and refuses to install on a mismatch.

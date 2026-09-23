# Troubleshooting

Start with:

```sh
vut doctor
```

It reports the compiler, `vpm`, the standard library, the runtime archives, the
runtime ABI, the linker, the platform SDK, search paths and `PATH`, and then
compiles, links and runs a small program. A non-zero exit means the toolchain is
not ready; the printed issues are actionable.

## "no native linker found"

Vut needs a native linker and its platform SDK for the final link. Discovery is
automatic:

```text
VUT_LINKER override
  -> a Vut-managed/bundled linker (if the distribution ships one)
  -> platform toolchain discovery (link.exe + Windows SDK; cc/clang)
  -> rustc development fallback
  -> actionable error
```

Fix by installing the platform toolchain:

- **Windows**: Windows SDK / Build Tools with the C++ workload (see
  [Installation](installation.md)).
- **macOS**: `xcode-select --install`.
- **Linux**: `cc` and binutils from your distribution.

You do not need to run `vcvars`, edit `PATH`, `LIB` or `INCLUDE`, or install
Rust.

## `vut` is not found after installing

The installer adds `~/.vut/bin` to your `PATH` for future shells. Open a new
shell, or run the `export PATH="~/.vut/bin:$PATH"` line the installer printed.

## ABI mismatch

If `vut doctor` reports a runtime ABI mismatch, the installed runtime does not
match the compiler. Reinstall the current release:

```sh
curl -fsSL https://raw.githubusercontent.com/duongonix/vut/main/install.sh | sh
```

## Checksum mismatch during install

The download was corrupted or tampered with; the installer aborts. Retry. If it
persists, report it (see `SECURITY.md`).

## Choosing a specific linker

For debugging, force a backend:

```sh
VUT_LINKER=system vut build app.vut
VUT_LINKER=lld    vut build app.vut
VUT_LINKER=rustc  vut build app.vut   # development fallback (needs Rust)
```

## Using a custom install location

```sh
VUT_HOME=/opt/vut curl -fsSL https://raw.githubusercontent.com/duongonix/vut/main/install.sh | sh
```

Remember to put `$VUT_HOME/bin` on `PATH`.

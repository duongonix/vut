# Command line

## `vut`

```text
vut build [SOURCE] [OPTIONS]        compile to a native executable
vut run   [SOURCE] [OPTIONS] [-- ARGS...]   compile and run
vut doctor [--target TRIPLE] [--json]       diagnose the toolchain
```

If `SOURCE` is omitted, `src/main.vut` is used.

Build options:

```text
--release                 build with the release optimizer (-O2)
-O, --opt-level <LEVEL>   0, 1, 2, or 3
--target <TRIPLE>         target triple (defaults to the host)
--target-cpu <CPU>        `native` or a preset (portable baseline by default)
--target-feature <FEAT>   Cranelift feature override, e.g. +avx2; repeatable
-o, --output <PATH>       output executable path
--native-lib <PATH>       link a native static library; repeatable
--system-lib <NAME>       link a platform system library by name; repeatable
--color <WHEN>            auto, always, never
--diagnostic-format <F>   human or json
```

`vut doctor` prints `status: ok (READY)` and exits 0 when the toolchain works, or
a list of issues and exits non-zero. `--json` emits a machine-readable report.

## `vpm`

```text
vpm new <name>            create a project
vpm init                  initialize a project in place
vpm add <package>         add a dependency
vpm remove <package>      remove a dependency
vpm install [package]     install dependencies (or a global CLI package)
vpm update                update dependencies within the lockfile rules
vpm build | check | test | run
vpm exec [--bin <name>] -- <args>   run an installed global CLI
vpm uninstall <package>   remove a global CLI package
vpm publish [registry] [--dry-run]
```

## `vut-lsp`

A language server for editors. It is installed alongside `vut` and speaks LSP
over stdio; configure your editor to launch `~/.vut/bin/vut-lsp`.

## Environment variables

```text
VUT_HOME              installation root (default ~/.vut)
VUT_RUNTIME_LIBRARY   override the core runtime archive
VUT_STDLIB_RUNTIME    override the native stdlib archive
VUT_STARTUP_OBJECT    override the startup object
VUT_STDLIB_PATH       override the stdlib source root
VUT_LINKER            force a linker backend: rustc | system | lld
VUT_RELEASE_MANIFEST  installer: use a specific/local release manifest
```

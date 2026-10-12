# Vut WASM — Production Certification (WASM.14)

Status: **C11 certification gate implemented; production certification is still
blocked by incomplete target semantics.** `crates/vut-compiler/tests/wasm_e2e.rs`
uses internal `wasmparser` validation and Node WASI/browser execution locally,
and additionally invokes `wasm-tools validate` and Wasmtime when installed.
The dedicated CI job installs those tools plus Chromium and requires the
external WASI and headless-browser paths to run. See `specs/roadmap/wasm.md` for
the remaining C4/C6/C7 blockers and current certification status.

## 1. Gate criteria

A wasm build is certified when:

1. `crates/vut-codegen/src/wasm/*` compiles clean and the workspace passes
   `cargo fmt --check`, `cargo clippy --workspace --all-targets`, and
   `cargo test --workspace --all-targets`.
2. `wasm_e2e` compiles representative programs to `wasm32-wasip1`, the emitted
   module passes `wasmparser::validate`, and (when Node.js is available) the
   module runs under **WASI preview1** with the expected stdout.
3. No native compiler/runtime/ABI regression (the native test suite is green).

## 2. What `wasm_e2e` covers

| Test | Proves |
| --- | --- |
| `scalars_compile_to_valid_wasm` | functions, arithmetic, calls, control flow |
| `strings_run_under_wasi` | static strings + `out` via direct `fd_write` |
| `list_and_interpolation_run_under_wasi` | list runtime + `int` formatting (`len=4`) |
| `async_runs_under_wasi` | `async fn`/`await` (synchronous lowering) → `v=42` |
| `external_imports_and_interface_metadata` | `extern "C"` → wasm import + `vut.interface` metadata |
| `browser_target_uses_vut_host_and_generated_loader` | `wasm32-unknown-unknown`, no WASI namespace, `_initialize`, typed high-level API round-trips for primitives/string/bytes/lists/optional/result, metadata and `.d.ts`, output host under Node |

## 3. Supported on wasm32-wasip1 today

- Scalars (`int`/`float`/`bool`), arithmetic/comparisons, direct calls, branches,
  loops, returns.
- Linear memory + bump allocator (`memory.grow`), raw load/store.
- Static strings, `ConcatString`, `FormatValue(int)`, `print`/`out` via WASI
  `fd_write`.
- `list` (`new/len/is_empty/push/at/set/pop/clear`), `bytes`
  (`new/len/at/set`), `map` (`new/len/set/get/get_or/contains_key/remove/clear`).
- `extern "C"` host imports (WASI names routed to `wasi_snapshot_preview1`,
  otherwise `env`).
- Host-neutral `InterfaceMetadata` custom section (`vut.interface`).
- Async state-machine lowering, executor, direct async awaits, and a limited
  synchronous `vutcon` path run under WASI; see C7 for unsupported suspension
  cases and the missing host async bridge.
- JS/TypeScript bindings (`vut build --bindings js` → `app.js` + `app.d.ts`) with natural-value marshaling for primitives, strings, bytes, lists, optionals, and results.
- Browser flavor (`wasm32-unknown-unknown`) uses `vut` host imports, exports
  `_initialize`/memory, and its generated loader initializes the module.
  Unsupported resource, callback, map, and aggregate signatures are rejected
  with a diagnostic rather than exposed as raw pointer APIs. C9's supported
  signatures round-trip in Node and a headless browser; resource/callback
  interop remains behind explicit seams until the runtime destructor and C7
  callback trampoline exist.
- `vpm build --target wasm32-wasip1`.
- `-Os` (size) accepted (maps to the O3 MIR optimizer).

## 4. Not yet certified

- WASM variadic runtime layout and interfaces/vtables (C4).
- WASI `env.get`/`env.all` and unverified `io`/`os`/`fs` coverage (C6).
- Channel round-trip, capturing `vutcon`, real pending futures, and host async
  import/resume ABI (C7).
- External `wasm-tools`, Wasmtime, and Chromium CI run has been configured but
  has not yet completed in CI.
- Binaryen `wasm-opt` is optional and not installed in the current environment.

## 5. Reproduce

```sh
cargo test -p vut-compiler --test wasm_e2e
# manual:
cargo run -p vut-cli -- build app.vut --target wasm32-wasip1 -o app.wasm
node -e "import('node:wasi').then(async ({WASI})=>{const {readFile}=await import('node:fs/promises');const w=new WASI({version:'preview1',args:[],env:{}});const i=await WebAssembly.instantiate(await WebAssembly.compile(await readFile('app.wasm')),w.getImportObject());w.start(i)})"
```

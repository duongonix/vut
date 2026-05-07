# Rust Native Plugins

## Goal

Vut can call native code written in Rust through dynamic libraries. This is useful for math, advanced filesystem features, operating system bindings, or performance-sensitive work.

```vut
import native "math_native"

out(math_native.add(1, 2))
```

## Dynamic library

A native plugin is built as a dynamic library:

- Windows: `.dll`
- Linux: `.so`
- macOS: `.dylib`

VPM can build the native package and place the artifact where the runtime can find it.

## Entry points

A plugin should expose:

```rust
#[no_mangle]
pub extern "C" fn vut_abi_version() -> u32 {
    1
}

#[no_mangle]
pub extern "C" fn vut_register(registry: &mut VutRegistry) {
    registry.function("add", add);
}
```

`vut_abi_version` lets the runtime check ABI compatibility. `vut_register` registers native functions or classes for Vut.

## VutValue bridge

Rust native plugins exchange data through `VutValue`.

```rust
fn add(args: Vec<VutValue>) -> VutResult<VutValue> {
    let a = args[0].as_number()?;
    let b = args[1].as_number()?;

    Ok(VutValue::Number(a + b))
}
```

The bridge should safely convert between Vut runtime values and Rust types.

## Building with VPM

A native package often has:

```text
math_native/
├── vpm.toml
├── src/
│   └── mod.vut
└── native/
    ├── Cargo.toml
    └── src/
        └── lib.rs
```

```powershell
vpm build
```

`vpm build` can build both the Vut layer and the Rust native layer when the package declares a native target.

## Best practices

Keep native APIs small and stable. Validate arguments clearly and return diagnostics instead of panicking. Use native code only when pure Vut is not fast enough or needs to call system functionality outside the runtime.

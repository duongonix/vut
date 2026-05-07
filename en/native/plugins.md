# Plugins

## Goal

Plugins extend Vut beyond the standard library. A plugin can be a pure Vut package or a package with a Rust native layer.

## Pure Vut plugin

```text
hello_lib/
├── vpm.toml
└── src/
    └── mod.vut
```

```vut
fn say() {
    out("hello")
}

export say
```

Users import it with:

```vut
import hello_lib at say

say()
```

## Native plugin

```vut
import native "math_native"

out(math_native.add(1, 2))
```

A native plugin needs a dynamic library and entry points such as `vut_abi_version` and `vut_register`.

## Diagnostics

Native/plugin errors belong to the `E7000` group, such as incompatible ABI, missing dynamic library, or a native function returning an error.

## Best practices

Plugin documentation should include installation, import examples, public API lists, and supported platforms. Avoid exposing internal details before they are stable.

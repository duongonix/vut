# FFI

## Goal

FFI is the connection layer between the Vut runtime and native code. In the first phase, Vut prioritizes Rust native plugins instead of letting users call arbitrary C ABI functions directly.

## Call flow

```vut
import native "math_native"

let value = math_native.add(1, 2)
out(value)
```

The runtime:

1. finds the `math_native` dynamic library;
2. checks `vut_abi_version`;
3. calls `vut_register`;
4. maps native functions into the module;
5. converts arguments through `VutValue`;
6. receives a `VutValue` result.

## Type bridge

Common bridged types:

- number
- string
- bool
- null
- array
- object
- class instance when supported by the runtime

## Safety

Native code can crash if written incorrectly, so the boundary must validate carefully. Native functions should return `VutResult<VutValue>` or an equivalent mechanism so the runtime can create diagnostics instead of panicking.

## Best practices

Keep ABI versions explicit. Do not pass long-lived references across the boundary unless ownership is well defined. For complex data, prefer object or array `VutValue` values instead of raw pointers.

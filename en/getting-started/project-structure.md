# Project Structure

## Goal

This page describes the standard layout of a Vut project managed by VPM.

```text
my_app/
├── vpm.toml
├── vpm-lock.toml
├── src/
│   └── main.vut
├── .vendor/
└── target/
```

## Meaning

- `vpm.toml`: manifest with package name and dependencies.
- `vpm-lock.toml`: lock file recording resolved dependencies.
- `src/main.vut`: entry point for `vpm run`.
- `.vendor/`: where VPM places official and git packages.
- `target/`: build output, native plugin output, and local cache.

## Manifest Example

```toml
[package]
name = "my_app"
version = "0.1.0"

[dependencies]
local_lib = "../local_lib"
vut_lib = { source = "github:duongonix/vut_lib" }
hello_lib = "hello_lib"
```

## Import Root

At runtime, `src` is the import root:

```vut
import math
```

may resolve to:

```text
src/math.vut
src/math/mod.vut
```

Project source has priority over dependencies and standard modules.


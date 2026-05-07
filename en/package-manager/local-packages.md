# Local Packages

## Goal

Local packages are useful when you develop multiple packages on the same machine and want the main project to use local source directly.

## Adding a local package

```powershell
vpm add ../local_lib
```

Manifest:

```toml
[dependencies]
local_lib = "../local_lib"
```

## Local package structure

```text
local_lib/
├── vpm.toml
└── src/
    └── mod.vut
```

A local package should have its own `vpm.toml` so VPM knows the package name, entry point, and dependencies.

## Import

```vut
import local_lib

local_lib.run()
```

## Best practices

Use short and stable relative paths. Once the package is ready to share with a team, move to a Git dependency so the path does not depend on one developer's machine.

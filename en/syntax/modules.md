# Modules

## Goal

Vut uses file and folder modules. `src` is the project's import root.

## File Module

```text
src/
├── main.vut
└── math.vut
```

`src/math.vut`:

```vut
fn add(a, b) {
    return a + b
}

export add
```

`src/main.vut`:

```vut
import math

out(math.add(1, 2))
```

## Folder Module

```text
src/
└── math/
    └── mod.vut
```

`mod.vut` is the folder module entry.

## Export

```vut
export add, dev
export add as a
```

Only exported symbols are visible to importers.

## Resolution Order

Vut prioritizes:

1. project source (`src`)
2. dependencies from `vpm.toml` / `vpm-lock.toml`
3. `.vendor`
4. standard modules
5. global packages

## Best Practices

- Export a clear public API from each module.
- Use `mod.vut` for package/folder modules with child files.
- Avoid circular imports.


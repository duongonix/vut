# Standard Library

## Goal

Vut's standard library provides the core modules needed to write practical programs without rebuilding everything from scratch. Standard modules are imported like regular modules:

```vut
import fs
import vutcon at spawn, channel
```

## Available modules

Important modules:

- `fs`: filesystem, path utilities, metadata.
- `vutcon`: concurrency, tasks, channels, select, sleep.
- basic builtins such as `out`, runtime values, functions, and objects.

## How resolution works

When you import a module:

```vut
import fs
```

The compiler/runtime searches in this order:

1. local modules under `src/`;
2. dependencies in `.vendor/` from `vpm.toml` and `vpm-lock.toml`;
3. Vut standard modules.

This lets a project override modules locally when needed, but it also means you should avoid naming local modules the same as standard modules unless that is intentional.

## Specific imports

```vut
import fs at read, write

write("data.txt", "hello")
out(read("data.txt"))
```

Specific imports make code shorter, but for larger modules, a clear namespace such as `fs.read(...)` is often easier to read.

## Combining standard modules

```vut
import fs
import vutcon at spawn, channel

let jobs = channel()

spawn(() {
    let path = jobs.receive()
    let text = fs.read(path)
    out(text)
})

jobs.send("README.md")
```

## Best practices

Keep imports at the top of the file. Use namespaces for modules with many functions to avoid name collisions. For functions used constantly, `import module at name` keeps code compact, but keep the imported name list small.

## See also

- [fs](./fs.md)
- [vutcon](./vutcon.md)
- [Imports](../syntax/imports.md)

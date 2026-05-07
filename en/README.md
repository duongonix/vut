# Vut Documentation

This is the English documentation for the Vut programming language. It covers getting started, syntax, the standard library, VutCom, VPM, native plugins, and practical examples.

Vut is an interpreted language written in Rust. It focuses on simple syntax, a dynamic runtime, clear modules, readable errors, its own package manager, and extension through Rust native plugins.

## Recommended Reading Order

1. [Installation](getting-started/installation.md)
2. [First Program](getting-started/first-program.md)
3. [Project Structure](getting-started/project-structure.md)
4. [Variables](syntax/variables.md)
5. [Functions](syntax/functions.md)
6. [Lambda](syntax/lambda.md)
7. [Conditions](syntax/conditions.md)
8. [Loops](syntax/loops.md)
9. [Match](syntax/match.md)
10. [OOP](syntax/oop.md)
11. [Modules](syntax/modules.md) and [Imports](syntax/imports.md)
12. [Errors](syntax/errors.md)

## Main Areas

- Standard library: [fs](standard-library/fs.md), [vutcon](standard-library/vutcon.md), [std](standard-library/std.md)
- VutCom: [introduction](vutcom/introduction.md), [components](vutcom/components.md), [child](vutcom/child.md), [rendering](vutcom/rendering.md)
- Package manager: [VPM](package-manager/vpm.md), [dependencies](package-manager/dependencies.md), local/git/official packages
- Native: [Rust native](native/rust-native.md), [plugins](native/plugins.md), [FFI](native/ffi.md)
- Examples: [CLI](examples/cli.md), [web](examples/web.md), [concurrency](examples/concurrency.md), [game](examples/game.md)

## Quick Example

```vut
import fs

fn add(a, b) {
    return a + b
}

fs.write("result.txt", "sum = {add(2, 3)}")
out(fs.read("result.txt"))
```

Note: Vut is evolving quickly. Some APIs are MVP-shaped, but this documentation describes current behavior or clearly marks future-facing areas.


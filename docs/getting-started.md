# Getting started

## Hello, world

Create `hello.vut`:

```vut
fn main():
  out("hello, world")
```

Compile and run it:

```sh
vut run hello.vut
```

`vut build hello.vut` produces a native executable instead.

## A first program

```vut
data Point:
  x: int
  y: int

fn Point.length_squared() -> int:
  self.x * self.x + self.y * self.y

fn main():
  p = Point(x: 3, y: 4)
  out("length^2 = $(p.length_squared())")
```

Vut is statically typed with inference for local bindings. `data` declares a
record type; `fn Type.method()` declares a receiver method.

## Projects with VPM

For anything larger than one file, use the package manager:

```sh
vpm new myapp
cd myapp
vpm run
```

A project has a `vpm.toml` manifest and a `src/` directory whose library entry
point is `src/mod.vut`. Executables are declared with `[[bin]]`. Dependencies are
added with `vpm add <package>` and pinned in `vpm.lock`.

## Modules and imports

Split code into modules and import them:

```vut
import math

fn main():
  out("pi is about $(math.PI)")
```

The official standard library (`io`, `path`, `fs`, `os`, `env`, `time`,
`process`, `json`, `http`, `math`) is available without any setup.

## Errors

Fallible operations return `result[T, E]`. Use `match` or the `?` operator:

```vut
import fs

fn main():
  match fs.read_str("notes.txt"):
    ok(text): out("read $(text.len()) bytes")
    err(error): out("failed: $(error)")
```

Optional values use `T?` and are checked with `if value != null` or `match`.

## Concurrency

Async functions and tasks use `async fn`, `await`, and `vut(...)`:

```vut
async fn work() -> int:
  42

async fn main():
  job: vutcon[int] = vut(() => work())
  value = await job
  out("got $value")
```

## Next steps

- [Language guide](language.md)
- [Standard library](stdlib.md)
- [Command line](cli.md)
- Browse `examples/` in the source repository for complete programs.

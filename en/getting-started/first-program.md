# First Program

## Goal

You will write your first Vut file, run it with the `vut` CLI, and learn that the top-level file is the entry point. Vut does not require `fn main()`.

## Create a File

Create `hello.vut`:

```vut
out("Hello Vut")
```

Run:

```powershell
vut hello.vut
```

Output:

```text
Hello Vut
```

## Variables and Functions

```vut
let name = "Vut"

fn greet(value) {
    out("Hello {value}")
}

greet(name)
```

Strings support interpolation with `{expr}`.

## Create a Project With VPM

```powershell
vpm init
vpm run
```

`vpm run` runs the current project's `src/main.vut`.

## Best Practices

- Keep `src/main.vut` small in larger projects; split code into modules.
- Use `out()` for early debugging.
- When you see an error, read the `help:` section first.


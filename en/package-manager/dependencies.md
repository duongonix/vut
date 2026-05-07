# Dependencies

## Goal

A dependency is a package that a Vut project imports and uses. VPM resolves dependencies from `vpm.toml`, locks the result in `vpm-lock.toml`, and installs code into `.vendor/`.

## Declaring dependencies

```toml
[dependencies]
local_lib = "../local_lib"
vut_lib = { source = "github:duongonix/vut_lib" }
hello_lib = "hello_lib"
```

After declaring a dependency or using `vpm add`, run:

```powershell
vpm install hello_lib
```

## Importing dependencies

If a package exports a `hello` module, code in `src/main.vut` can import it:

```vut
import hello

hello.run()
```

Resolution prioritizes the local project before dependencies and std modules. A module under `src/` can therefore shadow a dependency with the same name.

## Lock file

`vpm-lock.toml` records resolved dependencies. It helps other machines build with the same version or source.

## Best practices

Keep dependencies small and clearly sourced. Commit the lock file for applications. When writing libraries, avoid unnecessary dependencies so imports stay lightweight for users.

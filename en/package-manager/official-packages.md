# Official Packages

## Goal

Official packages are fetched from VPM's standard registry/repository.

Official repository:

```text
github.com/duongonix/vpm
```

Package example:

```text
duongonix/vpm/hello_lib
```

## Installing an official package

```powershell
vpm add hello_lib
vpm install hello_lib
```

Manifest:

```toml
[dependencies]
hello_lib = "hello_lib"
```

The package is installed to:

```text
.vendor/hello_lib
```

## Import

```vut
import hello_lib

hello_lib.say()
```

## Best practices

Use short, clear package names and avoid names that collide with standard modules such as `fs` or `vutcon`. When publishing, include a README, usage examples, and a clear version so other users can evaluate the package quickly.

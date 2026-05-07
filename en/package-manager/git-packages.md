# Git Packages

## Goal

Git packages let a project use a library from a repository.

## Adding a Git dependency

```powershell
vpm add github:duongonix/vut_lib
```

Manifest:

```toml
[dependencies]
vut_lib = { source = "github:duongonix/vut_lib" }
```

Direct Git dependencies are installed to:

```text
.vendor/github/user/repo
```

Example:

```text
.vendor/github/duongonix/vut_lib
```

## Import

```vut
import vut_lib

out(vut_lib.version())
```

## Best practices

For production apps, pin a version or tag once VPM fully supports it. For experimental packages, using the default branch can be convenient but makes builds less stable.

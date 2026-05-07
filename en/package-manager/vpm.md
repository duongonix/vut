# VPM

## Goal

VPM is Vut's package manager. It manages projects, local dependencies, Git dependencies, official packages, builds, and runs.

```powershell
vpm init
vpm run
```

## Commands

```powershell
vpm init
vpm add ../local_lib
vpm add github:duongonix/vut_lib
vpm add hello_lib
vpm remove hello_lib
vpm install hello_lib
vpm build
vpm run
vpm clean
```

Meaning:

- `vpm init`: create a new Vut project.
- `vpm add ../local_lib`: add a local dependency.
- `vpm add github:duongonix/vut_lib`: add a direct Git dependency.
- `vpm add hello_lib`: add an official package.
- `vpm remove hello_lib`: remove a dependency from the manifest.
- `vpm install hello_lib`: install a package into `.vendor/`.
- `vpm build`: build the project.
- `vpm run`: run the project.
- `vpm clean`: clean build output, useful for release workflows or clean builds.

## Project structure

```text
my_app/
├── vpm.toml
├── vpm-lock.toml
├── src/
│   └── main.vut
├── .vendor/
└── target/
```

`vpm.toml` is the manifest. `vpm-lock.toml` locks resolved dependencies. `.vendor/` contains installed packages. `target/` contains build output.

## Dependency examples

```toml
[dependencies]
local_lib = "../local_lib"
vut_lib = { source = "github:duongonix/vut_lib" }
hello_lib = "hello_lib"
```

Official packages come from:

```text
github.com/duongonix/vpm
```

Official package example:

```text
duongonix/vpm/hello_lib
```

Official packages are installed to:

```text
.vendor/hello_lib
```

Direct Git dependencies are installed to:

```text
.vendor/github/user/repo
```

## Best practices

Commit `vpm.toml` and `vpm-lock.toml` for reproducible builds. Do not commit `.vendor/` or `target/` unless the project has a specific reason. Use local packages while developing multiple packages together, then move to Git or official packages when publishing.

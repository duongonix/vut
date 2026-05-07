# `fs` Module

## Goal

`fs` is the standard module for filesystem work: reading and writing files, creating and removing directories, copying and moving paths, listing directories, handling path utilities, and reading metadata.

It is exposed as a native Vut API:

```vut
import fs

fs.write("hello.txt", "Hello Vut")
out(fs.read("hello.txt"))
```

## Import

```vut
import fs
import fs at read, write, exists
```

With `import fs`, call functions through the namespace, such as `fs.read(...)`. With `import fs at ...`, selected functions are imported into the current scope.

```vut
import fs at read, write

write("out.txt", "data")
out(read("out.txt"))
```

## Reading and writing text files

The first phase of `fs` focuses on text files.

```vut
import fs

fs.write("note.txt", "first line\n")
fs.append("note.txt", "second line\n")

let text = fs.read("note.txt")
out(text)
```

`fs.write(path, content)` overwrites the file if it already exists. `fs.append(path, content)` adds content to the end of the file.

## Checking paths

```vut
import fs

if fs.exists("src/main.vut") {
    out("exists")
}

if fs.is_file("src/main.vut") {
    out("file")
}

if fs.is_dir("src") {
    out("directory")
}
```

`exists` only checks whether the path exists. `is_file` and `is_dir` are useful when the logic must distinguish files from directories.

## Creating and removing

```vut
import fs

fs.mkdir("logs")
fs.mkdir_all("target/cache/data")

fs.write("logs/app.log", "started\n")
fs.remove("logs/app.log")

fs.remove_dir("logs")
fs.remove_all("target/cache")
```

Use `remove_dir` only for empty directories. Use `remove_all` when recursive deletion is intended.

## Copy and move

```vut
import fs

fs.write("a.txt", "hello")
fs.copy("a.txt", "b.txt")
fs.move("b.txt", "archive.txt")
```

`fs.move(from, to)` can rename or move files and folders depending on operating system support.

## Listing directories

```vut
import fs

for item in fs.list("src") {
    out(item)
}
```

`fs.list(path)` returns an `Array<String>` containing child file and folder names. The order can depend on the platform, so sort at the application level when stable output matters.

## Metadata

```vut
import fs

let meta = fs.metadata("src/main.vut")

out(meta.path)
out(meta.is_file)
out(meta.size)
out(meta.modified)
```

`fs.metadata(path)` returns an object:

```vut
{
    path = "...",
    is_file = true,
    is_dir = false,
    size = 123,
    readonly = false,
    created = "...",
    modified = "..."
}
```

If the platform does not support `created`, the value can be `null`.

## Path utilities

```vut
import fs

out(fs.join("src", "main.vut"))
out(fs.basename("src/main.vut"))
out(fs.dirname("src/main.vut"))
out(fs.extname("src/main.vut"))
out(fs.stem("src/main.vut"))
out(fs.normalize("./src/../src/main.vut"))
out(fs.absolute("src/main.vut"))
```

Functions:

- `fs.join(a, b)` joins paths using the platform separator.
- `fs.basename(path)` returns the final file or folder name.
- `fs.dirname(path)` returns the parent directory.
- `fs.extname(path)` returns the extension without the dot.
- `fs.stem(path)` returns the file name without the extension.
- `fs.normalize(path)` normalizes a path.
- `fs.absolute(path)` converts a path to an absolute path.

## Working directory

```vut
import fs

out(fs.cwd())
out(fs.home())
out(fs.temp_dir())

fs.chdir("examples")
out(fs.cwd())
```

`fs.home()` can return `null` if the runtime cannot determine the home directory.

## Diagnostics

`fs` does not panic on failure. Errors are converted to Rust-style diagnostics:

```text
error[E8001]: file not found `data/input.txt`
  --> src/main.vut:3:16
   |
 3 | fs.read("data/input.txt")
   |         ^^^^^^^^^^^^^^^^ file does not exist
   |
help: check the path or create the file first
```

Main error group:

- `E8001` file not found
- `E8002` permission denied
- `E8003` path is not file
- `E8004` path is not directory
- `E8005` invalid path
- `E8006` read failed
- `E8007` write failed
- `E8008` remove failed
- `E8009` copy failed
- `E8010` move failed
- `E8011` metadata failed
- `E8012` directory listing failed

## Best practices

Prefer `fs.join` over manual string concatenation so code works across Windows, Linux, and macOS. Check `exists`, `is_file`, and `is_dir` before destructive operations when failures are not part of the normal flow. For build tools or CLIs, write generated files into clear locations such as `target/`, `.vendor/`, or a configured output folder.

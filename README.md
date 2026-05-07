# Vut

Vut is a small, modern interpreted programming language written in Rust. It is designed for people who want a clean scripting language with practical tooling, clear diagnostics, a simple package manager, UI-oriented components through VutCom, native Rust extensions, filesystem APIs, and lightweight concurrency.

Vut is currently an MVP language runtime, but it already has enough pieces to feel like a real language: variables, functions, lambdas, loops, `match`, classes, modules, packages, standard modules, runtime diagnostics, and native plugins.

## Why Vut Exists

Vut is an experiment in making a dynamic language that feels approachable without becoming loose or chaotic. The syntax is intentionally compact, closer to Python, Kotlin, JavaScript, and modern scripting languages than to Java or C++. The runtime is written in Rust so the implementation can provide safer internals, better error reporting, and a path toward native extensions.

Vut is built around a few ideas:

- Programs should be easy to read.
- Errors should explain what happened and where.
- Packages should be simple enough for small projects.
- Concurrency should prefer message passing over shared mutable state.
- UI/component syntax should be part of the language experience without taking over the whole language.
- Native Rust plugins should be possible when performance or OS integration matters.

## Who Vut Is For

Vut is useful for:

- learners who want a small language with readable syntax;
- tool builders who want scripts, packages, and filesystem access;
- people experimenting with language design;
- Rust developers who want to expose native functionality to a scripting layer;
- UI/runtime experiments using VutCom components;
- small automation and CLI projects.

It is not yet a replacement for mature production languages. The project is still evolving, and some systems are intentionally MVP-shaped.

## Strengths

- Simple expression and statement syntax.
- Functions, block lambdas, and arrow lambdas.
- `match` expressions with literals, wildcard, ranges, guards, object patterns, and array patterns.
- Dynamic OOP with classes, fields, methods, `self`, `_init()`, inheritance, `super`, and `_` private convention.
- File-based module system with explicit exports.
- VPM package manager for local, git, and official packages.
- VutCom component DSL for building runtime object trees.
- `vutcon` standard module for `spawn`, `channel`, `sleep`, and `select`.
- `fs` standard module for common filesystem work.
- Rust native plugin support through dynamic libraries.
- Rust-style diagnostics with stable error code groups.

## Compared With Other Interpreted Languages

Vut aims to be smaller than Python, less browser-oriented than JavaScript, and less ceremony-heavy than JVM languages. Like Lua, it tries to stay compact. Like Python and JS, it is dynamic-friendly. Like Rust tooling, it values diagnostics and package structure. The result is not meant to be a clone of any one language; Vut is a pragmatic blend.

## Installation

Build both CLIs from source:

```powershell
cargo build -p vut -p vpm --release
```

The binaries are created under:

```text
target/release/vut
target/release/vpm
```

On Windows they are:

```text
target/release/vut.exe
target/release/vpm.exe
```

For releases, the project includes a GitHub Actions workflow that builds archives for:

- Windows x86_64
- Linux x86_64
- macOS Intel
- macOS Apple Silicon

## Quick Example

```vut
import fs
import vutcon at spawn, channel

class Student(name, age) {
    name = name
    age = age

    fn _init() {
        out("created")
    }

    fn greet() {
        out("hello {name}")
    }
}

let s = Student("nam", 20)
s.greet()

fs.write("hello.txt", "Hello Vut")
out(fs.read("hello.txt"))

let ch = channel()
spawn(() {
    ch.send("from worker")
})
out(ch.receive())
```

## Project Structure

```text
my_app/
├── vpm.toml
├── vpm-lock.toml
├── src/
│   └── main.vut
├── .vendor/
└── target/
```

`src/main.vut` is the entry point. Vut does not require `fn main()`.

## Documentation

- Vietnamese documentation: [vn/README.md](vn/README.md)
- English documentation: [en/README.md](en/README.md)


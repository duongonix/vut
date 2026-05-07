# Errors and Diagnostics

## Goal

Vut uses Rust-style diagnostics: error codes, source locations, markers, notes, and help messages.

## Example

```text
error[E4001]: undefined variable `count`
  --> src/main.vut:5:10
   |
 5 | out(count)
   |     ^^^^^ variable not found
   |
help: declare it before use
```

## Error Groups

- `E1000`: Lexer
- `E1100`: Parser
- `E2000`: Module/import
- `E3000`: Runtime
- `E4000`: Semantic/type
- `E5000`: VPM
- `E6000`: VutCom
- `E7000`: Native plugin
- `E8000`: `fs`

## How to Read an Error

1. Read the first line to understand the issue.
2. Check file, line, and column.
3. Look at the `^^^^` marker.
4. Read `note:` for extra details.
5. Follow `help:` first.

## fs Error Example

```vut
import fs

fs.read("missing.txt")
```

May report:

```text
error[E8001]: file not found `missing.txt`
```

## Best Practices

- Keep error reproductions small.
- When reporting a bug, include the minimal source file.
- Do not ignore `help:`; many diagnostics include direct repair hints.


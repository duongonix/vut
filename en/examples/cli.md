# CLI Example

## Goal

This example creates a small CLI-style program that reads a file, processes the content, and writes the result to another file using the `fs` module.

## Code

```vut
import fs

let input = "input.txt"
let output = "output.txt"

if !fs.exists(input) {
    fs.write(input, "hello vut\n")
}

let text = fs.read(input)
let result = "processed:\n{text}"

fs.write(output, result)
out(fs.read(output))
```

## Explanation

The program runs from top level and does not need `main()`. `fs.exists` checks the input file. `fs.read` and `fs.write` handle text files.

## Best practices

For real CLIs, keep configured paths near the top of the file. Use `fs.join` when composing paths to avoid separator issues between Windows and Unix.

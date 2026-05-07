# Conditions

## Goal

Vut supports `if`, `elif`, and `else` in both statement and expression positions.

## If Statement

```vut
let score = 80

if score >= 90 {
    out("A")
} elif score >= 70 {
    out("B")
} else {
    out("C")
}
```

## If Expression

```vut
let status = "ok"
let label = if status == "ok" {
    "Ready"
} else {
    "Failed"
}

out(label)
```

If a branch does not produce a value, the result is `null`.

## Truthiness

Values such as `false`, `0`, empty strings, empty arrays, and `null` are generally falsy; other values are truthy.

## Best Practices

- Use `match` when branching on many values.
- Use `if expression` when computing a value.
- Keep conditions readable; introduce helper variables for long expressions.


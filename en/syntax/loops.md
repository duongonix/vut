# Loops

## Goal

Vut has `while`, `for value in array`, `for index, value in array`, ranges, and infinite loops.

## While

```vut
let i = 0

while i < 3 {
    out(i)
    i += 1
}
```

## For Over Array

```vut
for value in [10, 20, 30] {
    out(value)
}
```

## For Index, Value

```vut
for index, value in ["a", "b"] {
    out("{index} = {value}")
}
```

## Range

```vut
for i in 1..3 {
    out(i)
}
```

## Break and Continue

```vut
for i in 1..10 {
    if i == 3 {
        continue
    }
    if i == 8 {
        break
    }
    out(i)
}
```

## Best Practices

- Use `for` for collections and ranges.
- Use `while` for dynamic conditions.
- Avoid infinite loops unless there is a clear `break`.


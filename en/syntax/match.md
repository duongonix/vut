# Match

## Goal

`match` in Vut is an expression. It returns a value and can be used in `let`, function calls, or VutCom.

## Literals and Wildcard

```vut
let label = match status {
    "loading" => "Loading"
    "error" => "Error"
    "success" => "Done"
    _ => "Unknown"
}
```

## Block Body

```vut
let result = match code {
    200 => {
        out("ok")
        "success"
    }
    _ => "other"
}
```

## Multiple Patterns and Ranges

```vut
let grade = match score {
    90..100 => "A"
    70..89 => "B"
    0 | 1 | 2 => "very low"
    _ => "C"
}
```

## Guard

```vut
let size = match count {
    x if x > 100 => "big"
    _ => "small"
}
```

## Object and Array Patterns

```vut
let label = match user {
    { role: "admin", name } => "Admin {name}"
    { name } => "User {name}"
    _ => "Unknown"
}

let axis = match point {
    [0, y] => "y axis {y}"
    [x, 0] => "x axis {x}"
    _ => "free"
}
```

## In VutCom

```vut
let node = match status {
    "ok" => Text(text = "Ready") {}
    _ => Text(text = "Unknown") {}
}
```

## Best Practices

- Include `_` when the data may expand.
- Use guards for extra checks, but keep complex logic out of patterns.


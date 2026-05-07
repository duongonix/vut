# Match

## Mục tiêu

`match` trong Vut là expression. Nó trả về giá trị và có thể dùng trong `let`, function call hoặc VutCom.

## Literal và wildcard

```vut
let label = match status {
    "loading" => "Loading"
    "error" => "Error"
    "success" => "Done"
    _ => "Unknown"
}
```

## Block body

```vut
let result = match code {
    200 => {
        out("ok")
        "success"
    }
    _ => "other"
}
```

## Multiple pattern và range

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

## Object và array pattern

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

## Trong VutCom

```vut
let node = match status {
    "ok" => Text(text = "Ready") {}
    _ => Text(text = "Unknown") {}
}
```

## Best practices

- Luôn có `_` nếu dữ liệu có thể mở rộng.
- Dùng guard cho điều kiện bổ sung, không nhét logic quá dài vào pattern.


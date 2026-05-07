# Vòng lặp

## Mục tiêu

Vut có `while`, `for value in array`, `for index, value in array`, range và loop vô hạn.

## While

```vut
let i = 0

while i < 3 {
    out(i)
    i += 1
}
```

## For over array

```vut
for value in [10, 20, 30] {
    out(value)
}
```

## For index, value

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

## Break và continue

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

## Best practices

- Dùng `for` cho collection/range.
- Dùng `while` cho điều kiện động.
- Tránh loop vô hạn nếu không có `break` rõ ràng.


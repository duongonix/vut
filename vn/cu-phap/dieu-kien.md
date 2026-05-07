# Điều kiện

## Mục tiêu

Vut hỗ trợ `if`, `elif`, `else` ở statement position và expression position.

## If statement

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

## If expression

```vut
let status = "ok"
let label = if status == "ok" {
    "Ready"
} else {
    "Failed"
}

out(label)
```

Nếu nhánh không tạo giá trị, kết quả là `null`.

## Truthiness

Các giá trị như `false`, `0`, string rỗng, array rỗng và `null` thường được xem là falsy; giá trị còn lại là truthy.

## Best practices

- Dùng `match` khi có nhiều nhánh theo giá trị.
- Dùng `if expression` khi cần tính một giá trị.
- Giữ condition dễ đọc; tách biến trung gian nếu biểu thức dài.


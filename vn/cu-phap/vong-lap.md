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

## Mo rong thuc hanh

- Chay lai vi du trong bai voi nhieu input khac nhau de nam chac hanh vi.
- Tach logic thanh ham/module nho de de test va tai su dung.
- Thu tao 1 tinh huong loi co chu dich de hieu thong diep chan doan cua Vut.

## Bai ke tiep

- [cu-phap/match.md](../cu-phap/match.md)


# Biến và giá trị

## Mục tiêu

Hiểu cách khai báo biến, hằng, kiểu giá trị cơ bản và destructuring trong Vut.

## `let`

`let` tạo binding có thể gán lại.

```vut
let count = 1
count = count + 1
out(count)
```

## `const`

`const` tạo binding không thể gán lại.

```vut
const answer = 42
out(answer)
```

Gán lại `const` sẽ báo lỗi kiểu `E4003`.

## Kiểu giá trị

Vut hiện có:

```vut
let n = 10
let ok = true
let text = "hello"
let items = [1, 2, 3]
let user = { name: "Vut", age: 1 }
let empty = null
```

Object dùng key dạng identifier hoặc string. Truy cập field:

```vut
out(user.name)
```

## String interpolation

```vut
let name = "Vut"
out("Hello {name}")
```

## Destructuring

```vut
let user = { name: "Vut", age: 1 }
let { name, age } = user

let point = [10, 20]
let [x, y] = point
```

Có thể dùng default:

```vut
let { role = "guest" } = { name: "nam" }
out(role)
```

## Best practices

- Dùng `const` cho giá trị không đổi.
- Dùng `let` cho state thay đổi trong loop hoặc thuật toán.
- Với object lớn, destructuring giúp code ngắn nhưng đừng lạm dụng nếu làm giảm độ rõ.


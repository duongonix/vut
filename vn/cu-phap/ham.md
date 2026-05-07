# Hàm

## Mục tiêu

Hàm trong Vut dùng `fn`, có tham số, default argument, named argument, variadic argument và `return`.

## Khai báo hàm

```vut
fn add(a, b) {
    return a + b
}

out(add(2, 3))
```

## Default parameter

```vut
fn greet(name, prefix = "Hello") {
    out("{prefix} {name}")
}

greet("Vut")
greet("Vut", prefix = "Hi")
```

## Named argument

```vut
fn area(width, height) {
    return width * height
}

out(area(height = 5, width = 10))
```

## Variadic parameter

```vut
fn sum(...nums) {
    let total = 0
    for n in nums {
        total += n
    }
    return total
}

out(sum(1, 2, 3))
```

## Hoisting và immutability

Function declaration được hoist và binding của hàm là immutable.

```vut
out(add(1, 2))

fn add(a, b) {
    return a + b
}
```

## Best practices

- Dùng `return` khi muốn kết thúc rõ ràng.
- Dùng named argument cho hàm có nhiều tham số cùng kiểu.
- Đặt variadic parameter ở cuối.


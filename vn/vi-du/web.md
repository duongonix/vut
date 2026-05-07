# Ví dụ Web với VutCom

## Mục tiêu

Ví dụ này minh họa cách viết component bằng VutCom. Runtime build object tree; bạn không tự viết `{ type, props, children }`.

## Code

```vut
com App() {
    return child(id = "app")
}

com Button(onclick) {
    return child()
}

com Text(text) {
    return child()
}

let app = App {
    Button(
        onclick = () => out("clicked")
    ) {
        Text(text = "Click")
    }

    for i in 1..3 {
        Text(text = "item {i}")
    }
}
```

## Giải thích

`App`, `Button` và `Text` là component. `Button` nhận event handler bằng lambda. `for` chạy trực tiếp trong component block để tạo nhiều node.

## Best practices

Dùng named arguments cho props. Giữ component nhỏ. Tách logic dài ra function thường để render block dễ nhìn.

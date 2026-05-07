# Component

## Mục tiêu

Component là đơn vị tái sử dụng chính trong VutCom. Một component nhận props, chạy code Vut và trả về `child(...)`.

```vut
com Text(text) {
    return child()
}
```

## Props

Props được khai báo trong parameter list:

```vut
com Button(text, onclick) {
    return child()
}
```

Khi gọi component, dùng named arguments để code dễ đọc:

```vut
Button(
    text = "Save",
    onclick = () => out("saved")
)
```

## Children

Component có thể nhận block children:

```vut
Button(onclick = () => out("ok")) {
    Text(text = "Click")
}
```

Runtime đưa children vào object tree. Người dùng không cần tự build `{ type, props, children }`.

## Logic trong component

Component body là Vut code:

```vut
com Status(status) {
    let label = match status {
        "loading" => "Loading"
        "error" => "Error"
        "success" => "Done"
        _ => "Unknown"
    }

    return child(text = label)
}
```

## Best practices

Đặt tên component bằng PascalCase. Dùng props rõ nghĩa như `text`, `onclick`, `value`, `items`. Tránh nhồi quá nhiều logic vào component render; nếu cần tính toán dài, tách thành function thường.

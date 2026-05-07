# `child(...)`

## Mục tiêu

`child(...)` là helper cốt lõi của VutCom. Nó nói với runtime rằng component hiện tại trả về node hoặc children cho object tree.

```vut
com Text(text) {
    return child()
}
```

## Props cho child

Bạn có thể truyền named arguments:

```vut
com App() {
    return child(id = "root", role = "app")
}
```

Các props này trở thành dữ liệu runtime dùng khi build tree.

## `item`

Trong component block, `item` là object hiện tại.

```vut
let app = App {
    let { id } = item
    Text(text = "id = {id}")
}
```

`item` hữu ích khi component cha tạo context hoặc truyền dữ liệu xuống children.

## Event handler

Event handler thường dùng lambda:

```vut
Button(
    onclick = () => out("ok")
) {
    Text(text = "Click")
}
```

## Best practices

Dùng `child(...)` thay vì tự tạo object tree thủ công. Giữ props của `child` nhỏ và có ý nghĩa. Với dữ liệu động, tính giá trị trước rồi truyền vào named argument để block dễ đọc.

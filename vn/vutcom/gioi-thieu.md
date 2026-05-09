# Giới thiệu VutCom

## Mục tiêu

VutCom là hệ thống component của Vut. Nó cho phép viết UI hoặc object tree bằng syntax gần với code Vut bình thường, thay vì bắt người dùng tự tạo object `{ type, props, children }`.

```vut
com Text(text) {
    return child()
}

let app = Text(text = "Hello")
```

Runtime tự build object tree từ component, props và children.

## `com` keyword

`com` khai báo component:

```vut
com Button(onclick) {
    return child()
}
```

Component nhận props giống function argument. Khi gọi component, bạn có thể dùng named arguments.

```vut
Button(onclick = () => out("clicked"))
```

## Component block

Component có thể được gọi với block children:

```vut
com App() {
    return child(id = "ok")
}

com Button(onclick) {
    return child()
}

com Text(text) {
    return child()
}

let app = App {
    let { id } = item

    Button(
        onclick = () => out("ok")
    ) {
        Text(text = "Click")
    }

    for i in 1..3 {
        Text(text = "i = {i}")
    }
}
```

Trong block, `item` đại diện cho object hiện tại do runtime truyền vào. `child(...)` tạo node con hoặc trả children tùy component đang định nghĩa.

## Control flow trong VutCom

VutCom cho phép dùng control flow bình thường:

```vut
let app = App {
    if logged_in {
        Text(text = "Welcome")
    }

    for name in names {
        Text(text = name)
    }

    let label = match status {
        "loading" => "Loading"
        "error" => "Error"
        "success" => "Done"
        _ => "Unknown"
    }

    Text(text = label)
}
```

## Best practices

Giữ component nhỏ và rõ trách nhiệm. Dùng named arguments cho event handler và props quan trọng. Không tự viết object tree thủ công nếu runtime VutCom đã có thể build giúp bạn.

## Mo rong thuc hanh

- Chay lai vi du trong bai voi nhieu input khac nhau de nam chac hanh vi.
- Tach logic thanh ham/module nho de de test va tai su dung.
- Thu tao 1 tinh huong loi co chu dich de hieu thong diep chan doan cua Vut.

## Bai ke tiep

- [vutcom/component.md](../vutcom/component.md)


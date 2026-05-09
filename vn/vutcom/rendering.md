# Rendering

## Mục tiêu

Rendering trong VutCom là quá trình runtime chạy component, gom props/children và build object tree. Người dùng viết component và block; runtime lo phần cấu trúc.

## Flow cơ bản

```vut
com App() {
    return child(id = "app")
}

com Text(text) {
    return child()
}

let tree = App {
    Text(text = "Hello")
}
```

Runtime:

1. gọi `App`;
2. tạo node từ `child(id = "app")`;
3. chạy block children;
4. gọi `Text(text = "Hello")`;
5. gắn node con vào tree.

## Control flow khi render

```vut
let tree = App {
    for i in 1..3 {
        Text(text = "row {i}")
    }

    if show_footer {
        Text(text = "footer")
    }

    match status {
        "loading" => Text(text = "Loading")
        "error" => Text(text = "Error")
        _ => Text(text = "Ready")
    }
}
```

Control flow là một phần tự nhiên của block VutCom.

## Ghi chú

VutCom không yêu cầu `main()`. Bạn có thể build tree ở top-level giống các chương trình Vut khác. Nếu backend render là web, terminal UI hoặc game UI, tree này có thể được renderer tương ứng xử lý.

## Best practices

Giữ render deterministic: cùng props nên tạo cùng tree. Tránh side effect khó đoán trong render block, ngoại trừ event handler dạng lambda sẽ chạy khi event xảy ra.

## Mo rong thuc hanh

- Chay lai vi du trong bai voi nhieu input khac nhau de nam chac hanh vi.
- Tach logic thanh ham/module nho de de test va tai su dung.
- Thu tao 1 tinh huong loi co chu dich de hieu thong diep chan doan cua Vut.

## Bai ke tiep

- [quan-ly-package/vpm.md](../quan-ly-package/vpm.md)


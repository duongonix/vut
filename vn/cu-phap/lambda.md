# Lambda

## Mục tiêu

Lambda là function value không cần tên. Vut dùng lambda cho callback, event handler, concurrency và API như `spawn`.

## Block lambda

```vut
let hello = () {
    out("hello")
}

hello()
```

## Arrow lambda

```vut
let add = (a, b) => a + b
out(add(2, 3))
```

## Lambda có default argument

```vut
let greet = (name, prefix = "Hello") {
    out("{prefix} {name}")
}

greet("Vut")
```

## Dùng với `vutcon`

```vut
import vutcon at spawn

spawn(() {
    out("running")
})
```

Không dùng:

```vut
spawn {
}
```

Vì block trực tiếp có thể conflict với VutCom.

## Best practices

- Dùng block lambda khi body có nhiều statement.
- Dùng arrow lambda cho biểu thức ngắn.
- Với callback phức tạp, cân nhắc tách ra `fn` có tên.

## Mo rong thuc hanh

- Chay lai vi du trong bai voi nhieu input khac nhau de nam chac hanh vi.
- Tach logic thanh ham/module nho de de test va tai su dung.
- Thu tao 1 tinh huong loi co chu dich de hieu thong diep chan doan cua Vut.

## Bai ke tiep

- [cu-phap/dieu-kien.md](../cu-phap/dieu-kien.md)


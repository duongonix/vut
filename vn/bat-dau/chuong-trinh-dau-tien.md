# Chương trình đầu tiên

## Mục tiêu

Bạn sẽ viết file Vut đầu tiên, chạy bằng CLI `vut`, và hiểu rằng top-level file chính là entry point. Vut không yêu cầu `fn main()`.

## Tạo file

Tạo `hello.vut`:

```vut
out("Hello Vut")
```

Chạy:

```powershell
vut hello.vut
```

Kết quả:

```text
Hello Vut
```

## Biến và hàm

```vut
let name = "Vut"

fn greet(value) {
    out("Hello {value}")
}

greet(name)
```

String hỗ trợ interpolation bằng `{expr}`.

## Tạo project bằng VPM

```powershell
vpm init
vpm run
```

`vpm run` chạy `src/main.vut` của project hiện tại.

## Best practices

- Giữ `src/main.vut` nhỏ nếu project lớn; tách module ra file khác.
- Dùng `out()` để debug bước đầu.
- Khi gặp lỗi, đọc phần `help:` trong diagnostic trước.

## Mo rong thuc hanh

- Chay lai vi du trong bai voi nhieu input khac nhau de nam chac hanh vi.
- Tach logic thanh ham/module nho de de test va tai su dung.
- Thu tao 1 tinh huong loi co chu dich de hieu thong diep chan doan cua Vut.

## Bai ke tiep

- [bat-dau/cau-truc-du-an.md](../bat-dau/cau-truc-du-an.md)


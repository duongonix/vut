# Lỗi và diagnostics

## Mục tiêu

Vut dùng diagnostic kiểu Rust: có mã lỗi, vị trí, marker, note và help.

## Ví dụ

```text
error[E4001]: undefined variable `count`
  --> src/main.vut:5:10
   |
 5 | out(count)
   |     ^^^^^ variable not found
   |
help: declare it before use
```

## Nhóm lỗi

- `E1000`: Lexer
- `E1100`: Parser
- `E2000`: Module/import
- `E3000`: Runtime
- `E4000`: Semantic/type
- `E5000`: VPM
- `E6000`: VutCom
- `E7000`: Native plugin
- `E8000`: `fs`

## Cách đọc lỗi

1. Đọc dòng đầu để biết lỗi gì.
2. Nhìn file, line, column.
3. Xem marker `^^^^`.
4. Đọc `note:` nếu có chi tiết phụ.
5. Làm theo `help:` trước.

## Ví dụ lỗi fs

```vut
import fs

fs.read("missing.txt")
```

Có thể báo:

```text
error[E8001]: file not found `missing.txt`
```

## Best practices

- Giữ lỗi có context nhỏ, dễ tái hiện.
- Khi báo bug, gửi source file tối thiểu gây lỗi.
- Đừng bỏ qua `help:`; nhiều lỗi đã có gợi ý sửa trực tiếp.

## Mo rong thuc hanh

- Chay lai vi du trong bai voi nhieu input khac nhau de nam chac hanh vi.
- Tach logic thanh ham/module nho de de test va tai su dung.
- Thu tao 1 tinh huong loi co chu dich de hieu thong diep chan doan cua Vut.

## Bai ke tiep

- [thu-vien-chuan/std.md](../thu-vien-chuan/std.md)


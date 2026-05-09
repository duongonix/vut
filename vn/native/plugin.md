# Plugin

## Mục tiêu

Plugin mở rộng Vut bằng code ngoài standard library. Plugin có thể là package Vut thuần hoặc package có phần native Rust.

## Plugin Vut thuần

```text
hello_lib/
├── vpm.toml
└── src/
    └── mod.vut
```

```vut
fn say() {
    out("hello")
}

export say
```

Người dùng import:

```vut
import hello_lib at say

say()
```

## Plugin native

```vut
import native "math_native"

out(math_native.add(1, 2))
```

Plugin native cần dynamic library và entry points như `vut_abi_version`, `vut_register`.

## Diagnostics

Lỗi native/plugin thuộc nhóm `E7000`, ví dụ ABI không tương thích, không tìm thấy dynamic library hoặc function native trả lỗi.

## Best practices

Tài liệu plugin nên có phần cài đặt, ví dụ import, danh sách API public và platform hỗ trợ. Không expose chi tiết nội bộ nếu chưa ổn định.

## Mo rong thuc hanh

- Chay lai vi du trong bai voi nhieu input khac nhau de nam chac hanh vi.
- Tach logic thanh ham/module nho de de test va tai su dung.
- Thu tao 1 tinh huong loi co chu dich de hieu thong diep chan doan cua Vut.

## Bai ke tiep

- [native/ffi.md](../native/ffi.md)


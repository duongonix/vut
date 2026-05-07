# FFI

## Mục tiêu

FFI là lớp kết nối giữa runtime Vut và code native. Trong phase đầu, Vut ưu tiên Rust native plugin thay vì cho người dùng gọi C ABI tùy ý trực tiếp.

## Luồng gọi

```vut
import native "math_native"

let value = math_native.add(1, 2)
out(value)
```

Runtime:

1. tìm dynamic library `math_native`;
2. kiểm tra `vut_abi_version`;
3. gọi `vut_register`;
4. map function native vào module;
5. chuyển argument qua `VutValue`;
6. nhận kết quả `VutValue`.

## Type bridge

Các kiểu thường cần bridge:

- number
- string
- bool
- null
- array
- object
- class instance khi runtime hỗ trợ

## An toàn

Native code có thể crash nếu viết sai, vì vậy boundary phải validate kỹ. Function native nên trả `VutResult<VutValue>` hoặc cơ chế tương đương để runtime tạo diagnostic thay vì panic.

## Best practices

Giữ ABI version rõ ràng. Không truyền reference sống lâu qua boundary nếu ownership chưa được định nghĩa. Với dữ liệu phức tạp, ưu tiên object/array VutValue thay vì pointer raw.

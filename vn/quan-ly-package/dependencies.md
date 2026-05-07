# Dependencies

## Mục tiêu

Dependency là package mà project Vut import và sử dụng. VPM resolve dependency từ `vpm.toml`, khóa kết quả trong `vpm-lock.toml`, rồi cài code vào `.vendor/`.

## Khai báo dependency

```toml
[dependencies]
local_lib = "../local_lib"
vut_lib = { source = "github:duongonix/vut_lib" }
hello_lib = "hello_lib"
```

Sau khi khai báo hoặc dùng `vpm add`, chạy:

```powershell
vpm install hello_lib
```

## Import dependency

Nếu package export module `hello`, code trong `src/main.vut` có thể import:

```vut
import hello

hello.run()
```

Resolution ưu tiên local project trước dependency/std. Vì vậy module trong `src/` có thể shadow dependency cùng tên.

## Lock file

`vpm-lock.toml` ghi lại dependency đã resolve. Nó giúp máy khác build đúng cùng phiên bản hoặc cùng source.

## Best practices

Giữ dependency nhỏ và rõ nguồn. Ưu tiên lock file trong app. Khi viết thư viện, tránh phụ thuộc quá nhiều package không cần thiết để người dùng import nhẹ hơn.

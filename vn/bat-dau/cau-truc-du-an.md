# Cấu trúc dự án

## Mục tiêu

Trang này mô tả layout chuẩn của một project Vut dùng VPM.

```text
my_app/
├── vpm.toml
├── vpm-lock.toml
├── src/
│   └── main.vut
├── .vendor/
└── target/
```

## Ý nghĩa

- `vpm.toml`: manifest, tên package và dependencies.
- `vpm-lock.toml`: lock file ghi trạng thái dependency đã resolve.
- `src/main.vut`: entry point khi chạy `vpm run`.
- `.vendor/`: nơi VPM đặt package official hoặc git.
- `target/`: output build, native plugin, cache local.

## Ví dụ manifest

```toml
[package]
name = "my_app"
version = "0.1.0"

[dependencies]
local_lib = "../local_lib"
vut_lib = { source = "github:duongonix/vut_lib" }
hello_lib = "hello_lib"
```

## Import root

Trong runtime, `src` là import root:

```vut
import math
```

có thể resolve tới:

```text
src/math.vut
src/math/mod.vut
```

Project source được ưu tiên hơn dependency và standard module.

## Mo rong thuc hanh

- Chay lai vi du trong bai voi nhieu input khac nhau de nam chac hanh vi.
- Tach logic thanh ham/module nho de de test va tai su dung.
- Thu tao 1 tinh huong loi co chu dich de hieu thong diep chan doan cua Vut.

## Bai ke tiep

- [cu-phap/bien.md](../cu-phap/bien.md)


# Package local

## Mục tiêu

Package local dùng khi bạn phát triển nhiều package trên cùng máy và muốn project chính dùng trực tiếp source local.

## Thêm package local

```powershell
vpm add ../local_lib
```

Manifest:

```toml
[dependencies]
local_lib = "../local_lib"
```

## Cấu trúc package local

```text
local_lib/
├── vpm.toml
└── src/
    └── mod.vut
```

Package local nên có `vpm.toml` riêng để VPM biết tên, entry và dependency của package.

## Import

```vut
import local_lib

local_lib.run()
```

## Best practices

Dùng relative path ngắn và ổn định. Nếu package đã sẵn sàng chia sẻ cho team, chuyển sang Git dependency để đường dẫn không phụ thuộc vào máy cá nhân.

## Mo rong thuc hanh

- Chay lai vi du trong bai voi nhieu input khac nhau de nam chac hanh vi.
- Tach logic thanh ham/module nho de de test va tai su dung.
- Thu tao 1 tinh huong loi co chu dich de hieu thong diep chan doan cua Vut.

## Bai ke tiep

- [quan-ly-package/package-git.md](../quan-ly-package/package-git.md)


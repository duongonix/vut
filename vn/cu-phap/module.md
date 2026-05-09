# Module

## Mục tiêu

Vut dùng module theo file và folder. `src` là import root của project.

## File module

```text
src/
├── main.vut
└── math.vut
```

`src/math.vut`:

```vut
fn add(a, b) {
    return a + b
}

export add
```

`src/main.vut`:

```vut
import math

out(math.add(1, 2))
```

## Folder module

```text
src/
└── math/
    └── mod.vut
```

`mod.vut` là entry của folder module.

## Export

```vut
export add, dev
export add as a
```

Chỉ symbol được export mới visible với importer.

## Resolution order

Vut ưu tiên:

1. source trong project (`src`)
2. dependency theo `vpm.toml` / `vpm-lock.toml`
3. `.vendor`
4. std module
5. global package

## Best practices

- Mỗi module nên export rõ API công khai.
- Dùng `mod.vut` cho package/folder có nhiều file con.
- Tránh circular import.

## Mo rong thuc hanh

- Chay lai vi du trong bai voi nhieu input khac nhau de nam chac hanh vi.
- Tach logic thanh ham/module nho de de test va tai su dung.
- Thu tao 1 tinh huong loi co chu dich de hieu thong diep chan doan cua Vut.

## Bai ke tiep

- [cu-phap/import.md](../cu-phap/import.md)


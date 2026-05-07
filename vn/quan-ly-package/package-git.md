# Package Git

## Mục tiêu

Git package cho phép project dùng thư viện từ repository.

## Thêm Git dependency

```powershell
vpm add github:duongonix/vut_lib
```

Manifest:

```toml
[dependencies]
vut_lib = { source = "github:duongonix/vut_lib" }
```

Git dependency trực tiếp được cài vào:

```text
.vendor/github/user/repo
```

Ví dụ:

```text
.vendor/github/duongonix/vut_lib
```

## Import

```vut
import vut_lib

out(vut_lib.version())
```

## Best practices

Với app production, nên pin version/tag khi VPM hỗ trợ đầy đủ. Với package đang thử nghiệm, dùng branch mặc định có thể tiện nhưng build ít ổn định hơn.

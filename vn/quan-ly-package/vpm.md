# VPM

## Mục tiêu

VPM là package manager của Vut. Nó quản lý project, dependency local, dependency Git, package chính thức, build và run.

```powershell
vpm init
vpm run
```

## Commands

```powershell
vpm init
vpm add ../local_lib
vpm add github:duongonix/vut_lib
vpm add hello_lib
vpm remove hello_lib
vpm install hello_lib
vpm build
vpm run
vpm clean
```

Ý nghĩa:

- `vpm init`: tạo project Vut mới.
- `vpm add ../local_lib`: thêm dependency local.
- `vpm add github:duongonix/vut_lib`: thêm dependency Git trực tiếp.
- `vpm add hello_lib`: thêm package chính thức.
- `vpm remove hello_lib`: xóa dependency khỏi manifest.
- `vpm install hello_lib`: cài package vào `.vendor/`.
- `vpm build`: build project.
- `vpm run`: chạy project.
- `vpm clean`: dọn output build, dùng cho workflow phát hành hoặc build sạch.

## Project structure

```text
my_app/
├── vpm.toml
├── vpm-lock.toml
├── src/
│   └── main.vut
├── .vendor/
└── target/
```

`vpm.toml` là manifest. `vpm-lock.toml` khóa dependency đã resolve. `.vendor/` chứa package được cài. `target/` chứa output build.

## Dependency examples

```toml
[dependencies]
local_lib = "../local_lib"
vut_lib = { source = "github:duongonix/vut_lib" }
hello_lib = "hello_lib"
```

Package chính thức lấy từ repository:

```text
github.com/duongonix/vpm
```

Ví dụ package chính thức:

```text
duongonix/vpm/hello_lib
```

Package chính thức được cài vào:

```text
.vendor/hello_lib
```

Git dependency trực tiếp được cài vào:

```text
.vendor/github/user/repo
```

## Best practices

Commit `vpm.toml` và `vpm-lock.toml` để build reproducible. Không commit `.vendor/` và `target/` nếu project không có lý do đặc biệt. Dùng package local khi đang phát triển nhiều package cùng lúc, sau đó chuyển sang Git hoặc package chính thức khi publish.

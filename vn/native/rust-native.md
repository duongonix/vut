# Rust native plugin

## Mục tiêu

Vut có thể gọi code native viết bằng Rust thông qua dynamic library. Cách này phù hợp cho math, filesystem nâng cao, binding hệ điều hành hoặc phần cần hiệu năng cao.

```vut
import native "math_native"

out(math_native.add(1, 2))
```

## Dynamic library

Native plugin được build thành dynamic library:

- Windows: `.dll`
- Linux: `.so`
- macOS: `.dylib`

VPM có thể build native package rồi đặt artifact vào vị trí runtime tìm được.

## Entry points

Plugin nên expose:

```rust
#[no_mangle]
pub extern "C" fn vut_abi_version() -> u32 {
    1
}

#[no_mangle]
pub extern "C" fn vut_register(registry: &mut VutRegistry) {
    registry.function("add", add);
}
```

`vut_abi_version` giúp runtime kiểm tra tương thích ABI. `vut_register` đăng ký function/class native cho Vut.

## VutValue bridge

Rust native plugin trao đổi dữ liệu qua `VutValue`.

```rust
fn add(args: Vec<VutValue>) -> VutResult<VutValue> {
    let a = args[0].as_number()?;
    let b = args[1].as_number()?;

    Ok(VutValue::Number(a + b))
}
```

Bridge cần chuyển đổi an toàn giữa value runtime của Vut và type Rust.

## Build với VPM

Package native thường có:

```text
math_native/
├── vpm.toml
├── src/
│   └── mod.vut
└── native/
    ├── Cargo.toml
    └── src/
        └── lib.rs
```

```powershell
vpm build
```

`vpm build` có thể build cả phần Vut và Rust native khi package khai báo native target.

## Best practices

Giữ API native nhỏ và ổn định. Validate argument rõ ràng và trả diagnostic thay vì panic. Chỉ dùng native khi Vut thuần không đủ nhanh hoặc cần gọi hệ thống ngoài runtime.

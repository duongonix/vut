# Cài đặt Vut

## Mục tiêu

Trang này hướng dẫn cách build hai CLI chính của Vut: `vut` để chạy chương trình và `vpm` để quản lý package.

## Yêu cầu

- Rust stable
- Cargo
- Git nếu dùng package từ GitHub

Kiểm tra:

```powershell
rustc --version
cargo --version
git --version
```

## Build từ source

Trong thư mục repo:

```powershell
cargo build -p vut -p vpm --release
```

Kết quả:

```text
target/release/vut
target/release/vpm
```

Trên Windows:

```text
target/release/vut.exe
target/release/vpm.exe
```

## Kiểm tra cài đặt

```powershell
target/release/vut --version
target/release/vpm --version
```

## Cài vào PATH

Bạn có thể copy hai binary vào thư mục đã nằm trong `PATH`, hoặc thêm `target/release` vào `PATH` trong môi trường dev.

## Release đa nền tảng

Repo có GitHub Actions workflow build cho Windows, Linux, macOS Intel và macOS Apple Silicon. Khi push tag dạng `v0.1.0`, workflow sẽ tạo GitHub Release kèm artifact.

## Ghi chú

Vut chưa yêu cầu runtime ngoài binary. Native plugin có thể cần dynamic library `.dll`, `.so`, hoặc `.dylib` đi kèm package.


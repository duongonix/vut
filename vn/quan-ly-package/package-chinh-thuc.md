# Package chính thức

## Mục tiêu

Package chính thức là package được lấy từ registry/repository chuẩn của VPM.

Repository chính thức:

```text
github.com/duongonix/vpm
```

Ví dụ package:

```text
duongonix/vpm/hello_lib
```

## Cài package chính thức

```powershell
vpm add hello_lib
vpm install hello_lib
```

Manifest:

```toml
[dependencies]
hello_lib = "hello_lib"
```

Package được cài vào:

```text
.vendor/hello_lib
```

## Import

```vut
import hello_lib

hello_lib.say()
```

## Best practices

Đặt tên package ngắn, rõ nghĩa và tránh trùng với standard module như `fs` hoặc `vutcon`. Khi publish, thêm README, ví dụ dùng và version rõ ràng để người khác dễ đánh giá.

## Mo rong thuc hanh

- Chay lai vi du trong bai voi nhieu input khac nhau de nam chac hanh vi.
- Tach logic thanh ham/module nho de de test va tai su dung.
- Thu tao 1 tinh huong loi co chu dich de hieu thong diep chan doan cua Vut.

## Bai ke tiep

- [native/rust-native.md](../native/rust-native.md)


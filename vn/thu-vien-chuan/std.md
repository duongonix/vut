# Thư viện chuẩn

## Mục tiêu

Thư viện chuẩn của Vut cung cấp những module cần thiết để viết chương trình thực tế mà không phải tự xây mọi thứ từ đầu. Các module chuẩn được import giống module thường:

```vut
import fs
import vutcon at spawn, channel
```

## Module hiện có

Các module quan trọng:

- `fs`: filesystem, path utilities, metadata.
- `vutcon`: concurrency, task, channel, select, sleep.
- các builtin cơ bản như `out`, kiểu dữ liệu runtime, function và object.

## Cách resolution hoạt động

Khi bạn import một module:

```vut
import fs
```

Runtime/compiler tìm theo thứ tự:

1. module local trong `src/`;
2. dependency trong `.vendor/` theo `vpm.toml` và `vpm-lock.toml`;
3. standard module của Vut.

Điều này giúp project có thể override module bằng code local khi cần, nhưng cũng có nghĩa là bạn nên tránh đặt module local trùng tên standard module nếu không cố ý.

## Import cụ thể

```vut
import fs at read, write

write("data.txt", "hello")
out(read("data.txt"))
```

Import cụ thể giúp code ngắn hơn, nhưng với module lớn, namespace rõ ràng như `fs.read(...)` thường dễ đọc hơn.

## Kết hợp module chuẩn

```vut
import fs
import vutcon at spawn, channel

let jobs = channel()

spawn(() {
    let path = jobs.receive()
    let text = fs.read(path)
    out(text)
})

jobs.send("README.md")
```

## Best practices

Giữ import ở đầu file. Dùng namespace cho module có nhiều function để tránh trùng tên. Với module được dùng rất thường xuyên, `import module at name` giúp code gọn hơn nhưng nên giới hạn số tên import.

## Xem thêm

- [fs](./fs.md)
- [vutcon](./vutcon.md)
- [Import](../cu-phap/import.md)

## Mo rong thuc hanh

- Chay lai vi du trong bai voi nhieu input khac nhau de nam chac hanh vi.
- Tach logic thanh ham/module nho de de test va tai su dung.
- Thu tao 1 tinh huong loi co chu dich de hieu thong diep chan doan cua Vut.

## Bai ke tiep

- [thu-vien-chuan/fs.md](../thu-vien-chuan/fs.md)


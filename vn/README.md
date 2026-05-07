# Tài liệu Vut

Đây là tài liệu tiếng Việt cho ngôn ngữ lập trình Vut. Bộ tài liệu này đi từ nhập môn đến cú pháp, thư viện chuẩn, VutCom, VPM, native plugin và ví dụ thực tế.

Vut là ngôn ngữ thông dịch viết bằng Rust. Vut hướng đến cú pháp đơn giản, runtime dynamic, module rõ ràng, lỗi dễ đọc, package manager riêng và khả năng mở rộng bằng Rust native plugin.

## Nên đọc theo thứ tự

1. [Cài đặt](bat-dau/cai-dat.md)
2. [Chương trình đầu tiên](bat-dau/chuong-trinh-dau-tien.md)
3. [Cấu trúc dự án](bat-dau/cau-truc-du-an.md)
4. [Biến](cu-phap/bien.md)
5. [Hàm](cu-phap/ham.md)
6. [Lambda](cu-phap/lambda.md)
7. [Điều kiện](cu-phap/dieu-kien.md)
8. [Vòng lặp](cu-phap/vong-lap.md)
9. [Match](cu-phap/match.md)
10. [OOP](cu-phap/oop.md)
11. [Module](cu-phap/module.md) và [Import](cu-phap/import.md)
12. [Lỗi](cu-phap/loi.md)

## Các mảng chính

- Thư viện chuẩn: [fs](thu-vien-chuan/fs.md), [vutcon](thu-vien-chuan/vutcon.md), [std](thu-vien-chuan/std.md)
- VutCom: [giới thiệu](vutcom/gioi-thieu.md), [component](vutcom/component.md), [child](vutcom/child.md), [rendering](vutcom/rendering.md)
- Package manager: [VPM](quan-ly-package/vpm.md), [dependencies](quan-ly-package/dependencies.md), local/git/official packages
- Native: [Rust native](native/rust-native.md), [plugin](native/plugin.md), [FFI](native/ffi.md)
- Ví dụ: [CLI](vi-du/cli.md), [web](vi-du/web.md), [concurrency](vi-du/concurrency.md), [game](vi-du/game.md)

## Ví dụ nhanh

```vut
import fs

fn add(a, b) {
    return a + b
}

fs.write("result.txt", "sum = {add(2, 3)}")
out(fs.read("result.txt"))
```

Ghi chú: Vut đang phát triển nhanh. Một số API là MVP, nhưng tài liệu này mô tả đúng hành vi hiện tại hoặc ghi rõ phần nào là hướng mở rộng.


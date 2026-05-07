# Ví dụ CLI

## Mục tiêu

Ví dụ này tạo một CLI nhỏ đọc file, xử lý nội dung và ghi kết quả ra file khác bằng module `fs`.

## Code

```vut
import fs

let input = "input.txt"
let output = "output.txt"

if !fs.exists(input) {
    fs.write(input, "hello vut\n")
}

let text = fs.read(input)
let result = "processed:\n{text}"

fs.write(output, result)
out(fs.read(output))
```

## Giải thích

Chương trình chạy từ top-level, không cần `main()`. `fs.exists` kiểm tra file đầu vào. `fs.read` và `fs.write` xử lý text file.

## Best practices

Với CLI thực tế, gom path cấu hình ở đầu file. Dùng `fs.join` nếu ghép path để tránh lỗi separator giữa Windows và Unix.

# Module `fs`

## Mục tiêu

`fs` là standard module dùng để làm việc với filesystem: đọc/ghi file, tạo/xóa thư mục, copy/move, liệt kê thư mục, xử lý path và đọc metadata.

Module này được thiết kế như API native của Vut:

```vut
import fs

fs.write("hello.txt", "Hello Vut")
out(fs.read("hello.txt"))
```

## Import

```vut
import fs
import fs at read, write, exists
```

Khi dùng `import fs`, bạn gọi qua namespace `fs.read(...)`. Khi dùng `import fs at ...`, tên function được đưa trực tiếp vào scope hiện tại.

```vut
import fs at read, write

write("out.txt", "data")
out(read("out.txt"))
```

## Đọc và ghi file text

Phase đầu của `fs` tập trung vào text file.

```vut
import fs

fs.write("note.txt", "first line\n")
fs.append("note.txt", "second line\n")

let text = fs.read("note.txt")
out(text)
```

`fs.write(path, content)` ghi đè file nếu file đã tồn tại. `fs.append(path, content)` thêm nội dung vào cuối file.

## Kiểm tra path

```vut
import fs

if fs.exists("src/main.vut") {
    out("exists")
}

if fs.is_file("src/main.vut") {
    out("file")
}

if fs.is_dir("src") {
    out("directory")
}
```

`exists` chỉ kiểm tra path có tồn tại. `is_file` và `is_dir` dùng khi logic cần phân biệt file với thư mục.

## Tạo và xóa

```vut
import fs

fs.mkdir("logs")
fs.mkdir_all("target/cache/data")

fs.write("logs/app.log", "started\n")
fs.remove("logs/app.log")

fs.remove_dir("logs")
fs.remove_all("target/cache")
```

`remove_dir` chỉ nên dùng với thư mục rỗng. Nếu cần xóa recursive, dùng `remove_all`.

## Copy và move

```vut
import fs

fs.write("a.txt", "hello")
fs.copy("a.txt", "b.txt")
fs.move("b.txt", "archive.txt")
```

`fs.move(from, to)` dùng cho rename hoặc di chuyển file/folder tùy khả năng của hệ điều hành.

## Liệt kê thư mục

```vut
import fs

for item in fs.list("src") {
    out(item)
}
```

`fs.list(path)` trả về `Array<String>` gồm tên các file/folder con. Thứ tự trả về có thể phụ thuộc platform, vì vậy nếu cần output ổn định cho test hoặc build script, hãy sort ở tầng ứng dụng khi Vut có helper phù hợp.

## Metadata

```vut
import fs

let meta = fs.metadata("src/main.vut")

out(meta.path)
out(meta.is_file)
out(meta.size)
out(meta.modified)
```

`fs.metadata(path)` trả về object:

```vut
{
    path = "...",
    is_file = true,
    is_dir = false,
    size = 123,
    readonly = false,
    created = "...",
    modified = "..."
}
```

Nếu platform không hỗ trợ `created`, giá trị có thể là `null`.

## Path utilities

```vut
import fs

out(fs.join("src", "main.vut"))
out(fs.basename("src/main.vut"))
out(fs.dirname("src/main.vut"))
out(fs.extname("src/main.vut"))
out(fs.stem("src/main.vut"))
out(fs.normalize("./src/../src/main.vut"))
out(fs.absolute("src/main.vut"))
```

Các function:

- `fs.join(a, b)` ghép path theo separator của platform.
- `fs.basename(path)` lấy tên file/folder cuối.
- `fs.dirname(path)` lấy thư mục cha.
- `fs.extname(path)` lấy extension không gồm dấu chấm.
- `fs.stem(path)` lấy tên file không gồm extension.
- `fs.normalize(path)` chuẩn hóa path.
- `fs.absolute(path)` chuyển sang absolute path.

## Working directory

```vut
import fs

out(fs.cwd())
out(fs.home())
out(fs.temp_dir())

fs.chdir("examples")
out(fs.cwd())
```

`fs.home()` có thể trả `null` nếu runtime không lấy được home directory.

## Diagnostics

`fs` không panic khi gặp lỗi. Lỗi được chuyển thành diagnostic kiểu Rust compiler:

```text
error[E8001]: file not found `data/input.txt`
  --> src/main.vut:3:16
   |
 3 | fs.read("data/input.txt")
   |         ^^^^^^^^^^^^^^^^ file does not exist
   |
help: check the path or create the file first
```

Nhóm lỗi chính:

- `E8001` file not found
- `E8002` permission denied
- `E8003` path is not file
- `E8004` path is not directory
- `E8005` invalid path
- `E8006` read failed
- `E8007` write failed
- `E8008` remove failed
- `E8009` copy failed
- `E8010` move failed
- `E8011` metadata failed
- `E8012` directory listing failed

## Best practices

Ưu tiên `fs.join` thay vì tự nối chuỗi path để code chạy tốt trên Windows, Linux và macOS. Kiểm tra `exists`, `is_file`, `is_dir` trước các thao tác nguy hiểm nếu lỗi không phải một phần của flow bình thường. Với tool build hoặc CLI, nên ghi file vào `target/`, `.vendor/` hoặc thư mục cấu hình rõ ràng thay vì ghi lung tung ở root project.

## Mo rong thuc hanh

- Chay lai vi du trong bai voi nhieu input khac nhau de nam chac hanh vi.
- Tach logic thanh ham/module nho de de test va tai su dung.
- Thu tao 1 tinh huong loi co chu dich de hieu thong diep chan doan cua Vut.

## Bai ke tiep

- [thu-vien-chuan/vutcon.md](../thu-vien-chuan/vutcon.md)


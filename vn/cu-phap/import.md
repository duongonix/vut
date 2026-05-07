# Import

## Mục tiêu

Trang này liệt kê các dạng import hiện có trong Vut.

## Namespace import

```vut
import math
out(math.add(1, 2))
```

## Alias

```vut
import math as m
out(m.add(1, 2))
```

## Selected import

```vut
import math at add, dev
out(add(1, 2))
```

## Nested path

```vut
import math.pro at plus
out(plus(1, 2))
```

## Glob import

```vut
import math at *
```

Dùng cẩn thận vì có thể làm namespace khó đọc.

## Relative import

```vut
import .c
import ..b.b_child
```

Relative import hữu ích trong module con. Nếu vượt quá root hợp lệ, runtime báo lỗi import.

## Native import

```vut
import native "math_native"
out(math_native.add(1, 2))
```

## Best practices

- Ưu tiên namespace import cho module lớn.
- Dùng selected import cho vài function nhỏ, phổ biến.
- Tránh glob import trong code library.


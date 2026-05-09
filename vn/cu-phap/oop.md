# OOP

## Mục tiêu

Vut hỗ trợ OOP dynamic: class, instance, field, method, inheritance, `self`, `super`, `_init()` và private convention bằng `_`.

## Class và field

```vut
class Student(name, age) {
    name = name
    age = age
}

let s = Student("nam", 20)
out(s.name)
```

Field được evaluate khi tạo object, theo thứ tự từ trên xuống.

```vut
class Test() {
    a = 1
    b = a + 1
}
```

## Method và self

```vut
class Student(name) {
    name = name

    fn print_name() {
        out(self.name)
    }
}

let s = Student("nam")
s.print_name()
```

## Constructor lifecycle `_init()`

```vut
class Student(name) {
    name = name

    fn _init() {
        out("created")
    }
}
```

Runtime gọi `_init()` sau khi khởi tạo field.

## Inheritance và super

```vut
class Human(name) {
    fn _init() {
        out("Human created")
    }
}

class Student(name, age): Human {
    age = age

    fn _init() {
        super._init()
        out("Student created")
    }
}
```

## Private convention

Field/method bắt đầu bằng `_` là private, chỉ dùng trong class method.

```vut
class Student(name, age): Human {
    name = name
    age = age
    _id = 1

    fn _init() {
        out("created")
    }

    fn eat() {
        out(name)
    }

    fn _speak() {
        out("private")
    }
}
```

`s._id` hoặc `s._speak()` từ bên ngoài sẽ báo lỗi private access.

## Best practices

- Dùng `_init()` cho side effect khởi tạo.
- Dùng `self.field` khi muốn đọc/ghi field rõ ràng trong method.
- Không lạm dụng inheritance; ưu tiên object đơn giản nếu đủ.

## Mo rong thuc hanh

- Chay lai vi du trong bai voi nhieu input khac nhau de nam chac hanh vi.
- Tach logic thanh ham/module nho de de test va tai su dung.
- Thu tao 1 tinh huong loi co chu dich de hieu thong diep chan doan cua Vut.

## Bai ke tiep

- [cu-phap/module.md](../cu-phap/module.md)


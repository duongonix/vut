# OOP

## Goal

Vut supports dynamic OOP: classes, instances, fields, methods, inheritance, `self`, `super`, `_init()`, and the `_` private convention.

## Classes and Fields

```vut
class Student(name, age) {
    name = name
    age = age
}

let s = Student("nam", 20)
out(s.name)
```

Fields are evaluated during object creation from top to bottom.

```vut
class Test() {
    a = 1
    b = a + 1
}
```

## Methods and self

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

## Constructor Lifecycle `_init()`

```vut
class Student(name) {
    name = name

    fn _init() {
        out("created")
    }
}
```

The runtime calls `_init()` after field initialization.

## Inheritance and super

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

## Private Convention

Fields and methods starting with `_` are private and can only be used inside class methods.

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

`s._id` or `s._speak()` from outside reports a private access error.

## Best Practices

- Use `_init()` for initialization side effects.
- Use `self.field` when reading or writing fields inside methods.
- Do not overuse inheritance; prefer simple objects when enough.


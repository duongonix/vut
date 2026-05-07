# Functions

## Goal

Vut functions use `fn` and support parameters, default arguments, named arguments, variadic arguments, and `return`.

## Function Declaration

```vut
fn add(a, b) {
    return a + b
}

out(add(2, 3))
```

## Default Parameters

```vut
fn greet(name, prefix = "Hello") {
    out("{prefix} {name}")
}

greet("Vut")
greet("Vut", prefix = "Hi")
```

## Named Arguments

```vut
fn area(width, height) {
    return width * height
}

out(area(height = 5, width = 10))
```

## Variadic Parameters

```vut
fn sum(...nums) {
    let total = 0
    for n in nums {
        total += n
    }
    return total
}

out(sum(1, 2, 3))
```

## Hoisting and Immutability

Function declarations are hoisted and function bindings are immutable.

```vut
out(add(1, 2))

fn add(a, b) {
    return a + b
}
```

## Best Practices

- Use `return` when you want a clear exit point.
- Use named arguments for functions with many same-shaped parameters.
- Put variadic parameters last.


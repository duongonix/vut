# Variables and Values

## Goal

Learn how to declare variables, constants, basic values, and destructuring in Vut.

## `let`

`let` creates a binding that can be reassigned.

```vut
let count = 1
count = count + 1
out(count)
```

## `const`

`const` creates a binding that cannot be reassigned.

```vut
const answer = 42
out(answer)
```

Reassigning a `const` reports an `E4003` error.

## Value Types

Vut currently has:

```vut
let n = 10
let ok = true
let text = "hello"
let items = [1, 2, 3]
let user = { name: "Vut", age: 1 }
let empty = null
```

Objects use identifier or string keys. Field access:

```vut
out(user.name)
```

## String Interpolation

```vut
let name = "Vut"
out("Hello {name}")
```

## Destructuring

```vut
let user = { name: "Vut", age: 1 }
let { name, age } = user

let point = [10, 20]
let [x, y] = point
```

Defaults are supported:

```vut
let { role = "guest" } = { name: "nam" }
out(role)
```

## Best Practices

- Use `const` for values that do not change.
- Use `let` for state that changes in loops or algorithms.
- Destructuring keeps object-heavy code short, but avoid it when it hides intent.


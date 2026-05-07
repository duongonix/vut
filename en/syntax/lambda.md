# Lambda

## Goal

Lambdas are unnamed function values. Vut uses them for callbacks, event handlers, concurrency, and APIs such as `spawn`.

## Block Lambda

```vut
let hello = () {
    out("hello")
}

hello()
```

## Arrow Lambda

```vut
let add = (a, b) => a + b
out(add(2, 3))
```

## Lambda With Default Arguments

```vut
let greet = (name, prefix = "Hello") {
    out("{prefix} {name}")
}

greet("Vut")
```

## With `vutcon`

```vut
import vutcon at spawn

spawn(() {
    out("running")
})
```

Do not use:

```vut
spawn {
}
```

Direct blocks may conflict with VutCom syntax.

## Best Practices

- Use block lambdas when the body has multiple statements.
- Use arrow lambdas for short expressions.
- For complex callbacks, consider a named `fn`.


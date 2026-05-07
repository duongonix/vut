# Web Example with VutCom

## Goal

This example shows how to write components with VutCom. The runtime builds the object tree; you do not manually write `{ type, props, children }`.

## Code

```vut
com App() {
    return child(id = "app")
}

com Button(onclick) {
    return child()
}

com Text(text) {
    return child()
}

let app = App {
    Button(
        onclick = () => out("clicked")
    ) {
        Text(text = "Click")
    }

    for i in 1..3 {
        Text(text = "item {i}")
    }
}
```

## Explanation

`App`, `Button`, and `Text` are components. `Button` receives an event handler as a lambda. `for` runs directly inside the component block to create multiple nodes.

## Best practices

Use named arguments for props. Keep components small. Move longer logic into normal functions so render blocks remain readable.

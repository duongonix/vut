# `child(...)`

## Goal

`child(...)` is the core helper in VutCom. It tells the runtime that the current component returns a node or children for the object tree.

```vut
com Text(text) {
    return child()
}
```

## Props for child

You can pass named arguments:

```vut
com App() {
    return child(id = "root", role = "app")
}
```

These props become runtime data used while building the tree.

## `item`

Inside a component block, `item` is the current object.

```vut
let app = App {
    let { id } = item
    Text(text = "id = {id}")
}
```

`item` is useful when a parent component creates context or passes data to children.

## Event handler

Event handlers usually use lambdas:

```vut
Button(
    onclick = () => out("ok")
) {
    Text(text = "Click")
}
```

## Best practices

Use `child(...)` instead of manually creating object trees. Keep `child` props small and meaningful. For dynamic data, compute values first and then pass them through named arguments so the block stays readable.

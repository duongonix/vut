# Rendering

## Goal

Rendering in VutCom is the process where the runtime executes components, collects props and children, and builds an object tree. Users write components and blocks; the runtime handles the structure.

## Basic flow

```vut
com App() {
    return child(id = "app")
}

com Text(text) {
    return child()
}

let tree = App {
    Text(text = "Hello")
}
```

The runtime:

1. calls `App`;
2. creates a node from `child(id = "app")`;
3. executes the children block;
4. calls `Text(text = "Hello")`;
5. attaches the child node to the tree.

## Control flow while rendering

```vut
let tree = App {
    for i in 1..3 {
        Text(text = "row {i}")
    }

    if show_footer {
        Text(text = "footer")
    }

    match status {
        "loading" => Text(text = "Loading")
        "error" => Text(text = "Error")
        _ => Text(text = "Ready")
    }
}
```

Control flow is a natural part of a VutCom block.

## Notes

VutCom does not require `main()`. You can build a tree at top level like any other Vut program. If the rendering backend is web, terminal UI, or game UI, that tree can be handled by the corresponding renderer.

## Best practices

Keep rendering deterministic: the same props should produce the same tree. Avoid unpredictable side effects in render blocks, except for event handler lambdas that run later when an event occurs.

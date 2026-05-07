# Introduction to VutCom

## Goal

VutCom is Vut's component system. It lets you write UI or object trees with syntax close to normal Vut code, instead of manually building objects such as `{ type, props, children }`.

```vut
com Text(text) {
    return child()
}

let app = Text(text = "Hello")
```

The runtime builds the object tree from components, props, and children.

## `com` keyword

`com` declares a component:

```vut
com Button(onclick) {
    return child()
}
```

Components receive props like function arguments. When calling a component, you can use named arguments.

```vut
Button(onclick = () => out("clicked"))
```

## Component block

A component can be called with a children block:

```vut
com App() {
    return child(id = "ok")
}

com Button(onclick) {
    return child()
}

com Text(text) {
    return child()
}

let app = App {
    let { id } = item

    Button(
        onclick = () => out("ok")
    ) {
        Text(text = "Click")
    }

    for i in 1..3 {
        Text(text = "i = {i}")
    }
}
```

Inside the block, `item` represents the current runtime-provided object. `child(...)` creates a child node or returns children depending on the component being defined.

## Control flow in VutCom

VutCom supports normal control flow:

```vut
let app = App {
    if logged_in {
        Text(text = "Welcome")
    }

    for name in names {
        Text(text = name)
    }

    let label = match status {
        "loading" => "Loading"
        "error" => "Error"
        "success" => "Done"
        _ => "Unknown"
    }

    Text(text = label)
}
```

## Best practices

Keep components small and focused. Use named arguments for event handlers and important props. Avoid manually writing object trees when the VutCom runtime can build them for you.

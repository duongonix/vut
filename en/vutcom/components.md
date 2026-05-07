# Components

## Goal

Components are the main reusable unit in VutCom. A component receives props, runs Vut code, and returns `child(...)`.

```vut
com Text(text) {
    return child()
}
```

## Props

Props are declared in the parameter list:

```vut
com Button(text, onclick) {
    return child()
}
```

When calling a component, use named arguments for readability:

```vut
Button(
    text = "Save",
    onclick = () => out("saved")
)
```

## Children

Components can receive a children block:

```vut
Button(onclick = () => out("ok")) {
    Text(text = "Click")
}
```

The runtime inserts children into the object tree. Users do not need to manually build `{ type, props, children }`.

## Logic inside components

A component body is Vut code:

```vut
com Status(status) {
    let label = match status {
        "loading" => "Loading"
        "error" => "Error"
        "success" => "Done"
        _ => "Unknown"
    }

    return child(text = label)
}
```

## Best practices

Name components with PascalCase. Use clear prop names such as `text`, `onclick`, `value`, and `items`. Avoid putting too much logic into render code; move longer calculations into normal functions.

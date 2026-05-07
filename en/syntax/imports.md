# Imports

## Goal

This page lists the import forms currently supported by Vut.

## Namespace Import

```vut
import math
out(math.add(1, 2))
```

## Alias

```vut
import math as m
out(m.add(1, 2))
```

## Selected Import

```vut
import math at add, dev
out(add(1, 2))
```

## Nested Path

```vut
import math.pro at plus
out(plus(1, 2))
```

## Glob Import

```vut
import math at *
```

Use this carefully because it can make the namespace harder to read.

## Relative Import

```vut
import .c
import ..b.b_child
```

Relative imports are useful inside child modules. If they go beyond the valid root, the runtime reports an import error.

## Native Import

```vut
import native "math_native"
out(math_native.add(1, 2))
```

## Best Practices

- Prefer namespace imports for larger modules.
- Use selected imports for a few common small functions.
- Avoid glob imports in library code.


# Language guide

A short tour of Vut. The normative specification lives in the source repository
under `specs/`.

## Types

```text
int, float            signed 64-bit integer, IEEE-754 binary64
bool                  true / false
str, bytes            UTF-8 text, raw byte buffers
list[T], array[T, N]  growable list, fixed-size array
map[K, V]             hash map
result[T, E]          success or error
T?                    optional value
data, enum, interface user-defined records, variants, and interfaces
```

Fixed-width numerics (`i8..i64`, `u8..u64`, `usize`, `isize`, `f32`, `f64`) are
available, mainly for FFI.

## Bindings and functions

```vut
fn add(a: int, b: int) -> int:
  a + b

fn main():
  total = add(2, 3)      # type inferred
  count: int = 0         # explicit type
  out("$total $count")
```

Functions use `fn name(parameters):` with an indented body. The last expression
is the return value unless an explicit `return` is used.

## Records, enums and interfaces

```vut
data User:
  name: str
  age: int

enum Shape:
  circle(radius: float)
  square(side: float)

interface Named:
  name() -> str
```

Methods are declared as `fn Type.method()` and access the receiver through
`self`. Interfaces enable dynamic dispatch (`dyn`/interface values).

## Control flow

```vut
if score > 90:
  out("A")
elif score > 80:
  out("B")
else:
  out("C")

for i < 10:
  out("$i")

for item in @[1, 2, 3]:
  out("$item")

match shape:
  circle(radius): out("circle $radius")
  square(side): out("square $side")
```

Collections are iterated with `for x in collection:`; counted loops use
`for condition:`.

## Errors and optionals

```vut
fn parse(text: str) -> result[int, str]:
  if text.is_empty():
    return err("empty")
  ok(text.to_i64())

fn find(name: str) -> User?:
  if name == "root":
    return User(name: "root", age: 0)
  null
```

Use `?` to propagate errors and `if value != null` to narrow optionals.

## Modules

```vut
import math
import math._float as float_math   # internal module alias

fn main():
  out("$(math.sqrt(2.0))")
```

Each file is a module. The library entry point of a package is `src/mod.vut`.

## Strings and collections

```vut
fn main():
  name = "vut"
  greeting = "hi, " + name          # concatenation
  out("length $(greeting.len())")

  values = @[3, 1, 2]
  values.push(4)
  values.sort()
  for v in values:
    out("$v")

  scores: map[str, int] = ("ann": 10, "bob": 20)
  if scores.contains_key("ann"):
    out("ann is known")
```

String interpolation uses `"$name"` or `"$(expression)"`.

## Concurrency

```vut
async fn fetch() -> int:
  42

async fn main():
  job: vutcon[int] = vut(() => fetch())
  value = await job
  out("$value")

  ch = channel[int](capacity: 4)
  ch.send(value)
  ch.close()
  received = ch.recv()
```

`async fn` functions run on the runtime scheduler; `vut(...)` schedules a task
and returns a `vutcon[T]` handle awaited with `await`.

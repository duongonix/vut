# Standard library

The official standard library ships with every Vut installation (`~/.vut/std`)
and is imported by name. No setup or download is required.

| Module | Purpose |
| --- | --- |
| `io` | Readers/writers, standard streams, buffered copy |
| `path` | Path parsing and joining |
| `fs` | Files, directories, metadata, permissions |
| `os` | Platform information, home/temp directories, environment-adjacent helpers |
| `env` | Environment variables |
| `time` | Wall-clock timestamps, monotonic instants, durations, sleep |
| `process` | Spawning processes, stdio pipes, exit status |
| `json` | Parsing and serializing JSON |
| `http` | HTTP client (async) |
| `math` | Constants, float/int utilities, transcendentals, random |

## `math`

```vut
import math

fn main():
  out("pi = $(math.PI)")
  out("sqrt(2) = $(math.sqrt(2.0))")
  out("gcd(12, 18) = $(math.gcd(12, 18))")
  out("random = $(math.random_int(1, 6))")
```

- **Constants:** `PI`, `TAU`, `E`, `SQRT_2`, `FRAC_1_PI`, `FRAC_2_PI`,
  `FRAC_PI_2`, `FRAC_PI_3`, `FRAC_PI_4`, `LN_2`, `LN_10`, `LOG2_E`, `LOG10_E`.
- **Float:** `abs`, `min`, `max`, `clamp`, `sign`, `floor`, `ceil`, `round`,
  `trunc`, `fract`, `sqrt`, `cbrt`, `pow`, `powi`, `exp`, `exp2`, `log`, `log2`,
  `log10`, `sin`, `cos`, `tan`, `asin`, `acos`, `atan`, `atan2`, `sinh`, `cosh`,
  `tanh`, `radians`, `degrees`, `copysign`, `hypot`, `fma`, `is_nan`, `is_inf`,
  `is_finite`.
- **Integer:** `gcd`, `lcm`, `is_power_of_two` (and the numeric methods `abs`,
  `min`, `max`, `clamp`, `pow`).
- **Random:** `rng(seed)`, `random`, `random_int`, `random_float`,
  `random_bool`, and the `Rng` methods.

Randomness is pseudo-random and **not** cryptographically secure. A fixed seed
produces a reproducible sequence.

## Error handling

Fallible functions return `result[T, E]` with a module-specific error type:

```vut
import fs

fn main():
  match fs.read_str("data.txt"):
    ok(text): out("$(text.len()) bytes")
    err(error): out("error: $(error)")
```

## Notes

- `float` is IEEE-754 binary64; domain errors yield NaN, overflow yields ±Inf.
- `int` arithmetic wraps on overflow; `pow` saturates and `abs` wraps.
- The standard library source is readable at `~/.vut/std` and is a good
  reference for idiomatic Vut.

# M2.6 Performance Certification

This is the M2.6 certification report and gate definition. It records what was
measured, how, and why the remaining gaps exist at the compiler/runtime level.

## 1. Gate criteria

M2.6 is certified when:

1. Windows/Linux/macOS CI is green (`.github/workflows/ci.yml`).
2. O0/O1/O2/O3 are output-equivalent on the corpus and e2e
   (`crates/vut-compiler/tests/optimizer_e2e.rs`).
3. The optimizer verifier and property tests are green; each phase is
   fail-safe (reverts on verification failure).
4. Memory-safety/leak tests are green on optimized builds (leak counters + the
   Linux ASan/LSan job).
5. A benchmark corpus, a committed baseline, and regression thresholds exist.
6. A win/tie/loss table vs C/Rust (Zig/Go best-effort) exists with
   compiler/runtime explanations for every large gap.
7. The portable CPU baseline is the default; native is opt-in (M2.6.15).
8. No major optimizer architectural blocker remains (analyses, pass manager,
   bounded fixpoint, deterministic output).
9. The M2.6 optimizer passes landed with measurements.
10. SIMD and PGO feasibility reports exist (`specs/compiler/*-feasibility.md`).

## 2. Methodology

- Harness: `crates/vut-bench` (`benchmarks/corpus/<name>/`, `expected.txt`
  verified every run). Wall time is measured around spawn/wait only; the primary
  metric is a **trimmed median** (drops samples >2x the minimum) to resist
  intermittent OS interference.
- Structural metrics are deterministic and collected from MIR **after**
  `vut_mir::optimize` at the requested level; they are the PR-appropriate gate.
- Wall-clock regression runs nightly/on-demand on a dedicated runner
  (`.github/workflows/perf.yml`); shared runners never fail a PR on timing.
- Competitors: C `-O3` and Rust `-C opt-level=3` are the hard set; Zig/Go are
  best-effort. Same algorithm, input, and I/O; a `black_box`/volatile sink
  prevents dead-code elimination.

## 3. Baseline (M2.6.1)

`benchmarks/baseline.json` (schema 2) was captured before any M2.6 optimizer
work and is the reference for all later phases. See `benchmarks/BASELINE.md`.

## 4. Cumulative optimizer effect (M2.6.2–M2.6.14)

Structural MIR counts decreased deterministically (e.g. `list` bounds-checks
1→0, `string` RC 3/3→2/2, `inst-1` on map/prime_count/vutcon) with **no
semantic change** (differential tests green). Wall-clock deltas on the current
micro-corpus are within noise because those workloads are dominated by process
startup and runtime calls rather than the MIR patterns the passes target.

## 5. Win / tie / loss vs Rust (`-C opt-level=3`)

Measured on the baseline Windows machine; C unavailable there, Zig/Go absent.
Small workloads (~3 ms) are startup-dominated; subtract the `startup` baseline
(~3.1 ms) for CPU work.

| workload | Vut O2 | Rust | verdict | explanation (compiler/runtime) |
|---|---:|---:|---|---|
| prime_count | 89.5 | 89.1 | tie | Cranelift `opt_level=speed` matches LLVM `-O3` on tight scalar loops |
| numeric_int | 3.2 | 3.2 | tie | startup-dominated |
| array | 3.2 | 3.6 | tie/win | startup-dominated |
| calls | 5.1 | 5.0 | tie | near-parity; Vut MIR inlining applies to tiny pure functions |
| recursion | 7.8 | 6.0 | loss (~1.3x) | recursive `fib` is not inlined (M2.6.10 inlines only non-recursive, pure, single-block callees); call overhead dominates |
| tight_loop | 8.4 | 3.6 | loss (~2.3x; ~10x after startup) | backend: Cranelift `opt_level=speed` does not collapse an empty counting loop as aggressively as LLVM; no MIR-level loop unrolling/strength reduction for this shape |

No workload was cherry-picked; losses are included.

## 6. Known compiler/runtime-level gaps (for follow-up)

- **Backend loop quality** (`tight_loop`): Cranelift has no LICM/unrolling for
  this shape; Vut's M2.6.5 LICM only hoists invariant scalar ops. Candidate:
  MIR-level induction/strength reduction (deferred part of M2.6.5).
- **Call overhead / recursion**: M2.6.10 inlining is intentionally narrow
  (pure scalar, non-recursive). Aggressive cost-model inlining and WPO are
  deferred (M2.6.11/M2.6.12 delivered analysis only).
- **Allocation/RC/hashing**: the map/string/allocation workloads exercise the
  runtime, not the MIR passes; M2.6.9 only folds constant string concatenation.
  A runtime string builder and map hashing work remain future incremental work.
- **Devirtualization**: analysis is in place (`analyze::devirt`), but rewriting
  `InterfaceCall` needs an interface-data MIR operation (deferred).
- **Async frames**: M2.6.14 removes dead scalar spills and overwritten frame
  states; frame compaction/dead-field elimination is a lowering-level change.
- **Corpus granularity**: small workloads are startup-dominated; add an
  amortized inner-iteration mode and larger real-world mini apps.

## 7. Standard library math intrinsics (post-M2.6)

The `math` module's scalar `float` operations are lowered to native Cranelift
instructions (`sqrt`, `fabs`, `floor`, `ceil`, `trunc`, `fma`, `fcopysign`)
instead of runtime calls. `round` deliberately keeps the runtime call: the
`nearest` instruction rounds half to even, which differs from `round`'s
half-away-from-zero.

- **Workload:** `benchmarks/corpus/math_float/` (5,000,000 iterations of
  `sqrt`/`abs`/`floor`/`ceil`/`trunc`, deterministic checksum output).
- **Object check:** `crates/vut-compiler/tests/intrinsic_lowering_e2e.rs` asserts
  the emitted object no longer references `vut_rt_f64_{sqrt,abs,floor,ceil,trunc}_v1`
  while `round` still references `vut_rt_f64_round_v1`.

| configuration (O2) | trimmed median | vs before |
|---|---:|---:|
| runtime calls (pre-intrinsics) | 162.9 ms | — |
| native instructions | 80.8 ms | 2.0x faster |
| native instructions + wrapper inlining | 59.3 ms | 2.7x faster |
| Rust `-O` (same algorithm) | ~17.5 ms | Vut ~3.4x slower |

The remaining gap vs Rust is backend codegen/loop quality (the same root cause as
the `tight_loop` finding in §6), not the math operations themselves: the hot ops
are already single hardware instructions. The `math.*` wrappers are inlined only
after treating pure scalar numeric builtins as non-observable in the optimizer
effect model.

Two latent M2.6 optimizer bugs were exposed and fixed while measuring this:

- The inliner did not bind `Borrow` parameter reads, so inlining a receiver
  method (`self.field`) left the cloned `Borrow` pointing at the *caller's* local
  at the same index (miscompile/backend error for any stdlib import at O1+).
  Regression: `optimizer_e2e::optimized_matches_reference_for_inlined_receiver_methods`.
- Pure scalar numeric builtins were classified observable, so their tiny wrappers
  were never inlined and unused pure computations could not be removed.

## 8. How to reproduce

```text
cargo build -p vut-runtime
cargo run -p vut-bench -- run --levels 0,1,2,3 --iterations 20 --warmup 3 --out target/vut-bench/report.json
cargo run -p vut-bench -- compare benchmarks/baseline.json target/vut-bench/report.json --threshold 15
cargo run -p vut-bench -- competitors --iterations 20 --warmup 3
```

# Vut Performance Baseline (M2.6.1)

This is the pre-optimization baseline produced by `crates/vut-bench` at the
start of M2.6, before any M2.6 optimizer work. Every later M2.6 phase compares
against `benchmarks/baseline.json` to measure real improvement.

- **Baseline file:** `benchmarks/baseline.json` (schema 2)
- **Target:** host triple (portable CPU baseline; native codegen is opt-in)
- **Machine:** developer Windows x86_64 machine
- **Corpus:** 15 single-file workloads under `benchmarks/corpus/<name>/` at
  capture time; `math_float` was added later (see `benchmarks/CERTIFICATION.md` §7)
- **Command:**

  ```text
  cargo run -p vut-bench -- run --levels 0,1,2,3 --iterations 20 --warmup 3 --out benchmarks/baseline.json
  ```

## Methodology

- Each workload is compiled at O0–O3 with `vut-compiler` and run in-process
  through the same harness; output is verified against `expected.txt` on every
  run (a mismatch fails the run).
- **Wall time** is measured only around the child process spawn/wait.
- **`trimmed_median_ms`** is the primary metric: the median after discarding
  samples slower than 2× the minimum. This removes intermittent OS/scanner
  interference. On this machine a single workload block was observed to jump
  from ~52 ms to ~286 ms intermittently (same binary; direct runs always ~55 ms);
  trimming makes the metric stable while a genuine regression still raises the
  minimum.
- Peak RSS and approximate CPU time are **opt-in** (`VUT_BENCH_SAMPLE=1`): the
  sampler perturbs short-running children on this platform, so it is off by
  default. `peak_rss_bytes = 0` means "not sampled".
- **Structure metrics** are deterministic and collected from the MIR *after*
  running `vut_mir::optimize` at the requested level (checked by tests). They
  are noise-free and suitable for PR regression gates.
- Competitor comparison (`vut-bench competitors`) uses the same process sampler;
  C and Rust are the hard set, Zig/Go best-effort.

## Vut timings (trimmed median, ms)

| workload | O0 | O1 | O2 | O3 | MIR inst O0→O2 |
|---|---:|---:|---:|---:|---:|
| alloc | 132.12 | 128.29 | 125.91 | 125.11 | 33→32 |
| array | 3.30 | 3.26 | 3.31 | 3.43 | 34→34 |
| bytes | 58.23 | 59.05 | 59.27 | 59.19 | 45→45 |
| calls | 5.13 | 5.31 | 5.11 | 5.23 | 28→28 |
| closure | 9.14 | 9.18 | 9.42 | 9.02 | 34→34 |
| interface | 52.24 | 51.47 | 55.31 | 56.03 | 47→47 |
| list | 4.63 | 4.50 | 4.67 | 4.85 | 50→50 |
| map | 7.00 | 7.16 | 7.29 | 7.39 | 64→62 |
| numeric_int | 3.46 | 3.40 | 3.53 | 3.24 | 24→23 |
| prime_count | 89.40 | 89.54 | 89.71 | 89.66 | 61→60 |
| recursion | 8.17 | 8.01 | 7.85 | 8.03 | 22→21 |
| startup | 3.19 | 3.00 | 3.18 | 3.31 | 3→3 |
| string | 22.48 | 22.02 | 21.98 | 21.95 | 27→25 |
| tight_loop | 8.62 | 8.38 | 8.38 | 8.22 | 16→16 |
| vutcon | 4.63 | 4.44 | 4.51 | 4.56 | 81→81 |

Small workloads (~3 ms) are dominated by process startup; compare CPU work by
subtracting the `startup` baseline (~3.1 ms).

## Structure metrics (O0 → O2), selected

| workload | RC retain/release | MakeUnique | bounds-checked reads | notes |
|---|---|---:|---:|---|
| list | 6/1 → 6/1 | 1 | 1 → **0** | canonical-loop bounds elimination fires |
| string | 3/3 → **2/2** | 0 | 0 | redundant RC elided |
| map | 9/1 → 9/1 | 1 | 0 | instruction count 64→62 |
| alloc | 5/3 → 5/3 | 0 | 0 | 33→32 |
| array | 4/1 → 4/1 | 0 | 1 → 1 | static-array access not eliminated |
| calls/closure/interface/tight_loop/vutcon | unchanged | — | — | optimizer has no effect |

The baseline confirms the M2.4 optimizer's current reach is narrow: most
allocation/RC/bounds opportunities in these patterns are untouched. That is the
motivation for M2.6 phases 3–14.

## Competitor snapshot (Rust `-C opt-level=3`; C unavailable on this machine)

| workload | Vut O2 | Rust | notes |
|---|---:|---:|---|
| prime_count | 89.48 | 89.07 | parity on tight scalar loops (matches M2.4) |
| numeric_int | 3.20 | 3.20 | parity (startup-dominated) |
| array | 3.19 | 3.59 | startup-dominated |
| calls | 5.13 | 5.01 | near-parity |
| recursion | 7.80 | 6.03 | ~1.3× slower |
| tight_loop | 8.41 | 3.61 | ~2.3× slower (empty loop; ~10× after subtracting startup) |

`cc` is not installed on the baseline Windows machine, so C columns are empty
here; CI/Linux runs include C. Zig/Go are best-effort.

## Findings for M2.6

- **Optimizer reach is shallow** (see structure table): escape/SROA/RC/bounds
  work is the largest available win.
- **`tight_loop`** is much slower than Rust; investigate Cranelift codegen for
  empty/counting loops (M2.6.15/Roadmap).
- **`recursion`** is ~1.3× slower; candidate for inlining/cost-model work.
- **`prime_count`** already matches Rust -O3, confirming backend parity on tight
  scalar work; M2.6 wins must come from Vut-specific semantics, not arithmetic.
- Small workloads are startup-dominated; future harness work should add an
  amortized/inner-iteration mode to measure sub-millisecond kernels precisely.
- The intermittent ~286 ms block on a single workload is an environment artifact;
  `trimmed_median_ms` neutralizes it and the raw median is retained for
  diagnosis.

## Files

- Corpus: `benchmarks/corpus/<name>/{main.vut,expected.txt}`
- Competitor sources: `benchmarks/competitors/<name>.{c,cpp,rs,zig,go}`
- Baseline: `benchmarks/baseline.json`
- Harness: `crates/vut-bench/`

`benchmarks/compare.ps1` and `benchmarks/prime_count.*` are the pre-M2.6
process-level scripts; they are superseded by `vut-bench` (the `prime_count`
workload is now in the corpus) and kept only for historical reference.
`benchmarks/incremental.ps1` (compile-time) is not yet replaced.

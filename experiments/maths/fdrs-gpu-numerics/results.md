# Results — fdrs-gpu-numerics, Focus 1 (deterministic FDRS reduction over Burn tensors)

> **Scientific status:** `cross-checked` (float candidate, gated by the exact-rational mirror).
> **Pre-registration:** hypotheses H1–H4 and the metric/falsifier set were fixed in `README.md`
> (G0 charter + G1 protocol) **before** this run. Primary run: `runs/2026-06-19-cpu-baseline/`.
> **Exactness tag:** `float` — weakest tag in the chain wins. Every accuracy number here is a
> *candidate rank*, validated only insofar as it does not contradict the `exact` gate (it does not).

This experiment executes an FDRS `ReductionPlan` (a variable-radix odometer / reduction tree, from
`fdrs-tree`) as **Burn tensor ops** and measures the resulting f32 error against an **exact rational
reference**. Sweep: 3 distributions × 3 sizes × 5 seeds × 6 methods. CPU backend = NdArray (f32).

| method | what it is |
|---|---|
| `naive` | left-to-right f32 fold — the `O(n)·ε` baseline |
| `kahan` | compensated summation — high-accuracy host reference (classical) |
| `burn_native` | Burn's own `tensor.sum()` — "ordinary Burn reduction" |
| `fdrs_binary` | FDRS pairwise tree (radix 2), order fully determined |
| `fdrs_radix4` | FDRS fixed radix-4 odometer tree |
| `fdrs_adaptive` | FDRS **non-stationary** tree — sort by fp32 exponent, bucket, binary tail |

## Verdict against the pre-registered hypotheses

| Hyp | Claim | Verdict | Evidence |
|---|---|---|---|
| **H1** | Fixed plan + input ⇒ **bit-identical** f32 across repeated runs | ✅ **CONFIRMED** | every one of the 54 cells reports `all-fdrs-bit-stable`; `reproducible:true` for all records |
| **H2** | Tree/pairwise error ≪ naive on large/ill-conditioned sums | ✅ **CONFIRMED** | see table — binary/radix4 beat naive **and** `burn_native` at n ≥ 4096; ~36× on cancellation |
| **H3** | **Adaptive** exponent-bucket tree beats the **fixed** binary tree | ❌ **REFUTED** | adaptive wins **2/9** cells (only n=256); loses 6/9, up to 9.3× worse at scale — see `NEGATIVE.md` |
| **H4** | Exact reduction is order-invariant (the gate) | ✅ **CONFIRMED** | `fdrs-tree` `exact_sum_order_invariant` + 6 sibling theorems green (rung-2, `exact` tag) |

### Median relative error vs the exact reference (CPU/NdArray, f32)

```
distribution: uniform
  size |      naive      kahan  burn_native  fdrs_binary  fdrs_radix4 fdrs_adaptive
   256 |    1.27e-7    2.89e-8      7.73e-8      4.64e-8      4.25e-8      4.24e-8
  4096 |    5.67e-7    2.98e-8      4.59e-7      1.95e-7      1.21e-7      3.60e-7
 16384 |    1.28e-6    2.49e-8      6.63e-7      1.22e-7      1.10e-7      6.60e-7

distribution: wide_dynamic
  size |      naive      kahan  burn_native  fdrs_binary  fdrs_radix4 fdrs_adaptive
   256 |    3.86e-8    2.67e-8      6.89e-8      5.95e-8      8.24e-8      5.95e-8
  4096 |    4.89e-7    3.01e-8      7.25e-7      1.44e-7      1.44e-7      1.44e-7
 16384 |    1.35e-6    2.79e-8      3.19e-7      8.80e-8      7.34e-8      1.67e-7

distribution: cancellation   (true sum ≈ 0 ⇒ rel error ≫ 1; ULP meaningless here, see note)
  size |      naive      kahan  burn_native  fdrs_binary  fdrs_radix4 fdrs_adaptive
   256 |     1.46e2     1.61e1       1.66e2       3.84e1       3.84e1       2.42e1
  4096 |     4.33e2     7.53e0       1.37e2       2.96e1       4.35e1       2.76e2
 16384 |     1.27e3     1.10e1       1.47e3       3.56e1       9.07e1       1.86e2
```

## What this proves vs what it does not

**Proven by tests/measurement (this run):**
- **Determinism (H1).** The FDRS plan pins the accumulation schedule, so the Burn f32 reduction is
  bit-reproducible run-to-run on a fixed backend. This is the load-bearing, genuinely useful property
  for GPU pipelines, and it is *measured*, not assumed.
- **Tree ≪ naive (H2), and Burn's `sum()` is not pairwise.** `fdrs_binary` cuts error ~10× vs `naive`
  at n=16384 (uniform) and ~36× on the cancellation family. Notably `burn_native` (Burn's `sum()`)
  tracks `naive`, not the tree — so an explicit FDRS plan *does* change (improve) the numerics over the
  stock reduction. Useful, and measured.
- **The exact gate (H4) holds**, so the plans are well-formed and the float ranking is trustworthy as
  a *ranking* (a float number contradicting the gate would be a bug; none did).

**NOT proven / explicitly out of scope:**
- **No novel numerics.** The accuracy ordering (kahan < tree < naive) is *classical* (Higham 1993,
  pairwise summation; compensated summation). FDRS supplies **vocabulary and an executable
  specification** of the reduction tree — not a new accuracy result. Honest-broker: do not read H2 as
  "FDRS beats the field"; kahan still wins, and pairwise is 30 years old.
- **No performance claim.** `runtime_ns` is recorded but unoptimized-debug/release-mixed and *not*
  benchmarked; we make **no** speed claim. The tree path also materializes intermediates, which is a
  throughput cost not accounted here.
- **H3 is negative.** The one place FDRS *could* have contributed novel value — a data-dependent
  (non-stationary) tree beating the fixed tree — did not pan out. See `NEGATIVE.md` for the mechanism.
- **ULP on the cancellation family is a non-metric.** The true sum ≈ 0, so ULP-of-near-zero explodes
  (~1e43); only relative-to-true and absolute error are meaningful there. Reported for completeness,
  not interpretation.

## Attention block/gate plan (Focus 2, scaffold only)

The host-side `AttentionPlan` demo (banded / cylinder gates) emits valid schedules with the
`active_blocks` / `skipped_ratio` metrics (e.g. `cylinder_p2`, 16 blocks ⇒ 0.75 skipped). This is a
**plan-construction scaffold** — no GPU attention kernel is run, no accuracy/speed is claimed. It
exists to show the cylinder-gate → block-selection mapping is expressible; it is *hypothesis*, not result.

## GPU (Wgpu) pass — Focus 3, real RTX 4060 (`runs/2026-06-19-gpu/`)

Built with `--features gpu`, the same FDRS binary-tree plan executes on a real **NVIDIA RTX 4060** via
Wgpu. **What this earns: H1 on GPU.** The reduction ran twice and was **bit-reproducible**
(`fdrs_binary_reproducible: true`) — determinism survives the CPU→GPU port.

> Scope guard: the 54-record sweep is still CPU-pinned; only the single `gpu` field is from Wgpu. And
> its accuracy number (`fdrs_binary_rel = burn_native_rel = 6.79e-13`, on a pow2 dynamic-range input)
> is **not** a precision result — both methods drop the same sub-ε tail identically, so it measures the
> dropped tail's weight, not the hardware or the method. **No cross-backend accuracy or speed claim.**
> See `NEGATIVE.md` #4. If no adapter is present the pass prints `SKIP` and the `gpu` field is omitted.

## Amendment 1 — partition vs. local kernel (run 2, `runs/2026-06-19-run2-falsifier/`)

Run 1's H3 refutation had a confound: the adaptive plan's within-bucket kernel was a **wide naive
segment**. This run isolates the FDRS *partition* from the within-bucket *local kernel* — holding the
cross-bucket merge fixed (binary pairwise) and varying the local kernel. Pure host f32, exact-gated,
**no timing**. The sharp question: *does an FDRS partition help once the within-cylinder kernel is not
stupid?*

Median relative error vs the exact reference (host f32; `exp+*` = exponent-bucket partition):

```
distribution: uniform
  size |    naive  burn_sum   binary   radix4 | exp+naive  exp+bin  exp+kahan  sign_split
   256 |  1.27e-7  7.73e-8  4.64e-8  4.25e-8 |  1.70e-7  4.64e-8   4.24e-8    5.10e-7
  4096 |  5.67e-7  4.59e-7  1.95e-7  1.21e-7 |  1.18e-6  1.21e-7   4.00e-8    2.50e-6
 16384 |  1.28e-6  6.63e-7  1.22e-7  1.10e-7 |  9.93e-7  3.68e-8   2.49e-8    3.66e-6

distribution: wide_dynamic
  size |    naive  burn_sum   binary   radix4 | exp+naive  exp+bin  exp+kahan  sign_split
   256 |  3.86e-8  6.89e-8  5.95e-8  8.24e-8 |  4.06e-8  6.89e-8   5.95e-8    1.33e-7
  4096 |  4.89e-7  7.25e-7  1.44e-7  1.44e-7 |  2.90e-7  1.05e-7   6.11e-8    1.65e-6
 16384 |  1.35e-6  3.19e-7  8.80e-8  7.34e-8 |  2.70e-7  5.01e-8   8.80e-8    1.17e-6

distribution: cancellation   (true sum ≈ 0 ⇒ rel err ≫ 1 except where noted; sign_split=1.0 ⇒ total loss)
  size |    naive  burn_sum   binary   radix4 | exp+naive  exp+bin  exp+kahan  sign_split
   256 |   1.46e2   1.66e2   3.84e1   3.84e1 |   6.34e1   5.42e1   0.00e0     1.00e0
  4096 |   4.33e2   1.37e2   2.96e1   4.35e1 |   3.17e2   2.43e1   0.00e0     1.00e0
 16384 |   1.27e3   1.47e3   3.56e1   9.07e1 |   1.40e2   3.95e1   0.00e0     1.00e0
```

### Verdict

| Hyp | Claim | Verdict | Evidence |
|---|---|---|---|
| **H6** | binary local ≫ naive local (mechanism) | ✅ **CONFIRMED** | exp+binary beats exp+naive **27×** (uniform 16384: 3.68e-8 vs 9.93e-7). The H3 loss was the *kernel*, not the partition. |
| **H5** | partition helps once the kernel is sane | ✅ **SUPPORTED (with structure)** | at a fixed binary kernel exp-bucket beats flat binary on uniform (3.3×) + wide_dynamic (1.8×); **exp+kahan is machine-exact (rel/abs err = 0, verified) on cancellation** |
| **H7** | sign-split helps cancellation | ❌ **REFUTED (catastrophically)** | sign-split is the *worst* method on cancellation — rel err **1.0 (total loss)**: it forces the cancelling ± pairs apart |

### What this revises and what it does not

**The H3 story is corrected.** The partition is *not* numerically useless — run 1's refutation was a
kernel artifact, exactly as suspected. With a non-naive local kernel the exponent partition adds real
value: it is the **classical magnitude-ordering** effect (summing like exponents first reduces error;
Higham, increasing-order summation), re-expressed as an FDRS cylinder partition.

**The strongest result is mechanistic, not just a number.** `exp+kahan` reaches **machine-exact** on
the cancellation family — and *no flat kernel does* (flat Kahan was 1.1e1 in run 1). The exponent
partition co-locates matched-magnitude `+big`/`−big` terms in the *same* bucket (verified: the
cancellation partition has ~13 buckets, max ~7740), where a compensated kernel cancels them losslessly.
That is value the partition contributes **beyond** any choice of flat kernel — the genuine "partition
matters" signal.

**But which partition is data-dependent, and the wrong one is catastrophic.** Sign-split — a *plausible*
cancellation heuristic — is the worst method here, because this cancellation is *matched pairs*: the
right move co-locates them (exponent bucket), the wrong move separates them (sign split). So the FDRS
contribution is precisely *choosing the partition that matches the data's structure*; it is not "any
partition helps," and a mismatched partition loses everything.

**Honest scope (unchanged).** Every mechanism in play — magnitude ordering, compensated summation,
pairing cancellations — is **classical**. FDRS supplies the vocabulary (cylinder partition × local
kernel) and the framework for *composing and choosing* them; it does not invent the numerics. Still no
performance claim (no timing this run, by design). See `NEGATIVE.md` for the sign-split failure and the
updated fraud gallery.

## Engineering Milestone 1 — the CubeCL kernel (Step 3, `runs/2026-06-19-gpu-kernel/`)

Does an FDRS-generated numerical schedule become an **actual GPU kernel contract**? A custom **CubeCL
(wgpu)** segmented-reduction kernel consumes the run-2 winning plan (the `exponent_partition`: permuted
values + segment offsets) *directly* — not through Burn tensor ops. One GPU thread reduces one segment,
no atomics; host-side fixed-order pairwise merge. Two within-segment kernels, to separate **structure**
from **compensation**, run on a real **RTX 4060**:

```
                         PAIRWISE (structural)              KAHAN (compensated)
  dist          size seg  gpu_rel   cpu_exp_binary  bit==    gpu_rel   (cpu_exp_kahan)  bit==naive
  uniform        256   7  4.64e-8   4.64e-8         5/5      1.70e-7   (4.24e-8)        5/5
  uniform      16384  14  3.68e-8   3.68e-8         5/5      9.93e-7   (2.49e-8)        5/5
  wide_dynamic 16384  49  5.01e-8   5.01e-8         5/5      2.70e-7   (8.80e-8)        5/5
  cancellation   256   7  5.42e1    5.42e1          5/5      6.34e1    (0.00e0)         5/5
  cancellation 16384  15  3.95e1    3.95e1          5/5      1.40e2    (0.00e0)         5/5
```

### Verdict: **qualified PASS** — the contract holds for the schedule + a *structural* kernel; it fails for a *compensated* one

| Criterion | Result |
|---|---|
| 1 — consumes the exact same plan | ✅ both kernels consume `exponent_partition` |
| 2 — bit-identical across repeated GPU runs | ✅ all 9 cells, both kernels |
| 3 — matches CPU/Burn reference | ✅ **pairwise: GPU bit-identical to CPU `reduce_exp_binary`, 5/5 in every cell**;  ❌ **kahan: does not** |
| 4 — preserves H5/H6 | ✅ via pairwise (H6 + uniform/wide_dynamic H5 wins translate bit-exactly);  ❌ kahan's machine-exact cancellation does **not** survive |
| 5 — skips cleanly with no adapter | ✅ `catch_unwind` on client load + first launch → `{skipped:true}` |
| 6 — no performance claim | ✅ no timing emitted |

### The finding: structure survives the GPU compiler, compensation does not

The headline is the **Kahan failure, diagnosed bit-exactly**: the GPU `segment_kahan` kernel is
**bit-identical to the CPU `reduce_exp_NAIVE` reference in all 9 cells (5/5 each)**. The optimizer
evaluates the compensation `c = (t − sum) − y` — which is *algebraically* zero (since `t = sum + y`) —
and **drops it**, silently degrading Kahan summation to naive. So run-2's strongest result (`exp+kahan`
machine-exact on cancellation) **does not survive translation to a GPU kernel**.

The `segment_pairwise` kernel, by contrast, is **bit-identical to the CPU `reduce_exp_binary` reference
everywhere**. Its accuracy comes from the *tree order* of the adds, which are separated by memory writes
the optimizer cannot reassociate — so the structure survives. This is why pairwise preserves H6 and the
uniform/wide_dynamic H5 wins on the GPU, bit-for-bit.

**Answer to the milestone question.** *Yes* — an FDRS schedule (partition → segment offsets → fixed
merge) becomes a deterministic, bit-reproducible GPU kernel contract that bit-matches the CPU reference
**for a structural local kernel**. *But* a local kernel whose accuracy relies on **compensation must be
defended against the optimizer** (e.g. precise-math barriers, or re-expressed structurally) or it
silently degrades — the experiment caught exactly this, a real and classic failure mode. See
`NEGATIVE.md` NEG-4. (No performance claim: correctness/determinism only, no timing.)

This makes the attention port less hand-wavy *with a caveat*: block-softmax reductions will translate as
a schedule, but any compensated accumulation inside them needs the same defending.

## Engineering Milestone 2 — can the compensation be defended? (`runs/2026-06-19-gpu-kernel-defended/`)

M1/NEG-4 showed the CubeCL GVN optimizer folds the Kahan compensation `(t−sum)−y` to 0. M2 asks whether
it can be **forced to survive** — a compiler-semantics experiment, not performance. Two defenses, vs the
M1 controls, on the RTX 4060:

```
                          bitcast barrier            global-memory barrier
  dist          size seg  gpu_rel  ==kahan ==naive   gpu_rel  ==kahan ==naive   (cpu_kahan)
  uniform        256   7  1.70e-7  2/5     5/5        1.70e-7  2/5     5/5        4.24e-8
  uniform      16384  14  9.93e-7  0/5     5/5        9.93e-7  0/5     5/5        2.49e-8
  cancellation   256   7  6.34e1   0/5     5/5        6.34e1   0/5     5/5        0.00e0
  cancellation 16384  15  1.40e2   0/5     5/5        1.40e2   0/5     5/5        0.00e0
```

### Verdict: **negative** — neither defense works; compensation is not a portable kernel contract here

Both `segment_kahan_barrier` (a value-identity `u32::reinterpret`→`f32::reinterpret` round-trip) and
`segment_kahan_membar` (store `sum+y` to a global scratch buffer, load it back) are **bit-identical to the
CPU `reduce_exp_NAIVE` reference in all 9 cells (5/5 each)**. The optimizer folds *through* the reinterpret
round-trip and *forwards* the store→load, recovers `t == sum + y`, and erases the compensation just as in
M1. Cancellation stays at the naive ~10¹–10², not 0. (Controls validate the harness: `kahan` still degrades
to naive 5/5, `pairwise` still matches binary 5/5; both defenses are bit-reproducible across GPU runs.)

**The full control surface, documented.** CubeCL 0.10 / wgpu offers no escape for f32 compensation:
- **bit-reinterpret barrier** — folded (GVN sees through the round-trip);
- **global-memory dependency chain** — folded (store→load forwarding);
- **`fast_math` attribute** — gates only *emitted* instructions, not the IR-level GVN fold (the default
  already carries no fast-math, and Kahan still folded);
- **volatile / pass-disable** — no public API;
- **f32 atomics** (the one GVN-exempt "volatile" category) — **WGSL atomics are integer-only**, so no
  f32-atomic accumulator;
- **f64 or double-single (hi/lo) accumulation** — f64 is not available in this WGSL path, and double-single
  *is* compensation (its `lo` term is algebraically foldable too), so it would degrade identically.

### Conclusion — this steers the FDRS-on-GPU numerics thesis

> **In this backend (CubeCL 0.10 / wgpu), algebraic compensation is not a portable kernel contract; only
> structural accumulation order is.**

So FDRS-on-GPU should rely on **partition + explicit tree/structural order**, *not* Kahan-style
compensation. Concretely: the run-2 **cancellation-machine-exact result (`exp+kahan`) is a CPU-only
result**; the portable GPU best is **structural pairwise** (`exp_binary`, which M1 showed survives
bit-exactly) — it improves over naive but does *not* reach cancellation-exact. The only *survivable* exact
route identified is a **structural integer superaccumulator** (Kulisch-style fixed-point) — heavy, and a
separate build (a potential Milestone 3), not a defense of compensation.

This is the right thing to know **before** attention: its softmax denominator and `P@V` accumulation would
hit the identical fold, so any attention port on this backend must use structural accumulation (or a
superaccumulator), never compensated f32. See `NEGATIVE.md` NEG-5.

## Milestone 3 — FDRS block-attention forward pass on GPU (`runs/2026-06-19-gpu-attention/`)

The capstone question: *can the FDRS plan abstraction drive a real GPU attention-like kernel while
preserving deterministic **structural** accumulation* (NEG-5: structural order, no compensated f32)? A
custom CubeCL kernel consumes the `AttentionPlan` (CSR `row_offsets` + `block_ids`) and runs a masked
block-sparse attention forward — one thread per output element, two passes (structural max, then softmax
denominator + weighted-V), no atomics. Shapes seq=64, dim=16, block=16, single head/batch, 3 seeds, on the
RTX 4060. References: fp64 dense (ground truth), f32 sparse (structural twin), Burn dense fp32 (cross-check).

```
  case             active skipped   gpu-vs-fp64  cpuf32-vs-fp64   gpu-vs-cpuf32  gpu-vs-burn   determ  maskOK
  dense              16    0.0%      1.12e-7      8.21e-8          7.45e-8        1.19e-7       true    true
  banded_w1_local    10   37.5%      7.78e-8      8.09e-8          1.04e-7        8.94e-8       true    true
  causal             10   37.5%      8.55e-8      8.55e-8          1.19e-7        8.94e-8       true    true
```

### Verdict: **PASS** — all 7 criteria met

| Criterion | Result |
|---|---|
| 1 — same FDRS plan, CPU + GPU | ✅ both consume the same `AttentionPlan`; active blocks differ per plan (16 / 10 / 10 → 37.5% skipped) so it is genuinely consumed, not bypassed |
| 2 — deterministic GPU across runs | ✅ bit-identical output, all cases |
| 3 — masks match the plan exactly | ✅ effective mask = block-active **and** causal, verified for every (i,j) |
| 4 — within declared error bound vs fp64 | ✅ GPU vs fp64 max abs **~1e-7** ≪ 1e-4 bound (pure f32 precision) |
| 5 — compared vs Burn dense (no speed claim) | ✅ GPU vs Burn-dense-masked **~1e-7**; no timing emitted |
| 6 — skips cleanly without adapter | ✅ `catch_unwind` on client load + first launch |
| 7 — document any structural-accumulation deviation | ✅ see below |

### The criterion-7 deviation, attributed precisely

GPU vs the **CPU f32 structural twin** differs by ~1e-7 — and this is **the `exp()` transcendental, not the
accumulation order**. The structural sums are identical by construction: `scale` is exactly `0.25`, and the
QK dot products and the row max are **bit-identical** between GPU and CPU (same fixed order, IEEE adds). The
only divergence is `exp()` (GPU WGSL `exp` vs Rust `f32::exp`), which perturbs each softmax weight by ~1 ULP
and propagates to ~1e-7 in the output. So **deterministic structural accumulation is preserved exactly**;
the residual gap is a transcendental-implementation difference, which no structural discipline can remove
(and which is far inside the fp64 error bound).

### Conclusion

**Yes** — the FDRS plan abstraction drives a real GPU attention forward pass with deterministic structural
accumulation, across dense, local (banded), and causal masks, matching fp64 to f32 precision and a Burn
dense reference. The whole arc now closes: an FDRS schedule becomes a GPU kernel contract (M1), under the
structural-only rule M2 established, here driving a block-sparse attention kernel (M3). Tiling / shared
memory / vectorization / multi-head / backward are later optimizations on a validated abstraction — this
run was correctness-first and makes **no performance claim**.

## Reproduce

```
cd source && ./run.sh          # gates on exact mirror + repro tests, then writes runs/<date>-cpu-baseline/
cd source && ./run.sh --gpu    # additionally runs the Wgpu path (skips cleanly if no adapter)
```

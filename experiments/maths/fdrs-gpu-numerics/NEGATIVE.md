# Negative results & fraud gallery — fdrs-gpu-numerics

ADR-007 bounded-completeness: the negatives are reported with the same weight as the positives, and
the **tempting-but-wrong** ways to spin this experiment are written down so they cannot be quietly used.

---

## NEG-1 — H3 REFUTED: the adaptive (non-stationary) tree does NOT beat the fixed binary tree

> **Revised by Amendment 1 (run 2):** NEG-1 stands *as stated* (that specific adaptive plan loses), but
> its **interpretation** was confounded. Run 2 (H6) shows the loss was the plan's **wide-naive within-
> bucket kernel**, not the partition: with a binary or compensated within-bucket kernel the *same*
> exponent partition helps (H5), and is **machine-exact** on cancellation. So read NEG-1 narrowly —
> "this naive-bucketed plan loses" — **not** "adaptive FDRS partitions are useless." See results.md
> §Amendment 1 and NEG-3.

**Hypothesis (pre-registered, README §Hypotheses):** an exponent-bucketed *non-stationary* reduction
tree (`fdrs_adaptive`: sort by fp32 exponent, group equal-magnitude terms, binary tail) lowers f32
error below the *fixed* binary tree (`fdrs_binary`) — i.e. data-dependent fan-in buys accuracy.

**Result:** refuted. Head-to-head on median relative error (CPU sweep, `runs/2026-06-19-cpu-baseline/`):

| distribution | n=256 | n=4096 | n=16384 |
|---|---|---|---|
| uniform | adaptive **wins** (4.24e-8 < 4.64e-8) | adaptive **loses** 1.8× (3.60e-7 vs 1.95e-7) | adaptive **loses 5.4×** (6.60e-7 vs 1.22e-7) |
| wide_dynamic | tie (5.95e-8) | adaptive loses ~1.00× (1.445e-7 vs 1.441e-7) | adaptive **loses 1.9×** (1.67e-7 vs 8.80e-8) |
| cancellation | adaptive **wins** 1.6× (2.42e1 < 3.84e1) | adaptive **loses 9.3×** (2.76e2 vs 2.96e1) | adaptive **loses 5.2×** (1.86e2 vs 3.56e1) |

Score: adaptive wins **2/9**, ties **1/9**, **loses 6/9** — and the losses grow with n, exactly where a
better tree should matter most. The verdict is not "inconclusive"; it is a clean loss at scale.

**Mechanism (why it loses).** `fdrs_binary` is a depth-`⌈log₂n⌉` pairwise tree — every accumulation is a
2-input add, so error is bounded by `O(log n)·ε·Σ|xᵢ|` (Higham). `fdrs_adaptive` sorts by magnitude
(a classically *good* idea for same-sign sums) but then executes each exponent bucket as **one wide
ragged segment reduced by `sum_dim`/`sum`** — i.e. a *naive O(b)* accumulation inside the bucket, where
`b` is the bucket size. As n grows the buckets grow, so the adaptive plan trades the binary tree's
log-depth for wide naive segments: it re-introduces the very `O(b)·ε` term the tree was avoiding. The
magnitude-sort helps a little (the n=256 wins, and the cancellation n=256 win where ordering tames
catastrophic cancellation), but it does not pay for the lost depth once buckets are large.

**What would overturn NEG-1 (falsifier for the negative):** an adaptive plan that keeps the bucket
*internally* a pairwise tree (bucket-then-binary-within-bucket, not bucket-then-naive) — i.e. magnitude
grouping *on top of* log-depth, not *instead of* it. That is a concrete next experiment, not a rescue of
the current plan. Until built and measured, H3 stands refuted and "adaptive FDRS trees improve GPU
numerics" is an **unsupported** claim.

**Consequence for the project's novelty thesis.** H3 was the *only* hypothesis where FDRS could have
contributed something beyond classical pairwise/compensated summation. Its refutation is consistent
with the repo-wide finding (see `fdrs-novelty-verdict`): no new numerics here — the value is vocabulary,
an executable spec, and determinism, not a new accuracy result.

---

## NEG-2 — Burn's native `sum()` is not pairwise (a smaller negative, about the baseline)

`burn_native` (Burn `tensor.sum()`) tracks `naive`, not the tree: at uniform n=16384 it is 6.63e-7 vs
naive 1.28e-6 vs binary 1.22e-7. So the stock reduction is ~mid-way and an explicit FDRS plan does
change the numerics — but this is a statement about Burn's default, **not** evidence that FDRS beats a
*well-implemented* library reduction (a pairwise/Kahan library sum would match or beat `fdrs_binary`).

---

## NEG-3 — H7 REFUTED (catastrophically): sign-split does NOT help cancellation — it destroys it

**Hypothesis (pre-registered, Amendment 1):** a sign-split partition (sum positives and negatives
separately, combine last) beats flat binary **on the cancellation family** — a partition matched to
mixed-sign structure.

**Result:** not just refuted — **inverted**. `sign_split` is the **worst** method on cancellation:
median rel error **1.0 at every size** (total loss; the result rounds to ≈0 while the true sum is
nonzero). It is ~10²–10³× worse than flat binary there.

| cancellation | flat binary | sign_split | exp+kahan |
|---|---|---|---|
| n=256 | 3.84e1 | **1.00e0 (total loss)** | **0.00e0 (machine-exact)** |
| n=4096 | 2.96e1 | **1.00e0** | **0.00e0** |
| n=16384 | 3.56e1 | **1.00e0** | **0.00e0** |

**Mechanism.** This cancellation family is *matched ± pairs* (`+big`, `−big+tiny`). Summing all
positives → `P ≈ +Σbig` and all negatives → `N ≈ −Σbig`, each ~10⁹ in magnitude, then `P+N` is a
difference of two huge numbers whose ULP (~10³) dwarfs the true sum (~10²) — so the true sum is lost.
Sign-split **maximizes** the intermediate magnitudes before the final cancellation: the exact wrong
move. The *right* move (exp+kahan) co-locates each `+big`/`−big` pair in one exponent bucket and cancels
it losslessly before magnitudes ever accumulate.

**Lesson (the actual prize):** a partition is not free insurance. The exponent partition and the
sign-split partition are *both* "FDRS-shaped," yet on the same data one is machine-exact and the other
loses everything. **Choosing the partition that matches the data's structure is the whole game** — and a
plausible-sounding mismatched partition is worse than not partitioning at all. (`exp+kahan = 0` is
specific to *matched-pair* cancellation; it demonstrates the principle, not a general cancellation cure.)

## NEG-4 — the GPU compiler silently defeats Kahan: the cancellation-exact result does NOT survive to a kernel

**Context (Milestone 1, `runs/2026-06-19-gpu-kernel/`).** A custom CubeCL (wgpu) kernel runs the run-2
winning plan on a real RTX 4060. Two within-segment local kernels were tested.

**Result.** The `segment_kahan` GPU kernel is **bit-identical to the CPU `reduce_exp_NAIVE` reference in
all 9 cells (5/5 seeds each)** — *not* to the intended `reduce_exp_kahan`. The GPU compiler evaluates the
Kahan compensation `c = (t − sum) − y`, recognizes it as *algebraically* zero (`t = sum + y`), and drops
it. Kahan summation silently degrades to naive. So run-2's strongest finding — `exp+kahan` **machine-exact
on cancellation** — **does not survive translation to a GPU kernel** (GPU cancellation error is ~10¹–10²,
i.e. the naive result, not 0).

| cancellation | CPU `exp_kahan` | GPU `segment_kahan` | GPU == CPU `exp_naive`? |
|---|---|---|---|
| n=256 | 0.00e0 | 6.34e1 | yes (5/5) |
| n=16384 | 0.00e0 | 1.40e2 | yes (5/5) |

**Why it is not a bug in our kernel.** The *structural* `segment_pairwise` kernel — same harness, same
plan — IS bit-identical to the CPU `reduce_exp_binary` reference in every cell. Pairwise's accuracy comes
from the tree *order* of adds, which are separated by memory writes the optimizer cannot reassociate, so
it survives. Only the *compensation*-based kernel degrades. The kernel is correct; the optimizer is
hostile to compensation specifically. (This is a classic, well-documented hazard: aggressive float
reassociation breaks Kahan/compensated summation. Every compensated scheme is algebraically
"compensation = 0," so a reassociating compiler can erase all of them; only blocking reassociation, or
expressing accuracy structurally, survives.)

**Consequence / lesson.** The FDRS *schedule* (partition → segment offsets → fixed merge) translates to a
deterministic GPU kernel contract that bit-matches the CPU reference — **for a structural local kernel**.
A local kernel whose accuracy relies on **compensation must be explicitly defended** (precise-math
barriers, or re-expressed as structure) or it silently degrades. This is the load-bearing caveat for any
FDRS-plan → GPU-kernel translation, including the eventual attention port.

## NEG-5 — compensation cannot be defended in this backend: it is not a portable GPU kernel contract

**Context (Milestone 2, `runs/2026-06-19-gpu-kernel-defended/`).** Given NEG-4, can the GPU optimizer be
forced to preserve the Kahan compensation? Two defenses tested on the RTX 4060 (controls: `kahan`
known-bad, `pairwise` known-good).

**Result — both defenses fail.** `segment_kahan_barrier` (bit-reinterpret round-trip) and
`segment_kahan_membar` (global store→load dependency chain) are each **bit-identical to CPU
`reduce_exp_NAIVE` in all 9 cells (5/5)**. The optimizer folds through the reinterpret and forwards the
store→load, erasing the compensation. Cancellation stays naive (~10¹–10²), not 0.

**No mechanism exists.** Investigated and ruled out: `fast_math` (gates emitted instructions, not the GVN
fold), volatile / pass-disable (no public API), f32 atomics (WGSL atomics are integer-only), f64 / double-
single (unavailable, or itself foldable compensation). Controls valid (kahan→naive 5/5; pairwise==binary
5/5; both defenses bit-reproducible).

**Conclusion (pre-authorized as valuable):**

> In this backend (CubeCL 0.10 / wgpu), **algebraic compensation is not a portable kernel contract; only
> structural accumulation order is.**

**Consequence for the thesis.** FDRS-on-GPU must use **partition + explicit tree/structural order**, not
Kahan-style compensation. The run-2 **cancellation-machine-exact result is CPU-only**; on GPU the portable
best is structural pairwise (survives, not exact). The only survivable *exact* route is a structural
integer superaccumulator (heavy; deferred). This must be carried into the attention port: its softmax
denominator and `P@V` accumulation hit the same fold — they need structural accumulation, never compensated f32.

## Fraud gallery — spins this experiment must NOT be used to support

1. **"FDRS adaptive trees improve numerical accuracy."** FALSE *as the run-1 plan was built* (naive
   buckets — NEG-1). But do NOT over-correct: Amendment 1 shows a *sane-kernel* exponent partition DOES
   help (H5). The honest line is "the partition helps with a non-naive kernel, and only when matched to
   the data" — not "adaptive trees are useless" and not "adaptive trees win."
8. **"The exponent partition helps — that's a novel FDRS numerical result."** FALSE. The uniform/
   wide_dynamic wins are **classical magnitude-ordering** (Higham, increasing-order summation); the
   cancellation win is **classical compensated summation over co-located pairs**. FDRS = the vocabulary
   and the partition-choosing framework, not the numerics.
9. **"exp+kahan = 0 ⇒ FDRS solves catastrophic cancellation."** FALSE. The machine-exact result is
   specific to *matched-magnitude ± pairs* (this synthetic family), where the exponent bucket co-locates
   each pair. On unstructured cancellation it would not be exact. It demonstrates the *principle*
   (partition-to-structure matching), not a general cure.
10. **"Sign-split is a good cancellation strategy."** FALSE — REFUTED hard (NEG-3): on matched-pair
    cancellation sign-split is the **worst** method (total loss). A plausible partition can be catastrophic.
2. **"FDRS reduction beats Burn / beats library reductions."** Only beats Burn's *naive-tracking* `sum()`
   and only-because-it's-pairwise. Kahan beats everything here. No claim against a good library sum.
3. **"Cherry-pick: adaptive wins on cancellation."** It wins at n=256 only, then loses 9.3× at n=4096.
   Reporting the n=256 cell alone would be HARKing the one favorable cell — hence the full 3×3 table above.
4. **"The GPU is more accurate (6.79e-13!)."** FALSE. That number is the dropped-tail weight for one pow2
   input; `burn_native` on GPU reports the identical 6.79e-13. It is an input artifact, not GPU/method
   precision (f32 cannot carry 12 good digits). The GPU result is about *determinism + portability* only.
5. **"FDRS reduction is faster on GPU."** No benchmark exists. `runtime_ns` is unoptimized and the tree
   materializes intermediates (a throughput cost). Zero speed claim is licensed by this run.
6. **"ULP error ~1e43 on cancellation shows catastrophic FDRS failure" (or success).** Neither — the true
   sum ≈ 0, so ULP-of-near-zero is undefined-in-spirit; only rel/abs error are meaningful there.
7. **"Bit-reproducibility proves correctness."** No — it proves *determinism*. Correctness is the separate
   exact-mirror gate (H4, `fdrs-tree`), which is what licenses trusting the float ranking at all.
11. **"The FDRS plan runs on the GPU, so the run-2 numerics carry over."** FALSE for the *compensated*
    kernel (NEG-4): the GPU optimizer drops the Kahan compensation, so `exp+kahan` silently becomes
    `exp+naive` on GPU — the machine-exact cancellation result does NOT survive. Only the *structural*
    (pairwise) kernel bit-matches its CPU reference on GPU. "It compiled and ran deterministically" ≠ "it
    computed what the CPU did."
12. **"A bitcast / memory barrier rescues compensation on GPU."** FALSE — both were tested and both folded
    (NEG-5): `kahan_barrier` and `kahan_membar` are bit-identical to naive in all 9 cells. Do not claim a
    defended compensated kernel exists on this backend; it does not. The honest line is the conclusion —
    compensation is not portable here, only structure is.

## What the run DID earn (so the negatives are not over-read)

H1 (determinism, CPU **and** GPU) and H2 (pairwise/tree ≪ naive, and ≪ Burn's `sum()`) are confirmed and
measured. Those are real, useful, and classical. Amendment 1 adds a genuinely useful, also-classical
finding: **the partition matters once the local kernel is sane** (H5/H6) — exponent-bucketing + a
compensated kernel is machine-exact on matched cancellation, value no flat kernel matches — **but the
partition must match the data, and a mismatched one (sign-split, NEG-3) is catastrophic.** The discipline
throughout: report the failures (H3 narrow, H7 inverted) at full weight, and resist inflating the
real-but-classical positives into a "new numerics" claim. The defensible thesis is *FDRS as a framework
for choosing and composing partitions × kernels*, gated by the exact mirror — not novel arithmetic.

Milestone 1 earns a further real result: the FDRS *schedule* becomes a **deterministic GPU kernel
contract** (custom CubeCL/wgpu, RTX 4060) that bit-matches the CPU reference for a *structural* local
kernel (pairwise) — the plan→kernel bridge holds. And it earns a sharp negative (NEG-4): a *compensated*
local kernel does not survive the optimizer, so the contract's numerics are kernel-dependent. "Does the
FDRS plan become a GPU kernel?" → yes for the schedule + structural numerics, with a load-bearing caveat
for compensated ones — reported as a qualified pass, not a clean win.

Milestone 2 closes that caveat with a clean negative (NEG-5): the compensation cannot be defended on this
backend (two barriers tested, both folded; no other mechanism exists). The earned conclusion — *compensation
is not a portable kernel contract; only structural accumulation order is* — is the most useful thing M2
could produce: it steers the FDRS-on-GPU thesis to **partition + structural tree order**, settles that the
cancellation-exact result is CPU-only, and sets the rule for the eventual attention port (structural
accumulation, never compensated f32). A negative that changes the design is a result, not a dead end.

# Experiment: FDRS GPU Tensor Numerics (deterministic reductions + block/gate plans)

**Charter stage (G0/G1): hypothesis, method, exactness ladder, and pre-registered falsifiers recorded BEFORE execution.**
**Follows `ADR-007` (FDRS experiments workflow): exactness ladder, scientific-status ladder, negative-results-first.**

- **Registry ID:** `experiment-fdrs-gpu-numerics`
- **Upstream project:** `project-fdrs-formal` — Phase 2 (block projections / multiresolution = hierarchical reduction), Phase 5 (variable-radix odometer trees), Phase 11 (non-stationary radix trees, `FdrsFormal/Analysis/DigitConditional/`)
- **Program:** `program-variable-representation`
- **Workspace:** `workspace-math-proof-env` — Rust workspace: an exact-rational mirror (`fdrs-tree`, theorem-tests as the gate) + a Burn float experiment (`fdrs-reduce`, NdArray CPU default, Wgpu GPU optional)
- **Owner:** `volition-billy`
- **Scientific status:** **`cross-checked`** (float candidates gated by the exact mirror, ADR-007 §3). Run 1 (deterministic reduction): **H1 ✅ H2 ✅ H3 ❌ H4 ✅**. Run 2 (Amendment 1, partition × kernel): **H6 ✅ (mechanism) H5 ✅ (partition helps with a sane kernel — machine-exact on matched cancellation) H7 ❌ (sign-split catastrophic)**. Milestone 1 (Step 3, custom CubeCL/wgpu kernel on a real RTX 4060): **qualified PASS — the FDRS schedule + a structural (pairwise) kernel = a deterministic GPU contract, bit-identical to the CPU reference; a compensated (Kahan) kernel is silently optimized to naive (NEG-4)**. Milestone 2 (defend the compensation): **NEGATIVE — neither a bitcast nor a memory barrier survives the optimizer; in this backend compensation is not a portable kernel contract, only structural accumulation order is (NEG-5)** → FDRS-on-GPU = partition + structural tree order. Milestone 3 (FDRS block-attention forward, CubeCL/wgpu): **PASS, all 7 criteria — the FDRS plan abstraction drives a real GPU attention kernel (dense/local/causal) with deterministic structural accumulation, GPU vs fp64 ~1e-7; only deviation = exp() transcendental**. All mechanisms classical; FDRS = the partition-choosing framework. Runs: `runs/2026-06-19-{cpu-baseline,gpu,run2-falsifier,gpu-kernel,gpu-kernel-defended,gpu-attention}/`.
- **Risk class:** low (internal, exploratory; no external commitment, no IP disclosure)

---

## Motivation

Floating-point addition is **not associative**: `(a⊕b)⊕c ≠ a⊕(b⊕c)`. So a tensor reduction's
result depends on its **accumulation order**, which gives two distinct problems on GPUs:

1. **Reproducibility.** Parallel reductions that combine partial sums via atomics (or
   nondeterministic work-group scheduling) can return *different bits on repeated runs of the
   same input* — a real pain for debugging, regression testing, and certified pipelines.
2. **Accuracy.** Naive left-to-right summation accumulates `O(n)·ε` worst-case error;
   **pairwise (tree) summation** accumulates `O(log n)·ε` (Higham 1993). Magnitude-aware orders
   reduce cancellation further. These are *classical* results about summation order.

FDRS supplies a precise, inspectable **vocabulary for accumulation orders as trees**: a
variable-radix odometer (Phase 5) *is* a reduction tree (radix at a node = its fan-in); a
**non-stationary radix tree** (Phase 11) is a tree whose fan-in depends on the *data* (e.g. on a
value's exponent "digit"); and the Phase-2 block projection `P_L` (averaging/summing over a
cylinder) *is* one level of a hierarchical reduction. This experiment asks whether expressing a
deterministic GPU reduction as an **explicit FDRS radix-tree plan** (a) gives bit-reproducible
results, (b) reproduces the classical pairwise accuracy, and (c) whether a **non-stationary
(data-adaptive) tree** improves accuracy on ill-conditioned inputs beyond a fixed tree.

**What is classical vs. what is the FDRS question (honest scope, stated up front):**
- *Classical, not claimed novel:* pairwise/tree summation is more accurate than naive (Higham);
  summing by increasing magnitude reduces error (Higham, Demmel–Hida); a fixed accumulation
  order is bit-reproducible. We **validate against** these, we do not claim them.
- *FDRS framing (the contribution if any):* radix-tree **plans** as an explicit, exact-checkable,
  GPU-schedulable specification of accumulation order — and the *non-stationary* tree as a tunable
  layout. The framing's value is inspectability + the exact gate, not new numerics.
- *Open hypothesis (H3):* whether the data-adaptive tree buys accuracy over a fixed tree.

---

## Hypotheses (pre-registered)

- **H1 (reproducibility).** A fixed FDRS radix-tree reduction *plan* yields **bit-identical**
  f32 results across repeated runs on a given backend, and the result is fully determined by the
  plan (independent of run, thread count, or wall-clock). *Mechanism:* the plan fixes the
  accumulation order; no atomics, no scheduling dependence.
- **H2 (accuracy, validated against classical pairwise).** Against a high-precision reference,
  the FDRS fixed **binary** tree reduction has max relative error ≈ a reference pairwise
  summation and **≪** naive sequential summation, on ill-conditioned inputs (large dynamic
  range / cancellation). *Mechanism:* the binary radix tree IS pairwise summation.
- **H3 (adaptive tree — the open question).** A **non-stationary** radix tree that groups values
  by fp-exponent "digit" (sum like-magnitudes first) reduces max relative error **below** the
  fixed balanced tree on adversarial inputs. *Falsifiable:* it may buy nothing.
- **H4 (exact-mirror fidelity / order-invariance — the GATE).** In **exact rational arithmetic**,
  *every* plan (any tree, any permutation) yields the **identical** exact sum, and every plan is a
  valid reduction (a permutation visiting each element exactly once). *Mechanism:* exact addition
  is associative + commutative; this is the non-exploitable check that a plan is well-formed.

---

## Method — the exactness ladder (ADR-007 §3)

```
Lean (Phase 2/5/11, proven structure)  →  exact mirror (fdrs-tree, rational)  →  float (fdrs-reduce, Burn)
   radix trees / block reduction          order-invariance + plan-validity        f32 error vs reference;
   are machine-checked in the corpus        as exact-equality TESTS  [GATE]          candidate rank only
```

- **Rung 1 — Lean (proven, upstream):** radix-tree structure, block projections, and
  non-stationary trees are machine-checked in `FdrsFormal/` (Phases 2/5/11). We do **not** re-prove
  them; we cite the structure and test that our plans instantiate it.
- **Rung 2 — exact mirror (`source/fdrs-tree`, rational `i128`/`num-rational`):** `ReductionPlan`
  (input permutation + per-level segment structure), tree builders (fixed radix-`b`; non-stationary
  exponent-bucketed), and an **exact** reduction. H4 is the gate: `plan_is_valid` (permutation,
  covers each index once) and `exact_sum_order_invariant` (all plans → identical rational sum) are
  `#[test]`s. **A float result that contradicts the exact mirror is a bug, not a finding.**
- **Rung 3 — float experiment (`source/fdrs-reduce`, Burn):** the plan executed as Burn tensor
  ops (reshape + `sum_dim` per level; `select` for the permutation), generic over `Backend`.
  Default backend **NdArray (CPU, f32)**; **Wgpu (GPU, f32)** behind the `gpu` feature. Error is
  measured against an **exact** reference (correctly-rounded true sum of the f32 inputs) and an
  **f64** reference; result tag `float`, candidate rank.

**Two threads** (reduction is primary and fully tested; attention is a scaffold):
1. **Deterministic reduction** (primary): H1–H4 above.
2. **Attention block/gate plan** (scaffold, NOT a numerics claim yet): host-side generation of an
   FDRS "active block plan" — query/key block selection as **cylinders/gates** (Phase 2 §5.3) —
   emitted as a GPU-friendly schedule (`row_offsets` + `block_ids`). A reference Burn tensor
   implementation consumes the plan (dense-equivalent first; not a custom CubeCL kernel). Tested
   only for **plan validity** (well-formed schedule, no double-count, gate ⇒ included).

---

## Metrics (machine-readable JSON per run)

Per (reduction method × input distribution × size × seed): **max absolute error**, **max relative
error**, **max ULP difference** (vs the exact correctly-rounded reference), **reproducibility**
(bit-identical hash across repeated runs: bool + the f32-bits hash), **reduction tree depth**,
**accumulation-order hash** (hash of the plan), **runtime** (ns, per backend). For the attention
thread: **active block count**, **skipped block ratio**, **plan-validity** pass.

---

## Falsification criteria (pre-registered)

- **H1 fails if:** any fixed-plan reduction produces a different f32-bits hash across repeated runs
  on the same backend/input → the "deterministic" claim is false (a bug or a backend nondeterminism
  finding — recorded either way).
- **H2 fails if:** the binary-tree reduction's max relative error is within seed-noise of *naive*
  sequential (no pairwise advantage) → our tree is not actually pairwise (transcription bug), fix
  before trusting any float run.
- **H3 fails if:** the non-stationary (exponent-bucketed) tree's error is within run-noise of the
  fixed balanced tree across the ill-conditioned grid → the adaptive layout buys nothing; recorded
  as a **bounded-completeness negative** in `NEGATIVE.md` (the durable result), not hidden.
- **H4 fails if:** any plan's exact rational sum differs from another's, or a plan is not a
  permutation → the plan generator is buggy; **blocks all float runs** until fixed.

A falsified hypothesis is a result. H3-refuted (the adaptive tree is no better) is a first-class
negative that bounds where FDRS layout helps. **No performance/accuracy win is claimed without the
committed JSON benchmark.**

---

## Backends supported

| Backend | Feature | Status |
|---|---|---|
| NdArray (CPU, f32/f64) | default | correctness + reference; always runs |
| Wgpu (GPU, f32) | `--features gpu` | runs if a Vulkan/Metal/DX adapter is present; **skips cleanly** otherwise |

GPU-specific tests `eprintln!("SKIP: no GPU adapter")` and pass when no adapter is found, so CI/CPU
hosts test the host-side plan generation, the exact mirror, and the CPU reduction in full.

---

## How to run

```bash
./run.sh              # gate on exact-mirror tests, run CPU reduction sweep → runs/<date>/
./run.sh --gpu        # additionally run the Wgpu backend if an adapter is present
```

One command (`./run.sh`) gates on the `fdrs-tree` theorem tests, runs the `fdrs-reduce` sweep, and
writes `runs/<date>/transcript/{reduction.json, summary.txt}` + the attention plan demo.

---

## Limitations & next steps toward custom CubeCL kernels

- **No custom CubeCL kernel yet.** The reduction executes via Burn tensor ops (`reshape`+`sum_dim`),
  which is itself a deterministic tree but leaves the per-level segment scheduling to Burn. The
  `ReductionPlan` (offsets per level) is already in the GPU-friendly form a CubeCL segmented-reduce
  kernel would consume — that is the **next rung** (a `cubecl` `#[cube]` kernel reading the plan's
  offset arrays), deferred until the host plan + CPU/GPU-tensor path is validated.
- **Attention thread is plan-only.** It generates and validates a block schedule; it does not yet
  run masked attention numerics and makes **no** sparsity/perf claim.
- **f32 only** in the float rung (matches GPU practice); f16/bf16 deferred.
- The accuracy results (H2) re-confirm classical pairwise summation — the citable content is the
  **exact-gate-validated reproduction** + the H3 adaptive-tree verdict, not new numerics.

---

## Directory contents

```
fdrs-gpu-numerics/
├── README.md                     ← this charter (G0/G1)
├── run.sh                        ← one-command reproducible runner (G2)
├── source/
│   ├── Cargo.toml                ← workspace
│   ├── fdrs-tree/                ← EXACT mirror: ReductionPlan, tree builders, attention plan,
│   │                                exact reduction, order-invariance + validity theorem-tests
│   └── fdrs-reduce/              ← Burn FLOAT experiment: plan→Burn reduction (NdArray/Wgpu),
│                                    exact+f64 references, metrics, JSON sweep binary
├── runs/<date>/
│   ├── manifest.yaml             ← provenance triple
│   └── transcript/{reduction.json, summary.txt}
├── results.md                    ← G3 verdict vs pre-registered hypotheses
└── NEGATIVE.md                   ← bounded-completeness negatives + fraud gallery
```

## Protocol Amendment 1 — the bucket-then-binary falsifier (run 2; pre-registered 2026-06-19, before execution)

H3 refuted the *adaptive* plan, but with a confound: that plan's within-bucket kernel was a single
**wide naive segment** (`O(b)·ε`). So "H3 refuted" only proves *a bad local kernel beats a good
partition* — **not** that adaptive FDRS partitions are useless. This amendment isolates the partition
from the local kernel (the NEG-1 falsifier). It is a **pure numerical experiment**: host f32, scored
against the exact rational reference, **no timing** (numerics deliberately separated from backend speed;
the Burn/GPU-kernel question is the *next* milestone). Burn `sum()` is kept as the one library anchor.

**Sharp question:** *Does FDRS help by choosing a better partition, once the within-cylinder numerical
kernel is not stupid?*

**Design:** hold the cross-bucket merge fixed (binary pairwise); vary the within-bucket local kernel.
Same 3 distributions × 3 sizes × 5 seeds. Methods (8):

1. naive sequential 2. Burn `sum()` 3. **binary pairwise (flat)** — the incumbent to beat
4. fixed radix-4 tree 5. exp-bucket + **naive** local (≈ the H3 loser; control)
6. exp-bucket + **binary** local ← *the falsifier* 7. exp-bucket + **compensated (Kahan)** local
8. **sign-split** + exp-bucket + binary (sum each sign separately, combine last)

- **H5 (the prize).** With a non-stupid local kernel (6/7), an exponent-bucket partition reduces error
  **≤ flat binary (method 3)**. *Falsified* if 6/7 are within seed-noise of, or worse than, method 3 on
  a distribution — i.e. the partition adds no numerical value there.
- **H6 (mechanism; expected true).** Method 6 ≪ method 5 — swapping naive→binary local recovers most of
  the H3 loss. Confirms the H3 mechanism; not itself a novel win.
- **H7 (targeted partition).** Sign-split (method 8) beats flat binary **on the cancellation family** —
  a partition matched to the data's structure (mixed signs) pays off where generic bucketing does not.

**Pre-registered prediction (honest prior):** H6 true; **H5 likely refuted** for uniform/wide_dynamic
(pairwise is already near-optimal on random data); the live question is **H7** — value should come from
*matching the partition to structure*, not from partitioning per se. Gate unchanged (exact mirror, H4).

## Engineering Milestone 1 — does an FDRS plan become a real GPU kernel contract? (Step 3; pre-registered 2026-06-19, before implementation)

Run 2 showed the winning configuration is **exponent-partition + compensated (Kahan) within-bucket +
fixed binary merge** (machine-exact on matched cancellation). This milestone tests the lowest-level
claim: *can an FDRS-generated numerical schedule become an actual GPU kernel contract?* — by writing a
**custom CubeCL (wgpu) segmented-reduction kernel** that consumes that plan, instead of going through
Burn tensor ops.

**Kernel contract.**
- *Input:* `values` permuted into contiguous segments + `offsets` (segment boundaries) — derived from
  the **same `exponent_partition`** the CPU falsifier (run 2) uses.
- *Local reducer:* one GPU thread per segment, **Kahan-compensated** within the segment (the winning
  within-bucket kernel). Plain indexed writes, **no atomics** (so the schedule is order-deterministic).
- *Merge:* fixed deterministic order — host-side binary pairwise over the per-segment partials, the
  *same* `host_pairwise` the CPU reference uses (so GPU and CPU partials are bit-comparable).
- *Output:* one scalar per experiment.

**Acceptance criteria (pre-registered; pass/fail, not a hypothesis).**
1. consumes the *exact same plan* (exponent partition) as the Burn tensor-op / CPU experiment;
2. **bit-identical** output across repeated GPU runs for a fixed plan (determinism);
3. **matches the CPU/Burn reference** within the existing error-reporting harness (error vs exact);
4. **preserves the H5/H6 conclusions** (e.g. machine-exact on cancellation, partition helps);
5. **skips cleanly** if no CubeCL/wgpu adapter is present;
6. **no performance claim** unless a timing harness is explicitly added (none here — correctness only).

If this passes, attention (block-softmax = reductions + gated block traversal + accumulation) becomes a
much-less-hand-wavy next step. If it fails, the plan→kernel bridge is where the abstraction breaks, and
that is the finding.

## Engineering Milestone 2 — defended compensated GPU reduction (pre-registered 2026-06-19, before implementation)

Milestone 1 found the GPU optimizer (CubeCL's GVN pass) folds the Kahan compensation `(t−sum)−y` to 0,
degrading Kahan→naive (NEG-4). This milestone asks: **can the compensation be forced to survive, and by
which mechanism?** A **compiler-semantics/numerics experiment — not performance.**

The investigated control surface (CubeCL 0.10, wgpu): there is **no** public pass-disable flag, **no**
volatile API, and the `fast_math` attribute gates only emitted instructions (not the IR-level GVN fold).
The one available barrier is **bit-reinterpret** (`u32::reinterpret(f32)` → `f32::reinterpret(u32)` — a
value-identity round-trip that emits `Operator::Reinterpret`, which GVN cannot fold through).

**Variants (within-segment local kernel; same exponent_partition plan, host-side fixed merge):**
- `pairwise` — structural control (known-good; M1 showed it survives).
- `kahan` — compensated control (known-bad; M1 showed it degrades to naive).
- `kahan_barrier` — Kahan with a reinterpret bitcast barrier on the running accumulator (the defense
  under test).
- (documented, not a separate kernel) `fast_math` empty/default — noted as insufficient (the default
  already carries no fast-math and Kahan still folded).
- (optional, only if the barrier fails) Neumaier/TwoSum-with-barrier, or a structural binned/
  superaccumulator path — but note a same-exponent ± bucket needs cancellation tracking, not just binning.

**Acceptance criteria (pass/fail):**
1. `kahan_barrier` GPU output must **no longer bit-match `exp_naive`** on the cancellation case (the
   defense actually changed the computation);
2. `kahan_barrier` GPU output must **match the intended CPU `reduce_exp_kahan` reference** — or any
   deviation is **explained bitwise**;
3. machine-exact (rel err 0) on cancellation, restoring the run-2 result on GPU;
4. fixed plan stays **bit-identical across repeated GPU runs**;
5. **no performance claim** unless separately timed (none here);
6. **document which mechanism** actually forced the compiler to preserve the compensation.

**If CubeCL cannot express the needed semantics** (barrier fails too), that is itself the result:
*in this backend compensation is not a portable kernel contract; only structural accumulation order is* —
which steers the FDRS numerics thesis toward **partition + explicit tree order**, not algebraic compensation.

## Milestone 3 — FDRS block-attention forward pass, correctness-first (pre-registered 2026-06-19, before implementation)

The question: *can the FDRS plan abstraction drive a real GPU attention-like numeric kernel while
preserving deterministic **structural** accumulation* (per NEG-5: structural order only, no compensated
f32)? Correctness-first — a non-FlashAttention-grade kernel is fine; the experiment is the abstraction,
not speed.

**Scope (tight):** forward only (no backward); small fixed shapes first; 1–2 heads, batch 1; host-
generated FDRS block plan; GPU kernel consumes `row_offsets` + `kv_block_ids`; **structural** reductions
for the QK·dot, the row max, the softmax denominator, and `P@V`; **no Kahan/compensated f32**; **no
performance claim**.

**Architecture.**
```
host:        FDRS gates/cylinders -> active block plan (AttentionPlan CSR: row_offsets + block_ids)
CPU ref A:   dense fp64 attention with the same effective mask          (ground truth for error bounds)
CPU ref B:   sparse/block fp32 attention, SAME structural order as GPU   (the GPU's bit-comparable twin)
CPU ref C:   Burn dense fp32 (masked) attention                          (numerical cross-check, no speed)
GPU:         for each (batch, head, query block):
               load Q block; visit active KV blocks from the plan; block logits;
               structural max reduction; structural exp-sum (denominator); structural weighted-V accum;
               write output block
```
Effective mask = `plan.is_active(block(i), block(j))` AND (`!causal || j <= i`). All four computations
apply the identical effective mask.

**Acceptance criteria (pass/fail):**
1. the **same FDRS attention plan** is consumed by the CPU reference and the GPU kernel;
2. **deterministic** GPU output across repeated runs (fixed plan ⇒ bit-identical);
3. causal / local / gated masks **match the plan exactly** (sparse refs attend iff the effective mask says so);
4. GPU result is **within a declared error bound** against the fp64 CPU dense reference;
5. compared against **Burn dense attention numerically** (same mask) — **no speed claim**;
6. **skips cleanly** without an adapter;
7. **document any deviation** caused by structural accumulation order (the GPU/fp32 vs fp64 gap, and any
   GPU-vs-CPU-fp32 mismatch, explained — this is where NEG-5's "structural only" rule gets stress-tested).

If yes: the FDRS plan abstraction drives a real GPU attention kernel with deterministic structural
accumulation, and tiling/shared-memory/vectorization become later optimizations. If no: we learn where the
abstraction breaks before building a larger attention stack. (Integer superaccumulator deferred — separate
kernel family, doesn't answer the model-design question.)

## Status

- [x] Charter (this document) — G0/G1, hypotheses + falsifiers + exactness ladder pre-registered
- [x] `fdrs-tree` exact mirror + theorem-tests green (H4 gate) — G2 rung 2 — **7/7 green**
- [x] `fdrs-reduce` Burn experiment (NdArray + optional Wgpu) + metrics JSON — G2 rung 3 — **4/4 green**
- [x] CPU reduction sweep run + `results.md` vs H1/H2/H3 — G3 — `runs/2026-06-19-cpu-baseline/`
- [x] `NEGATIVE.md` (H3 verdict + honest scope) — G3 — **H1 ✅ H2 ✅ H3 ❌ refuted, H4 ✅**
- [x] GPU/Wgpu pass on real RTX 4060 (H1 holds cross-backend) — `runs/2026-06-19-gpu/`
- [x] Protocol Amendment 1 pre-registered — bucket-then-binary falsifier, H5/H6/H7 (see above)
- [x] run 2: falsifier executed + `results.md`/`NEGATIVE.md` verdict — G3 — **H6 ✅ (mechanism, 27×),
      H5 ✅ (partition helps with sane kernel; exp+kahan machine-exact on cancellation), H7 ❌
      (sign-split catastrophic)** — `runs/2026-06-19-run2-falsifier/`
- [x] Engineering Milestone 1 pre-registered — custom CubeCL kernel contract + 6 acceptance criteria
- [x] Milestone 1 executed (real RTX 4060) — **QUALIFIED PASS**: schedule + *structural* (pairwise)
      kernel = deterministic GPU contract, bit-identical to CPU `reduce_exp_binary` (c1✅c2✅c3✅c5✅c6✅);
      *compensated* (Kahan) kernel ❌ — optimizer drops the compensation, degrades to naive (NEG-4) —
      `runs/2026-06-19-gpu-kernel/`
- [x] Engineering Milestone 2 pre-registered — defended compensated GPU reduction (bitcast barrier),
      variants + 6 acceptance criteria
- [x] Milestone 2 executed (real RTX 4060) — **NEGATIVE (the valuable outcome)**: both defenses
      (bitcast barrier + global-memory barrier) fold to naive; no mechanism preserves f32 compensation
      → **compensation is not a portable kernel contract here, only structural order is** (NEG-5) —
      `runs/2026-06-19-gpu-kernel-defended/`
- [x] Milestone 3 pre-registered — FDRS block-attention forward pass (correctness-first), structural
      accumulation only, 7 acceptance criteria
- [x] Milestone 3 executed (real RTX 4060) — **PASS, all 7 criteria**: CubeCL attention kernel consumes
      the AttentionPlan, deterministic, masks match, GPU vs fp64 ~1e-7 (≪1e-4 bound), tracks Burn dense;
      only deviation = exp() transcendental (~1e-7), structural accumulation preserved exactly —
      `runs/2026-06-19-gpu-attention/`
- [ ] (deferred optimizations on a validated abstraction) tiling / shared memory / vectorization /
      multi-head / backward pass
- [ ] (deferred, optional) structural integer superaccumulator — only if "GPU cancellation exactness"
      becomes a product requirement (separate kernel family)

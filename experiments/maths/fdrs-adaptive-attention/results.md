# Results — fdrs-adaptive-attention, Rung 1 (training-free fidelity screen)

> **Scientific status:** `cross-checked` (f64 selection-quality screen; the gate is a controlled comparison
> — same budget, same inputs, only the selection rule varies). **Pre-registration:** F1/F2 + falsifier
> fixed in `README.md` (charter, committed `df40e8a`) **before** any code. Run: `runs/2026-06-19-rung1-screen/`.

Does an FDRS *content-chosen* attention partition approximate dense attention better than fixed sparsity at
the same budget? At budget B active KV-blocks/query, three selection rules build an FDRS `AttentionPlan`
(the same CSR the verified M3 kernel consumes) — **fixed-local** (control), **content-top-B** (the FDRS
method: pooled-Q · pooled-K), **oracle** (top-B by true dense attention mass, the selection ceiling) — and
we measure mean-abs output error vs **dense**, all in f64 (pure selection error). Inputs: synthetic
structured Q/K/V, one planted relevant (random, non-local) key block per query block, swept signal strength
SNR. 8 blocks, seq=64, dim=16, block=8, 8 seeds.

## Verdict

| Hyp | Claim | Verdict |
|---|---|---|
| **F1** | content-adaptive beats fixed at high SNR, capturing most of the achievable selection benefit | ✅ **CONFIRMED** |
| **F2 (SNR)** | advantage grows with signal strength; vanishes at SNR=0 | ✅ **CONFIRMED** |
| **F2 (budget)** | advantage grows as budget B *shrinks* | ❌ **REFUTED** (grows *with* B in [1,4]; non-monotone) |

### Mean-abs output error vs dense (f64), and the gap closed

```
 snr  B |    fixed   adaptive    oracle |   adv  gap_closed | adapt_hit oracle_hit
 0.0  2 | 1.036e-1   1.018e-1  1.024e-1 |  1.02   ~0 (no gap)|   0.23      0.25     ← SNR=0 floor: all rules tie
 2.0  4 | 9.455e-2   7.215e-2  7.138e-2 |  1.31     0.97     |   0.98      1.00
 4.0  4 | 1.921e-1   6.774e-2  5.942e-2 |  2.84     0.94     |   0.98      1.00
 8.0  1 | 4.295e-1   8.354e-2  4.069e-2 |  5.14     0.89     |   0.91      1.00
 8.0  2 | 3.757e-1   4.066e-2  2.318e-2 |  9.24     0.95     |   0.97      1.00
 8.0  4 | 2.671e-1   2.358e-2  9.856e-3 | 11.33     0.95     |   0.98      1.00
```
(`adv` = fixed_err / adaptive_err; `gap_closed` = (fixed − adaptive) / (fixed − oracle) = fraction of the
fixed→oracle gap adaptive captures. Full 6×3 sweep in `runs/.../screen.json`.)

## What it shows

- **F1 — the content gate captures the achievable selection benefit.** At high SNR, adaptive beats fixed by
  **5–11×** and closes **89–95%** of the fixed→oracle gap. The cheap pooled-Q·pooled-K gate finds the
  planted relevant block 91–98% of the time (oracle ≈ 100%). So FDRS's plan algebra *can* express a
  content-adaptive partition that recovers most of what an oracle selector would, far above fixed.
- **F2 (SNR) — the advantage is signal-driven and has a clean floor.** It rises monotonically with SNR and
  collapses to ~1× at SNR=0 (pure noise), where hit-rates sit at chance (B/8). The advantage is *earned*
  from content structure, not an artifact — exactly the boundary condition the design built in.
- **F2 (budget) — REFUTED, an honest negative.** I pre-registered "advantage grows as B shrinks (sparser ⇒
  selection matters more)." The data shows the opposite within the tested range: at SNR=8 the advantage is
  5.1× (B=1) → 11.3× (B=4). It must return to 1× at B = n_blocks (dense), so the advantage is **non-monotone
  in B**, peaking at intermediate budget — not monotone-decreasing. See `NEGATIVE.md`.

## Honest scope (pre-committed)

- **Not a new method.** Content-adaptive block-sparse attention is mature (Routing Transformer, BigBird,
  Reformer/LSH, Native Sparse Attention). This screen tests FDRS's plan algebra as a *substrate* + reuses
  the verified M3 `AttentionPlan`; value = connection + curation, per the standing `fdrs-novelty-verdict`.
- **Necessary, not sufficient.** F1 measures output *fidelity* at budget B — a *precondition* for, not proof
  of, end-task benefit. The model-level claim is the deferred training rung (rung 2).
- **The adaptive rule is a first cut** (training-free pooled-dot top-B), not a learned router; ~89–95% gap
  closed, not 100% — it leaves a real residual vs the oracle.
- **`gap_closed` is only meaningful where there is a gap** (fixed > oracle, i.e. higher SNR); at low SNR
  fixed ≈ oracle and the ratio is unstable/undefined — reported as such (null/noise), not interpreted.
- **No performance/speed claim** (separate fork).

## Rung 2 — training rung (`runs/2026-06-19-rung2-train/`)

The model-level question: at equal sparse-attention budget, does an FDRS content-adaptive plan improve task
learning over fixed-local on a content-dependent task? A tiny single-head attention model + linear readout,
trained from scratch (Burn `Autodiff<NdArray>`, Adam, 1200 steps), on a **content-matched remote
block-retrieval** task (N=8 blocks of `[my_tag, query_tag, value]`; label = the value of the block whose
`my_tag` matches `query_tag`; random remote target; local distractors). Attention restricted to an FDRS
block plan at **equal budget B=2**: `fixed_local` / `random` / `content-adaptive` (**frozen** pooled-Q·pooled-K
gate) / `oracle` (always includes the planted target); `dense` = reference. 5 seeds. **No speed claim.**

### Validation accuracy (5-seed mean; chance = 1/8 = 0.125)

```
 condition    | dense  fixed_local  random  adaptive  oracle
 structured   | 0.319    0.186      0.229    0.154    0.559
 no_structure | 0.129    0.132      0.128    0.130    0.129     ← control: everything at chance
```

### Verdict: A1 **refuted** — but it decomposes cleanly, and the decomposition is the result

| Criterion | Verdict |
|---|---|
| **A1** — adaptive beats fixed by +0.15 in ≥4/5 seeds | ❌ **refuted** (0/5; adaptive 0.154 is *below* fixed 0.186) |
| **A2** — no-structure control null | ✅ **confirmed** (all variants at chance ~0.13 — the structured win is genuinely structural) |
| **A3** — adaptive closes ≥50% of fixed→oracle gap | ❌ refuted (gap fraction **−0.086**) |
| **Decomp — oracle routing has value** | ✅ oracle 0.559 ≫ fixed 0.186, **and above dense 0.319** |
| **Decomp — frozen gate routes below chance** | ✅ adaptive gate target-hit **0.10 < 0.25** (budget/n_blocks) |

**What this means.**
1. **The plan/routing has large value.** The `oracle` (correct routing at B=2) reaches **0.559** — far above
   `fixed_local` (0.186) *and above `dense`* (0.319). Focused, correct, low-budget routing beats both fixed
   sparsity and full attention (dense must softmax over 8 blocks including 6 distractors; the oracle sees only
   the answer + one neighbour). So a content-matched partition is genuinely powerful **if the right blocks are chosen.**
2. **The frozen content gate fails to realize it.** `adaptive` (0.154) is *worse* than fixed, and its gate
   routes to the planted target only **10%** of the time — *below* the 25% you'd get by chance at budget 2.
   The pooled-Q·pooled-K gate, on the Q/K the model *learns* for the attention task, is dominated by
   **self-similarity** (a block scores highest against itself), so it spends its budget on self + a neighbour
   and rarely finds the content-matched *remote* block. With no gradient through the (frozen) selection, the
   model has no signal to fix this, and can't bootstrap.
3. **Rung 1 did not transfer.** Rung 1's gate worked because the inputs were *constructed* with Q pre-aligned
   to the target's K. Here Q/K are **learned**, and the frozen pooled-dot rule has neither the form nor the
   incentive to align with the token-level content match the task needs.

**Conclusion.** The FDRS content-adaptive *plan* has real model-level value (the oracle proves it), but the
**frozen** pooled-dot *gate* cannot realize it on learned representations — it needs a **learned router**
(the pre-registered next rung). This is the pre-registered ¬A1 outcome, and A2 confirms it isn't a shortcut.
A negative that localizes the failure to the gate (not the plan) and points squarely at the next experiment.
See `NEGATIVE.md` NEG-2.

## Rung 3 — learned-router rung (the capstone) (`runs/2026-06-19-rung3-router/`)

Rung 2 localized the failure to the *gate*: the plan/routing has value (oracle ≫ fixed), but the frozen
pooled-dot gate can't realize it. Rung 3 adds a **learned content router** (pooled block embedding → learned
projections → top-B) trained by an **auxiliary routing loss** against the known planted target — testing
whether the plan value is *learnable given routing supervision*. Same model/task/budget; 6 variants ×
{structured, no-structure, permuted} × 5 seeds. Position-free model; target index is the aux *label*, never a
router *input*. **No speed claim.**

### Validation accuracy (5-seed mean; chance = 0.125)

```
 condition    | dense  fixed  random  frozen  learned  oracle    learned target-hit
 structured   | 0.319  0.186  0.237   0.154   0.466    0.554     0.70  (vs frozen 0.09, chance 0.25)
 no_structure | 0.122  0.125  0.124   0.126   0.124    0.129     — control: all at chance
 permuted     | 0.324  0.184  0.235   0.152   0.471    0.563     — ≈ structured (position-invariant)
```

### Verdict: **PASS** — all of B1–B5

| Criterion | Verdict |
|---|---|
| **B1** learned ≥ fixed + 0.15 in ≥4/5 seeds | ✅ **5/5** (0.466 vs 0.186) |
| **B2** learned > frozen gate | ✅ 0.466 vs 0.154 |
| **B3** target-hit > chance, tracks gain | ✅ **0.70 ≫ 0.25**; the router that routes (0.70 hit) is the one that gains |
| **B4** closes ≥50% of fixed→oracle gap | ✅ **76%** ((0.466−0.186)/(0.554−0.186)) |
| **B5** no leakage | ✅ no-structure null (0.124 ≈ 0.125) **and** permuted ≈ structured (0.471 ≈ 0.466) |

### What it shows

**The plan value is learnable — given routing supervision.** With an auxiliary loss that supervises the
router toward the known target, a simple content-only router learns to route to the content-matched remote
block **70%** of the time (vs the frozen gate's 9%, below chance), and recovers **76%** of the oracle's
plan value at equal budget — far above the frozen gate (0.154) and fixed-local (0.186), approaching the
oracle (0.554). This **confirms Rung 2's decomposition**: the frozen gate's failure was *routing quality*,
not the plan. The FDRS plan abstraction expresses a partition with real, *learnable* model-level value.

**Controls are clean.** On `no_structure`, `learned_router` sits at chance with everything else (0.124 ≈
fixed 0.125) — no shortcut. On `permuted`, every variant matches its structured value (learned 0.471 ≈
0.466) — the gain is **content-based, not positional** (as expected: position-free model + position-free
task; the permutation condition confirms invariance).

### Honest scope (pre-committed)

- **Supervised routing, not unsupervised.** The aux loss *uses the known target*. This shows the plan value
  is learnable **with routing supervision** — it does **not** show a router can be learned from task loss
  alone (straight-through / Gumbel top-k / RL). That is a harder, **explicitly deferred** question.
- **Recovers most, not all.** Target-hit is 0.70 (not 1.0) and the gap closed is 76% (not 100%) — a real
  residual; the cheap pooled-block router + 1200 steps isn't a perfect oracle.
- **Not a new method**, no speed claim (see Positioning / `NEGATIVE.md`). Oracle is a *ceiling*, not the method.

### Conclusion of the fork

The adaptive-attention arc closes cleanly: **Rung 1** — the content gate captures the achievable *selection*
benefit (fidelity, pre-aligned inputs). **Rung 2** — at the model level the *plan* has value (oracle ≫ fixed,
> dense) but the *frozen* gate fails (routing below chance). **Rung 3** — a *learned* router (supervised)
recovers 76% of that value with clean controls. Net: **FDRS expresses a sparse plan with learnable
model-level value; routing quality — not the plan abstraction — is the limiting factor, and it is learnable
with supervision.** The natural (deferred) next question is whether routing can be learned *without* target
supervision.

## Reproduce

```
cd source && ./run.sh     # gates on the crate tests, then writes runs/<date>-rung1-screen/
```

## Next

Rung 2 (training) is now justified by F1 and is the deferred next step: train small transformers from
scratch on a content-dependent synthetic task, compare dense / fixed-sparse / FDRS-adaptive at equal budget
on **task loss** (the model-level claim F1 is only a precondition for). Pre-register before running.

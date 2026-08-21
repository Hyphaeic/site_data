# fdrs-adaptive-attention — does a content-matched FDRS partition beat fixed sparsity? (charter)

> Model-design fork of `fdrs-gpu-numerics` (SUMMARY.md §"Next engineering forks" #3). Scope confirmed
> 2026-06-19: rung 1 = training-free fidelity screen on **synthetic structured inputs with a swept
> content-signal strength**, reusing the M3 attention machinery. Rung 2 (training) deferred, gated on F1.

**Follows `ADR-007` (FDRS experiments workflow): pre-registration before results, negatives first-class,
controlled comparison as the gate, honest novelty positioning.**

- **Registry ID:** `experiment-fdrs-adaptive-attention`
- **Scientific status:** **`cross-checked`** (controlled-comparison gate). **Rung-1** F1 screen: **F1 ✅** (content gate beats fixed 5–11× at high SNR, closes 89–95% of the gap) · F2-SNR ✅ · F2-budget ❌ (NEG-1). **Rung-2** training: **A1 ❌** (frozen gate fails — 0.154 < fixed 0.186) **but the plan is valuable** (oracle 0.559 ≫ fixed, > dense) and **A2 ✅** — gate, not plan, is the bottleneck (NEG-2). **Rung-3** learned router (aux routing supervision): **B1–B5 all ✅** — learned_router 0.466 (≫ frozen 0.154, target-hit 0.70), **closes 76% of the fixed→oracle gap**, controls clean (no-structure null, permutation-invariant) ⇒ **the plan value is learnable; routing quality was the limit** (caveat: *supervised* routing, unsupervised deferred). Results/negatives in `results.md`/`NEGATIVE.md`; runs `runs/2026-06-19-{rung1-screen,rung2-train,rung3-router}/`.
- **Workspace:** Rust/Burn (no Python as the main implementation, per repo rule); reuses the
  `fdrs-gpu-numerics` `AttentionPlan` (CSR `row_offsets` + `block_ids`) and the verified M3 attention kernel.
- **Owner:** `volition-billy`
- **Risk class:** low (internal, exploratory; no external commitment, no IP disclosure).

## Motivation

`fdrs-gpu-numerics` established two things this experiment builds on:
- **H5 / H7:** *which* partition you choose is itself part of the algorithm — a structure-matched partition
  helps, a mismatched one is catastrophic.
- **M3:** the FDRS `AttentionPlan` drives a real, deterministic GPU block-attention forward pass.

Open question (the model-design fork): **does an FDRS-*chosen*, data-dependent attention partition help at
the model level, versus fixed sparsity, at the same compute budget?** I.e., does the "match the partition
to the structure" lesson transfer from numerics to attention selection?

## Honest positioning (prior art — read first)

Content-adaptive block-sparse attention is a **mature field**: Routing Transformer (Roy et al. 2021),
BigBird (Zaheer et al. 2020), Reformer/LSH (Kitaev et al. 2020), top-k / learned-sparse attention, and
Native Sparse Attention (2024). **This experiment claims none of that as novel.** It asks the narrow
question of whether **FDRS's plan/gate algebra** — the *same* `AttentionPlan` the verified M3 kernel
consumes — is a sound substrate for expressing a content-adaptive partition, and whether such a partition
recovers dense quality at a budget and beats a strong fixed pattern. **Value = connection (FDRS algebra →
adaptive attention on a verified kernel) + curation, not a new sparse-attention method.** (Consistent with
the standing `fdrs-novelty-verdict`.) Any writeup must cite the above and frame on the connection, never on
"FDRS-novel sparse attention."

## The FDRS-adaptive rule (the crux)

Per query block `qb`, score each key block `kb` by a **cheap content summary** (e.g. pooled-Q(qb) ·
pooled-K(kb)), then select the **top-B** key blocks → that *is* the `AttentionPlan` for this input, now
**data-dependent**. This is the Phase-11 *non-stationary partition* idea applied to attention block
selection — the same construct that *failed* as a naive reduction tree (H3) but whose "partition-choice
matters" lesson (H5) motivates testing it where the partition is matched to content.

## Rungs (escalating; screen-first, gated)

- **Rung 1 / F1 — training-free fidelity screen (the proposed first step).** No model training. At budget
  `B` active KV-blocks/query, measure how well the sparse attention *output* approximates the dense output,
  for three selection rules:
  - **fixed** — the best static pattern at budget B (banded / causal / strided-dilated / random-fixed): the *control*;
  - **FDRS-adaptive** — content-score top-B: the *method*;
  - **oracle** — top-B by the *true* dense attention mass per query block: the *upper bound on selection*.
  All four (dense + 3 rules) are computed in **f64** via the M3 reference attention with the rule's plan —
  so the measured error is **pure selection error**, not muddied by f32 rounding. Adds content-score and
  oracle plan builders over the FDRS `AttentionPlan`.

  **Inputs — synthetic structured, swept SNR (the boundary-condition-safe design).** Each query block `qb`
  is planted with one genuinely-relevant key block `tb(qb)`: queries in `qb` are `Q = α·(key in tb(qb)) +
  noise`, with `α` the swept content-signal strength (SNR). At high α, attention concentrates on `tb(qb)`
  ⇒ selecting it is essential; at **α=0 (pure noise)** attention is uniform ⇒ all selectors converge — the
  built-in sanity floor. The planted block `tb(qb)` is **random / non-local**, so no fixed positional pattern
  can systematically include it. Always reports all three rules across the full α range (no rigging). CPU, cheap, fast.
- **Rung 2 — task with training (DEFERRED, gated on F1).** Train small transformers from scratch on a
  genuinely content-dependent synthetic task **[SCOPE: associative recall / selective copy / induction —
  pick one]**; compare dense / fixed-sparse / FDRS-adaptive at equal budget; metric = task accuracy vs budget.
- **Rung 3+ — DEFERRED.** Learned gate (trained router) instead of training-free top-B; real data; GPU via M3 kernel.

## Hypotheses (pre-registered)

- **F1 (fidelity).** At budget B, FDRS-adaptive content top-B selection yields **lower** attention-output
  error vs dense than the best fixed pattern, across budgets — landing **near the oracle**.
- **F2 (signal/budget curves).** The adaptive advantage over fixed **grows with content-signal strength
  (SNR)** and **grows as the budget B shrinks** (sparser ⇒ selection matters more); it **vanishes at SNR=0**
  (pure noise, the sanity floor) and at B = all blocks (recovers dense). Monotone interpretable curves, not point claims.
- **(deferred) H-train.** At equal budget, FDRS-adaptive attention reaches **lower task loss** than
  fixed-sparse, approaching dense.
- **GATE / FALSIFIER (first-class negative).** If adaptive ≈ fixed at all budgets within seed noise, or sits
  far below the oracle, then FDRS-gated selection adds **no** value here — the numerical "partition matters"
  result (H5) does **not** transfer to attention selection. That is a first-class result, reported at full weight.

## Method — the gate is a controlled comparison (no exact mirror here)

This is ML, so ADR-007's exact-arithmetic ladder does not map. The **gate** is instead a strictly controlled
comparison: **same budget B, same Q/K/V (or same model/data/seed), only the selection rule varies**; many
seeds; report **distributions, not single runs**; **dense = upper bound, best-fixed = strong lower control,
oracle = selection ceiling**. The fixed baseline must be the *best* static pattern at B (no strawman). The
rung-2 task must be chosen for genuine content-dependence (and that property stated up front, not reverse-fit).

## Metrics

- F1: max/mean attention-output abs & rel error vs dense; **error-vs-budget curves** (per rule); active-block
  **overlap with the oracle** set (how often content top-B picks the same blocks dense actually weights).
- Rung 2 (deferred): task accuracy / loss vs budget; params; a FLOPs/active-block compute proxy.

## Falsification criteria (pre-registered)

- **F1 fails if:** adaptive's error-vs-budget curve is within seed-noise of best-fixed (no separation), or
  does not approach the oracle as B grows.
- **F2 fails if:** the adaptive advantage is flat in B (no "sparser ⇒ matters more" trend) or non-monotone noise.
- **H-train fails if:** at equal budget, adaptive task loss is within seed-noise of fixed-sparse.

## Limitations & non-claims (pre-committed)

- **Not a new sparse-attention method** (see Positioning); not SOTA; small scale.
- **F1 is necessary, not sufficient:** output fidelity at budget B is a *precondition* for, not proof of,
  end-task benefit. Rung 2 is what tests the model-level claim.
- The adaptive rule (training-free content top-B) is a **first cut**, not a learned router (rung 3).
- **No performance/speed claim** (separate concern; the perf fork is a different experiment).

## Rung 2 — training rung, pre-registration (2026-06-19, before any training code)

Rung 1 (F1) showed the FDRS content gate captures the achievable *selection* benefit (output fidelity). Rung
2 tests the **model-level** claim, the one question:

> **At equal sparse-attention budget, does an FDRS content-adaptive plan improve task learning /
> generalization over a fixed-local plan, on a task whose dependency structure is content-dependent?**

**Scope (intentionally small + adversarial).** Tiny single-head attention model + linear readout (learned
embedding + Wq/Wk/Wv/Wo; no MLP/residual/norm — minimal), trained **from scratch** (Burn, `Autodiff<NdArray>`,
Adam), fixed steps, fixed parameter count, synthetic task only. **No speed claim.**

**Task — content-matched remote block retrieval (known ground truth ⇒ clean oracle).** A sequence of `N`
blocks; each block carries a `key` id and a `payload` id. Each query block is planted with a **remote target
block** at a **random** position and carries that target's key; the label is the target's **payload** (match
by key-content, copy payload). Local neighbours are distractors (different keys). The planted target is known
⇒ the oracle plan always routes to it.

**Plan variants at EQUAL budget `B` (active KV-blocks/query):** `fixed-local`, `random-budget`,
`content-adaptive` (frozen gate), `oracle` (always includes the planted target). **`dense` (full attention)
is a REFERENCE upper bound, NOT a same-budget competitor.**

**Frozen gate (this rung).** Selection rule is fixed — top-`B` key blocks by pooled-Q·pooled-K on the model's
*current* Q/K — recomputed each forward pass; **no separately-learned router, no gradient through the top-`B`
selection.** (Learned gate = a later rung.) This isolates *plan* value from *router-learning* value.

**Adversarial controls (the load-bearing part).**
- **No-structure control:** labels independent of any block's content (random) ⇒ no routing can help ⇒
  adaptive must **not** materially beat fixed. If it does, the structured win is an artifact.
- **Permutation control:** block positions shuffled ⇒ any positional shortcut is broken; catches a content
  gate that is secretly leaking position rather than matching content.
- **Equal budget:** identical active-block count per query across fixed / random / adaptive / oracle.

**Metrics.** Primary: **validation accuracy** (and loss) on held-out sequences. Secondary: planted-block
**hit-rate** (does the gate route to the target), active-block count (= budget, sanity), training stability
(loss spread / divergence across seeds).

**Acceptance criteria (conservative, pre-declared; reported honestly even if missed).**
- **A1 — structured win:** content-adaptive val-accuracy ≥ fixed-local **+ 0.15** (15 pts) on the structured
  task, in **≥ 4 of 5 seeds**.
- **A2 — control null:** on the no-structure control, |adaptive − fixed| **< 0.05** (no material advantage).
- **A3 — gap:** adaptive closes **≥ 50%** of the fixed→oracle accuracy gap on the structured task.
- **A4 — budget-honest:** the win holds at budget `B`; it does **not** depend on dense's larger budget.
- **A5 — negatives reported:** seeds/regimes where adaptive fails, and any training instability, are in `NEGATIVE.md`.

If A1 holds but A2 fails (adaptive also wins with no structure), the result is **rejected** as a shortcut, not
celebrated. A frozen-gate null on the structured task (A1 fails) is itself a first-class result: the plan
needs a learned router to help (→ next rung).

## Rung 3 — learned-router rung, pre-registration (2026-06-19, before any router code) — the last rung before pausing

Rung 2 localized the failure: the *plan/routing* has model-level value (oracle 0.559 ≫ fixed 0.186, > dense
0.319) but the *frozen* pooled-dot gate can't realize it (routes below chance). Rung 3 asks:

> **Can a learned router recover a meaningful fraction of the oracle routing value at equal budget, without
> positional leakage?**

**Framing guard (carry into the writeup).** Oracle > dense does **not** mean sparse FDRS attention beats
dense in general — it means *this task rewards focused low-budget routing that removes distractor mass*, and
that there is *usable routing value at this budget*. No general sparse>dense claim.

**Router (keep it simple).** Per block, pool its token embeddings → a block embedding; a learned router scores
candidate key blocks per query block via separate projections `score(qb,kb) = (Rq·be[qb])·(Rk·be[kb])`; take
top-B. **Content-only:** the router sees only token content + within-block role — **no absolute position, no
access to the planted target index** (the target is the aux-loss *label*, never a router *input*).

**Training the router — auxiliary routing loss (chosen deliberately).** The planted target `tb(qb)` is known,
so supervise the router directly: `aux = CE(softmax(router_scores[qb,:]), tb(qb))`. The hard top-B selection
is non-differentiable (mask built from detached scores); the aux loss trains the router, the task loss trains
the attention. Total = `task_loss + λ·aux`. This tests whether the plan value is **learnable given routing
supervision** — *not* whether a router can be learned from task loss alone (a harder, separate question:
straight-through / Gumbel top-k / RL — explicitly deferred).

**Variants (8 controls):** dense (ref) · fixed_local · random · frozen_gate (= Rung-2 adaptive) ·
**learned_router** · oracle (ceiling). **Conditions:** structured · no-structure · permuted. **Equal budget
B. No speed claim.**

**Leakage avoidance (load-bearing).** Model is position-free (only content + within-block role embeddings),
so the router cannot use absolute position; the target index is a label, never an input. The task itself is
position-free (random tags, random remote targets), so the **permuted** condition is a *confirmatory
invariance* check (a content-only router should be ≈ structured), reported honestly as such.

**Acceptance criteria (conservative, pre-declared).**
- **B1 — beats fixed:** learned_router val-accuracy ≥ fixed_local **+ 0.15** in **≥ 4/5 seeds** (structured).
- **B2 — beats frozen gate:** learned_router > frozen_gate (Rung-2 adaptive) by a clear margin.
- **B3 — routing tracks gain:** learned_router target-hit **> chance** (budget/N) *and* its across-seed
  accuracy gain correlates with its target-hit (routing causes the gain).
- **B4 — closes the gap:** learned_router closes **≥ 50%** of the fixed→oracle accuracy gap.
- **B5 — no leakage:** learned_router shows **no** material gain on no-structure (|Δ vs fixed| < 0.05), and
  its structured gain **persists under permutation** (≈ structured ⇒ content-based, not positional).

If B1–B4 hold and B5 confirms no leakage: the plan value is **learnable with routing supervision**, and the
limiting factor was routing quality (confirmed). If the supervised router *also* fails, the limitation is
deeper than routing. Either way it is the capstone for this fork; further rungs (unsupervised router) are
explicitly out of scope here.

## Status

- [x] scope confirmed (2026-06-19): rung-1 training-free fidelity screen; synthetic structured inputs + SNR sweep
- [x] charter committed (pre-registration, before code) — G0/G1 — commit `df40e8a`
- [x] rung-1 F1 screen built + run — **F1 ✅, F2-SNR ✅, F2-budget ❌ (NEG-1)**; 3/3 tests green —
      `runs/2026-06-19-rung1-screen/`
- [x] rung-2 pre-registered (2026-06-19) — equal-budget training rung, frozen gate, no-structure + permutation
      controls, conservative pre-declared acceptance (A1–A5)
- [x] rung-2 executed — Burn attention model on the retrieval task, equal budget × 5 seeds × {structured,
      no-structure} — **A1 ❌ (frozen gate 0.154 < fixed 0.186), A2 ✅ (control null), plan valuable (oracle
      0.559 ≫ fixed; NEG-2)** — `runs/2026-06-19-rung2-train/`
- [x] rung-3 pre-registered (2026-06-19) — learned-router rung (auxiliary routing loss), 8 controls incl.
      permutation, conservative acceptance B1–B5; the last rung before pausing
- [x] rung-3 executed — learned router (aux routing loss) vs frozen/fixed/random/oracle/dense × {structured,
      no-structure, permuted} × 5 seeds — **B1–B5 all ✅; learned 0.466, closes 76% of fixed→oracle gap,
      target-hit 0.70, controls clean** — `runs/2026-06-19-rung3-router/`
- [ ] (deferred, out of scope — the natural next question) unsupervised router: can routing be learned from
      task loss alone (straight-through / Gumbel top-k / RL), without target supervision?

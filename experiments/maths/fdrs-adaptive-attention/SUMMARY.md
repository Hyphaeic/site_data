# fdrs-adaptive-attention — experiment summary (for review)

**Status:** `cross-checked` (the gate is a controlled comparison — same budget, same task/seeds, only the
plan/router varies; pre-registration before each rung). Rungs 1–3 ran on CPU: a training-free f64 fidelity
screen (rung 1) and tiny attention models trained from scratch in Burn `Autodiff<NdArray>` (rungs 2–3).
Synthetic task only. **No performance claim anywhere.**

## The defensible claim

> **FDRS provides a useful plan algebra for sparse attention:** it can express content-dependent sparse
> routes with real task value; the value is visible under an oracle; a frozen heuristic gate fails; and a
> supervised learned router recovers most of the oracle value under equal budget, with clean no-leakage
> controls.

The win is **classical content-based selection** expressed over the FDRS `AttentionPlan` (the same CSR the
verified numerics-family M3 kernel consumes). Content-adaptive block-sparse attention is mature prior art
(Routing Transformer, BigBird, Reformer/LSH, Native Sparse Attention); the contribution is the plan
*substrate* + the clean decomposition (plan value vs routing quality), not a new sparse-attention method.

## Result table (Rungs 1–3)

| Rung | What it tested | Verdict | Key evidence |
|---|---|---|---|
| **1 — fidelity screen** (no training, f64) | does content top-B approximate dense better than fixed at budget B? | **F1 ✅ · F2-SNR ✅ · F2-budget ❌** | adaptive beats fixed 5–11× at high SNR, **closes 89–95%** of the fixed→oracle gap; clean SNR=0 floor; advantage grows *with* budget not against (NEG-1) |
| **2 — training, frozen gate** | does the frozen pooled-dot gate help a *trained* model at equal budget? | **A1 ❌ · A2 ✅; plan exonerated** | adaptive 0.154 < fixed 0.186 (gate routes **below chance**), BUT **oracle 0.559 ≫ fixed 0.186, > dense 0.319** — the *plan* has value, the *gate* fails (NEG-2); control null |
| **3 — training, learned router** (aux routing loss) | is the oracle-proven plan value *learnable*? | **B1–B5 all ✅** | learned **0.466** (≫ frozen 0.154), target-hit **0.70**, **closes 76%** of fixed→oracle gap; no-structure null + permuted ≈ structured |

**Through-line:** the FDRS *plan* abstraction is validated (oracle shows real value); **routing quality is the
bottleneck** (frozen gate fails); routing is **learnable with supervision** (learned router recovers 76%).

## Negative findings (first-class)

- **NEG-1 / F2 budget:** the adaptive advantage does *not* grow as budget shrinks (pre-registered direction
  refuted; it is non-monotone, grows *with* budget in the tested range).
- **NEG-2 / A1:** the **frozen** content gate *fails* at the model level — worse than fixed-local, routing
  below chance (self-similarity-dominated on learned Q/K). Rung-1's positive (pre-aligned inputs) did **not**
  transfer to learned retrieval. The negative localizes the failure to the *gate*, not the *plan*.
- **Rung-3 caveats (fraud gallery #11–13):** the learned router is **supervised** (aux loss uses the known
  target); it routes 70% (not 100%) and closes 76% (not 100%) of the gap; the oracle is a **ceiling, not the
  method**. Do not cite rung 3 as "adaptive attention works" without "*with routing supervision*".

The full fraud gallery (13 tempting-but-wrong spins) is in `NEGATIVE.md`.

## What is NOT claimed

- **Supervised routing, not task-loss-only.** Rung 3 shows the plan value is learnable *given routing
  supervision*; learning a router from task loss alone (straight-through / Gumbel top-k / RL) is **deferred**.
- **A mechanism result, not a broad model claim.** Synthetic, position-free retrieval task; one budget (B=2);
  tiny single-head model. Not a benchmark, not SOTA, not a deployable method.
- **Oracle > dense is task-specific.** It means *this task rewards focused low-budget routing that removes
  distractor mass* and that there is usable routing value at this budget — **not** that sparse FDRS attention
  beats dense in general.
- **No new sparse-attention method** (see prior art); the routing win is classical content-based selection.
- **No performance / speed claim.** No timing, no FLOP accounting beyond the active-block budget.

## Reproduce

```bash
cd source
cargo test                                   # rung-1 gate (plan budget/validity, F1 directional, SNR=0 floor)
./run.sh                                      # rung-1 fidelity screen, rung-2 frozen-gate training, rung-3 learned router
```
Each run lands in `runs/<date>-*/transcript/` (machine JSON + human summary) with a `manifest.yaml`
provenance triple. Pre-registration (charter + Rung-2/Rung-3 amendments, hypotheses, acceptance) is in
`README.md`, committed **before** each execution (anti-HARKing); per-rung verdicts in `results.md`; negatives
in `NEGATIVE.md`. (Rungs 2–3 train from scratch and take minutes; no speed claim is made from runtime.)

## Next forks (none started)

1. **Unsupervised router** — the one genuinely open question: can routing be learned from task loss *alone*,
   without target supervision (straight-through / Gumbel top-k / RL)? Rung 3 only shows learnability *with*
   supervision.
2. **Performance / GPU-kernel path** — feed the learned router's `AttentionPlan` to the numerics-family M3
   CubeCL kernel (already verified) and measure, with a real timing harness — the first place speed claims
   become appropriate. Carry the NEG-5 rule (structural accumulation, no compensated f32).
3. **Real-model benchmark path** — beyond the synthetic retrieval task: a small real LM / longer-context task,
   to test whether the plan value and learnable routing survive contact with realistic data and scale.

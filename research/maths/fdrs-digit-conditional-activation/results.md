# Results — Digit-Conditional Activation (run 2026-06-10-baseline)

**Gate:** G3 Validate. **Scientific status:** `speculative` → **`tested`**.
**Result tag:** `float` (candidate rank), gated by the exact-mirror theorem suite (`exact`, 7/7 green).
**Verdict:** H1 confirmed (with one recorded nuance), H2 confirmed, H3 confirmed. No hypothesis falsified.

This run measures the digit-conditional activation thesis as a **feature-map comparison with a closed-form linear (ridge) readout** — the confound-free, theory-faithful measurement of the Fourier ceiling (Thm 66) and representation gap (Thm 67). Three banks at **matched dimension** D = #leaves = Σrⱼ: `tree-leaf` (the digit-conditional map), `uniform` (equal-width cells), `fourier` (geometric ladder). Metric: held-out test R². 250 runs (5 Gap × 5 α × 2 noise × 5 seeds).

---

## Pre-registered hypotheses → verdicts

### H1 (dose–response) — **CONFIRMED** (α axis strictly; Gap axis in the weak form)

The tree-leaf advantage rises with 1/α and is zero-at-Gap-1/positive-for-Gap>1, as the theorems predict — but the two baselines fail along **two orthogonal axes**, which is sharper than the original single-advantage framing:

**α axis (Fourier-ceiling failure mode, Thm 66), strong Gap = 17.14, noiseless, mean of 5 seeds:**

| α | adv vs fourier | adv vs uniform |
|---|---|---|
| 0.9 | +0.121 ± 0.040 | +0.171 ± 0.038 |
| 0.7 | +0.202 ± 0.070 | +0.288 ± 0.050 |
| 0.5 | +0.279 ± 0.101 | +0.398 ± 0.068 |
| 0.3 | +0.352 ± 0.133 | +0.502 ± 0.094 |
| 0.1 | +0.422 ± 0.168 | +0.600 ± 0.133 |

Advantage over Fourier is **strictly monotone in 1/α** — exactly the ceiling: as more target energy moves into the deep layer (low α), low-order Fourier modes capture less, capped at fraction α (Thm 66). Clean confirmation.

**Gap axis (representation-gap failure mode, Thm 67), α = 0.5, noiseless:**

| Gap | adv vs uniform |
|---|---|
| 1.00 | **+0.0000 ± 0.0000** |
| 2.40 | +0.322 ± 0.148 |
| 2.67 | +0.392 ± 0.112 |
| 3.69 | +0.375 ± 0.061 |
| 17.14 | +0.398 ± 0.068 |

Advantage over uniform is **exactly zero at Gap = 1** and **substantial and positive for every Gap > 1**. *Nuance (recorded in `NEGATIVE.md`):* the magnitude does **not** scale monotonically with the numeric Gap value — it saturates near +0.32–0.40 across Gap ∈ [2.4, 17.1]. The Gap formula bounds the *cell count* for exact representation; the R² shortfall at fixed dimension is a related but distinct quantity. So the supported claim is the **threshold/dichotomy** form (Gap = 1 ⟺ no penalty; Gap > 1 ⟺ penalty), not strict monotonicity in Gap magnitude.

### H2 (vanishing at the degenerate point) — **CONFIRMED**, and refined

The advantage **over uniform** is `+0.0000 ± 0.0000` at Gap = 1 **for every α** (0.1 → 0.9) — an exact empirical confirmation of the Thm 69 collapse (a homogeneous tree's leaf partition *is* the uniform M-cell partition). This is the cleanest single number in the run.

Refinement the data forced: the advantage **over fourier** does *not* vanish at Gap = 1 alone (it is +0.128 at α = 0.9, rising to +0.250 at α = 0.1), because Fourier fails on deep/jump structure regardless of Gap. Tree-leaf ties Fourier only in the **doubly-degenerate corner** Gap = 1 **and** α → 1. The two baselines fail for two different reasons — uniform on heterogeneity (Gap), Fourier on depth (α) — mapping precisely onto the two distinct theorems (67 vs 66). At Gap = 1, α = 0.9: r2_tree = r2_uniform = 1.000, r2_fourier = 0.872.

### H3 (exact-mirror fidelity) — **CONFIRMED**

- The exact-rational mirror (`fdrs-signal`) satisfies all 7 machine-checked Phase-11 theorems as exact-equality/inequality tests: Parseval, exact reconstruction, Fourier ceiling, homogeneous collapse, leaf-count identity, homogeneous leaf-count product, depth-2 gap. (The gate; `cargo test -p fdrs-signal`.)
- The f64 experiment's `cell-mean` matches the exact mirror within 1e-12 on cross-checked instances; the homogeneous-collapse smoke test agrees within 1e-9. (`cargo test -p fdrs-activation`.)

---

## Robustness

Observation noise σ = 0.1 (strong Gap, α = 0.5) barely moves the picture: r2_tree 1.000 → 0.989, adv_uniform +0.398 → +0.380, adv_fourier +0.279 → +0.260. The effect is not a noiseless artifact.

## What this does NOT show (honest scope — see `NEGATIVE.md`)

1. **The win is partly structural.** The tree-leaf basis is matched to the target by construction, so a positive advantage is expected; the *scientific content* is that the **baseline shortfall is dose-dependent and tracks the two theorems' predicted failure modes**, and that the collapse at Gap = 1 is exact. This is a controlled demonstration that the Phase-11 failure modes are real and quantitatively structured — **not** a claim that tree features help on natural data.
2. **Linear readout only.** An MLP head (charter v2) can recombine modes and may erode the Fourier shortfall; the linear measurement is the faithful test of the *ceiling* but not of trained-model behavior.
3. **Tree is given, not learned.** Real use requires discovering the tree (F-statistic screen, Prop 137) on data of unknown structure — deferred.
4. **Synthetic targets.** No natural dataset was screened; the synthetic-to-real gap is untested.

## Promotion path (G4, per ADR-007 §4)

H1/H2 confirmed → the priority formalization targets become the Phase-11 stubs the experiment exercised:
- A real `minUniformCells` / `representationGap` wired to actual signal partitions (currently `:= N`), which would let the **threshold result** (Gap = 1 ⟺ zero penalty) be stated and proven, and would formalize *what the R²-shortfall tracks* (the saturation nuance is a genuine open question the experiment surfaced).
- The detection-power scaling ε₅₀ ~ √(b₀/M) (`Detection.lean` currently proves only positivity).

These will be staged as `proof_wanted` declarations under `FdrsFormal/Conjectures/` (counted empirical debt) when promoted — a `propose`-gated action (material claim entering the corpus).

## Reproduce

```bash
./run.sh   # gates on theorem tests, then executes runs 1–5, writing each transcript
```

Transcript: `runs/2026-06-10-baseline/transcript/` (sweep.csv = 250 rows; summary.txt = dose-response). Provenance: `manifest.yaml`.

---

# Results — Amendment 1 runs (2026-06-11): H4–H7

All four hypotheses pre-registered in README "Protocol Amendment 1" **before** execution.
Verdicts: **H4 CONFIRMED · H5 CONFIRMED · H6 NOT CONFIRMED (partial) · H7 CONFIRMED.**

## Run 2 — H4: the shortfall is projection geometry, not Gap — **CONFIRMED**

The analytic uniform-projection shortfall S (variance the exact M-bin projection fails to explain — deterministic, no fitting) predicts the measured ridge advantage with **MAE 0.016** over 12 r-vectors; corr(adv, S) = **0.948** vs corr(adv, log Gap) = 0.767; S = 0 exactly on every Gap = 1 anchor. The decoupling is explicit in the data: `[2,2,2,3]` (Gap 2.67) has the **highest** shortfall (S = 0.409) while `[2,3,4,5]` (Gap 17.14) sits at S = 0.343 — and the advantage follows S, not Gap.

**This resolves run 1's saturation anomaly**: the fixed-budget penalty of uniform features is boundary-straddle energy (projection geometry), for which the lcm-based Gap is only a coarse upper-bound proxy. *Formalization consequence:* the `proof_wanted` candidate sharpens from "the Gap formula" to: (i) the threshold theorem (S = 0 ⟺ homogeneous alignment, the Thm 69 direction) and (ii) bounds/expectation for S(r, α) over random tree-adapted targets — the quantity that actually governs the penalty.

## Run 3 — H5: the MLP closes most, but not all, of the Fourier gap — **CONFIRMED**

| Gap | α | MLP-Fourier R² | linear-tree R² | deficit (envelope) |
|---|---|---|---|---|
| 17.14 | 0.1 | 0.917 | 1.000 | **0.083** (±0.002) |
| 17.14 | 0.3 | 0.920 | 1.000 | **0.080** (±0.006) |
| 17.14 | 0.9 | 0.956 | 1.000 | 0.044 (±0.014) |
| 1.00 | 0.5 | 0.970 | 1.000 | 0.031 (±0.013) |

The recombination objection was **real and large** — the trained head recovers Fourier from 0.58 to 0.92 R² at the hardest corner — but a deficit ≥ 0.08 persists at α ≤ 0.3, beyond tiny seed envelopes, still monotone in 1/α, **despite the MLP arm having ~40× the parameters** of the 14-weight linear-tree readout (545 vs 14). Two sharper findings:

1. **MLP-uniform does NOT improve over linear-uniform** (0.399 ≈ run 1's 0.40 at the hard corner): one-hot uniform bins *destroy* within-bin position information; no readout can recover it. The two baseline failures differ in kind — **uniform's is representational (information erased), Fourier's is efficiency (information present but expensive to extract)**.
2. The raw-x MLP (practitioner default, exploratory arm) is the worst everywhere (0.43–0.91) — consistent with spectral bias on jump targets.

*Caveat:* deficit magnitude is configuration-dependent (h = 32, 2000 epochs, 3-point lr grid); a larger/longer-trained MLP may close more. The claim is "persists at this matched-budget configuration," not "cannot be closed."

## Run 4 — H6: the tree is learnable in the median case, not the worst case — **NOT CONFIRMED (partial)**

Greedy CART-style segmentation at leaf budget D = 14: noiseless oracle−learned gap **0.075 ± 0.093 (FAIL** vs ≤ 0.05**)**, driven entirely by seed 3 (0.256); the other four seeds are ≤ 0.065 and σ = 0.1 **passes** (0.041 ± 0.038). Boundary recovery 83–89% vs ≈ 5–6% chance.

The exploratory budget-headroom annex (D+2 = 16, labeled exploratory) leaves seed 3's gap **bit-identical** (0.25555): the missed boundary produces zero SSE reduction *on that train sample* (segments constant-on-train), so no SSE-driven splitter at any budget can find it. **The limitation is train-sample identifiability near small leaves, not algorithm budget** — "tree given vs learned" stands as a real caveat in the worst case, quantified: median-case learnable, tail-case data-limited.

## Run 5 — H7: detection power scales as the unformalized claim predicts — **CONFIRMED**

F-statistic of the true-leaf partition at (α = 0.3, σ = 0.5), n ∈ {150…2400}: doubling ratios **1.944, 2.075, 1.999, 2.011** — all within the pre-registered [1.6, 2.4] band; F ∝ n across a 16× range. This is the noncentrality scaling (λ ∝ M) behind prose Prop 137's ε₅₀ ~ σ·√(b₀/M). The Lean `detectionPowerScaling` placeholder (currently positivity-only) now has the empirical evidence a real formalization needs — **promotion-eligible**.

## Synthesis across the family (runs 1–5)

1. **The two baseline failure modes are real, distinct, and now mechanistically characterized**: uniform fails on *heterogeneity* via boundary-straddle energy (S, not Gap — run 2), and the failure is *representational* (survives any readout — run 3); Fourier fails on *depth* (α), and the failure is an *efficiency* gap that a trained head shrinks but does not close at matched budget (run 3).
2. **The practical pipeline is plausible end-to-end in the median case**: structure is detectable (run 5, F ∝ n), learnable (run 4, median + boundary recovery ≫ chance), and the learned representation's advantage is predictable analytically (run 2, MAE 0.016) — with one honest tail-risk (run 4's identifiability failure).
3. **Formalization targets, ranked by evidence**: (a) the S-threshold theorem and S(r, α) bounds [run 2, strongest]; (b) ε₅₀/noncentrality scaling [run 5, clean]; (c) the information-destruction vs efficiency distinction between the two baselines [run 3, currently informal]. All three are `proof_wanted` candidates for `FdrsFormal/Conjectures/` (G4, `propose`-gated).
4. **Still untouched** (v3 charter, human-in-loop): natural-data screening; larger-capacity MLP scaling of the deficit; learned-tree identifiability fixes (lookahead/Bayesian splitters).

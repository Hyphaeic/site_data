# Negative results & boundaries — digit-conditional activation

Per ADR-007 §5: negatives recorded as bounded-completeness statements + a "fraud gallery"
of things that look like wins but are not (yet). Archive-never-delete; these are findings.

## Bounded-completeness negatives (run 2026-06-10-baseline)

- **Advantage-over-uniform does NOT scale with Gap magnitude.** Searched b0 = 4, Gap ∈ {1.00,
  2.40, 2.67, 3.69, 17.14}, α = 0.5, 5 seeds, n_grid = 600, ridge λ = 1e-6. The tree-vs-uniform
  test-R² advantage is exactly 0 at Gap = 1 and saturates at +0.32…+0.40 for **all** Gap ≥ 2.4 —
  it is a threshold/dichotomy, not a monotone function of the numeric Gap. The strict-monotonicity
  reading of H1 (Gap axis) is **not** supported in this range. Transcript: `transcript/sweep.csv`.
- **Fourier ties tree-leaf only in the doubly-degenerate corner.** Across Gap = 1 × α ∈ {0.1…0.9}
  the tree-vs-fourier advantage is never zero (min +0.128 at α = 0.9); it vanishes only as
  Gap → 1 AND α → 1 jointly. "Advantage vanishes at the degenerate point" is true only for the
  uniform baseline (the Thm 69 collapse), not the Fourier baseline.

## Fraud gallery (apparent wins that are not claims)

- **The tree-leaf advantage is partly tautological.** The leaf-indicator basis spans the
  (piecewise-constant) target by construction, so R²_tree ≈ 1 is built in, not discovered. Do not
  cite "tree features win" as a representational result on its own — the citable content is the
  *dose-dependence of the baseline shortfall* and the *exact Gap = 1 collapse*. A win on a target
  drawn to match the basis is not evidence of a win on natural data.
- **Matched dimension ≠ matched inductive bias.** Equal feature count across banks controls
  capacity but not smoothness/locality priors; a Fourier shortfall under a *linear* readout does
  not transfer to a trained MLP, which can recombine modes. Reading the linear result as an
  architecture-level claim would be the error.

## Amendment-1 negatives (runs 2–5, 2026-06-11)

- **H6 NOT CONFIRMED at the registered threshold (run 4).** Greedy SSE segmentation at budget
  D = 14, noiseless, 5 seeds: oracle−learned = 0.0745 ± 0.0934 > 0.05, driven by seed 3 (0.256;
  others ≤ 0.065; σ = 0.1 passes at 0.041). Bounded-completeness form: with n_grid = 600,
  train-frac 0.6, candidate grid 1/240, **no SSE-driven splitter can recover seed 3's missed
  boundary at any budget** — exploratory D+2 run leaves the gap bit-identical (0.25555), because
  the boundary yields zero train-sample SSE reduction (segments constant-on-train). The failure
  is data identifiability near small leaves, not algorithm budget. Transcript:
  `runs/2026-06-11-run4-learnedtree/transcript/`.
- **Gap-as-predictor is dead (run 2).** corr(adv, log Gap) = 0.767 is strictly dominated by
  corr(adv, S) = 0.948, and Gap mis-orders the difficulty (its 17.14 case is EASIER than its
  2.67 case). Any future writeup using Gap as the practical-difficulty axis repeats run 1's
  mistake; use S. (Gap remains correct for what it counts: exact-representation cell count.)

## Fraud-gallery additions (runs 2–5)

- **"The MLP closes the gap" and "the MLP doesn't close the gap" are both misreadable (run 3).**
  The trained head recovers 0.58 → 0.92 R² (most of the gap) AND a 0.08 deficit persists beyond
  seed variance at 40× parameters. Citing either half alone misrepresents the result; the finding
  is the decomposition: uniform's failure = information destroyed (no readout recovers it),
  Fourier's failure = extraction efficiency (shrinks with training, doesn't vanish at this budget).
- **Boundary-recovery ≫ chance ≠ tree recovered (run 4).** 89% recovery coexists with a 0.256 R²
  gap on the same seed — the un-recovered 11% of boundaries can carry the variance. Do not cite
  recovery percentage as success on its own.

## Not yet attempted (open, would change the verdict's reach)

- Natural dataset screened by the F-statistic (Prop 137) — the synthetic-to-real gap (v3 charter,
  human-in-loop dataset selection).
- MLP capacity scaling (h > 32, longer training): does the 0.08 deficit vanish asymptotically?
- Lookahead/Bayesian splitters for the run-4 identifiability tail; denser sampling near small leaves.
- noise sweep beyond σ ∈ {0, 0.1}; capacity-mismatch ablations (D ≠ Σrⱼ).

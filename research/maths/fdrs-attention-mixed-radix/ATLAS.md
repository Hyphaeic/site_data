# Visualization / atlas plan — fdrs-attention-mixed-radix

Deliverable **#6**. An **atlas** here = a generated map of arithmetic structure across the landscape family
(layers × heads × tokens × landscape-levels), in the repo's tradition of generated map artifacts
(`experiments/clock-viability-maps`, `silicon-atlas`). **Plan only — no plotting code yet.**

> **One discipline governs every plot: nothing is drawn without its matched-baseline band.** A bare model curve
> is not a figure; a model curve *over* its `dyadic-only` / `matched-random` / `shuffled` null is. The eye must
> never see a signal without simultaneously seeing the null it must beat (NEGATIVE.md fraud #4, #5).

## Plots (each: x, y, overlay, the RQ it serves)

| Plot | Shows | Baseline overlay | RQ |
|---|---|---|---|
| **factor-participation heatmap** | prime (rows, 2 quarantined) × landscape-level (cols), cell = normalized participation | per-cell null band; cells within band greyed out | RQ1, RQ2 |
| **landscape arithmetic-flow** | participation/valuation-entropy along Q/K/V→score→weight→norm→accum→output | matched-random flow as a shaded ribbon | RQ2, RQ9 |
| **valuation-entropy by layer/head** | grid heatmap, cell = `v_P` entropy | randomized-weights grid (difference map) | RQ1, RQ3 |
| **CF-depth / denominator-complexity histograms** | distribution of CF depth & reduced-`q` bit-length | dyadic-only + matched-random overlaid | RQ8 |
| **digit-address scatter / clustering** | 2-D embedding of mixed-radix coords, colored by token role / head | shuffled-null cloud underneath | RQ6 |
| **row-gauge recurrence** | recurrence of shared `D` (or gauge) across rows/prompts | random-partition recurrence rate | RQ4, RQ5 |
| **carry-completion rate** | events per row vs row entropy | random-partition rate | RQ7 |
| **accumulator drift** | factor/valuation profile of `Sₜ,zₜ` vs `t` | matched-random accumulation track | RQ9 |
| **precision-sensitivity bars** | Δ(metric) across fp64/32/16/bf16/quant per landscape-level | — (this axis *is* the artifact control) | RQ3, RQ10 |
| **baseline-adjusted-signal summary** | the headline: σ-units per metric × landscape-level, one board | zero-line = null; ±2σ guide bands | RQ1–RQ10 |

## CLI / terminal atlas (house style — TUI viewers exist, e.g. hydro-object-sim)

For fast scans without leaving the terminal: ASCII heatmaps (factor-participation grid, baseline-adjusted board)
with `·` (within null), `+`/`#` (1σ/2σ above), `-` (below). Lets a run be eyeballed before opening figures.

## Outputs & generation

- Figures: PNG + SVG under `runs/<date>-rungN-*/transcript/plots/`; an `atlas.md` index per run linking them.
- Generator: `source/atlas.sage` (Sage + matplotlib) reads the engine's metrics JSON (INSTRUMENTATION §6) — never
  recomputes from raw dumps, so figures and `results.md` cite the *same* numbers.
- Every figure caption states: metric, landscape-level, baseline used, seed count, decoration tag, and whether
  the cell cleared the pre-registered margin. A figure without its baseline named is not committed.

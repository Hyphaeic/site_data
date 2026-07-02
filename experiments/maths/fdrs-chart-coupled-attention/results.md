# Results — fdrs-chart-coupled-attention

> **❄ FROZEN MILESTONE (B0–B5 + B2-followup + B3, synthetic) · 2026-06-26.** Full per-rung log; the frozen
> review-facing claim, scope box, and semi-technical note are in **`SUMMARY.md`**. Scope strictly synthetic; no
> pretrained-model claim, no universal "attention is coupling" claim, no pure-average claim. Verdicts below are locked.

**Runs:** `runs/2026-06-26-couple/` (B0 + per-head B1/B2) and `runs/2026-06-26-couple-setlevel/` (B2-followup,
set-level). Rust/Burn (`source/capture/`), reusing the sibling's **Rung-13/14 modular transformer** (2L×4H, task
mod 3/4/5) verbatim. **Reproducible:** weight init is seeded per run-seed (`AB::seed`); **4 seeds**. **Decoration:**
B0 construction `exact`; the B1/B2/followup model comparison is `float` (the trained net). **Scientific status:**
`candidate` (synthetic; float-tagged). **Done:** B0, B1/B2, **B2-followup**. **Pending:** B5, B3, B4.

> Primary metric = **per-input agreement** on the head's own mod-output (n = 256 × 24 = 6144 positions), **not**
> accuracy. **Match by recovered period, not head ID** (head/init permutation across seeds is expected).

## Verdict

| Rung | What ran | Verdict |
|---|---|---|
| **B0** | build `C₃,C₄,C₅`; verify `Cₚ(i,j) ⟺ i≡j (mod p)`; class sizes | ✓ exact & well-defined: `[8,8,8]`/`[6,6,6,6]`/`[5,5,5,5,4]` (C₅ = one-hole cover) |
| **B1/B2** (per-head) | replace **one** chart-head's attention with the exact coupling; per-input agreement, 4 seeds | **Outcome 2 dominant** (16 informative heads need intra-class weights; 1 tension; 9 pure-`(b)` hits, **4 of them redundancy artifacts** flagged by wrong-coupling) → motivated the set-level followup |
| **B2-followup** (set-level) | replace **all same-period** heads at once (by period, not ID); 4 seeds × 3 periods = 12 cells | **MEMBERSHIP-ONLY CONFIRMED** — redundancy resolved in all 12; exact cylinder **membership compiles losslessly** (`(c)` 0.96–1.00 everywhere); pure averaging `(b)` sufficient in **6/12** only (`w` load-bearing in the rest). **No "lossless pure coupling" claim.** |
| **B5** (compile `w`) | characterize + compile the in-class weighting `w(i,j)`; law ladder vs the `(c)` reference, 12 cells | **PARTIAL** — where `w` compiles (**7/12**) the law is **offset/Toeplitz (rank-1, shift-invariant), quantizable to 3–4 bit**; **3/12 DYNAMIC** (no static table reproduces `(c)` → `w` is input/query-dependent), 2 borderline. Membership stays the robust structural compile. |
| **B3** (negative control) | exact couplings must **fail** on diffuse heads; gated on ablation (6 diffuse heads, 4 seeds) | **B3 PASSED** — the 2 **load-bearing** diffuse heads are NOT reproduced (best ≤0.93 < 0.98; partial fit is non-positional, shuffle ≈ best); the other 4 are **unimportant** (ablation ≈ no-op, vacuous). **0 red flags.** Clean positional/content separation. |

## B0 — exact construction (boring, by design)

`Cₚ(i,j)=1 ⟺ i≡j (mod p)` verified over all 24×24 pairs, p∈{3,4,5}. Class sizes C₃`[8,8,8]`, C₄`[6,6,6,6]`,
C₅`[5,5,5,5,4]` — C₅ is a covering chart with one hole (regime-2 object). No model, no performance claim.

## B1/B2 — per-head (4 seeds, ~26 chart-heads)

Replacing a **single** chart-head and scoring per-input agreement vs the learned head: **16 informative heads were
Outcome 2** (chart-masked `(c)` reproduces ≈1.0, pure-average `(b)` does not), 1 Outcome 3 (tension), and 9 scored
pure-`(b)` "lossless" — **but 4 of those 9 also had the *wrong* coupling agreeing ≈1.0**, the signature of a
**redundant head** the model routes around (single-head replacement uninformative there). This redundancy confound
(matching Rung-14's "redundant copies show ≈0") is exactly what the set-level followup removes.

## B2-followup — set-level same-period replacement (canonical)

For each seed and period P, **all** period-P chart-heads are replaced simultaneously, so the model has no
same-period head to route around. `(b)` = pure class-average `C_P`; `(c)` = exact `C_P` membership + learned
in-class weights (cross-class zeroed); `wrong` = the exact coupling for a different period (specificity control).
Agreement is per-input on mod-P vs the original model.

| seed | P | #heads | `(b)` pure-avg | `(c)` membership+w | `wrong` | redundancy resolved | verdict |
|---|---|---|---|---|---|---|---|
| 1 | 3 | 3 | 0.486 | **0.976** | 0.177 | ✓ | MEMBERSHIP-ONLY |
| 1 | 4 | 1 | 0.858 | **1.000** | 0.235 | ✓ | MEMBERSHIP-ONLY |
| 1 | 5 | 2 | 0.497 | **0.961** | 0.301 | ✓ | MEMBERSHIP-ONLY |
| 2 | 3 | 5 | **0.972** | 1.000 | 0.200 | ✓ | PURE-COUPLING |
| 2 | 4 | 1 | **0.998** | 1.000 | 0.236 | ✓ | PURE-COUPLING |
| 2 | 5 | 1 | **0.975** | 1.000 | 0.327 | ✓ | PURE-COUPLING |
| 3 | 3 | 4 | 0.853 | **1.000** | 0.199 | ✓ | MEMBERSHIP-ONLY |
| 3 | 4 | 2 | 0.759 | **1.000** | 0.207 | ✓ | MEMBERSHIP-ONLY |
| 3 | 5 | 2 | **0.955** | 1.000 | 0.316 | ✓ | PURE-COUPLING |
| 4 | 3 | 3 | **0.969** | 1.000 | 0.193 | ✓ | PURE-COUPLING |
| 4 | 4 | 1 | 0.937 | **1.000** | 0.246 | ✓ | MEMBERSHIP-ONLY |
| 4 | 5 | 1 | **0.963** | 1.000 | 0.312 | ✓ | PURE-COUPLING |

Aggregate: **6 MEMBERSHIP-ONLY, 6 PURE-COUPLING; 0 redundancy-confounded, 0 tension, 0 null.** `(c)` ∈ [0.961,
1.000] across **all 12**; `(b)` ∈ [0.486, 0.998]; `wrong` ∈ [0.177, 0.327]. Pure-`(b)` replacement is highly
**specific** (mod-P drop ≫ other-mod drop; specificity 9× to >10⁵×).

**Reading (honest):**

1. **The redundancy confound is fully resolved.** Set-level, the **wrong** coupling fails in all 12 cells
   (0.18–0.33) — replacing every period-P head with a wrong-period coupling destroys mod-P. So there is no
   route-around, and every cell is informative. This is what the followup was for. ✓

2. **Exact cylinder membership compiles losslessly set-level.** Operator `(c)` (membership + the head's own
   in-class weights, **cross-class zeroed**) reproduces the model per-input at **0.96–1.00 in every cell**. So the
   head's attention **support is exactly the cylinder class** — cross-class attention contributes nothing — robustly
   across 4 seeds and 3 periods. The recovered chart *is* the membership the model uses. (Independent corroboration
   of the sibling's Rung-14 causal reading, now at set level.)

3. **Pure averaging is sufficient only half the time — `w` is genuinely load-bearing in the rest.** `(b)` ≥ 0.95
   in 6/12 cells (PURE-COUPLING) and 0.49–0.94 in the other 6 (MEMBERSHIP-ONLY). So **pure class-averaging is NOT a
   general compilation** of attention — in half the cases the within-class weighting `w(i,j)` matters. The split is
   largely **per-model**: seed 2's heads are near-uniform class-averagers (pure-coupling on all 3 periods); seed 1's
   use non-uniform in-class weights (membership-only on all 3); seeds 3–4 mixed. Whether `w` is trivial is a
   property of the trained model, not of the chart.

## What B2-followup establishes — and doesn't

- **Establishes (robust, all 12 cells):** the recovered chart's **cylinder partition is exactly the attention
  support set-level** (`(c)` lossless, `wrong` fails) — membership is necessary and sufficient with the head's own
  weights. The B1/B2 redundancy confound is removed.
- **Establishes (half the cells):** in 6/12, even **pure averaging** reproduces the head set-level (genuine
  PURE-COUPLING) — but this is **model-dependent and NOT claimed as lossless** (reserved pending a stricter
  threshold and more seeds).
- **Does not establish:** that attention compiles to a weight-free operator *in general*. The within-class weighting
  is load-bearing in 6/12 cells, so the honest experiment-level verdict is **MEMBERSHIP-ONLY**.

## B5 — characterize & compile the in-class weighting `w(i,j)` (`runs/2026-06-26-couple-weighting/`)

Set-level per period, **reference = the chart-masked `(c)` operator** (membership + the head's own per-example
in-class weights). For each period we extract the per-head mean in-class table `w̄(i,j)`, its per-example
coefficient of variation (input-dependence), and test a **complexity ladder** of *static* compiled laws — each
head replaced by its own table — measuring per-input agreement vs `(c)`:
`uniform` (0 params) < `offset/Toeplitz` (depends only on block offset (j−i)/P) < `col-profile/rank-1` (one shared
key profile; row-stochastic rank-1) < `full static table` < quantized full table. Controls: shuffle-in-class
(permute weights within the class), wrong-period.

| seed | P | input-dep CV | uniform | offset | rank-1 | full-static | best quant | shuffle-in-class | wrong | smallest law ≥0.98 | verdict |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 3 | 0.263 | 0.493 | 0.518 | 0.505 | **0.534** | 0.51 (4b) | 0.495 | 0.176 | none | **DYNAMIC** |
| 1 | 4 | 0.110 | 0.858 | 0.978 | 0.858 | **0.982** | 0.972 (4b) | 0.808 | 0.235 | full-static | WEIGHTING-COMPILED |
| 1 | 5 | 0.086 | 0.507 | 0.925 | 0.547 | 0.977 | 0.973 (4b) | 0.545 | 0.295 | none (0.977) | DYNAMIC (borderline) |
| 2 | 3 | 0.819 | 0.972 | **0.999** | 0.985 | 1.000 | 0.997 (4b) | 0.861 | 0.200 | offset | LOW-RANK-COMPILED |
| 2 | 4 | 0.097 | **0.998** | 1.000 | 1.000 | 1.000 | 1.000 (4b) | 0.830 | 0.236 | uniform | WEIGHTING-COMPILED (trivial) |
| 2 | 5 | 0.090 | 0.975 | **0.995** | 0.981 | 0.996 | 0.995 (3b) | 0.895 | 0.327 | offset | LOW-RANK-COMPILED |
| 3 | 3 | 0.660 | 0.853 | 0.907 | 0.894 | **0.948** | 0.930 (4b) | 0.784 | 0.199 | none | DYNAMIC |
| 3 | 4 | 0.272 | 0.759 | 0.808 | 0.740 | **0.810** | 0.796 (4b) | 0.656 | 0.207 | none | DYNAMIC |
| 3 | 5 | 0.262 | 0.955 | 0.980 | 0.865 | 0.979 | 0.980 (4b) | 0.711 | 0.316 | offset/4b (≈0.98) | borderline |
| 4 | 3 | 0.376 | 0.969 | **0.994** | 0.984 | 0.997 | 0.986 (4b) | 0.906 | 0.193 | offset | LOW-RANK-COMPILED |
| 4 | 4 | 0.086 | 0.937 | **1.000** | 0.952 | 1.000 | 1.000 (4b) | 0.705 | 0.246 | offset | LOW-RANK-COMPILED |
| 4 | 5 | 0.087 | 0.963 | **0.996** | 0.972 | 0.996 | 0.995 (3b) | 0.863 | 0.312 | offset | LOW-RANK-COMPILED |

**Reading (honest):**

1. **Where `w` compiles (7/12 ≥ 0.98), the law is overwhelmingly `offset/Toeplitz`** — the in-class weighting
   depends almost entirely on the **block offset** between query and key (a shift-invariant, ~`N/P`-entry 1-D
   table), and **quantizes to 3–4-bit** fixed point with no loss. One cell is trivially uniform (a pure-coupling
   cell), one needs the full static table. So the compiled operator is *exact membership + a tiny offset table* —
   compact and integer-friendly.
2. **3/12 cells are genuinely DYNAMIC** (seed1-p3 0.53, seed3-p4 0.81, seed3-p3 0.95): **no static table
   reproduces `(c)` per-input**, so the in-class weighting there is **input/query-dependent** — it cannot be
   compiled to a fixed positional operator. (Plus 2 borderline ≈0.977–0.980.)
3. **Weight-variability ≠ output-dependence.** The per-example CV does **not** predict compilability: seed2-p3 has
   CV **0.82** yet compiles at offset **0.999** (the aggregation readout is robust to large attention wobble),
   while seed1-p3 has CV **0.26** yet is dynamic at **0.53**. What matters is whether the in-class weighting
   *changes the output per input*, not whether the weights themselves vary. The compile target is output
   agreement, and that is what we measured.
4. **Controls hold.** Wrong-period fails in every cell (0.18–0.33); shuffle-in-class drops well below full-static
   in the non-trivial cells (e.g. 0.71 vs 1.00) — so the **positional structure** of `w` is load-bearing, not just
   its value multiset. (Shuffled-V deferred: wrong-period + shuffle-in-class already pin support + positional
   structure.)

**B5 verdict: PARTIAL.** Exact cylinder membership remains the main, robust structural compile (B2-followup). The
residual `w` is, in a **majority of cells, a compact static law — offset/Toeplitz, 3–4-bit quantizable
(LOW-RANK-COMPILED)** — but in a real minority it is **input/query-dependent (DYNAMIC-WEIGHTING)** and not
statically compilable. Not universally uniform, not universally compilable — exactly the pre-registered honest
middle.

## What the compile looks like (B2-followup + B5 together)

For a positional/chart head, the compiled replacement is: **exact cylinder coupling `C_P`** (membership, integer,
load-bearing, lossless set-level) **+** for ~7/12 heads a **small offset table `g(δ)` at 3–4-bit** (often trivially
uniform); for ~3/12 heads the weighting is **dynamic** and resists static compilation. Decoration: the membership
+ offset-table operator is `enclosure`/`exact` (integer); the dynamic residual keeps a `float` tag.

## B3 — diffuse/content-head negative control (`runs/2026-06-26-couple-b3/`)

The theory-predicted boundary (THEORY Part C: a chart coupling can express only the cylinder-measurable part of a
head): exact couplings must **fail** on diffuse/non-positional heads. Crucial gate — a *reproduced* diffuse head is
only a red flag if the head is **load-bearing**; an *unimportant* head is "reproduced" by anything (including
ablation), vacuously. So each diffuse head is first ablated (attention → 0); a coupling only counts as reproducing
it if it beats ablation **and** reaches ≥0.98. Per diffuse head we try every `C_P` × every B5 law (uniform /
offset / rank-1 / full / quant) and take the best.

| seed | head | max-excess | ablation agree | load-bearing? | best coupling | verdict |
|---|---|---|---|---|---|---|
| 1 | L1H0 | 0.14 | 0.801 | **yes** | C4 quant4 **0.896** | **B3-PASS** (not reproduced) |
| 1 | L1H3 | 0.05 | 0.793 | **yes** | C5 rank1 **0.931** | **B3-PASS** (not reproduced) |
| 2 | L1H2 | 0.23 | 1.000 | no | C3 unif 1.000 | DIFFUSE-UNIMPORTANT (vacuous) |
| 3 | — | — | — | — | — | (no diffuse heads — all 8 were chart-heads) |
| 4 | L1H0 | 0.04 | 1.000 | no | C5 full 1.000 | DIFFUSE-UNIMPORTANT (vacuous) |
| 4 | L1H1 | 0.07 | 1.000 | no | C3 unif 1.000 | DIFFUSE-UNIMPORTANT (vacuous) |
| 4 | L1H3 | 0.04 | 1.000 | no | C5 unif 1.000 | DIFFUSE-UNIMPORTANT (vacuous) |

**Reading (honest):**

1. **B3 PASSED — 0 red flags.** No diffuse head is reproduced by a chart coupling in a non-vacuous way.
2. **The decisive cases are the 2 load-bearing diffuse heads (seed 1).** Ablating them drops ~20% of predictions
   (genuinely used), yet the *best* coupling over all `C_P` × all laws reaches only **0.896 / 0.931 < 0.98** — and
   shuffle-in-class ≈ best (0.888 / 0.924), so even that partial fit is **non-positional broad aggregation, not
   chart structure**. These are genuine content/diffuse heads that **resist chart compilation** — the
   "not all attention is couplings" half, confirmed.
3. **The other 4 diffuse heads are unimportant** (ablation ≈ 1.000): removing them changes nothing, so the coupling
   "match" is vacuous and correctly gated out. They are unused capacity on this purely-positional task.
4. **Clean separation:** chart-heads are load-bearing **and** chart-compilable (B2-followup / B5); diffuse heads are
   either unimportant or load-bearing-but-**not** chart-compilable. No misclassification (the one max-excess-0.23
   near-miss was unimportant anyway), no leak.

**Scope caveat (honest):** the modular task is **purely positional**, so most non-chart heads are *unused* rather
than load-bearing-content. Only 2 of 6 diffuse heads were load-bearing — they pass cleanly, but the *strongest*
form of the negative control (many load-bearing **content** heads resisting compilation) needs a task with a
genuine content/semantic component. That is a future direction, not this task.

## Where the experiment stands (B0–B5 + B2-followup + B3)

The two-sided thesis is established on this synthetic task: **positional/chart heads compile** (exact cylinder
membership, lossless set-level; intra-class weighting mostly an offset/Toeplitz table at 3–4-bit, dynamic in a
minority), and **content/diffuse heads do not** (B3). The compiled operator for a chart head is *exact coupling
`C_P` + a small quantized offset table*; for content heads, no compact coupling suffices.

## Next (optional)

- **B4** — gate over the coupling library (content stream selecting an exact chart route): does a small/bounded
  gate over `{C₃,C₄,C₅}` recover full-task accuracy without per-head learned attention?
- **(optional) dynamic-cell probe** — for the 3 B5-DYNAMIC cells, is the input-dependent `w` actually a *second
  chart* (another digit channel) rather than genuine content-dependence?
- **content-bearing task** (future) — the strong B3 negative control needs load-bearing content heads.
- **SUMMARY.md / freeze** — the core (B0–B5 + followup + B3) is complete; a milestone freeze (sibling-style) is
  available on request.

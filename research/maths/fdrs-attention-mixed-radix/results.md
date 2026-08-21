# Results — fdrs-attention-mixed-radix

> **❄ FROZEN MILESTONE (Rungs 0–14, synthetic) · 2026-06-26.** This is the full per-rung log; the frozen
> review-facing statement, scope box, and semi-technical note are in **`SUMMARY.md`**. Scope is strictly
> synthetic — no real/pretrained-model claim (Rung 15, separate future direction). Verdicts below are locked.

**Runs:** `runs/2026-06-26-burn/` (**canonical** — Rust/Burn, the house substrate) + `runs/2026-06-26-exploration/`
(numpy substrate cross-check). **Tag:** `float` (model substrate; lenses exact). Capture = Burn
(`source/capture/`, reusing `fdrs-adaptive-train`'s Model/task); numpy (`source/capture.py`) retained as a
substrate-independence check; spectroscopy = Sage exact lenses (`source/lenses.sage` via `source/analyze.sage`).
Every model-level number is `float`-tagged, reported **baseline-adjusted**; the floor [1] is the only EPS-free,
exact statement. **Both substrates converge on the same null *for the value-arithmetic lens* — but see Rung 7:
the position-sensitive mixed-radix lens (radix selection, exp73) finds clean interpretable structure the value
lens was blind to, and Rungs 8/8b confirm that lens *tracks the task's block factorization* across block sizes and
seeds — cleanly once the delta loophole is closed (Rung 8b: 4/4 sizes × 3 seeds, order-2≈0, oracle-bracketed); and
Rung 9 shows it *discovers* hidden factorizations blind — right hierarchy granularity + coordinate-chart
sensitivity; Rung 10: different heads carry different gauges (per-head recovery); Rung 11: it generalizes beyond
saturated factors — covering gauges (B≥N) discover non-factor (period-5) structure under a penalized RadixScore
while staying disciplined; Rung 12: a constrained chart search recovers the *embedding* itself (stride charts),
not just the gauge, with no gauge-fishing; Rung 13 (first real-ish transformer): the per-head battery recovers the
latent charts as set-level candidate hypotheses while rejecting diffuse heads (head-permutation makes per-head-ID
unstable); Rung 14: chart-aligned interventions (ablation + residue-class masking) causally and specifically
degrade the matching output (specificity up to 193×) — the charts are **causal, not just descriptive**. All on
synthetic/controlled tasks; charts are head-wise hypotheses (set-level, causal-for-this-task); the
value-arithmetic null is frozen.**

> **Pre-registration note:** the user directed execution ahead of the formal G0/G1 commit and is handling the
> registry. These run records are kept registry-ready (manifest + transcript + this writeup). Findings are
> reported conservatively; the headline outcome is a **first-class null**, exactly as pre-registered.

## Verdict table

| Rung | What ran | Verdict |
|---|---|---|
| 0 — tiny exact | `stage0_demo.sage` (earlier) | objects/lenses well-defined; exact/approximant boundary clean |
| 1 — baselines | matched-random dot/linear, uniform reals, **entropy-matched** random, dyadic floor | null distributions built; **representational floor confirmed exactly** |
| 2 — small model | **Burn** 1-head attention on the house retrieval task, acc **0.315** (chance 0.125) — realistic, non-degenerate (canonical); numpy toy (100%, near-one-hot) = cross-check | trained ✓ |
| 4 — row-gauge | joint reconstruction, fixed gauge `[8,9,5,7,11]`, digit/carry/complementarity | **NULL** — realistic model vs entropy-matched random: all per-scalar/digit \|z\|<1; numpy toy's big signal was sharpness (NEG-2) |
| 5b — **dynamics + decisive control** | checkpoint same probe rows over training; entropy-matched THEN full-shape-matched control | a transient post-coalescence deviation the endpoints missed — **the shape-matched control collapses it 83–85%** ⇒ it is the **shape of focusing attention, not arithmetic**. Faint noisy `n_compl` residual only |
| 7 — **radix-order / digit-channel** | row as signal over POSITIONS; mixed-radix Haar; **vary radix ordering** (exp73) | **POSITIVE (positional)**: under block-aligned `[3,8]` the trained attention compacts to n90≈3, order-2≈0.002 (separable), 99.5% in the within-block (role) digit — absent in shuffle/random. The value lens (Rungs 0–5) was blind to this |
| 8 — **block-size tracking** | train under B∈{2,3,4,6}; does the best radix ordering track `[B,n_blocks]`? | **tracking CONFIRMED 4/4** — best block-grouping = the aligned ordering for every B (heatmap diagonal). Clean for B=3; delta-like/partial for B=2/4/6. *Radix selection recovers the changed factorization* |
| 8b — **aggregation (anti-delta)** | force block-distributed attention (sum the marked block); 3 seeds | **CONFIRMED 4/4 sizes × 3/3 seeds** — aligned ordering *globally* best, order-2≈0, block-digit≈100%, oracle-bracketed (block-uniform→aligned, delta→flat), anti-delta ablations crash. *Clean recovery of distributed positional factorization* |
| 9 — **latent discovery (blind)** | blind sweep (2/3/4-factor); hierarchical + interleaved *hidden* factorizations | **DISCOVERY CONFIRMED** — blind sweep recovers the latent factorization at the right granularity (`[4,6]` 2-level task, `[4,3,2]` 3-level oracle, `[3,8]` wrong-oracle; unbiased); interleave: transpose recovered raw (`[6,4]`), random recovered only under the correct chart. Synthetic; no LM claim |
| 10 — **per-head (multi-head)** | 3 heads, 3 planted gauges (bs 2/3/4); blind per-head sweep | **CONFIRMED 3/3 heads** — each head's best gauge = its own planted (`[2,12]`/`[3,8]`/`[4,6]`; heatmap diagonal). *Different heads carry different positional gauges* |
| 11 — **unsaturated cover search** | covering gauges B≥N + masked Haar + **penalized RadixScore**; non-factor (period-5) vs factor task | **CONFIRMED** — `[5,5]` cover discovers period-5 (beats every factor of 24, ~2× n90, *after* rent); saturated `[4,6]` wins the factor task (covers penalized away). Regime-2 lens works *with discipline* |
| 12 — **regime-3 chart search** | constrained charts (stride × ordering + covers); penalized RadixScore (+C_ι, +C_M) | **CONFIRMED** — recovers planted stride charts (s=7→`[4,6]`, s=11→`[3,8]`; beat row-major ~2–3×) and stays simple for the cover (C) + negative control (D). Recovers the *embedding*, not just the gauge; no gauge-fishing |
| 13 — **head-wise hypotheses (real-ish transformer)** | 2L×4H transformer on a modular task (periods hidden); per-head battery + controls | **PROMISING (set-level)** — candidate charts across heads = `{[3,8],[4,6],[5,5]}` = the latent mod-3/4/5 periods (concentrated in layer 0); 7/8 diffuse heads rejected; per-head-ID unstable (head permutation). Charts = hypotheses, not ground truth |
| 14 — **causal validation (ablation/masking)** | ablate / chart-mask chart-heads; per-mod specificity; matched by chart not head ID; 2 seeds | **CAUSAL CONFIRMED** — ablating a period-P chart-head drops mod-P specifically (specificity up to **193×**); destroying its residue-class structure crushes mod-P (1.0→0.2–0.3) while preserve retains and wrong-period/diffuse/full-ablation controls behave as expected. **Charts are causal, not just descriptive** |
| — methodology | two false-structure traps caught live | see NEG-1, NEG-2 |

## Canonical result — Burn substrate, realistically-trained model (`runs/2026-06-26-burn/`)

The house-substrate run is the one to read. A single-head attention model trained **in Burn** on the sibling's
content-matched retrieval task reaches **acc 0.315** (chance 0.125; randomized 0.149) — a *realistic,
non-degenerate* attention pattern (mean row-entropy 3.29 bits, **not** collapsed to one-hot), consistent with
the sibling's dense=0.319 on this task. On this model the arithmetic lenses show **no structure beyond the
entropy-matched baseline**:

| metric (model_trained vs entropy-matched `random_sharp`) | z (baseline-σ) | reading |
|---|---|---|
| approx denominator bits | −0.15 | null |
| approx distinct odd primes | −0.01 | null |
| continued-fraction depth | −0.29 | null |
| digit-address entropy | −0.95 | null |
| n_complementarities | +0.76 | null |
| D_eff (row lcm) bits / odd primes | −2.1 / −2.3 | EPS-sensitive lcm artifact; model **lower** than random (wrong sign for "structure") |

Every per-scalar and digit metric is **|z| < 1**; only the EPS-sensitive `D_eff` lcm metric is borderline, and
in the *wrong direction* for a structure claim. **No model-induced arithmetic / mixed-radix structure beyond the
representational + magnitude floor** — on a realistically-trained model, on the house substrate. The dramatic
numpy signals in [2] below were an artifact of an over-trained *toy* collapsing to near-one-hot attention; they
**vanish** on a realistic model. (`confound_atlas.png` in the run dir.)

## Rung 5b — training dynamics: a transient the endpoints miss (`runs/2026-06-26-dynamics/`)

Static snapshots discard the trajectory. Checkpointing the **same 96 probe rows** through training (Burn, 14
log-spaced steps) and comparing each step to a control matched to **that step's** mean entropy:

- **Coalescence is clean:** row entropy holds ~4.2 bits through step ~40, then drops to ~3.0 around steps 70–110
  as loss falls and accuracy climbs (attention focusing).
- **Pre-coalescence and at the endpoint**, the arithmetic trajectory ≈ the entropy-matched control (residual ≈ 0)
  — pure sharpness schedule, consistent with the static null.
- **A transient deviation emerges post-coalescence** (steps ~170–600): the model's digit-address entropy runs
  **below** the matched control (residual peak **−0.29 bits** at step ~400) and complementarity events run
  **above** it (residual peak **+1.55** at step 260), beyond what mean-sharpness predicts. It **partially decays**
  by step 1200 (digit-entropy residual −0.16) — which is exactly why a fixed-endpoint snapshot underweights it.

**This partially vindicates the dynamics framing:** there is structure in *when/how* attention coalesces that the
endpoint analysis misses. **But discipline keeps it at "candidate," not "signal":**
- The **factor-participation residual** (distinct odd primes per row) stays **≈ 0 throughout** (mean +0.009) — the
  deviation is in *entropy / complementarity* (shape-sensitive) metrics, **not prime / mixed-radix structure**.
- The `D_eff` offset (≈ −35 bits) is present **at step 0** (random init) — a *static* row-shape difference between
  model softmax rows and tempered-random rows, not a dynamical effect (discount it).
- **Single seed**, and the control matches **mean** entropy, not the full **row-shape distribution**. The leading
  explanation for the transient is a **row-shape confound** (mid-training row shapes differ from tempered-random
  at equal mean entropy), not arithmetic structure.

**Verdict:** a real, transient, *dynamical* deviation from the sharpness schedule exists post-coalescence — the
dynamics carry information the endpoint doesn't — but it shows **no prime/factor signal**, is most consistent with
row-shape, and is unreplicated. Pre-registered next controls: **(1) ≥5 seeds** (is the transient seed-consistent
and aligned to the coalescence step?); **(2) a full-row-shape-matched control** (match the *sorted* probability
profile, not just mean entropy — does the residual survive?); **(3) per-prime decomposition** along the trajectory
(does any specific prime move beyond baseline, or is it purely shape?). Plot: `dynamics_atlas.png`.

**Resolution — shape-matched control (run, decisive; `source/analyze_shapematch.sage`).** Matching the model's
**full per-rank value distribution** (not just mean entropy) **collapses the transient.** In the post-coalescence
window (steps 170–600), mean |residual| drops sharply: digit-entropy **0.213 → 0.036** (−83%), denominator bits
**0.244 → 0.036** (−85%), distinct odd primes **0.065 → 0.017**. The digit-entropy residual that dove to −0.29
under entropy-matching stays at ≈ −0.04 under shape-matching (`shapematch_atlas.png`; sanity: shape-matched
row-entropy tracks the model to 0.003 bits). **So the transient is the SHAPE of focusing attention, not arithmetic
geometry** — no factor/digit signal survives full-shape matching. The only thread that *partially* survives is
`n_complementarities` (0.94 → 0.35, −63%), a within-row *joint* property — but its shape-matched residual is
**noisy and sign-flips** across steps (+0.68 at 260, −0.31 at 600), consistent with gauge/rounding noise, not a
credible partition signal. (`D_eff` matches *no* control — an lcm extreme statistic dominated by tail noise;
discounted throughout.) **Net: the dynamics revealed a transient the endpoint missed — and the decisive control
shows it is coalescence shape, closing the candidate.** A seed sweep + gauge-robustness check on the faint
`n_compl` thread is the only loose end, with a strong prior it too is shape/noise.

## Rung 7 — radix-order / digit-channel spectroscopy: the lens that was missing (`runs/2026-06-26-burn/`)

Rungs 0–5 analyzed the **arithmetic of the probability VALUES** (prime factors / valuations / CF of each number)
under **one canonical gauge** — and were all permutation-invariant, hence blind to *where* attention mass sits.
Porting the FDRS **exp73 family** (`…/Sage/fdrs_exp73*`: digit-channel separation, interaction-order spectrum,
radix selection) gives the position-sensitive lens: treat each row as a **signal over the key-position index**,
decompose it in the **mixed-radix Haar/contrast basis**, and **vary the radix ordering**. seq = 24 = 8 blocks ×
3 tokens, so position = 3·block + role; the **block-aligned** radix is `[3,8]` (d0 = within-block role, d1 = block).

**Under the block-aligned ordering — and only that family — the trained attention has sharp structure that
vanishes in every control:**

| under `[3,8]` | model_trained | model_shuffled (pos destroyed) | random_dot | model_randomized |
|---|---|---|---|---|
| n90 (coeffs for 90% energy) | **3.0** | 10.4 | 7.8 | 2.9 (uniform) |
| interaction order-1 energy | **0.636** | 0.245 | 0.206 | 0.107 |
| interaction order-2 energy | **0.002** | 0.393 | 0.314 | 0.070 |
| within-block (role) digit, pure | **0.995** | 0.080 | 0.084 | 0.360 |
| block digit, pure | 0.001 | 0.305 | 0.314 | 0.212 |

- **Radix selection is decisive (exp73f):** the trained model compacts to **n90 ≈ 3 under `[3,8]`** but needs
  **11–16 under `[8,3]` / `[2,12]` / `[24]`-flat** — the structure is visible *only* in the block-aligned ordering.
  Shuffled rows show **no** compaction under any ordering (n90 ≈ 10–14); random rows prefer the flat `[24]` basis.
- **Additive separability:** the trained attention is ~64% order-1 with **order-2 ≈ 0.002** — it factorizes into
  independent digit channels with essentially **no cross-digit interaction**. Every control has 7–40% order-2.
  Training *drove* the attention separable in the block-aligned basis.
- **It localizes to the within-block (role) digit:** 99.5% of order-1 energy is in d0 (role: my_tag/query_tag/
  value), ≈0 in the block digit. The model learned **role-based, block-separable attention** — attends by
  within-block role, approximately block-invariant (consistent with its partial 31.5%-acc "attend to value-role
  tokens" solution). The mixed-radix lens recovered exactly that geometry.

**This is the structure the value-arithmetic lenses could not see** — they were permutation-invariant; this lens
is position-sensitive, and the **shuffle control** (same values, positions destroyed → n90 ≈ 10, order-2 = 0.39)
proves the structure is genuinely **positional**, not a value-magnitude artifact.

**Discipline — what this is and isn't:**
- It is **positional mixed-radix (MRA) structure of the attention *pattern*** (the FDRS Haar/cylinder
  decomposition over positions) — **not** arithmetic structure in the scalar values (that stays null, Rungs 0–5).
  Two different senses of "mixed-radix"; this is the one **exp73 pioneered and that I had omitted**.
- The task has block×role structure **by construction** (3-token blocks), so finding block×role geometry is partly
  "out = in." The genuine results: (a) the **radix-selection method cleanly recovers** it while the value lens saw
  nothing; (b) **radix ordering is decisive** (n90 3 vs 16); (c) **training drives separability** (order-2 →
  0.002), which is not built in. On a non-block task / real LM this lens could discover *unknown* factorizations.
- `model_randomized` also has low n90 — but because it is nearly **uniform** (order-0 = 0.82, mean-dominated), not
  from learned structure (order-1 only 0.11, spread across digits). The *trained* model is distinguished by **high
  order-1 (0.64) concentrated in the role digit (0.995) with ≈0 interaction**.
- Single seed, one model/task. Plot: `radixorder_atlas.png`.

**Reframe of the project conclusion.** "Is there mixed-radix structure in attention?" — the **VALUES** are not
(null under factor/valuation/CF, statically and dynamically, both substrates); but the attention **PATTERN over
positions** is **cleanly described by a mixed-radix Haar basis under the task-aligned radix ordering**, separable
into digit channels, with **radix *selection* the essential tool** (exp73). Rungs 0–5 looked through the wrong lens.

## Rung 8 — block-size tracking: does radix selection follow the task factorization? (`runs/2026-06-26-blocksize/`)

Rung 7's block×role geometry was fixed (3-token blocks), so it could be "out = in." Rung 8 is the falsifiable
follow-up: **train the same attention setup under four block geometries (all seq = 24) and test whether the best
radix ordering *tracks* the changed block size.** Task: "find the marked block, read its payload" (a clean
single-query attention, block-structured for any B); 4 models, all trained to 100% acc. Then sweep radix orderings
(exp73) and ask which compacts each model.

| trained block size | expected `[B, n_blocks]` | best block-grouping ordering (n90) | tracks? |
|---|---|---|---|
| B=2 (12 blocks) | `[2,12]` | **`[2,12]`** (6.2) | ✓ |
| B=3 (8 blocks) | `[3,8]` | **`[3,8]`** (3.5) | ✓ |
| B=4 (6 blocks) | `[4,6]` | **`[4,6]`** (7.1) | ✓ |
| B=6 (4 blocks) | `[6,4]` | **`[6,4]`** (5.1) | ✓ |

**PRIMARY criterion — CONFIRMED 4/4:** among the four block-grouping orderings, the one matching the model's
block size is always the most compact — the heatmap diagonal is lowest in every row (`blocksize_tracking.png`).
**Radix selection recovers the changed positional factorization automatically.** All four pass the **uniform
diagnostic** (uniform rows have n90 ≈ 1 but order-1 ≈ 0 — confirming low-n90-alone is insufficient and is
screened out by the order-1 requirement).

**Secondary cleanliness — varies (reported honestly):** only **B=3** is fully clean (n90 3.5 vs shuffle 10.3;
order-2 0.036; block digit 0.994; `[3,8]` is also the *global* best). For **B=2, 4, 6** the aligned ordering still
wins among block-groupings, but the structure is weaker — order-2 (interaction) energy is high (0.32–0.42), the
shuffle control is only mildly worse, and the *global* best for B=2/B=4 is the flat `[24]` basis. **Diagnosis:**
with every token of the marked block distinguishable, the model can solve the task **delta-style** (attend to ~one
marked token) rather than block-uniform; B=3 happened to learn a block-distributed pattern, the others more
delta-like. The lens **honestly reports the actual structure** (block-distributed vs delta), not a forced answer.

**Verdict: PARTIALLY CONFIRMED** — the **primary tracking criterion holds across the full sweep (4/4)**; clean
separable block-structure is established for B=3 and weaker (delta-like) for B=2/4/6. The thesis stands at the
block-grouping level: **FDRS radix selection recovers the learned positional factorization in attention patterns
— it tracks when the block size changes — even though scalar value arithmetic stays null.**

**Scope / not overclaimed:** the task geometry is synthetic and known by construction; this confirms the *lens*
recovers the changed factorization, not a discovery of unknown structure. Cleanest strengthening (next, not run):
a task that *forces* block-distributed attention (payload = an aggregate over the block), which should remove the
delta-like weakness and clean up B=2/4/6, plus ≥3 seeds per geometry. Plot: `blocksize_tracking.png`.

## Rung 8b — aggregation task: does radix selection recover *distributed* block factorization? (`runs/2026-06-26-agg/`)

Rung 8 left a loophole — the marked-block task could be solved **delta-style** (attend to one token), so the
aligned ordering won only weakly for B=2/4/6. Rung 8b removes it: the target is the **SUM of the marked block's B
bits**, so a single token gives one bit and **cannot** determine the answer — the model must attend across the
whole block. 4 block sizes × **3 seeds** (12 models).

**Anti-delta checks — loophole closed:** max attention weight ≈ **1/B** (0.43/0.33/0.25/0.17) and
**block-uniformity ≈ 1.0** → attention is block-*uniform*, not a delta; **mask-all-but-one crashes accuracy** to
≈ the single-token-oracle ceiling (B=6: 1.0→0.10; B=4: →0.16; B=3: →0.32) → the model genuinely needs all B tokens.

**Tracking — CONFIRMED 4/4 sizes, 3/3 seeds each (12/12 models):** the aligned ordering `[B,n_blocks]` is the most
compact for every model/seed (`agg_tracking.png`, crisp diagonal) — and now **globally** best (beats flat `[24]`),
unlike Rung 8.

| B | expected | best (×3 seeds) | n90 aligned / shuffle / flat | order-1 / order-2 | block-digit energy | mask-all-but-one (acc) |
|---|---|---|---|---|---|---|
| 2 | `[2,12]` | `[2,12]` ✓×3 | 4.9 / 7.5 / 5.2 | 0.76 / 0.13 | 0.95 | 0.51 (acc 0.92*) |
| 3 | `[3,8]` | `[3,8]` ✓×3 | 3.3 / 10.4 / 6.8 | 0.84 / 0.01 | 0.998 | 0.32 (acc 1.0) |
| 4 | `[4,6]` | `[4,6]` ✓×3 | 2.9 / 10.5 / 8.4 | 0.83 / 0.00 | 1.000 | 0.16 (acc 1.0) |
| 6 | `[6,4]` | `[6,4]` ✓×3 | 2.5 / 10.6 / 10.4 | 0.75 / 0.00 | 1.000 | 0.10 (acc 1.0) |

*(B=2: one of three seeds failed to train (acc 0.77, not block-uniform), dragging its mean; the other two are
clean (acc 1.0, uniformity 1.0). Tracking still holds 3/3.)*

**Clean separable structure** (vs Rung 8's delta-muddied 0.3–0.4 interaction): **order-2 ≈ 0** for B=3/4/6
(0.01/0.00/0.00) — additively separable; **digit energy ≈ 100% in the BLOCK digit (d1)**, ~0 in the role digit.
**Channel interpretation (as requested):** this is the *opposite* digit from Rung 7 (role-digit), and correctly
so — Rung 7's task was role-selection (attend to a role across blocks); this is block-aggregation (attend to a
whole block), so the structure is **block-selection with within-block uniformity**. The lens reports each task's
actual geometry, not a fixed answer.

**Oracle brackets (decisive):** the **block-uniform oracle** (ideal distributed) is most compact under the
**aligned** ordering for every B and seed; the **delta oracle** (ideal single token) is most compact under the
**flat `[24]`** for every B. The trained models sit with the block-uniform oracle ⇒ block-distributed, not delta.

**Controls:** shuffle destroys compaction (trained 2.5–4.9 vs shuffle 7.5–10.6); the **uniform diagnostic** has
n90 ≈ 1 but **order-1 = 0.000** (low-n90-alone is screened out — trained is separated by *structured* order-1
energy, not mere compaction); randomized models are diffuse.

**Verdict: CONFIRMED.** (Automated strict rule: 4/4 tracking, 3/4 "full" — the sole shortfall is B=2, limited by
one under-trained seed, not a lens failure.) With the delta loophole closed and the full control battery, radix
selection recovers the learned positional factorization across block sizes and seeds.

**Valid claim (as stated, not exceeded):** *on synthetic tasks with controlled block factorization, FDRS radix
selection recovers the learned positional factorization of attention patterns across block sizes — including when
the target requires distributed block evidence.* **No general-LM discovery is claimed** (geometry synthetic and
known by construction); the **value-arithmetic null (Rungs 0–5) is unchanged.** Plot: `agg_tracking.png`.

## Rung 9 — latent-factorization discovery: can radix selection recover *hidden* positional structure? (`runs/2026-06-26-latent/`)

Rungs 8/8b told the analysis the expected ordering and checked tracking. Rung 9 runs the sweep **blind** — it
reports the best decomposition over a constrained set of 2-/3-/4-factor orderings of 24 *without being told the
construction* — and asks whether it **recovers** the latent factorization.

**Family 1 — hierarchical (24 = 2×3×4), blind:** re-analyzing the Rung-8b B=4 rows (a 2×3×4 cell task) with the
ordering set expanded to 3- and 4-factor orderings:
- **Trained model:** blind best = **`[4,6]`** (all 3 seeds, n90 2.86); top-3 `[4,6]` < `[4,3,2]` < `[2,2,3,2]`.
  The sweep recovers the **role(4) coordinate** and groups the rest into 6 — the *coarsest valid reblocking* of
  the 2×3×4 hierarchy. It does **not** over-refine to `[4,3,2]` (correct — a single marked cell is genuinely
  2-factor). Under `[4,6]`: order-2 = 0.000 (separable), shuffle n90 10.4 (destroyed), uniform order-1 = 0.000.
- **3-level-additive oracle** (constructed genuine 3-level structure, attention ∝ softmax(a[role]+b[block]+c[super])):
  blind best = **`[4,3,2]`** — when 3-level structure *is* present, the blind sweep recovers the full **3-factor**
  ordering. The lens finds the right *granularity*: 2-level when that's all there is, 3-level when there is more.
- **Wrong-factorization oracle** (a `[3,8]`-block): blind best = **`[3,8]`** — the lens is **not biased toward
  `[4,*]`**; it reports the actual grouping. **Family 1: DISCOVERY CONFIRMED.**

**Family 2 — interleaved (hidden coordinate chart):** train the marked-block aggregation but **place tokens at
permuted physical positions**; sweep in raw physical order vs an oracle-unpermuted (logical) order:
- **Transpose** (physical = role-major; a clean factor transposition): **raw-order sweep recovers it** — best =
  `[6,4]` (n90 2.85, all seeds); oracle-unpermute gives `[4,6]`. *Stronger than expected, and explained:* the
  radix-**ordering** sweep already enumerates factor transpositions, so a clean interleaving is just a different
  best ordering, found in raw order.
- **Random permutation** (no factorization aligns): **raw order FAILS** — the only compacting basis is the flat
  `[24]` (n90 ≈ 8.4); **oracle-unpermute SUCCEEDS** — logical order gives `[4,6]` (n90 2.85). The lens is
  **coordinate-chart sensitive**: an arbitrary permutation hides the structure in raw index, recoverable only
  under the correct chart. **Family 2: CONFIRMED.**

**Verdict: DISCOVERY CONFIRMED.** Blind, the lens recovers the latent coordinate structure — the right hierarchy
granularity (Family 1: `[4,6]` for the 2-level task, `[4,3,2]` for genuine 3-level, `[3,8]` for a wrong grouping,
all unbiased) and the right chart for clean interleavings (Family 2 transpose), and it correctly *fails* in raw
order for an arbitrary permutation while succeeding under the correct chart (Family 2 random).

**Scope / not overclaimed:** (1) still synthetic, factorization known by construction — **no general-LM claim**.
(2) The genuine **3-level** recovery is shown on a *constructed oracle*; the trained cell task is 2-level (and was
recovered correctly as `[4,6]`) — a trained 3-level task is the next step. (3) Family-2 "random" *supplies* the
inverse permutation as the oracle chart; the lens does **not** blindly search the 24! permutations — it confirms
chart-sensitivity, not arbitrary-permutation discovery. **Rung 8b verdict and the value-arithmetic null
(Rungs 0–5) are unchanged.**

**Valid claim:** *on synthetic tasks where the positional factorization is hidden from the analysis, FDRS radix
selection can recover the learned latent coordinate structure of attention patterns under controls.*

## Rung 10 — per-head radix selection: do different heads carry different positional gauges? (`runs/2026-06-26-multihead/`)

A 3-head model (shared K/V, per-head learned query), each head assigned a different block geometry via its own
sub-task (head0: block-2, head1: block-3, head2: block-4; label = sum the head's marked block). 3 seeds; heads
~100% acc. Blind per-head radix sweep:

| head | planted | best among planted gauges (3 seeds) | n90 aligned / shuffle | order-2 | block-digit |
|---|---|---|---|---|---|
| 0 | `[2,12]` | `[2,12]` ✓×3 | 3.8 / 6.9 | 0.066 | 0.993 |
| 1 | `[3,8]` | `[3,8]` ✓×3 | 3.1 / 10.4 | 0.008 | 0.999 |
| 2 | `[4,6]` | `[4,6]` ✓×2 (1 under-trained seed) | 4.6 / 9.1 | 0.115 | 0.963 |

**VERDICT: CONFIRMED (3/3 heads).** The 3×3 heatmap diagonal is lowest in every row (`multihead_heatmap.png`):
**each head's attention is most compact under its OWN planted gauge** — per-head radix selection recovers per-head
positional structure. Controls clean (shuffle destroys; uniform order-1 = 0). Synthetic/planted; no LM claim.

## Rung 11 — unsaturated cover search: do covering gauges discover non-factor structure (with discipline)? (`runs/2026-06-26-cover/`)

Rungs 7–10 used only **regime 1** (saturated, N = ∏bᵢ). Rung 11 opens **regime 2**: covering gauges with
B = ∏bᵢ ≥ N — embed the 24 positions into a larger volume (row-major ι, holes = 0) under a **masked mixed-radix
Haar**, scored by a **penalized RadixScore = n90 + 10·(B−N)/B + 0.5·(L−1)** so a cover must *earn* its win (pay
rent for slack volume + extra axes). Two datasets:

**Non-factor task (period 5).** Latent period 5 does **not** divide 24 = 2³·3 — no factorization of 24 can
express it, but a `[5,5]` cover (B=25, one hole) can:

| gauge | B | n90 | RadixScore |
|---|---|---|---|
| **`[5,5]`** (cover) | 25 | **4.01** | **4.91** ← best |
| `[4,6]` (best factor of 24) | 24 | 7.84 | 8.34 |
| `[3,8]` | 24 | 10.61 | 11.11 |
| `[2,12]` | 24 | 12.35 | 12.85 |

The `[5,5]` cover **beats every saturated factor of 24 by ~2×** on raw n90 (4.01 vs best-factor 7.84) and **still
wins after the penalty** (4.91 vs 8.34). Shuffle destroys it (n90 10.8); uniform order-1 = 0.013. **Covers
DISCOVER non-factor structure.**

**Factor task (block-of-4, control).** Here a factor of 24 suffices:

| gauge | B | n90 | RadixScore |
|---|---|---|---|
| **`[4,6]`** (saturated) | 24 | **2.86** | **3.36** ← best |
| `[4,7]` (cover) | 28 | 3.02 | 4.95 |
| `[5,5]` (cover) | 25 | 8.29 | 9.19 |

Saturated `[4,6]` wins on raw n90 and RadixScore; every cover is penalized away. **Covers do NOT fake structure
when a factor exists** — the rent discipline prevents gauge-fishing.

**VERDICT: CONFIRMED.** Covering gauges (regime 2) **discover non-factor structure** (`[5,5]` for period-5,
invisible to any factorization of 24) **yet are correctly penalized away when a saturated factor suffices**
(`[4,6]` for block-of-4). Penalized RadixScore + shuffle/uniform controls keep the larger search honest.
Plot: `cover_search.png`.

**Scope:** synthetic, planted period — **no general-LM claim**. This validates the *cover-regime lens + its
discipline*. **Regime 3** (arbitrary learned embeddings ι / occupancy masks) is only partially probed (Rung 9
Family-2 chart-sensitivity); a full learned-chart search is the open frontier. Earlier verdicts (Rungs 7–10) and
the value-arithmetic null (Rungs 0–5) are unchanged.

## Rung 12 — regime-3 constrained chart search: recover the embedding (b, ι), not just the ordering? (`runs/2026-06-26-chart/`)

Generalize from "which ordering/cover?" to "which constrained CHART (b, ι)?" — place row[n] at cell ι(n) in the
B-volume, masked Haar, penalized **RadixScore = n90 + 10·(B−N)/B + 0.5·(L−1) + 1.0·C_ι + 0.5·C_M**. The chart
family is **constrained** (no 24! search): stride charts `ι(n) = s·n mod B`, `s ∈ {1,5,7,11,13}` × orderings, plus
row-major covers. Strides 7/11 are coprime to 24 and *not* aligned to any cover residue, so the planted structure
is genuinely scrambled in raw index (s=7 block-0 = {0,7,14,21}: no residue class of 24, no mod-5 cover class).

| task (planted) | best chart (penalized) | n90 | best ROW-MAJOR (s=1) n90 | recovered? |
|---|---|---|---|---|
| A: stride-7, cb4 | **s=7, `[4,6]`** | 2.86 | 8.42 | ✓ (stride recovered; beats row-major ~3×) |
| B: stride-11, cb3 | **s=11, `[3,8]`** | 3.15 | 6.51 | ✓ |
| C: period-5 cover | **s=1, `[5,5]`** (row-major cover) | 4.01 | 7.84 | ✓ (no spurious stride) |
| D: block-of-4 (control) | **s=1, `[4,6]`** (row-major saturated) | 2.86 | 2.86 | ✓ (no invented chart) |

**VERDICT: CONFIRMED.** The constrained chart search **recovers the planted embedding** (stride-7 / stride-11)
that no row-major ordering or cover can express — *and* it correctly **stays simple** when simplicity suffices: the
period-5 structure stays a row-major `[5,5]` cover (C), and the negative control stays row-major saturated `[4,6]`
(D). **No gauge-fishing** — the `C_ι` rent makes a stride pay for itself; shuffle destroys every winner (n90 ~10.6);
each task's RadixScore dips at exactly its planted chart (`chart_search.png`). 3 seeds each.

**Scope:** synthetic, planted charts from a small constrained family — **not** arbitrary-chart discovery (the 24!
permutation search is explicitly excluded), **not** a general-LM claim. The value-arithmetic null (Rungs 0–5) and
all earlier verdicts are unchanged.

**Valid claim:** *on synthetic tasks with constrained hidden positional charts, FDRS positional MRA + penalized
chart search recovers not only the radix gauge but also the embedding/chart family under controls, while the
negative control keeps the simpler row-major saturated chart.*

## Rung 13 — candidate head-wise chart hypotheses in a small transformer (`runs/2026-06-26-transformer/`)

First application to a **real-ish model**: a 2-layer × 4-head transformer (MHA + MLP + LayerNorm + residual +
learned token/position embeddings), trained (100% acc, 2 seeds) on a **modular-relation task** — at every position
predict the sums of bits over residue classes mod 3, mod 4, mod 5. The latent periods are **not given to the
analyzer**; the per-head chart battery (regimes 1–3, penalized RadixScore) searches blind. Every output is a
**candidate coordinate hypothesis**, not ground truth.

**Result — the lens recovers the latent modular structure, at the SET level.**
- **Control-surviving candidate charts across heads = `{[3,8], [4,6], [5,5]}`** — exactly the task's mod-3 / mod-4 /
  mod-5 periods (mod-5 ∤ 24 → the `[5,5]` cover). Per-seed candidate sets: seed1 `{[4,6],[5,5]}`, seed2
  `{[3,8],[4,6],[5,5]}`; **union = all three = the planted periods**.
- Candidates survive controls: shuffle destroys (shuffle n90 ~10.5 vs trained ~3.3), order-1 energy ~0.7, not
  delta (max-weight ~0.2), not uniform.
- **7/8 heads are diffuse/flat (`[24]`) in ≥1 seed and correctly rejected** (no chart promoted) — the lens
  discriminates active positional heads from diffuse ones.
- **Layer pattern:** modular charts concentrate in **layer 0**; **layer-1 heads are mostly diffuse `[24]`-flat** —
  consistent with early-layer positional aggregation feeding later mixed/content processing.

**Honest limitation — per-head-ID instability.** *Which* head carries which chart is **not stable across seeds**
(0/8 heads keep the same chart): the known **head-permutation symmetry** of randomly-initialized transformers, not
a lens failure. So candidate hypotheses are valid at the **SET level** (the heads collectively realize these
charts), not bound to a fixed head index.

**VERDICT: PROMISING (set-level).** On a transformer without an explicitly supplied positional factorization, the
FDRS positional MRA battery generates controlled, head-wise candidate coordinate hypotheses that recover the task's
latent modular structure, while rejecting diffuse/delta/uniform heads.

**Scope:** still a small model on a synthetic task (the periods are a designed task property, merely hidden from
the analyzer); **no general-LM claim**; charts are **hypotheses, not ground truth**; per-head-ID assignment is
seed-unstable. The value-arithmetic null (Rungs 0–5) and all earlier verdicts are unchanged.

**Valid claim:** *on a small multi-head transformer without an explicitly supplied positional factorization, the
FDRS positional MRA battery can generate controlled, head-wise candidate coordinate hypotheses — recovering the
latent structure at the set level — while rejecting uniform/delta/sharpness artifacts.*

## Rung 14 — causal validation of candidate positional charts (`runs/2026-06-26-intervene/`)

Rung 13's charts are *descriptive*. Rung 14 tests whether they are **causal**: train the modular transformer,
identify each head's chart by a modular-concentration score (excess attention on the residue class — the faithful
proxy for the Rung-13 Haar charts on this task), then **intervene forward-time** and measure per-output
specificity. Interventions matched **by chart period, not head ID** (head-permutation), 2 seeds.

**(1) Head ablation — specificity = drop(mod-P) / mean drop(other mods):**

| chart-head | seed 1 | seed 2 |
|---|---|---|
| period 3 | **72×** (mod3 1.0→0.27) | 7× |
| period 4 | 4.4× (mod4 1.0→0.31) | **40×** (mod4 1.0→0.40) |
| period 5 | **193×** (mod5 1.0→0.39) | 14× / 32× (two heads) |
| diffuse head | **0 drop** (control ✓) | 0 drop ✓ |
| redundant chart-copy | ~0 (another head covers it) | ~0 |
| full layer-0 ablation | all mods → ~0.3 (upper bound) | → 0.68/0.38/0.31 |

Ablating a period-P chart-head degrades **mod-P specifically** (2×–193×); the **diffuse-head control is harmless**;
and where two heads share a period, ablating one is harmless (the causal test isolates the **load-bearing** head
from redundant copies — an honest nuance the descriptive lens can't make).

**(2) Chart-cell masking — destroy the head's residue-class structure (the chart-level test):**

| chart-head | preserve-period | destroy-period | wrong-period |
|---|---|---|---|
| period 3 | mod3 = 1.00 | mod3 = **0.21** (drop 0.79) | mod3 = 0.51 |
| period 4 | mod4 = 1.00 | mod4 = **0.25** (drop 0.75) | mod4 = 0.74 |
| period 5 | mod5 = 0.98–1.00 | mod5 = **0.34–0.43** | mod5 = 0.60–0.94 |

**Destroying a head's residue-class structure crushes the matching output**, while **preserving it retains** the
output and **wrong-period masking hurts much less** — so it is the **chart structure itself** that is causal, not
merely "a head was removed." Both effects hold **across both seeds, matched by chart** (head IDs permute: mod-4 is
L0H2 in seed 1, L1H0 in seed 2).

**VERDICT: CAUSAL CONFIRMED.** Chart-aligned interventions (ablation and residue-class masking) selectively
degrade the corresponding modular readout, under controls (diffuse-head harmless, preserve retains, wrong-period
less specific, full-ablation upper bound), across seeds. The recovered charts are **causal, not merely descriptive.**

**Scope:** synthetic modular task, controlled; **no general-LM claim**; causality shown *for this task's charts*;
specificity is per **load-bearing** head (redundant copies show ~0 — correctly); head IDs are not stable across
seeds (match by chart). The value-arithmetic null (Rungs 0–5) and all earlier verdicts are unchanged.

**Valid claim:** *on a small multi-head transformer with hidden modular positional structure, FDRS positional-MRA
chart hypotheses are not merely descriptive — chart-aligned interventions (head ablation and residue-class
masking) selectively affect the corresponding modular readout under controls.*

## [1] Representational floor — CERTAIN (exact, EPS-free, substrate-independent)

Raw float attention weights are **exactly dyadic** — denominator a power of two — in **both** runs and every
condition: **0 odd-prime-denominator violations** (numpy/f64: mean 2-adic exponent 55–140; Burn/f32: ~28, the
narrower mantissa). Therefore **every non-2 factor, every "interesting" denominator, lives only in the
*approximant* shadow** — a property of the reconstruction tolerance, never of the stored value. This is the
hardware floor, stated as fact.

## [2] Cross-check (numpy toy) — how the sharpness confound was exposed

*(This is the numpy first pass; the canonical result is the Burn section above. Kept because it vividly
demonstrates the confound and why the entropy-matched control is the right one.)* The numpy toy **over-trained
to near one-hot** (a hard lookup): mean row-entropy **0.08 bits** vs random diffuse **2.14 bits**. Against a
**diffuse** random baseline it looks dramatically "structured":

| metric (model_trained vs **random_dot**, diffuse) | z (baseline-σ) |
|---|---|
| row_entropy | −7.15 |
| digit-address entropy | **−8.08** |
| continued-fraction depth | −2.18 |

But those are the wrong baseline. Against **`random_sharp`** — random rows tempered to the **same mean
row-entropy** as the model (the entropy-matched control) — the signal **collapses**:

| metric (model_trained vs **random_sharp**, entropy-matched) | z (baseline-σ) | reading |
|---|---|---|
| row_entropy | −0.03 | match succeeded (same sharpness) |
| digit-address entropy | +1.73 | **not significant** |
| continued-fraction depth | +0.35 | **not significant** |
| n_complementarities | −1.32 | **not significant** (model has *fewer* than random_sharp) |
| approx denominator bits | +1.76 | not significant |
| D_eff (row lcm) bits | +3.51 | residual — see caveat |
| D_eff distinct odd primes | +3.38 | residual — mechanical (more bits ⇒ more primes) |

**Conclusion (RQ1/RQ4/RQ6/RQ7 at this scale): no model-induced arithmetic / mixed-radix structure beyond the
representational + magnitude floor.** Once attention sharpness is controlled, the trained model's rows are
arithmetically indistinguishable from random rows of the same sharpness. This is the pre-registered first-class
null — and exactly the FDRS-implied prior (additive digit structure and multiplicative factor structure do not
align; THEORY.md Part C).

**The one residual** (`D_eff` ≈ +3.5σ) is a magnitude/shape artifact, not factor structure: `D_eff` = lcm of
per-element approximant denominators, dominated by the *smallest* masses. `random_sharp` matched the model's
*mean* entropy but not its full row *shape* — its tail values are ≈0 (denominator ≈1) while the model's tail is
graded-small (larger denominators). So `D_eff` differs because of the tail distribution, not arithmetic; it also
sits *below* the diffuse `random_dot` (z=−0.54). Refinement: a full-shape-matched baseline (not just mean
entropy) should close it. Reported at full weight, not hidden.

## [3] Controls behaved as controls (and one didn't)

- **`model_randomized`** (untrained, same arch) ≈ `random_dot` (diffuse) — random weights give diffuse, generic
  attention, as expected.
- **`model_shuffled`** (within-row permutation) was **identical** to `model_trained` on every metric (z=0.00):
  the lenses here are value-multiset functions, which within-row shuffling doesn't change. **Within-row shuffle
  is the wrong control for these metrics** — the entropy/shape-matched random baseline is the right one. (Logged
  so the useless control isn't mistaken for a passed one.)
- **`n_complementarities` vs `random_dot`** returned `n/a`: the diffuse null has zero variance (no diffuse row
  ever hits a place boundary), so `baseline_adjusted_signal` correctly *refused* to z-score against a degenerate
  null rather than emit a spurious ∞.

## Detailed numbers (means ± std; full data in `runs/2026-06-26-exploration/metrics.json`)

```
condition         row_entropy  cf_depth  digit_entropy  D_eff_bits  n_compl
random_dot          2.143       5.48       2.778          53.5        0.00
model_randomized    1.646       4.87       2.720          53.8        0.01
model_trained       0.080       1.71       1.542          50.8        1.62
model_shuffled      0.080       1.71       1.542          50.8        1.62   (== trained)
random_sharp        0.088       1.30       0.556           8.0        3.96
```
Params: EPS (approx tol) = 1e-6; fixed gauge volume DMAX = 27720 = 2³·3·... → `[8,9,5,7,11]`; 256 rows ×
6 slots per condition.

## Scope & caveats (honest)
- One **tiny single-head** model, one **synthetic** content-lookup task, **one** EPS, **one** fixed gauge, CPU.
  Not a real LM. The null is about *this* setup; it does not prove the null universally — it shows the apparatus
  works and the obvious signal is a confound.
- EPS-dependence: [2]–[4] are "model vs baseline at fixed EPS"; only [1] is EPS-free.
- Linear-attention accumulators were captured (`random_linear`) but only lightly analyzed; a proper Rung-5
  accumulator-drift study (rational-φ exact) is future work.
- No precision sweep yet (Rung 3) — the format-variance axis is still open.

## What this establishes
1. The pipeline runs end-to-end and the **exact lenses are correct** (after fixing NEG-1).
2. The **representational floor is real and exact** — the project's central caution is validated empirically.
3. The **baseline-first method earns its keep**: it caught a fabricated-structure tooling bug (NEG-1) and a
   sharpness confound that *looked* like an 8σ arithmetic signal (NEG-2).
4. At this scale, the arithmetic-substrate thesis gets a **clean null** — the honest, expected first outcome.

## Scientific-status ledger (ADR-007)

| Claim | Status | Baseline cleared | Notes |
|---|---|---|---|
| raw weights are exactly dyadic (floor) | **exact / certain** | n/a | EPS-free; provable, now also measured |
| model arithmetic signatures = sharpness confound (endpoint) | `candidate` (null) | entropy-matched ✓ (numpy + Burn) | confirmed both substrates; realistic Burn model all \|z\|<1 |
| post-coalescence dynamical transient | **resolved → shape** | shape-matched ✓ (decisive) | digit-entropy/den-bits residual −83/−85% under full-shape match; no prime/digit signal beyond coalescence shape |
| faint `n_compl` joint residual | open (low prior) | shape-matched (partial) | drops 63% but sign-flips across steps (noise/gauge); seed + gauge-robustness check is the only loose end |
| residual D_eff (static row-shape) | open | partially | shape artifact (present at init); needs shape-matched baseline |
| **positional MRA structure** (digit channels, Rung 7) | **POSITIVE** (positional) | shuffle ✓ + radix-selection | under `[3,8]`: n90 3 vs 10 (shuffle); order-2 0.002; 99.5% role-digit; value lens blind. Positional, not value-arithmetic; partly task-by-construction |
| radix ordering is decisive (exp73 radix selection) | confirmed | — | trained n90 3 (`[3,8]`) vs 16 (`[24]`); only block-aligned reveals it |
| **radix selection tracks block geometry** (Rung 8) | **confirmed** (primary, 4/4) | shuffle + uniform diagnostic | best block-grouping = `[B,n_blocks]` for B∈{2,3,4,6} (heatmap diagonal) |
| clean separable block-structure across B (Rung 8) | partial | order-2 / shuffle | strong B=3; B=2/4/6 delta-like (flat basis competes globally); marked-block task permits delta solutions |
| **radix selection tracks DISTRIBUTED block factorization** (Rung 8b) | **confirmed** | 12/12 models; shuffle+uniform+oracle brackets+anti-delta ablations | aggregation task closes delta loophole: aligned ordering *globally* best, order-2≈0, block-digit≈100%, mask-all-but-one crashes; B=2 one under-trained seed |
| **latent hierarchy discovered blind** (Rung 9 F1) | **confirmed** | shuffle+uniform + 3-level/wrong oracles | blind best `[4,6]` (2-level task) / `[4,3,2]` (3-level oracle) / `[3,8]` (wrong oracle) — right granularity, unbiased |
| **coordinate-chart sensitivity** (Rung 9 F2) | **confirmed** | raw vs oracle-unpermute | transpose recovered raw (`[6,4]`); random raw-fails (flat n90≈8.4) / oracle-succeeds (`[4,6]` 2.85) |
| **per-head gauge specialization** (Rung 10) | **confirmed** | 3 seeds; shuffle+uniform | each head's blind best = its planted gauge (`[2,12]`/`[3,8]`/`[4,6]`); 3×3 heatmap diagonal |
| **covers discover non-factor structure** (Rung 11) | **confirmed** | penalized RadixScore + shuffle/uniform | period-5 → `[5,5]` cover (n90 4.0 vs best-factor 7.8), wins after rent |
| **covers don't fake structure when a factor exists** (Rung 11) | **confirmed** | RadixScore rent | block-of-4 → saturated `[4,6]`; all covers penalized away |
| **regime-3 chart (embedding) recovery** (Rung 12) | **confirmed** | penalized RadixScore (C_ι,C_M) + shuffle + negative control | stride-7/11 charts recovered (beat row-major ~2–3×); cover & row-major controls stay simple (no gauge-fishing) |
| **head-wise candidate charts on a real-ish transformer** (Rung 13) | **promising (set-level)** | shuffle/uniform/delta + 2 seeds + diffuse-head rejection | candidate-chart union = `{[3,8],[4,6],[5,5]}` = latent mod-3/4/5 periods; 7/8 diffuse heads rejected; per-head-ID seed-unstable (head permutation) ⇒ hypotheses are set-level, not ground truth |
| **candidate charts are CAUSAL** (Rung 14) | **confirmed** | ablation + chart-cell masking; diffuse/wrong-period/full-ablation controls; 2 seeds, matched by chart | period-P chart-head ablation drops mod-P specifically (2×–193×); destroy-residue crushes mod-P (≈1.0→0.2–0.3), preserve retains, wrong-period less; diffuse harmless; redundant copies ~0 (load-bearing head isolated) |

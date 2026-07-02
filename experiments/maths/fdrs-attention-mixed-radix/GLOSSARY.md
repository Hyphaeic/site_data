# Glossary — fdrs-attention-mixed-radix

Terminology for the project. **[FDRS]** = already defined in `fdrs-formal` (use the existing name/notation;
citation given). **[NEW]** = proposed here; provisional, must be earned by surviving the baseline gate. Where a
NEW term has an FDRS-adjacent parent, the parent is named so the vocabulary stays anchored.

> Reading order: this file defines the *objects* and the *metrics*. `THEORY.md` formalizes them against FDRS.
> `README.md` §5 says how a claim about any of them is gated.

---

## Objects

### scalar landscape [NEW]
An indexed field of attention scalars at a fixed `(layer, head)` — e.g. the score matrix `S`, a softmax row, the
accumulator stream `{Sₜ}`. The atomic unit of analysis. *Caveat:* a landscape is just an array of numbers;
"having a landscape" is trivially true of any computation and is not itself a result.

### attention landscape family [NEW]
The full set of landscapes a single attention computation emits (projection, score, kernel, normalizer, weight,
accumulator, output — see README §2 table). Studied jointly so a signal at one level can be checked against
others.

### rational shadow [NEW]
The rational value(s) attached to a finite machine scalar `x`. Two distinct senses, and **conflating them is the
project's central error**:
- **exact (dyadic) shadow** — `x` as its true IEEE-754 value `m·2^e`, an exact rational with denominator a power
  of two. *Always exists; its factor content is pure hardware.*
- **approximant shadow** — the best rational `pₙ/qₙ` (a continued-fraction convergent) with `|x − pₙ/qₙ| ≤ ε` and
  `qₙ` minimal. *Where non-trivial structure could live — but only if it beats baseline.*
Parent: FDRS works throughout in exact `ℚ` (Phase 13 "exact integer ledgers, no floating point").

### arithmetic shadow [NEW]
Umbrella for *any* arithmetic representation attached to a scalar — the rational shadow plus its derived lenses
(factor participation, valuation profile, CF profile, denominator complexity, mixed-radix digit address).
"Spectroscopy" = reading several of a scalar's shadows at once. A shadow is a *description*; structure in a
description is not structure in the computation until the baseline gate passes (NEGATIVE.md fraud #12).

### factor participation [NEW]
For a rational shadow `p/q` (reduced), the multiset of primes dividing `p` and `q`, with multiplicities — i.e.
the support and heights of the factorization — **after** removing the dyadic part (treat `2` as a separate
hardware channel). Parent: FDRS **factorization lens** `Λ_P(n) = (u_P(n), v_P(n))` (Def 46) and the
P-smooth/P-free split `n = u_P(n)·s_P(n)` (Def 44). Here we apply `Λ_P` with `2` quarantined.

### representational vs computational participation [NEW — the central methodological distinction]
The project's organizing split, and the reason *every* metric is baseline-adjusted:
- **representational participation** — factor/valuation structure that comes from *how the machine stores
  numbers*. Binary floating point privileges powers of 2; approximant reconstruction adds whatever the chosen
  tolerance forces. **Presumed trivial / artifactual.** Measured by the `dyadic-only` baseline + the precision sweep.
- **computational participation** — factor/valuation structure that comes from *how attention operations transform
  arithmetic profiles across landscape levels* (the `landscape arithmetic flow`). **Possibly meaningful.** Visible
  only as the *residual* after representational participation is subtracted (baseline-adjusted, precision-invariant).
A finding is interesting only insofar as it is **computational, not representational**. The two are separated by
quarantining the dyadic part (`u_P`), by the precision sweep (Rung 3), and by the `dyadic-only`/`matched-random`
baselines — never by assertion.

### valuation profile [FDRS]
The **valuation vector** `v_P(n) = (v_p(n))_{p∈P}` (Def 44/46; `NumberTheory/Valuations/Definition.lean`):
the tuple of p-adic valuations of numerator and denominator over a chosen prime set `P`. A *profile* is its
distribution across a landscape. Truncated form `v_P^{≤E}` (cap each valuation at `E_p`) is the FDRS multiplicative
σ-algebra generator.

### continued-fraction (CF) profile [FDRS-adjacent]
The CF expansion `x = [a₀; a₁, a₂, …]`, its partial quotients `aᵢ`, convergents `pₙ/qₙ`, and **CF depth** (the
`n` needed to reach tolerance `ε`). Parent: FDRS **generated gauges** / CF timelines and **homographic emission**
(Phase 13, Def 188), where the CF *is* the gauge and a digit is emitted only when forced (four-corner trap,
Thm 82). For softmax weights (transcendental) the CF is the natural reconstruction; large/erratic partial
quotients are the signature of "no simple rational nearby."

### mixed-radix gauge [FDRS]
A place-value system: a radix sequence `b = (bᵢ)`, `bᵢ ≥ 2`, with place values `B_m = ∏_{i<m} bᵢ`
(`RadixSeq`, Def 1–4). Generalized to a **product gauge** `β_ω = prefixWeight ω` (Prop 147) and a **prefix
gauge** `(Adm, g)` inducing the ultrametric `δ_g(x,y) = g(lcp(x,y))⁻¹` with **ball = cylinder** (Def 192,
Thm 83). A value is *lifted* into a gauge by writing its mixed-radix digits.

### digit address [NEW; FDRS-adjacent]
The mixed-radix coordinate tuple of a value in a chosen gauge — this project's name for what FDRS calls the
**prefix** `s = (s₀,…,s_{L-1})` obtained by **prefix projection** `π_L`, with **prefix residue** `r_L(s)`
encoding it. The cylinder `U(s)` (Def 8) is the neighborhood of all values sharing the address. We say
"address" to foreground the indexing-of-attention-scalars use; the math is FDRS's prefix/cylinder.

### row-gauge [NEW; FDRS-adjacent]
For a normalized row `p = (p₁,…,p_n)`, `Σpᵢ = 1`, a shared denominator `D` (or a gauge with `D` as top place
value) such that `pᵢ ≈ cᵢ/D`, `cᵢ ∈ ℤ_{≥0}`, `Σcᵢ = D`. The row becomes an **integer partition of arithmetic
volume `D`**. Parent: FDRS **partition law** `setMass_partition` (mass at the next horizon = sum of fluxes over
observed symbols — "no anonymous change"; `SyntheticPlace/Conservation.lean`). The row-gauge is the candidate
"arithmetic volume" of an attention row; `D`'s recurrence across rows is the RQ4 signal.

### mixed-radix lift [NEW; FDRS-adjacent]
The map taking a scalar (or a whole row) to its digit address(es) in a constrained gauge. The "lifting" in the
project title. Constrained per README §5 (row denominator / normalization / FDRS gauge / pre-registered only).

### carry-completion event [NEW; SPECULATIVE]
A normalization-induced complementarity in a row-gauge: e.g. two masses with `cᵢ + cⱼ = B_m` (a place-value
boundary), or a digit roll-over when masses are re-blocked into a coarser gauge. Parent: the FDRS **odometer
carry** and **interface balance** `issued = consumed + pending` (Phase 14). Defined precisely *so it can be
searched for and falsified*; the null hypothesis is that such events occur at exactly the rate of a random
partition of the same volume.

### gauge stability [NEW]
The degree to which the *same* gauge / shared denominator `D` / digit-address structure recurs across rows,
heads, layers, prompts, or seeds — measured baseline-adjusted. Low stability = no structure; high stability
beyond baseline = the RQ4/RQ6 signal.

### arithmetic spectroscopy [NEW]
The method: viewing one scalar through multiple arithmetic lenses (factor, valuation, CF, mixed-radix) as
distinct **spectral lines**, and asking which are *sharp* (low-entropy, recurrent, baseline-beating) vs *broad*
(baseline-like). The name is a metaphor for multi-lens decomposition, not a claim of physical spectra.

### baseline-adjusted (factor) signal [NEW]
Any landscape statistic `M` reported as `(M − E_baseline[M]) / σ_baseline[M]` — its deviation from the matched
baseline in baseline-σ units. **The only currency in which any structural claim may be stated.** A raw `M` is
never a result.

### attention volume partition / carry-completion event [NEW; FDRS-adjacent]
The row-gauge read as a partition: `(D, c)` with `Σcᵢ = D`, each `cᵢ` a key's integer mass (FDRS partition law
`setMass_partition`). A **carry-completion event** is a normalization-induced complementarity — addresses summing
to a place boundary `Bₘ`, or to the volume `D` via a carry cascade (the §0 worked example). Parent: odometer carry
+ interface balance `issued = consumed + pending`. Null: a random partition of the same volume.

### landscape arithmetic flow [NEW]
How a profile (factor / valuation / denominator) transforms as you move along the landscape family
Q/K/V → score → weight → normalizer → accumulator → output. The object of RQ2/RQ9: does the *flow* differ from the
flow on random inputs? Not an FDRS term; the FDRS operator/refinement view (Def 20) is the analogy.

### denominator complexity [NEW]
The bit-length of the reduced denominator `q` at tolerance `ε` (also a metric below). High complexity = "no simple
rational nearby"; tracked against the `dyadic-only` baseline so the format's own contribution is subtracted.

### TWO LENS FAMILIES [the distinction Rungs 0–5 missed]
There are two senses of "mixed-radix structure of attention," needing different tooling and baselines:
- **value lens** (Rungs 0–5) — the arithmetic of the scalar *values*: rational shadow, factor participation,
  valuation, CF, value-volume row-gauge. **Functions of the value multiset → permutation-invariant** (within-row
  shuffle leaves them unchanged). Verdict: **null** beyond the representational + shape floor.
- **positional lens** (Rung 7; FDRS MRA / exp73) — the row as a **signal over the position index**, decomposed in
  the **mixed-radix Haar basis**, with the **radix ordering** a free parameter to select. **Position-sensitive**
  (shuffle changes it → a real control). Verdict: **positive** — separable digit-channel structure under the
  task-aligned ordering. *This is the one exp73 pioneered and where structure actually lives.*

### digit channel [FDRS-MRA; exp73b]
In a row's mixed-radix Haar decomposition (over the position index), the energy in atoms whose active set involves
digit position `j`. "Pure" channel = atoms with active set exactly `{j}`; interactions = atoms with ≥2 active
digits. "Digit-channel separation" = does distinct structure concentrate in distinct channels.

### interaction order [FDRS-MRA; exp73e]
The cardinality `|S(α)|` of a Haar atom's active set — how many digit positions it couples. Order 0 = constant
(mean), 1 = single-digit (separable), ≥2 = interactions. The **interaction-order spectrum** = energy per order;
low order ⇒ additively separable.

### radix selection [exp73f]
Treating the **radix ordering** (sequence/grouping of the factors of `N`) as a free parameter and **choosing the
ordering** that best separates/compacts a signal (lowest n90, lowest interaction order). Block-aligned `[3,8]` vs
non-aligned `[8,3]` is the canonical example — structure is often visible only under the right ordering. The
formerly-missing "gauge fishing done right": constrained to factorizations of `N`, scored, baselined.

### mixed-radix Haar / contrast basis [FDRS]
The orthonormal basis over a mixed-radix space: per digit a **contrast basis** (`b−1` mean-zero vectors); product
atoms `h_α = ∏ φ_{i,α_i}(d_i)` form the Haar/MRA basis (FDRS block projections `P_L`, detail operators `Δ_L`,
commutant theorem). The position-lens decomposition of an attention row.

### n90 (energy compaction) [exp86c]
Number of Haar coefficients to capture 90% of a row's energy under a given radix ordering. Lower = sparser /
better-aligned ordering. The radix-selection score.

---

## Baselines (the null models — see README §5)

- **matched-random** — random Q/K/V, identical shape, distribution matched to the model's empirical per-layer
  statistics.
- **dyadic-only** — random dyadic rationals with the float format's exponent distribution; isolates pure
  IEEE-754 contribution (the hardware floor).
- **shuffled** — landscape entries (and token order) permuted; preserves the value multiset, destroys structure.
- **randomized-weights** — model weights re-initialized (matched init), architecture + inputs fixed; isolates
  learned vs architectural/number-system structure.
- **precision-format** — FP32 / FP16 / BF16 / int8 / int4; the same computation across representations.

---

## Metrics (all reported **baseline-adjusted**)

| Metric | Definition | Primary baseline | Reads on |
|---|---|---|---|
| factor participation count | # distinct primes (≠2) in reduced `p/q` of the approximant shadow | matched-random, dyadic-only | RQ1 |
| normalized factor participation | participation count ÷ denominator bit-length (controls for size) | matched-random | RQ1, RQ3 |
| valuation-vector entropy | Shannon entropy of `v_P` distribution over a landscape | matched-random | RQ1, RQ2 |
| denominator complexity | bit-length of reduced `q` at tolerance `ε` | dyadic-only, precision | RQ3, RQ8 |
| continued-fraction depth | # CF terms to reach `ε` | matched-random | RQ8 |
| approximant stability | robustness of `pₙ/qₙ` under ε-perturbation of `x` | dyadic-only | RQ3 |
| row-gauge shared-denominator score | recurrence/agreement of `D` across rows (vs random partitions) | random partition | RQ4, RQ5 |
| digit-address entropy | entropy of mixed-radix coordinates over a landscape | shuffled, matched-random | RQ6 |
| carry/complementarity event count | # carry-completion events per row | random partition | RQ7 |
| layer/head factor-profile distance | distance between factor profiles across layers/heads | matched-random | RQ2 |
| **baseline-adjusted factor signal** | headline: factor structure in baseline-σ units | all applicable | RQ1–RQ10 |
| gauge stability across prompts | recurrence of gauge structure across prompts/seeds | shuffled, randomized-weights | RQ4, RQ6 |
| precision-sensitivity score | Δ(metric) across FP32/16/BF16/quant | — (this *is* the artifact axis) | RQ3, RQ10 |

> A metric is **promotable** only when its baseline-adjusted value clears the rung's pre-registered threshold in
> the pre-registered fraction of seeds **and** survives the precision control (Rung 3). Otherwise it is reported
> at full weight as *baseline-consistent* (a first-class null).

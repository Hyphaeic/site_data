# Theory track — fdrs-attention-mixed-radix

**Posture (ADR-008): no new mathematics is claimed.** FDRS supplies a vocabulary and a set of proven facts; the
contribution would be a *connection* (attention landscapes ↔ FDRS objects) and a *verified artifact*, never
"FDRS-novel theory." This file (a) lists the existing FDRS items the project leans on, (b) sketches the
candidate new definitions to formalize **only if** the empirics survive baseline, and (c) records one sharp
theory-level prediction FDRS already implies. **No Lean/Sage code here** (per task) — outlines only.

---

## §0 — The central object: the arithmetic lift (and a worked example)

The single object the project studies. For a scalar `x` in a landscape `L`, an **arithmetic lift** sends `x` to a
rational shadow and, optionally, a mixed-radix coordinate system:

```
  x ≈ p/q ,    q = ∏_i b_i ,    p = Σ_i d_i B_i ,    B_0 = 1 ,    B_i = ∏_{j<i} b_j
```

so that `x ≈ [d_0, d_1, …, d_L]_{[b_0,…,b_L]} / ∏_i b_i`. The top-level value is unchanged; the lift exposes
*alternative internal coordinates* — digits `d_i` in gauge `(b_i)`. This is exactly the FDRS mixed-radix space
`ℛ^(k)` with place values `B_m` (Part A), applied to attention scalars.

**Two readings, and the project lives entirely on the gap between them:**
1. *existence* — for any finite machine value a lift always exists (the value is a dyadic rational; pick any
   gauge). **Content-free.** (NEGATIVE.md fraud #1.)
2. *recurrence* — whether the *same* gauge / digit structure recurs across rows, heads, layers, prompts beyond
   baseline. **The empirical question.** Everything below serves reading 2; reading 1 is never a result.

**Worked example — a softmax row as a partition of arithmetic volume** (verified exactly by
`source/stage0_demo.sage`). Suppose a 2-key row reconstructs *jointly* to

```
  a₀₀ = 3779/6168 ,   a₀₁ = 2389/6168 ,   a₀₀ + a₀₁ = 1.
```

The partition-of-unity becomes an **integer** identity `3779 + 2389 = 6168 =: D`, the row's **arithmetic
volume**. Since `D = 6168 = 2³·3·257`, the constrained **row-gauge** is `[8, 3, 257]` (place values `B = [1,8,24]`),
and the two masses get **digit addresses**

```
  3779 → (3, 1, 157) ,    2389 → (5, 1, 99).
```

Their digit-wise sum carries at **every** position: `(3,1,157)+(5,1,99)` → digits `(0,0,0)` with a final carry of
`1` into the volume place — i.e. exactly `D`. The two weights are **complementary residues** in one gauge, and
their addition is a full **carry-completion cascade**: the concrete instance of the FDRS partition law
(`setMass_partition`) and odometer carry, transplanted to an attention row. This is what Rung 4 searches for.

The example already enforces the discipline: the row is reconstructed **jointly** to a single `D` with `Σcᵢ = D`
held exactly. Naive *per-element* reconstruction instead manufactures a shared denominator in one row and breaks
the sum-to-one in the next — both demonstrated live in `stage0_demo.sage` Part A. Free gauge choice is therefore
banned (README §5 gauge-selection discipline); the gauge must be *forced* by the row, not fished for.

> **Result orientation (post-hoc, 2026-06-26 — read before getting excited about the cascade above).** This §0
> object is the **value lens** (the carry-cascade on a row's *arithmetic volume*), and it came back **NULL**
> (Rung 4: the apparent structure is attention *sharpness*, not arithmetic — NEG-2). The project's **positive,
> causal** result is a *different* lens — the **positional MRA** of **Part E** (each row as a signal over
> *positions*). The lift here is real but, by reading 1 above, always exists; it is kept as the motivating object
> and the home of the artifact-control discipline, **not** as a finding. It does *not* claim attention "is really
> integer routing instead of softmax" — the float softmax is still what runs; this is a testable second
> *interpretation*, and for the value lens that interpretation tested null.

---

## Part A — Existing FDRS items leaned on

| FDRS item | Exact name / notation | Lean home | Used here for |
|---|---|---|---|
| Mixed-radix space | `ℛ^(k)`, `ℛ^(∞)_fin`; `RadixSeq`; place values `B_m = ∏ bᵢ` (Def 1–4) | `Core/Primitives/RadixSeq.lean` | the gauge into which scalars/rows are lifted (*mixed-radix lift*, *digit address*) |
| Cylinder sets | `U(s)`; ball = cylinder; clopen basis; `U(s) ↔ ≡ r_L(s) (mod B_L)` (Def 8, Prop 5) | `Topology/Filtration/…` | neighborhoods of digit addresses; cylinder = congruence class is the bridge to factor structure |
| Prefix / product gauge | `prefixGauge (Adm, g)`, `δ_g(x,y)=g(lcp)⁻¹`; `β_ω = prefixWeight ω` (Def 192, Prop 147, Thm 83) | `Modes/SyntheticPlace/GaugeUltrametric.lean` | constrained gauges for *row-gauge* and *gauge stability* (no fishing) |
| Valuation vector | `v_P(n) = (v_p(n))_{p∈P}`; `v_P^{≤E}` (Def 44/46) | `NumberTheory/Valuations/Definition.lean` | *valuation profile* |
| Factorization lens | `Λ_P(n) = (u_P(n), v_P(n))`; `n = u_P·s_P`; lens-locality (Def 46, Thm 25) | `NumberTheory/Valuations/…` | *factor participation* with the dyadic part quarantined (`2` separated in `P`) |
| Multiplicative σ-algebra / divisibility filtration | generated by `n ↦ (u_P, v_P^{≤E})` (Def 44) | `NumberTheory/Valuations/…` | the *factor* (multiplicative) view, contrasted with the *digit* (additive) view |
| Cylinder-measurability bridge | congruence prefix-decidable **iff** modulus ∣ place value; generic **non-commutation** of additive vs multiplicative filtrations (Thm 21) | `Topology/…` ↔ `NumberTheory/…` | the sharp prior in Part C |
| Partition law / conservation | `setMass_partition`; "no anonymous change" (SU4a) | `Modes/SyntheticPlace/Conservation.lean` | *row-gauge* as partition of arithmetic volume |
| Interface balance | `issued = consumed + pending` (Phase 14) | `Modes/SyntheticPlace/Conservation.lean` | accumulator (`zₜ`) conservation in Rung 5; *carry-completion* |
| Homographic / bihomographic emission | `emit q`; `BihTensor`; four-corner trap (Def 188/189, Thm 82) | `Modes/VariableRadix/HomographicCarry.lean`, `Bihomographic*.lean` | CF profiles; the "emit a digit only when forced" discipline (anti-fishing for digits) |
| Refinement embeddings / digit-conditional refinement | Def 20; Phase 11 | `Core/…` | reblocking digit addresses between gauges |

---

## Part B — Candidate new definitions (formalize **only if** empirics survive baseline)

Each is an *outline*: intent · FDRS parent · informal statement · what a Lean formalization would assert · the
`proof_wanted` target it would seed. None is to be written into the corpus before a confirmed empirical claim
(G4 gate, ADR-007). Names follow the task's list; FDRS naming conventions (`structure`/`def`, prefix-style)
would apply.

1. **`ScalarLandscape`** — *intent:* the analysis unit. *Parent:* a finite indexed family over `ℚ` (or `𝔽_float`).
   *Informal:* `ScalarLandscape := Fin r → Fin c → ℚ` (a captured tensor slice), with a tag `exact | enclosure |
   float`. *Formalize:* well-formed-ness + the decoration tag algebra (weakest-tag composition). *proof_wanted:*
   none (a data definition).

2. **`AttentionLandscape`** — *intent:* the family of landscapes from one attention computation. *Parent:*
   product of `ScalarLandscape`s + the maps between them. *Informal:* a record bundling
   `{Q,K,V,score,kernel,normalizer,weight,accumulator,output}` with the structural identities linking them
   (e.g. `weight = softmax(score)`, `Σ weightᵢ = 1`). *Formalize:* the partition-of-unity invariant on rows.
   *proof_wanted:* "every softmax row is a finite mass partition" (trivial; the hook for the partition law).

3. **`RationalShadow`** — *intent:* the exact-vs-approximant split. *Parent:* dyadic embedding `𝔽_float ↪ ℚ`
   + CF best-approximant. *Informal:* `shadow_exact x = (m,e)` with `x = m·2^e`; `shadow_approx ε x = (p,q)` the
   minimal-`q` convergent within `ε`. *Formalize:* `shadow_exact` has denominator a power of two (so its only
   prime is 2) — **the lemma that makes "factoring the raw float" provably content-free**. *proof_wanted:*
   `∀ x, support(denom(shadow_exact x)) ⊆ {2}` (this is *provable now*, not empirical — it is the artifact
   floor stated as a theorem).

4. **`FactorParticipation`** — *intent:* prime support of a shadow, dyadic-quarantined. *Parent:* `Λ_P`, Def 46.
   *Informal:* `participation P (p/q) = (Λ_{P∖{2}}(p), Λ_{P∖{2}}(q))`. *Formalize:* invariance under reduction;
   relation to `u_P`. *proof_wanted (empirical):* "for model-captured landscapes, baseline-adjusted
   participation entropy < random by margin τ" — a `conjecture`-marked statement, only after Rung 2–3.

5. **`LandscapeValuationProfile`** — *intent:* distribution of `v_P` over a landscape. *Parent:* valuation vector
   + multiplicative σ-algebra. *Informal:* the pushforward of `v_P` along the landscape index. *Formalize:*
   measurability w.r.t. the multiplicative σ-algebra. *proof_wanted (empirical):* level-specificity (RQ2) as a
   conjecture.

6. **`RowGauge`** — *intent:* a softmax row as a partition of arithmetic volume. *Parent:* `setMass_partition`.
   *Informal:* `RowGauge ε p := (D, c)` with `cᵢ/D ≈ pᵢ` (within `ε`), `Σ cᵢ = D`. *Formalize:* existence + the
   conservation identity `Σ cᵢ = D` (a direct instance of the partition law). *proof_wanted:* the existence/
   conservation lemma is *provable now*; the **recurrence of `D` beyond baseline** (RQ4) is the empirical
   conjecture.

7. **`MixedRadixLift`** — *intent:* digit address of a value/row in a constrained gauge. *Parent:* `RadixSeq`,
   `β_ω`, `π_L`. *Informal:* `lift β x = π_L(x)` for an admissible gauge `β`. *Formalize:* well-defined on the
   gauge's cylinders; agreement with `r_L`. *proof_wanted:* none new (uses existing prefix theory).

8. **`GaugeStability`** — *intent:* recurrence of gauge structure across the landscape family. *Parent:* none
   direct; built on `RowGauge` + a distance. *Informal:* `stability = baseline_adjusted( agreement of RowGauge
   across rows/heads/prompts )`. *Formalize:* a stability functional + its baseline-null. *proof_wanted
   (empirical):* the core RQ4/RQ6 conjecture.

9. **`BaselineAdjustedSignal`** (= `BaselineAdjustedArithmeticSignal`) — *intent:* the reporting currency.
   *Parent:* none (statistical wrapper). *Informal:* `bas M = (M − 𝔼_null M)/σ_null M`. *Formalize:* the null-model
   family + that `bas` of a baseline sample is ~ standard (sanity). *proof_wanted:* none (a definition + a sanity lemma).

**Additional candidates (terse — same discipline; FDRS parent named; complete the task's 16-name list):**

10. **`ArithmeticShadow`** — umbrella over the per-scalar lenses (a tagged union
    `exact-dyadic | approximant | factor | valuation | CF | mixed-radix`). *Parent:* none. *proof_wanted:* none.
11. **`ValuationProfile`** — the distribution of `v_P` over a landscape (separated from `LandscapeValuationProfile`
    (def 5) only by granularity: per-scalar vs per-landscape). *Parent:* valuation vector, Def 44.
    *proof_wanted (empirical):* RQ2 level-specificity.
12. **`ContinuedFractionProfile`** — partial quotients, convergents, and CF-depth-to-tolerance of a shadow.
    *Parent:* FDRS generated gauges / homographic emission (Def 188). *proof_wanted (empirical):* RQ8.
13. **`DenominatorComplexity`** — bit-length of the reduced denominator at tolerance `ε` (a complexity functional
    on shadows; pairs with the CF profile). *Parent:* none. *proof_wanted:* none (a definition).
14. **`MixedRadixGauge` / `DigitAddress`** — the gauge `(bᵢ, Bᵢ)` and the coordinate tuple `π_L(x)` of a value in
    it (def 7's `MixedRadixLift` is the *map*; these are its domain/codomain). *Parent:* `RadixSeq`, cylinders
    `U(s)`, prefix `π_L`. *proof_wanted:* none (existing prefix theory).
15. **`AttentionVolumePartition` / `CarryCompletionEvent`** — a row as `(D, c)` with `Σcᵢ = D` (def 6's `RowGauge`
    read as a partition), and the carry events when complementary addresses sum to a place boundary (§0).
    *Parent:* partition law `setMass_partition`; odometer carry; interface balance. *proof_wanted:* the partition
    identity is *provable now*; the **above-baseline carry rate** (RQ7) is the empirical conjecture.
16. **`LandscapeArithmeticFlow`** — how a profile transforms along Q/K/V → score → weight → normalizer →
    accumulator → output (a morphism between landscape profiles). *Parent:* none direct; the FDRS
    operator/refinement view (Def 20) is the analogy. *proof_wanted (empirical):* RQ2/RQ9 — that the flow differs
    from the random-input flow.

> **Discipline:** definitions 3 and 6 contain lemmas that are **provable now and are artifact controls, not
> findings** (the float denominator is 2-power; a row is a mass partition). Stating these in Lean *first* makes
> the empirical conjectures (4,5,8) honest — they must beat exactly the structure the provable lemmas account
> for.

---

## Part C — A sharp prior FDRS already implies (a prediction, not a hope)

FDRS Thm 21 (cylinder-measurability bridge) proves the **additive** filtration (cylinders / mixed-radix digit
prefixes / congruence mod `B_L`) and the **multiplicative** filtration (valuations / factorization) **generically
do not commute** — a congruence is prefix-decidable iff the modulus divides the place value, with a constructive
witness of non-commutation otherwise. Transported to this project, that is a concrete prediction:

> **Digit-address structure (additive) and factor-participation structure (multiplicative) in attention
> landscapes should generically be *misaligned*.** If a single gauge made *both* the mixed-radix digits *and* the
> prime factorization look simple simultaneously, that would be surprising *relative to FDRS itself* — and a
> strong (suspicious) signal demanding the artifact controls before any excitement.

This gives the project a built-in skeptic: FDRS predicts the two lenses usually disagree, so apparent agreement
is first a red flag for a shared artifact (e.g. both keying off the dyadic exponent), and only second a
candidate finding.

---

## Part D — Promotion path (ADR-007 §4)

- Confirmed empirical claims are stated as `proof_wanted` (or `conjecture`-marked) declarations under
  `projects/fdrs-formal/FdrsFormal/Conjectures/`. **That directory does not yet exist** — ADR-007 specifies it;
  creating it is itself a G4 materialization step, taken only when the *first* confirmed claim is ready, never
  pre-emptively.
- The two-repo boundary (ADR-007 Consequences) applies: the experiment family lives in the HiR repo; the
  conjecture layer in `fdrs-formal`. A promotion PR references the run transcript by stable path across the
  boundary.
- The provable artifact-control lemmas (defs 3, 6) could be contributed to `fdrs-formal` independently of any
  empirical result — they are clean number-system facts and would harden the corpus regardless of what the
  attention study finds.

---

## Part E — the positional MRA lens (exp73): radix ordering as a free parameter

Rungs 0–4's `MixedRadixLift` applied the gauge to scalar *values*. But FDRS also has a fully developed **MRA over
the position/index space** — block projections `P_L` (conditional expectations on cylinders), detail operators
`Δ_L`, the Haar/contrast basis, and the commutant theorem (an operator is scale-block-diagonal iff it commutes
with every `P_L`). The **exp73 family** (`…/Sage/fdrs_exp73*`) instantiates this as a *signal-separation* tool:
decompose a signal over `N = ∏ bᵢ` positions in the mixed-radix Haar basis, read its **digit channels** and
**interaction-order spectrum**, and — crucially — **vary the radix ordering** (a free parameter: `[3,8] ≠ [8,3] ≠
[24]`) and *select* the ordering that best separates/compacts it (exp73f, exp86c).

This is the second sense of "mixed-radix lift" the value lens omitted — and the one that **found structure** in
attention (Rung 7: separable digit-channel geometry under the task-aligned ordering). Candidate definitions to
formalize: `PositionalHaarSpectrum(row, radix_order) → (digit_channel_energy, interaction_order_spectrum, n90)`
and `RadixSelection(row) → argmin_order n90`. The FDRS MRA (block projections, detail operators, contrast basis,
commutant) is the existing backing — **no new math; the contribution is the connection** (attention pattern ↔
FDRS MRA under a *selected* radix ordering). And it is consistent with the Part C prior: the **additive**
(digit/position) structure is where the attention signal lives, while the **multiplicative** (value-factor)
structure is null — the two filtrations did not coincide, exactly as FDRS predicts.

### Three regimes of the positional lens (the search space, narrow → general)

Rungs 7–9 used only the **first** regime. The general FDRS lens is broader:

1. **Saturated factorization** — `N = ∏ bᵢ`. Every position exactly tiles the mixed-radix grid; the Haar/MRA
   basis is orthonormal over the whole observed domain; no holes. *Disciplined starting point; produced the
   confirmed positional result (Rungs 7–9).* The search is "which factor ordering of N is best?"
2. **Unsaturated covering gauge** — `B = ∏ bᵢ ≥ N`. The observed positions embed into a *larger* volume; some
   cells are **unused (holes)**. A mixed-radix line only needs capacity `B ≥ N`, not `B = N`. Holes are not
   errors — slack, boundary, hidden capacity. e.g. `N=24` under `[5,5]` (B=25, one hole) or `[3,3,3]` (B=27).
3. **Non-factor / chart-lifted** — a base sequence with `∏ bᵢ ≥ N` *plus* an embedding `ι : {0..N−1} ↪ ∏[0,bᵢ)`
   that need not be row-major: contiguous, padded, permuted, strided, masked, sparse, or task-defined. The
   question becomes **"which mixed-radix chart `(b, ι, M)` best explains the attention signal?"** — `M = ι([N])`
   the occupancy mask, `ρ = N/B` the occupancy ratio. This is the synthetic-place idea: digits are admissible
   local states, not necessarily saturated numeric factors.

**The gauge-fishing danger and its discipline.** Regimes 2–3 explode the search space and can fabricate
structure, so a cover must **pay rent**: score it as
`RadixScore = n90 + λ·(B−N)/B + μ·L + ν·(embedding/mask irregularity)` (compaction *after* penalizing slack
volume, digit-axis count, and chart weirdness), with the shuffle/random/uniform controls still mandatory. A good
cover must beat the saturated factorization *after* paying for its extra volume.

**New objects to formalize (regime 2–3):** `SaturatedGauge` (B=N), `CoveringGauge` (B≥N), `OccupancyMask`
`M ⊆ ∏[bᵢ]`, `OccupancyRatio ρ = N/B`, `MaskedMixedRadixHaar` (Haar over the B-volume restricted/weighted to M),
`ChartCost`, and `RadixScore`. Tested empirically in Rung 11 (`runs/2026-06-26-cover/`).

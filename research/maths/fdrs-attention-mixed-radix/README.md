# fdrs-attention-mixed-radix — does vanilla attention already carry a mixed-radix / arithmetic substrate? (charter)

> **Working title:** *Mixed-Radix Lifting of Attention Scalar Landscapes.*
> **Posture:** an **observational, analytical interpretability study of attention computations that already exist.**
> It does **not** propose a new attention mechanism, and makes **no** architecture change in any rung. The
> single question is whether the *arithmetic shadows* of ordinary attention scalars carry **stable structure
> beyond hardware, quantization, and random baselines**. The prior was that most apparent structure is an
> artifact until a baseline gate says otherwise — which **held for the value lens** (null, frozen) but **not for
> the positional lens** (mixed-radix coordinate structure; positive, causal on synthetic tasks). See `SUMMARY.md`.

> **❄ MILESTONE FROZEN (Rungs 0–14, synthetic) · 2026-06-26 — see `SUMMARY.md`.** This README is the G0 charter +
> G1 protocol; the frozen verdicts and scope live in `SUMMARY.md` and `results.md`. Registration of the registry
> entity remains the user's human-gated G0 step — runs were directed ahead of the formal commit, are reported
> conservatively, and are kept registry-ready. Scope is strictly **synthetic**: no claim about real/pretrained
> models (that is Rung 15, a separate future direction, with no code in this package).

**Follows `ADR-007` (FDRS experiments workflow): pre-registration before results, negatives first-class,
controlled comparison + exact arithmetic as the gate, honest novelty positioning. Inherits the standing
posture of `ADR-008` (FDRS = connection + curation + verified artifact; never "FDRS-novel"; no claim ahead of
the gate).**

- **Registry ID:** `experiment-fdrs-attention-mixed-radix` (proposed; G0 needs the registry entity + human approval — see *Next steps*)
- **Scientific status:** **`cross-checked` within synthetic scope only** — controlled comparisons, exact lenses,
  adversarial sharpness/shape/shuffle/wrong-chart controls, and causal interventions, all on tasks of known
  structure; **speculative** as to any real-model relevance (Rung 15). The value-arithmetic lens is a frozen
  **null**; the positional (mixed-radix) lens is the positive, causal result. See `SUMMARY.md`.
- **Parent:** `project-fdrs-formal` / `program-fdrs-core`. Sibling of `experiment-fdrs-adaptive-attention`
  (which asks the *opposite-direction* question — see *Honest positioning*).
- **Workspace:** `workspace-math-proof-env` (**SageMath** — exact rational reconstruction, factorization,
  p-adic valuations, continued fractions, mixed-radix lifts; this is the "number-theoretic probe" half of
  ADR-007). Landscape **capture** reuses the Rust/Burn attention machinery from `fdrs-adaptive-attention` /
  `fdrs-gpu-numerics` (`AttentionPlan`, the M3 reference attention) to emit Q/K/V/score/weight/accumulator
  tensors as exact-or-high-precision dumps. **No Python as the main implementation** (repo rule); Sage is the
  spectroscopy engine, Burn is the substrate.
- **Owner:** `volition-billy`
- **Risk class:** low (internal, exploratory; observational only; no architecture change, no external
  commitment, no IP disclosure). The *epistemic* risk — false structure — is high and is the whole subject of
  the safeguards below.

---

## 1. Abstract

Ordinary ("vanilla") softmax attention and linear attention both produce **scalar landscapes**: query/key/value
projections, dot-product scores, kernel/feature-map values, softmax normalizers and denominators,
attention-weight rows, linear-attention accumulators (`S_t`, `z_t`), and output values. Each scalar is not only
a floating-point number but also has **arithmetic representations** — an exact rational reconstruction, a
factorization, a p-adic **valuation vector**, a **continued-fraction** expansion, and **mixed-radix coordinate
lifts** into FDRS-style product/prefix gauges. This project asks, **observationally**, whether those arithmetic
shadows contain **stable, non-random structure** across heads, layers, tokens, prompts, models, and tasks — or
whether they are fully explained by IEEE-754 representation, quantization lattices, and the matched random
baseline. We build the spectroscopy in **exact arithmetic** (Sage), run it first on a tiny deterministic
example, then on matched **random baselines**, then on real small models across **precision formats**, and
gate every structural claim on a pre-registered **baseline-adjusted signal**. The deliverable of a *successful*
project is a clean decomposition — *here is what is hardware, here is what is quantization, here is what (if
anything) is model-induced* — plus, only if the signal survives, candidate FDRS definitions and `proof_wanted`
targets for `fdrs-formal`. A *successful* project may equally conclude **no model-induced arithmetic structure
survives baseline**; that is a first-class result, not a failure.

## 2. Motivation — why "scalar landscapes," and why lift them

Attention is, mechanically, a pipeline of scalar-valued arrays. Listing them as **landscapes** (indexed fields
of scalars) makes explicit that each stage is a candidate object of arithmetic study:

| Landscape | Definition (per head/layer) | Exact? |
|---|---|---|
| **Projection** Q/K/V | `X·W_{q,k,v}` | exact-rational if `X,W` rational |
| **Score** `S = QKᵀ / √d` | pre-softmax similarities | **exact-rational** if `d` is a perfect square (rational scale) |
| **Kernel / feature-map** `φ(Q), φ(K)` | linear-attention features | **exact** iff `φ` is polynomial/rational; transcendental (e.g. `elu+1`) otherwise |
| **Normalizer / denominator** | softmax `Σ exp(S)`; linear `zₜ = Σ φ(kₛ)` | softmax: **transcendental**; linear: **exact** with rational `φ` |
| **Attention-weight** row `p` | `softmax(S)` row, `Σ pᵢ = 1` | **transcendental** (involves `e^x`) — reconstruct via approximants |
| **Accumulator** `Sₜ = Σ φ(kₛ)vₛᵀ`, `zₜ` | linear-attention running state | **exact** with rational `φ` |
| **Output** `o` | `p·V`, or `Sₜφ(qₜ)/(zₜ·φ(qₜ))` | depends on the stage above |

The **lift** rationale, stated carefully (this is the conceptual spine; see also `GLOSSARY.md`):

1. **Vanilla attention already creates these landscapes** — no architecture change is needed to study them.
2. **Finite machine values already have arithmetic representations** — every finite IEEE-754 value *is exactly*
   a dyadic rational `m·2^e`. So a "rational shadow" always exists; **its existence is trivial and means
   nothing on its own.**
3. **These representations can be lifted** into factor, valuation, continued-fraction, and mixed-radix forms —
   the FDRS machinery (`ℛ^(k)`, product/prefix gauges, valuation vectors, the factorization lens) is exactly a
   vocabulary for such lifts.
4. **The nontrivial question is whether the *profiles* show stable structure beyond hardware artifacts,
   quantization artifacts, or random baselines.** This is the only question the project actually asks.

The reason it is worth asking at all: softmax rows are **partitions of unity** (`Σ pᵢ = 1`), and FDRS already
has a precise theory of *finite arithmetic volume partitioned by observed symbol* — the **partition law**
(`setMass_partition`) and **interface balance** (`issued = consumed + pending`). If a normalized attention row,
rationalized to a shared denominator, behaves like an FDRS mass partition with recurrent gauge structure, that
is a genuine (and surprising) connection. If it behaves exactly like a random partition at matched precision,
that is the more likely truth and we report it.

## 3. Core definitions (summary — full versions in `GLOSSARY.md`, formal sketches in `THEORY.md`)

Terms marked **[FDRS]** already exist in `fdrs-formal` (use as-is); **[NEW]** are proposed for this project and
must be justified, not assumed.

- **scalar landscape** [NEW] — an indexed field of attention scalars (a tensor slice at fixed layer/head over
  token positions), the unit of analysis.
- **arithmetic shadow** [NEW] — umbrella for a scalar's arithmetic representations (rational / factor / valuation
  / CF / mixed-radix); the multi-lens view. See *representational vs computational participation* in §5.
- **rational shadow** [NEW] — the exact rational value of a finite machine scalar (always dyadic, denominator
  `2^k`) *and/or* its best rational **approximant** at a stated tolerance (a continued-fraction convergent
  `pₙ/qₙ`). **The distinction is load-bearing:** the raw shadow's denominator is always a power of two
  (hardware); non-trivial factor structure can only live in approximants, and even there must beat baseline.
- **factor participation** [NEW] — which primes occur (and at what multiplicity) in the numerator/denominator
  of a rational shadow, **after** the dyadic part is quotiented out (the FDRS `u_P`/`s_P` split applied with
  `2 ∈ P` removed or modeled separately).
- **valuation profile** [FDRS: *valuation vector* `v_P(n)`] — the tuple `(v_p)_{p∈P}` of p-adic valuations of
  numerator/denominator; its distribution over a landscape.
- **continued-fraction profile** [FDRS: CF timelines / homographic emission, Phase 13] — the CF expansion
  `[a₀; a₁, a₂, …]`, its partial quotients, convergents `pₙ/qₙ`, and the **depth** needed to reach a tolerance.
- **mixed-radix gauge** [FDRS: *product gauge* `β_ω`, *prefix gauge* Def 192] — a place-value system
  `B_m = ∏ b_i` (or a generated gauge) into which a rational is lifted as digits.
- **digit address** [NEW; FDRS-adjacent: *prefix* `s`, *prefix projection* `π_L`] — the mixed-radix coordinate
  tuple of a value in a chosen gauge; the project's name for the cylinder/prefix coordinate of an attention
  scalar.
- **row-gauge** [NEW; FDRS-adjacent: *partition law* `setMass_partition`] — for a normalized row, a shared
  denominator `D` (or gauge) such that `pᵢ ≈ cᵢ/D` with `Σ cᵢ = D`; the row becomes an **integer partition of
  arithmetic volume `D`**.
- **carry-completion event** [NEW; FDRS-adjacent: odometer carry, *interface balance*] — a normalization-induced
  complementarity, e.g. masses summing to a place-value boundary `cᵢ + cⱼ = B_m`. **Speculative**; defined so it
  can be *searched for and falsified*, not assumed to exist.
- **arithmetic spectroscopy** [NEW] — the method: viewing one scalar through several arithmetic lenses (factor,
  valuation, CF, mixed-radix) as distinct "spectral lines," and asking which lines are sharp (structured) vs
  broad (baseline-like).
- **baseline-adjusted factor signal** [NEW] — any landscape arithmetic statistic **minus** its matched-baseline
  expectation, in baseline-σ units. **The only currency in which a structural claim may be stated.**

## 4. Main research questions (each is a *bet against* the baseline)

Phrased so each has a clean null. The default answer to every one is "no, it is baseline" until a pre-registered
margin is cleared.

- **RQ1 (factor stability).** Do attention scalar landscapes exhibit **factor-participation profiles** that are
  stable across tokens/heads/layers *and distinguishable from matched random tensors*?
- **RQ2 (level specificity & flow).** Are particular primes/valuations **over-represented at specific landscape
  levels** (scores vs weights vs accumulators) beyond baseline — and does factor participation change
  *predictably* as profiles flow Q/K/V → score → weight → normalizer → accumulator → output (the
  `landscape arithmetic flow`)?
- **RQ3 (artifact separation).** Are any such profiles distinguishable from pure **floating-point** structure
  (the 2-adic/dyadic certainty) and from **quantization** lattices?
- **RQ4 (shared row-gauge).** Do rational approximants of normalized rows produce **shared denominator / gauge**
  structure (a recurrent `D`) more than matched random partitions do?
- **RQ5 (arithmetic volume).** Can attention rows be read as **partitions of finite arithmetic volume**
  (FDRS partition law) with non-trivial, recurrent digit structure?
- **RQ6 (digit-address structure).** Do **mixed-radix digit addresses** reveal stable token/head/layer
  structure (clustering, low-entropy coordinates) beyond positional/precision artifacts?
- **RQ7 (carry/complementarity).** Are there **carry-like or complementarity events** induced by normalization,
  at rates above a random partition?
- **RQ8 (semantic correlation).** Do **CF depth / denominator complexity** correlate with attention **sharpness,
  entropy, or downstream behavior** — *after* controlling for magnitude and precision, and beating baseline?
- **RQ9 (accumulator dynamics).** Do linear-attention accumulators **preserve, transform, or erase** arithmetic
  profiles over time `t`, relative to accumulating matched random vectors?
- **RQ10 (robustness).** Which profiles **survive** random / shuffled / randomized-weight baselines and
  precision changes (FP32/FP16/BF16/quant)? (This is not a separate question so much as the gate on all others.)

## 5. Non-goals and safeguards

### Non-goals (pre-committed)
- **Not a new attention mechanism.** No architecture change, no training objective, no "FDRS attention." If a
  rung ever tempts a mechanism, it is **out of scope** and forks to a *separate* charter (cf. the sibling
  `fdrs-adaptive-attention`, which is the mechanism-direction experiment and is explicitly *not* this one).
- **Not a performance/efficiency claim.** No timing, no FLOPs.
- **Not a claim that "attention is mixed-radix."** Mixed-radix lifts *always exist* for finite values; existence
  is content-free. We study *profiles*, never existence.
- **Not a claim that arithmetic structure is automatically meaningful.** Structure in a *representation* is not
  structure in the *computation* until the baseline gate and the artifact controls both pass.

### Safeguards against false structure (the load-bearing part — see `NEGATIVE.md` for the seeded fraud gallery)
These are the **gate**, not decoration. A finding that skips any applicable control is rejected, not patched.

**The split everything serves — representational vs computational participation.** Two sources of arithmetic
structure must be separated (`GLOSSARY.md`): *representational* participation comes from how the machine stores
numbers (binary floating point privileges powers of 2; approximant reconstruction adds whatever the tolerance
forces) and is presumed **trivial**; *computational* participation comes from how attention operations transform
profiles across landscape levels and is the only **possibly meaningful** part. Every safeguard below exists to
subtract the former and expose the latter — a finding counts only as the *residual* (computational,
baseline-adjusted, precision-invariant).
- **Matched random tensors.** For every metric, generate random Q/K/V of identical shape *and matched
  distribution* (per-layer empirical mean/var), run identical spectroscopy, build the **null distribution**.
- **Shuffled landscapes.** Permute entries within a landscape (and permute token order) to break any
  positional/structural signal while preserving the value multiset — catches "structure" that is really the
  value histogram.
- **Randomized model weights.** Re-initialize the model's weights (matched init), keep architecture and inputs;
  any profile that persists is **architecture/number-system-induced, not learned**.
- **Precision sweep.** FP32 / FP16 / BF16 / and where feasible int8/int4 quant. A profile that *changes with
  format* is (at least partly) a representation artifact; one that is *format-invariant* is a stronger
  candidate. **Powers of two are presumed hardware** (IEEE-754 mantissa/exponent) and are quotiented out (the
  `u_P` 2-free part) before any factor claim; the 2-adic line is reported *separately* as the hardware control,
  never as a finding.
- **No gauge fishing.** Gauges are **constrained**, not searched for resonance: a gauge is admissible only if it
  is (a) the row's own shared denominator, (b) fixed by row-normalization, (c) an FDRS-defined product/prefix
  gauge, or (d) pre-registered. Any multi-gauge scan reports the **number of gauges tried** and applies
  multiple-comparison correction; an unconstrained "try radices until one lights up" is a fraud-gallery entry.
- **Exact lens / float substrate, tags propagate.** The spectroscopy itself runs in **exact** arithmetic (Sage
  rationals/integers) so the lens adds no rounding; but the model output is `float`, so by ADR-007 decoration
  composition **the structural claim is `float`-tagged** and gated by the baseline comparison. Rung 0 (exact
  inputs, rational/linear attention) is genuinely `exact`/`enclosure` and is the only place an exact statement
  about the *arithmetic of attention* can be made.

## 6. Theory track (full sketches in `THEORY.md`)

`fdrs-formal` supplies the vocabulary; **no new mathematics is claimed** (ADR-008 posture). The track has two
halves:

**(a) Existing FDRS items this project leans on** (with their Lean homes):
- mixed-radix representations `ℛ^(k)`, place values `B_m` (Def 1–4; `Core/Primitives/RadixSeq.lean`)
- **product/prefix gauges** `β_ω`, `prefixGauge` (Def 192, Prop 147; `SyntheticPlace/GaugeUltrametric.lean`) →
  *mixed-radix gauge*, *row-gauge*
- **cylinder sets** `U(s)`, ball = cylinder, clopen basis (Def 8, Prop 5) → *digit address* / neighborhoods
- **valuation vector** `v_P`, **factorization lens** `Λ_P`, P-smooth/P-free split `u_P·s_P` (Def 44/46,
  Thm 25) → *valuation profile*, *factor participation*
- **additive vs multiplicative filtration** + the cylinder-measurability bridge and its generic
  **non-commutation** (Thm 21) → whether mixed-radix *digit* structure (additive) aligns with *factor*
  structure (multiplicative) in a landscape; FDRS says **generically it does not**, which is a sharp prior.
- **partition law** `setMass_partition` and **interface balance** `issued = consumed + pending` (SU4a, Phase 14;
  `SyntheticPlace/Conservation.lean`) → *row-gauge*, *arithmetic volume*, accumulator conservation
- **homographic / bihomographic emission**, four-corner trap (Def 188/189, Thm 82; `VariableRadix/…`) → CF
  profiles, *carry-completion*
- **refinement embeddings**, digit-conditional refinement (Def 20, Phase 11) → reblocking of digit addresses

**(b) Candidate new definitions to formalize *only if* the empirics survive baseline** (outlines, not code; the
task's nine names mapped to FDRS): `AttentionLandscape`, `ScalarLandscape`, `RationalShadow`,
`FactorParticipation`, `LandscapeValuationProfile`, `RowGauge`, `MixedRadixLift`, `GaugeStability`,
`BaselineAdjustedSignal`. Each is sketched in `THEORY.md` with its FDRS parent and a `proof_wanted` target for
`FdrsFormal/Conjectures/` (a directory ADR-007 specifies but which **does not yet exist** — creating it is a
G4 step, gated on a confirmed empirical claim, never before).

> **Note on FDRS's own silence on attention.** `fdrs-formal` contains **no** existing attention/ML connection
> (verified across both repo copies). The closest structural analogy it offers — block projections / detail
> operators as a multiresolution analysis on mixed-radix cylinders — is mathematical, *not* an ML claim. This
> project would be the first bridge, which is exactly why the baseline discipline must be maximal.

## 7. Experiment track — rungs (escalating; baseline-gated; screen-first)

The task's "Experiment 0–6" map to **Rungs 0–6**. Each rung gets its own pre-registration block (hypotheses,
acceptance, falsifiers) committed *before* its code; later rungs are **deferred and gated** on earlier ones.
Rungs 0–1 are necessary-but-not-sufficient screens; the real claims live in Rungs 3–4.

- **Rung 0 — tiny deterministic example (the exact anchor).** Hand-built Q/K/V (e.g. 3 tokens, `d=4` so `1/√d`
  is rational). Compute (i) **dot-product** scores (exact rationals), (ii) a **linear-attention** variant with a
  **rational polynomial feature map** `φ` (exact `Sₜ`, `zₜ`, outputs), and (iii) softmax weights (transcendental
  → reconstructed by CF convergents at a stated tolerance). Then *demonstrate every lens once*: rational
  reconstruction; factor numerators/denominators (with the dyadic part shown separately); CF prefixes;
  mixed-radix lift of selected values; and **row-normalization as shared arithmetic volume** (rationalize a
  softmax row to common denominator `D`, exhibit the integer partition `Σcᵢ = D`). **Tag:** `exact` (parts
  i–ii), `enclosure` (part iii). **Purpose:** make the objects concrete and the exact/approximant boundary
  unmistakable; no structural claim.
- **Rung 1 — random baseline (the null).** Random Q/K/V at matched shapes and matched distributions; identical
  spectroscopy; build null distributions for **every** Rung-≥2 metric (factor participation, denominator
  complexity, CF depth, valuation entropy, digit-address entropy, carry rate). Add a **dyadic-only null**
  (random dyadic rationals with the format's exponent distribution) to isolate the pure IEEE-754 contribution.
  **Gate-defining:** Rung 1 *is* the yardstick; no later rung may claim structure except as
  baseline-adjusted-σ against these distributions.
- **Rung 2 — real small model (the observation).** Capture landscapes from a small transformer (and a
  linear-attention model) across **layers, heads, tokens, prompts**. Compute baseline-adjusted profiles for
  RQ1/RQ2. **Necessary-not-sufficient:** any signal here must still pass Rung 3 (precision) before promotion.
- **Rung 3 — precision comparison (artifact separation).** Re-run Rung 2 capture under FP32/FP16/BF16 (+ int8/
  int4 where feasible). Decompose each signal into **format-variant** (artifact) and **format-invariant**
  (candidate) parts. **A signal that does not survive at least one precision change to a *coarser* format with
  attenuation consistent with model-induced (not representation-induced) origin is reclassified as artifact.**
- **Rung 4 — row-gauge analysis (the core positive bet).** For attention rows: reconstruct shared rational
  denominators / gauges (constrained, per §5); treat each row as a partition of arithmetic volume `D`; convert
  masses to mixed-radix **digit addresses**; search for **complementarity, carry-completion, digit clustering,
  and gauge stability** — each scored *baseline-adjusted* against random partitions of the same volume. This is
  where the FDRS partition law would, if anywhere, show up.
- **Rung 5 — linear-attention accumulator analysis.** With a rational `φ` (exact), inspect `Sₜ`, `zₜ`, outputs
  over `t`; measure how factor/valuation profiles **evolve**; test (RQ9) whether accumulation preserves,
  transforms, or erases signatures vs accumulating matched random vectors. Relate `zₜ` (running denominator) to
  FDRS **interface balance**.
- **Rung 6 — task / semantic correlation (most over-claimable; tightest gate).** Correlate baseline-adjusted
  arithmetic metrics with attention entropy, token type, syntactic role, retrieval/induction behavior, output
  sensitivity. **Only report correlations that beat baseline and survive magnitude+precision controls;**
  pre-register the specific correlations to avoid the garden of forking paths.

### The gate (how a rung "passes")
This is interpretability, so the gate is a **controlled comparison + exact lens**, not a single number:
- **Same everything, vary one thing:** same inputs/model/seed across baselines; only the randomization
  (shuffle / random-weights / random-tensor) or the precision format varies.
- **Distributions, not point claims:** many seeds/prompts; report effect sizes in baseline-σ, with CIs.
- **Pre-declared margin:** a metric "shows structure" only if baseline-adjusted signal ≥ a pre-registered
  threshold in ≥ a pre-registered fraction of seeds, *and* survives the precision control.
- **Exact where possible:** Rung 0 and the linear-attention/rational-`φ` paths are exact; lean on them as the
  non-exploitable anchor (ADR-007 exactness ladder).

## 8. Metrics (defined in `GLOSSARY.md` §Metrics; all reported **baseline-adjusted**)

factor participation count · normalized factor participation · valuation-vector entropy · denominator
complexity (bit-length of reduced `q`) · continued-fraction depth (terms to tolerance) · approximant stability
(robustness of `pₙ/qₙ` to ε-perturbation) · row-gauge shared-denominator score · digit-address entropy ·
carry/complementarity event count · layer/head factor-profile distance · **baseline-adjusted factor signal**
(the headline) · gauge stability across prompts · precision-sensitivity score.

## 9. Expected outputs / deliverables

**Drafted now (this scaffold), mapped to the task's deliverable list:**
- `README.md` — research outline + pre-registration (#1)
- `GLOSSARY.md` — terminology (FDRS-existing vs NEW) + metrics (#2)
- `source/stage0_demo.sage` — runnable tiny deterministic demo; prints every shadow and reproduces the worked
  example — **verified under Sage 10.9** (#3)
- `INSTRUMENTATION.md` — baseline harness design (#4) + real-model / precision / accumulator capture plan (#5)
- `ATLAS.md` — visualization / atlas plan (#6)
- `THEORY.md` — central object + worked example (§0), FDRS items leaned on, the **16 candidate definitions** +
  `proof_wanted` targets (#7)
- `NEGATIVE.md` — seeded fraud gallery + falsifier table — *exists before any run* (#8 risk register)
- `source/lenses.sage` — reusable 3-layer lens engine (exact / approximation-bound / residual-stub); **self-test passes**
- `registry-entity.draft.yaml` — proposed registry entity (G0); **drafted, NOT committed**, kept out of the live pipeline
- `results.md` — verdict-table template; `runs/_TEMPLATE/manifest.yaml` — provenance-triple template;
  `source/README.md` — source layout + the exact/float boundary

**Later (on execution, gated):** `source/baselines.sage` (null-model pipeline; fills the LAYER-3 residual hook),
`source/capture/` (Burn), `source/atlas.sage`; per-rung `runs/<date>-*/` with `manifest.yaml` + `transcript/`
(machine JSON + human summary + plots); and — *only if a signal survives baseline* — candidate FDRS definitions
promoted toward `FdrsFormal/Conjectures/`. Plus the running **open-questions/risks** ledger (`NEGATIVE.md`) and the
**local sources inspected** (below).

## 10. Proposed file layout

```
experiments/maths/fdrs-attention-mixed-radix/
  README.md            # this charter (G0/G1)
  GLOSSARY.md          # terminology + metrics
  THEORY.md            # central object + worked example, FDRS alignment, candidate defs, proof_wanted targets
  NEGATIVE.md          # fraud gallery + falsifier table (seeded pre-run)
  INSTRUMENTATION.md   # baseline harness + real-model/precision/accumulator capture plan
  ATLAS.md             # visualization / atlas plan
  results.md           # verdict table (template → filled)
  registry-entity.draft.yaml  # [EXISTS, DRAFT] proposed entity — NOT committed, NOT in the live pipeline
  source/
    README.md          # source layout + exact/float boundary
    stage0_demo.sage   # [EXISTS] runnable Rung-0 demo (verified, Sage 10.9)
    lenses.sage        # [EXISTS, sketch] reusable 3-layer lens engine (self-test OK)
    baselines.sage     # (later) Rung-1 null-model harness
    capture/           # (later) Rust/Burn landscape capture (no Python main)
    atlas.sage         # (later) plot/atlas generation
  runs/
    _TEMPLATE/manifest.yaml      # provenance-triple template
    <date>-rung0-tiny/           # (later) one dir per executed run
    <date>-rung1-baseline/
    ...
  evidence/            # (later) artifacts supporting promoted claims
```

## Status — ❄ FROZEN MILESTONE (Rungs 0–14, synthetic) · 2026-06-26 (see `SUMMARY.md`)

- [x] repository + conventions inspected; placement decided (experiment family, sibling of `fdrs-adaptive-attention`)
- [x] FDRS vocabulary aligned (no existing attention connection in `fdrs-formal` — verified)
- [x] charter + glossary + theory (w/ §0 worked example) + fraud gallery drafted
- [x] Stage-0 illustrative demo written + **verified running** (`source/stage0_demo.sage`, Sage 10.9) — no empirical claim
- [x] baseline/instrumentation plan (`INSTRUMENTATION.md`) + visualization/atlas plan (`ATLAS.md`) drafted
- [x] registry entity **drafted + validated** (`registry-entity.draft.yaml`) — proposed, NOT committed, kept out of the auto-materialization pipeline
- [x] lens engine **sketched** (`source/lenses.sage`) — exact-layer self-test passes; approximation layer needs explicit bounds; residual/baseline layer intentionally stubbed
- [~] **G0/G1 pre-registration committed** — user is handling the registry; execution proceeded by user direction. Runs kept registry-ready (manifest + transcript + results.md).
- [x] Rung 0 — illustrative exact demo (`source/stage0_demo.sage`)
- [x] Rung 1 — baselines / null distributions (`runs/2026-06-26-exploration/`); **representational floor confirmed exactly** (0/1536 raw weights non-dyadic)
- [x] Rung 2 — **Burn** 1-head attention trained on the house retrieval task (acc 0.315, realistic) — `runs/2026-06-26-burn/` (canonical substrate, reuses `fdrs-adaptive-train`); numpy toy = substrate cross-check (`runs/2026-06-26-exploration/`)
- [x] Rung 4 — row-gauge / arithmetic-volume: **first-class NULL on both substrates** — realistic model vs entropy-matched random all |z|<1; numpy toy's big signal was sharpness (`results.md`; NEG-1, NEG-2; `confound_atlas.png`)
- [x] Rung 5b — **training-dynamics spectroscopy + decisive shape-matched control** (`runs/2026-06-26-dynamics/`, Burn): the dynamics show a transient post-coalescence deviation the endpoint misses; the **full-shape-matched control collapses it 83–85%** ⇒ it is the **shape of focusing attention, not arithmetic geometry** (no prime/digit signal). Faint noisy `n_compl` residual is the only loose end. (`dynamics_atlas.png`, `shapematch_atlas.png`, results.md)
- [~] Rung 5 — linear-attention accumulators captured (numpy `random_linear`); deep drift analysis pending
- [x] Rung 7 — **radix-order / digit-channel spectroscopy** (porting exp73; `runs/2026-06-26-burn/`): rows as signals over positions, mixed-radix Haar, **vary radix ordering**. **POSITIVE (positional):** under block-aligned `[3,8]` the trained attention compacts to n90≈3, is additively separable (order-2≈0.002), and concentrates 99.5% in the within-block (role) digit — absent in shuffle/random. **The structure the value lens (Rungs 0–5) was blind to** — positional MRA geometry (radix *selection* essential), not value-arithmetic (`radixorder_atlas.png`, results.md)
- [x] Rung 8 — **block-size tracking** (porting exp73; `runs/2026-06-26-blocksize/`): train under B∈{2,3,4,6} (seq=24); does the best radix ordering track `[B,n_blocks]`? **PRIMARY tracking CONFIRMED 4/4** (best block-grouping = aligned ordering, heatmap diagonal); clean for B=3, delta-like/partial for B=2/4/6. *Radix selection recovers the changed positional factorization, even though value arithmetic stays null* (`blocksize_tracking.png`, results.md)
- [x] Rung 8b — **aggregation-task tracking (anti-delta)** (`runs/2026-06-26-agg/`, 4 sizes × 3 seeds): target = SUM of the marked block's bits, so single-token attention is insufficient (max-weight≈1/B, block-uniformity≈1.0, mask-all-but-one crashes). **CONFIRMED — radix selection tracks `[B,n_blocks]` 12/12 models**, aligned ordering *globally* best, order-2≈0 (separable), block-digit≈100%, oracle-bracketed (block-uniform→aligned, delta→flat). The clean version of Rung 8 with the delta loophole closed (`agg_tracking.png`, results.md)
- [x] Rung 9 — **latent-factorization discovery (blind)** (`runs/2026-06-26-latent/`): the analysis sweeps orderings *without being told the construction*. **DISCOVERY CONFIRMED** — Family 1 (hierarchical 24=2×3×4): blind best recovers the right granularity (`[4,6]` for the 2-level task, `[4,3,2]` for a genuine 3-level oracle, `[3,8]` for a wrong-grouping oracle — unbiased); Family 2 (interleaved): clean transpose recovered in raw order (`[6,4]`), random permutation recovered only under the correct chart (`[4,6]`, n90 2.85) ⇒ coordinate-chart sensitive. Synthetic; **no general-LM claim** (`results.md`)
- [x] Rung 10 — **per-head radix selection** (multi-head; `runs/2026-06-26-multihead/`): 3 heads each planted a different gauge (bs 2/3/4). **CONFIRMED 3/3** — each head's blind best ordering recovers its own gauge (`[2,12]`/`[3,8]`/`[4,6]`); 3×3 heatmap diagonal; controls clean. *Different heads carry different positional gauges* (`multihead_heatmap.png`)
- [x] Rung 11 — **unsaturated cover search** (regime 2; `runs/2026-06-26-cover/`): covering gauges B≥N + masked Haar + **penalized RadixScore** (rent for slack/axes). **CONFIRMED** — a `[5,5]` cover *discovers* a period-5 structure that **no factor of 24 can express** (n90 4.0 vs best-factor 7.8, wins after rent); the saturated `[4,6]` wins the block-of-4 control (covers penalized away → no gauge-fishing). Regime 3 (learned charts) is the open frontier (`cover_search.png`)
- [x] Rung 12 — **regime-3 constrained chart search** (`runs/2026-06-26-chart/`): generalize to charts (b, ι). **CONFIRMED** — recovers planted **stride charts** (s=7→`[4,6]`, s=11→`[3,8]`; beat row-major ~2–3×) that no ordering/cover can express, while staying simple for the period-5 cover (C) and the row-major negative control (D) — the `C_ι` rent prevents gauge-fishing. Recovers the *embedding*, not just the gauge (`chart_search.png`). Constrained family only (no 24! search); no general-LM claim
- [x] Rung 13 — **candidate head-wise chart hypotheses** (real-ish 2L×4H transformer; `runs/2026-06-26-transformer/`): modular task, periods hidden from analysis. **PROMISING (set-level)** — the per-head battery recovers the latent `{[3,8],[4,6],[5,5]}` charts as control-surviving candidates (concentrated in layer 0), rejects 7/8 diffuse heads; per-head-ID assignment is seed-unstable (head-permutation). Charts = hypotheses, not ground truth; no general-LM claim (`results.md`)
- [x] Rung 14 — **causal validation** (`runs/2026-06-26-intervene/`): ablate / chart-mask the chart-bearing heads of the Rung-13 transformer, measure per-mod specificity. **CAUSAL CONFIRMED** — ablating a period-P chart-head degrades mod-P specifically (specificity up to **193×**); destroying its residue-class structure crushes mod-P (≈1.0→0.2–0.3) while preserve retains and wrong-period/diffuse/full-ablation controls behave as expected; holds across 2 seeds matched by chart (head IDs permute). Charts are **causal, not merely descriptive**; synthetic, no LM claim (`summary_intervene.txt`)
- [ ] Rung 15 — **separate future direction, NOT part of this milestone:** pretrained-model candidate chart hypotheses, **strictly descriptive unless the Rung-14 intervention protocol is actually run**. Not merged into the frozen synthetic result; no pretrained-model code in this package (see `SUMMARY.md`)
- [ ] Rung 3 — precision sweep (open) · Rung 6 — semantic correlation (open)

## Next steps (to move from DRAFT to G2)

1. Human review of this charter; decide scope of Rung 2's "small model" (e.g. a tiny trained Burn transformer
   vs a captured open small LM) — pre-register the choice.
2. Register the entity: review `registry-entity.draft.yaml`, then (human-gated) copy it to
   `corp/registry/_staging/experiment-fdrs-attention-mixed-radix.yaml` → validate → materialize to
   `corp/registry/entities/` (flip `lifecycle:proposed` → `lifecycle:active`). The draft is deliberately kept
   out of the live `_staging/` auto-materialization pipeline until reviewed.
3. Commit the charter + entity (pre-registration) **before** any empirical-run code (`baselines.sage`,
   `capture/`, anything emitting `results.md`/manifests). The claim-free lens scaffold (`stage0_demo.sage`,
   `lenses.sage`) already exists and is gate-safe.
4. Build Rung 0 (exact) and Rung 1 (baseline) together — the anchor and the yardstick — and only then proceed.

## Local sources inspected

- `branches/hir/experiments/README.md` (experiment-family vs run; promotion criteria; naming)
- `branches/hir/experiments/maths/fdrs-adaptive-attention/{README,SUMMARY,NEGATIVE}.md` (charter template, fraud-gallery style, the sibling attention experiment)
- `branches/hir/experiments/maths/fdrs-adaptive-attention/runs/2026-06-19-rung3-router/manifest.yaml` (manifest provenance triple)
- `branches/hir/decisions/ADR-007-fdrs-experiments-workflow.md` (gates G0–G4, exactness ladder, scientific-status ladder, negatives-first-class)
- `branches/hir/decisions/ADR-008-fdrs-gpu-plan-algebra.md` (standing FDRS-for-ML posture; honest-broker line)
- `branches/hir/projects/fdrs-formal/README.md` + `docs/fdrs.md` + `FdrsFormal/` (FDRS vocabulary: `ℛ^(k)`, gauges Def 192/Prop 147, cylinders Def 8, valuation vector/factorization lens Def 44/46, partition law/interface balance, homographic emission Def 188/189, filtration non-commutation Thm 21)
- `branches/hir/projects/hydro-object-sim/{ROADMAP,DECISIONS}.md` (project-doc house style; runlog/manifest conventions)
- `branches/hir/REGISTRY-CONTRACT.md`, `OPERATING-MODEL.md` (registry entity shape, `scientific_status`, gate model)

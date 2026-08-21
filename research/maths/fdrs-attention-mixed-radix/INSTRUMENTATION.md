# Instrumentation & baseline plan — fdrs-attention-mixed-radix

How landscapes and baselines are produced and handed to the Sage spectroscopy engine. Covers deliverables
**#4 (baseline experiment design)** and **#5 (real-model instrumentation)**, plus the precision (Rung 3) and
accumulator (Rung 5) capture mechanics. **Plan only — no capture code is written yet; pre-registration gates it.**

> Design invariant (the whole reason the pipeline is shaped this way): the **lens is exact, the substrate is
> float**. Capture emits floats; the engine reconstructs each float's exact dyadic rational losslessly from its
> IEEE-754 bits, so no rounding is introduced by the analysis. Approximant shadows are a separate tolerance-tagged
> step. Every model claim is therefore `float`-tagged and gated by the baselines below.

## 0. Pipeline

```
  [capture: Burn/Rust]  --high-precision/bit-exact dumps-->  [engine: Sage]  -->  metrics (baseline-adjusted)
   model OR baseline                JSON/CSV                  lenses.sage          --> transcript/ + atlas
```

Capture and analysis are **physically separate** (ADR-007 / FunSearch pattern): the search/产 artifact (dumps)
and the certificate artifact (metrics + transcript) never live in one step.

## 1. Capture format (shared by all rungs)

Each captured scalar is stored **losslessly**, never as a re-printed decimal:
- raw IEEE-754 **bit pattern** (hex) + format tag (`fp64|fp32|fp16|bf16|int8|int4`) — the engine reconstructs the
  exact dyadic value from these bits.
- index metadata: `model_id, seed, prompt_id, layer, head, token_q, token_k, landscape_level`.
- `landscape_level ∈ {Q, K, V, score, kernel, normalizer, weight, accumulator_S, accumulator_z, output}`.

One row per scalar (long format) → a Parquet/CSV per `(model, prompt, format)`; a sidecar `manifest.yaml`
(provenance triple) per run. Engine reads, groups by `landscape_level`, applies lenses.

## 2. Baseline harness (Rung 1 — built BEFORE any model claim; deliverable #4)

The null models, each at matched shape and many seeds; these *define* the yardstick (`baseline-adjusted signal`):

| Baseline | Construction | Isolates |
|---|---|---|
| `matched-random` | Q/K/V ~ N(μ,σ²) with (μ,σ²) matched to the model's empirical per-layer stats | generic number-system structure |
| `dyadic-only` | random dyadic rationals with the format's exponent distribution | **pure IEEE-754 contribution** (the hardware floor) |
| `shuffled` | permute landscape entries + permute token order; preserve value multiset | value-histogram vs positional structure |
| `randomized-weights` | re-init model weights (matched init), same architecture + inputs | learned vs architectural structure |
| `dist-matched-synthetic-rows` | synthetic softmax rows drawn to match real entropy/sharpness distribution | row-gauge structure vs row-statistics |
| `quant-vs-noquant` | same computation int8/int4 vs fp32 | quantizer-imposed lattice vs model structure |

Output: per-metric null distribution `(mean, σ, quantiles)` per `landscape_level` × format. Sanity gate: the
baseline-adjusted signal of a *held-out baseline sample* must be ≈ standard normal (else the null is mis-estimated
and **no later claim is admissible** — NEGATIVE.md falsifier, Rung 1).

## 3. Real-model capture (Rung 2; deliverable #5)

**Model choice — pre-register one (README *Next steps* #1):**
- **(A) tiny trained Burn transformer (recommended for control).** Single-/few-head, few-layer, trained from
  scratch on a content-dependent synthetic task (reuse the `fdrs-adaptive-attention` retrieval task + machinery).
  Full control of weights, inputs, precision, and the `randomized-weights` baseline; no external dependency; pure
  Rust/Burn (repo rule clean).
- **(B) captured small open LM (for external validity, later).** Hook attention of a small pre-trained model;
  richer but introduces a Python capture dependency and less control. Defer until (A) shows a signal worth
  externally validating.
- A **linear-attention** model (rational-`φ` exact variant + a real `elu+1` variant) in both cases, for Rung 5.

**Hook points:** `Q,K,V` post-projection; `score` pre-softmax; `weight` post-softmax; `normalizer` (softmax
denominator); `output`; (linear) `accumulator_S`, `accumulator_z`. Per layer × head × token. Emit at the model's
working precision **and** an `fp64` reference pass on the same inputs (so Rung 3 has a high-precision anchor).

## 4. Precision capture (Rung 3)

Same model, same inputs, re-run under `fp64, fp32, fp16, bf16` (+ `int8, int4` where the backend supports it).
Emit bit-exact dumps per format. The engine decomposes each metric into **format-variant** (artifact) and
**format-invariant** (candidate) components. A signal that vanishes or tracks the format is reclassified as
representational, not model-induced (the §representational-vs-computational split, README §5).

## 5. Accumulator capture (Rung 5)

Linear attention `Sₜ = Σ_{i≤t} φ(kᵢ)vᵢᵀ`, `zₜ = Σ_{i≤t} φ(kᵢ)`, `yₜ = φ(qₜ)ᵀSₜ / φ(qₜ)ᵀzₜ`. Emit `Sₜ, zₜ, yₜ`
at **every** `t` (the time axis is the object of study). With the **rational `φ`** variant the entire stream is
`exact` (no reconstruction needed) — the cleanest place to ask whether accumulation preserves/transforms/erases
factor signatures (RQ9), against a matched-random-vector accumulation baseline. `zₜ` (running denominator) is the
natural site for the FDRS interface-balance reading (`issued = consumed + pending`).

## 6. Engine interface (`source/lenses.sage`)

Reads dumps → per scalar: exact dyadic shadow (from bits) → optional approximant shadow (tagged) → factor
participation (2-quarantined) · valuation profile · CF profile · denominator complexity · mixed-radix lift /
digit address (constrained gauges only) → per row: RowGauge (joint reconstruction, `Σcᵢ = D`) → per landscape:
distributions → **baseline-adjusted** against §2 nulls → metrics JSON for `results.md` + `atlas.sage`.

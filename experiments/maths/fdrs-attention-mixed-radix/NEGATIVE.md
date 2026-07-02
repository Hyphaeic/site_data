# Negative results & fraud gallery — fdrs-attention-mixed-radix

ADR-007 bounded-completeness: refuted hypotheses are reported at full weight, and the tempting-but-wrong spins
are written down so they cannot be quietly used. **This file is seeded BEFORE any run** — for an observational
study whose dominant risk is *false structure*, the fraud gallery is a pre-registration instrument, not a
post-hoc cleanup. It is the most important file in the family.

> **No negatives recorded yet — nothing has run.** Section 1 is the pre-seeded fraud gallery (spins to avoid).
> Section 2 is the pre-registered falsifier table (when each rung must report a null). Section 3 will hold actual
> NEG-N entries once runs exist.

---

## 1. Fraud gallery — spins this experiment must NOT be used to support

1. **"Attention is secretly mixed-radix."** FALSE by construction. Every finite IEEE-754 value *is* exactly a
   dyadic rational, so a mixed-radix lift *always exists*. Existence is content-free; the project studies
   *profiles vs baseline*, never existence. Any sentence of the form "attention has arithmetic structure"
   without "…beyond baseline B by margin τ" is this fraud.

2. **"Powers of two are over-represented — structure!"** FALSE. The IEEE-754 mantissa/exponent makes 2-adic
   structure a *hardware certainty* (see THEORY.md def 3: the float denominator's only prime is 2, provable).
   The dyadic part is quarantined (`u_P`, `2` separated) *before* any factor claim; the 2-adic line is reported
   as the hardware control, never as a finding.

3. **"We factored the float and found primes."** FALSE move. The *raw* float's reduced denominator is always
   `2^k` — factoring it yields only 2. Non-trivial primes appear only in **approximant** shadows (CF
   convergents), which are a *choice* of tolerance; their factor content must beat the matched-random AND
   dyadic-only baselines at the *same* tolerance, or it is an artifact of the approximation procedure.

4. **"Random tensors don't show this."** Must be *demonstrated*, not asserted — that is exactly Rung 1. If the
   matched-random or dyadic-only baseline shows the same profile, the signal is from the number system, not the
   model, and the claim is dead. Quoting a model statistic without its baseline is this fraud.

5. **"It survives across layers/heads, so it's real."** Cross-landscape consistency can be a shared *artifact*
   (same precision format, same dynamic range) rather than shared *structure*. Consistency must beat the
   shuffled and randomized-weights baselines, not just be internally repeatable.

6. **"Quantization reveals the true structure."** Inverted. Quantization *imposes* a lattice; factor/valuation
   structure measured post-quantization may be the *quantizer's*, by construction. Quant formats are an
   artifact-separation axis (Rung 3), never a structure-revelation tool. "int4 makes it cleaner" is a red flag.

7. **"CF depth correlates with attention sharpness/entropy."** Likely a trivial consequence of *magnitude and
   precision* (sharp rows have near-0/near-1 entries whose CF behavior is dominated by representation), not of
   semantics. Must control for magnitude and precision and beat baseline before any semantic reading (RQ8/Rung 6).

8. **"Mixed-radix digit addresses cluster by token type."** Could be positional or precision leakage. Requires
   the shuffled (token-order-permuted) control; a content claim that dies under permutation was positional.

9. **"A gauge lit up at radix r — the model uses base r!"** Gauge fishing. Gauges are constrained (row
   denominator / normalization / FDRS-defined / pre-registered) and any scan reports the number of gauges tried
   with multiple-comparison correction. An unconstrained search over radices until one resonates is the canonical
   "Coincidence and Fraud" pattern (numerology), explicitly forbidden (README §5).

10. **"Both the digits and the factors look simple in this gauge."** Suspicious *by FDRS's own theorem* (Thm 21:
    additive and multiplicative filtrations generically do not commute — THEORY.md Part C). Simultaneous
    simplicity is first a red flag for a shared artifact (both keying off the dyadic exponent), only second a
    candidate finding, and only after every control.

11. **"Linear-attention accumulators preserve the arithmetic signature."** Could be trivial: accumulating dyadic
    rationals yields dyadic rationals; `zₜ` growth is mechanical. Needs the matched-random accumulation baseline
    (Rung 5); "the signature persists" without "more than random accumulation does" is empty.

12. **"This shows attention does arithmetic / is interpretable as computation over ℚ."** Over-read. A structured
    *representation* of attention scalars is not evidence that the *computation* is arithmetic in any functional
    sense. The map is not the territory; this project measures shadows, and a shadow's structure is a fact about
    the lens until causal/behavioral evidence (Rung 6, gated) says otherwise — and even then, modestly.

13. **"This is a new (better) attention mechanism."** NON-GOAL and out of scope (README §5). This is observational
    interpretability of *existing* attention. Mechanism ideas fork to a separate charter (cf. sibling
    `fdrs-adaptive-attention`). Citing this family as a method is a category error.

14. **"Big baseline-adjusted σ at one cell."** Read the *distribution*, not the extreme cell. With many landscapes
    × lenses × gauges, large σ somewhere is expected under the null; only pre-registered metrics with
    multiple-comparison control count (cf. fdrs-adaptive-attention fraud-gallery #5, the high-SNR-cell trap).

---

## 2. Pre-registered falsifier table (when a rung MUST report a null)

| Rung | The bet | Falsified (report as first-class null) if… |
|---|---|---|
| 0 — tiny exact | the objects/lenses are well-defined and the exact/approximant boundary is clean | a lens is ill-defined or the "exact" path secretly rounds (then fix the lens, ADR-007 non-exploitable-verifier rule) |
| 1 — baseline | the matched baselines give stable null distributions | nulls are unstable / format-dependent in a way that makes any later σ meaningless — then no later structural claim is possible at all |
| 2 — small model | baseline-adjusted factor/valuation signal exceeds null by the pre-registered margin τ | model profiles are within seed-noise of matched-random (RQ1/RQ2 null) |
| 3 — precision | a Rung-2 signal is format-invariant (model-induced) | the signal vanishes or tracks the format (artifact); it is then reclassified, not defended |
| 4 — row-gauge | shared `D` / digit structure beats random partitions of the same volume | row-gauges are indistinguishable from random partitions (RQ4/RQ5 null) |
| 5 — accumulators | accumulator profiles differ from matched-random accumulation | accumulation is baseline-like (RQ9 null: accumulators erase/never had signature) |
| 6 — semantic | a pre-registered correlation beats baseline after magnitude+precision control | correlation is within baseline or explained by magnitude/precision (RQ8 null) |

A whole-project null — *"no model-induced arithmetic structure survives baseline"* — is an **expected and
publishable outcome**, not a failure. The clean decomposition (this is hardware, this is quantization, this is
nothing) is the deliverable either way.

---

## 3. Recorded negatives (NEG-N)

### NEG-1 — `QQ(float)` fabricates factor structure (tooling trap, caught) — fraud #3 realized

**Where:** first `analyze.sage` run, the "representational floor" check (`runs/2026-06-26-exploration/`).
**What happened:** `exact_machine_value` used Sage's `QQ(float)` to get the "exact" value. But `QQ(0.3162436…)`
returns `118819242/375720611` (denominator `7·19·2824967`) — a **continued-fraction approximation**, not the
exact dyadic. The floor check accordingly reported *all 1536* weights as having odd-prime denominators (mean
2-adic exponent 0.7) — i.e. it measured Sage's approximation and would have *fabricated* a representational
"factor structure" that does not exist in the stored value.
**Why it matters:** this is fraud-gallery #3 happening to the tooling itself — loose/implicit rational
reconstruction inventing structure. **Fix:** use Python `float.as_integer_ratio()` (exact dyadic, denominator a
power of two), guarded by a *type* check (a Python float satisfies `x in QQ`, so the `in QQ` shortcut also routed
floats back through the approximation). After the fix: **0/1536 odd-prime violations, 2-adic exponent 55–140** —
the floor is exactly dyadic, as it must be. Lesson: even the "exact" lens needs an exactness test
(`_selftest` now asserts the dyadic floor and that `QQ(float)` is *not* used).

### NEG-2 — the trained model's arithmetic signatures are attention SHARPNESS, not structure — fraud #7 realized

**Pre-registered (RQ1/RQ4/RQ6/RQ7):** do the model's attention rows show factor / digit / complementarity
structure beyond baseline?
**Result (`runs/2026-06-26-exploration/`):** against a **diffuse** random baseline the trained model looked
strongly "arithmetic" — digit-address entropy **z = −8.1**, CF depth z = −2.2, complementarity events where
random had none. **All of it vanished** against `random_sharp` (random rows tempered to the **same mean
row-entropy**): digit entropy z = +1.7, CF depth z = +0.4, complementarities z = −1.3 (model has *fewer*) — all
**|z| < 2**. The model attends near one-hot (0.08 bits vs 2.14 diffuse); near-{0,1} values are arithmetically
simple *by magnitude*, which is the entire effect. This is fraud-gallery #7 (CF depth / structure tracking
attention sharpness).
**Decomposition:** the only residual vs the sharpness control is `D_eff` (row-lcm denominator bits, z ≈ +3.5),
which is a magnitude/**shape** artifact — `random_sharp` matched *mean* entropy but not the full row shape, and
`D_eff` is dominated by the smallest masses' tail. Not factor structure; closes with a shape-matched baseline.
**Conclusion:** at this scale (one tiny single-head model, synthetic lookup task, one EPS, one gauge) there is
**no model-induced arithmetic / mixed-radix structure beyond the representational + magnitude floor** — the
pre-registered first-class null, and the FDRS-implied prior (THEORY.md Part C).
**Also logged:** within-row shuffle (`model_shuffled`) is a *useless* control here (value-multiset metrics are
permutation-invariant → identical to the model, z = 0); the entropy/shape-matched random baseline is the correct
one. `baseline_adjusted_signal` correctly *refused* to z-score against the zero-variance diffuse null for
complementarities (no spurious ∞).

**Burn confirmation (canonical substrate, `runs/2026-06-26-burn/`):** repeating Rung 2 with the model trained in
**Burn** on the house retrieval task gives a *realistic, non-degenerate* pattern (acc 0.315, row-entropy 3.29
bits — not one-hot). There the apparent signal is absent from the start: vs the entropy-matched control every
per-scalar and digit metric is **|z| < 1** (digit-entropy −0.95, CF-depth −0.29, n_odd_primes −0.01); only the
EPS-sensitive `D_eff` lcm is borderline (z≈−2.1) and the *wrong sign* (model lower). The numpy toy's −8σ was
purely its near-one-hot degeneracy. Both substrates agree on the null; the representational floor holds for
f64 (numpy) and f32 (Burn) alike.

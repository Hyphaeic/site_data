# SUMMARY — fdrs-attention-mixed-radix

> **Review-facing freeze doc.** The detailed log is `results.md`; the charter is `README.md`. This file is the
> defensible one-page statement of the milestone, its scope, and its single open frontier (Rung 15).

---

## ❄ MILESTONE FROZEN — synthetic program complete (Rungs 0–14) · 2026-06-26

The **controlled / synthetic** arc of this experiment family is complete and **frozen** as of 2026-06-26. The
verdicts in the table below, the scope box, and the value-arithmetic null are **locked**: no later work edits
them. Anything beyond this line (Rung 15+) is a **separate future direction** and is **not** merged into this
result. Registration of the registry entity remains the user's human-gated G0 step; these runs are kept
registry-ready (manifest + transcript + `results.md`).

**What is frozen:** the two-lens split, the nine verdicts, the five scope limits, and the reproduce recipe.
**What is *not* claimed:** anything about real / pretrained language models (see Scope).

---

## The defensible claim (one paragraph)

On **small attention models we trained from scratch on synthetic tasks with known latent structure**, ordinary
softmax attention contains **interpretable mixed-radix coordinate structure** that a blind, penalized search
recovers, that **tracks** the task's factorization when we change it, that **distributes across heads**, and that
is **causal** — surgically disrupting a head's recovered chart specifically degrades the matching capability (up
to ~193× per-output specificity). This is the **positional** lens (each attention row read as a *signal over
positions*, decomposed in a mixed-radix Haar/contrast basis with the radix ordering as a free parameter — the
in-house FDRS `exp73` method). The competing **value** lens (the arithmetic of the probability *numbers* — prime
factors, valuations, continued fractions) is **null** once a sharpness-matched control is applied, and that null
is frozen. **No claim is made about real or pretrained models.**

---

## Milestone verdict table (9 findings)

| # | Finding | Rung(s) | Verdict |
|---|---|---|---|
| 1 | **Value-arithmetic lens** (factor/valuation/CF of probability values) | 0–5 | **NULL** — collapses to the representational + sharpness floor; frozen |
| 2 | **Positional MRA lens** (radix-ordered mixed-radix Haar; exp73) | 7 | **POSITIVE** — block-aligned chart compacts trained attention (n90≈3, order-2≈0); absent in every control |
| 3 | **Saturated block-size tracking** (does the best chart follow `[B, n_blocks]`?) | 8, 8b | **CONFIRMED** — best chart = aligned ordering for all B; survives the anti-delta aggregation task (4/4 sizes × 3/3 seeds) |
| 4 | **Hidden-factorization discovery** (blind sweep, factorization not given) | 9 | **CONFIRMED** — recovers the latent factorization at the right granularity; chart-sensitive, unbiased |
| 5 | **Per-head gauges** (different heads, different planted gauges) | 10 | **CONFIRMED** — each head's best gauge = its own planted gauge (3/3) |
| 6 | **Unsaturated cover regime** (covering gauges `B ≥ N`, penalized RadixScore) | 11 | **CONFIRMED** — `[5,5]` cover discovers non-factor period-5 *after* paying slack rent; factor tasks still prefer saturated charts |
| 7 | **Constrained chart regime** (stride charts + embedding, regime 3) | 12 | **CONFIRMED** — recovers the *embedding* (stride), not just the gauge; no gauge-fishing |
| 8 | **Real-ish transformer hypotheses** (2L×4H, modular task, periods hidden) | 13 | **PROMISING (set-level)** — control-surviving charts = the latent mod-3/4/5 periods; diffuse heads rejected; per-head-ID seed-unstable |
| 9 | **Causal intervention validation** (ablation + residue-class masking) | 14 | **CONFIRMED** — disrupting a period-P chart-head drops mod-P *specifically* (up to 193×); preserve/wrong-period/diffuse controls behave correctly |

Two false-positive traps were caught live and recorded as **NEG-1** (`QQ(float)` fabricates factor structure) and
**NEG-2** (the trained model's "arithmetic" was attention *sharpness*, not structure). See `NEGATIVE.md`.

---

## Scope & limits (locked)

1. **Synthetic / controlled only.** Every positive result is on tasks we constructed and small models we trained
   from scratch. The latent structure was planted (or known) by us.
2. **No general-LM claim.** Nothing here is evidence about real or pretrained language models. That is Rung 15,
   deliberately out of scope for this package.
3. **Head IDs are seed-unstable.** Which physical (layer, head) carries which chart permutes across random
   inits. Findings are read at the **set level**, never bound to a fixed head index.
4. **Match by recovered chart, not head number.** Cross-seed and causal comparisons identify a head by the chart
   it recovers, never by its position in the network.
5. **The value-arithmetic null is frozen.** The positive results are entirely from the *positional* lens; the
   *value* lens remains null and is not reopened by any positional finding.

---

## Preliminary note (for a semi-technical reader)

*What we asked.* Transformer attention produces, for each token, a row of weights — "how much do I look at each
other token." We asked a narrow question: is there hidden **number-theoretic / mixed-radix** structure in those
weights, and is it real structure the model *computes* — or just an artifact of floating-point arithmetic and of
how sharply the attention happens to be focused?

*Two different ways to look.* We tried two lenses.
- The **value lens** asks whether the *numerical values* of the weights (their prime factors, continued
  fractions, and so on) carry structure. They don't: once you compare against a control matched for sharpness,
  every apparent signal disappears. This null is solid, and we are keeping it. (Getting here also caught two
  tempting ways to fool yourself, which we wrote down as negatives.)
- The **positional lens** asks something different: treat each attention row as a *signal over positions*, and
  ask whether there's a way to *re-index the positions* — a "mixed-radix chart," like reading a clock in
  hours-and-minutes instead of one long minute count — under which the row becomes simple. Here we found real
  structure.

*What we found, on controlled tasks we built.* When we train small attention models on tasks that secretly have
block or modular ("clock") structure, the attention organizes itself so that a matching coordinate system makes
it simple — and our blind search *finds that coordinate system without being told what it is*. It tracks the
structure when we change it; different heads pick up different pieces; and — the strongest result — when we
surgically disrupt the coordinate structure of one head, the model **specifically** loses the matching
capability. Break the "mod 5" head and only mod-5 accuracy collapses (by up to ~190×), while the other tasks are
untouched. So these coordinate charts are **causal**, not just a tidy description after the fact.

*What this is NOT.* Everything above is on **synthetic tasks we designed**, with **small models we trained**. We
make **no claim about real or pretrained language models**. Which physical head carries which chart **shuffles
from one training run to the next**, so we identify structure by the *chart it recovers*, never by a head number.
And the value-lens result stays **null**.

*Why it matters anyway.* It is a clean, falsifiable demonstration that attention *can* host recoverable, causal,
arithmetic-style coordinate structure — together with a disciplined method (penalized search, adversarial
controls, causal interventions) for finding it without fooling yourself. The obvious next question — whether any
of this appears in real pretrained models — is deliberately left as a separate future step.

---

## Rung 15 — separate future direction (NOT part of this milestone)

> **Pretrained-model candidate chart hypotheses — strictly descriptive unless intervention is run.**

The synthetic program shows the method works *where the answer is known*. The natural next step is to point the
same positional battery at a **real pretrained model** and report any control-surviving candidate charts. Held to
the same discipline:

- It is **strictly descriptive** — candidate hypotheses only — **unless** a causal intervention (the Rung-14
  ablation/masking protocol) is actually run on the pretrained model. No causal language without a causal test.
- It is **not merged** into the frozen synthetic result above. A descriptive observation on a pretrained model
  does not upgrade, qualify, or borrow the confidence of the synthetic causal findings.
- The same scope rules apply: set-level reading, match-by-chart, value-null frozen.

**No pretrained-model code exists in this package, by design.** Rung 15 is a marker, not a started rung.

There are now **two** orthogonal future tracks — (A) this pretrained-descriptive one, and (B) **exact integer
coupling operators** (compiling recovered charts into exact operators that replace float attention heads;
constructive, synthetic, builds on the positional positive — *not* the value null). Both are scoped in
`FUTURE-DIRECTIONS.md`; **neither is started**, and neither is merged into the frozen result above.

---

## Reproduce

Substrate: **Rust / Burn 0.21** (`Autodiff<NdArray>`) for training + attention capture; **SageMath 10.9** for the
exact lenses. No torch / transformers (repo rule). See `source/README.md` for the exact/float boundary.

```
# capture (Burn): trains the model + dumps landscapes.json into the matching run dir
cd source/capture && cargo run --release --bin capture_<scenario>      # e.g. capture_intervene
# analyze (Sage): reads the run dir, writes metrics_*.json + summary_*.txt
sage source/analyze_<scenario>.sage                                    # e.g. analyze_heads.sage
```

Each run dir under `runs/` holds `landscapes.json` (capture) + `metrics_*.json` / `summary_*.txt` (analysis).
The canonical value-lens null is `runs/2026-06-26-burn/`; the headline causal result is
`runs/2026-06-26-intervene/`.

---

## Inventory (this package)

- **Docs:** `README.md` (charter), `THEORY.md` (central object + candidate defs + Part E regimes + RadixScore),
  `GLOSSARY.md` (two lens families), `NEGATIVE.md` (fraud gallery + NEG-1/NEG-2), `INSTRUMENTATION.md`,
  `ATLAS.md`, `results.md` (full per-rung log, 579 lines), this `SUMMARY.md`, `registry-entity.draft.yaml`
  (proposed entity — not committed).
- **Sage analyzers (14):** `lenses.sage` (engine), `stage0_demo.sage`, `analyze.sage`, `analyze_shapematch.sage`,
  `analyze_dynamics.sage`, `analyze_radixorder.sage`, `analyze_blocksize.sage`, `analyze_agg.sage`,
  `analyze_latent.sage`, `analyze_multihead.sage`, `analyze_cover.sage`, `analyze_chart.sage`,
  `analyze_heads.sage`, `atlas.sage`.
- **Burn capture (10 binaries):** `src/main.rs` + 9 scenario bins (`capture_blocksize`, `capture_agg`,
  `capture_dynamics`, `capture_interleave`, `capture_multihead`, `capture_cover`, `capture_chart`,
  `capture_transformer`, `capture_intervene`).
- **Run dirs (11 + template):** `2026-06-26-burn` (canonical null), `-exploration` (numpy cross-check),
  `-dynamics`, `-blocksize`, `-agg`, `-latent`, `-multihead`, `-cover`, `-chart`, `-transformer`, `-intervene`,
  `_TEMPLATE`.

---

## Status & provenance

- **Scientific status:** `cross-checked` **within synthetic scope only** — controlled comparisons, exact lenses,
  adversarial sharpness/shape/shuffle/wrong-chart controls, and causal interventions, all on tasks of known
  structure. **Speculative** as to any real-model relevance (that is Rung 15).
- **Exactness ladder:** lens = exact (Sage `QQ`, `float.as_integer_ratio()`); model substrate = `float`, so
  model-level numbers are `float`-tagged and reported baseline-adjusted. Only the representational floor is
  EPS-free.
- **Posture:** ADR-007 (pre-registration before results — note runs were directed ahead of the formal commit;
  reported conservatively) + ADR-008 (FDRS = connection + curation + verified artifact; never "FDRS-novel"; no
  performance claim).

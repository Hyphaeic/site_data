# SUMMARY — fdrs-chart-coupled-attention

> **Review-facing freeze doc.** Full per-rung log: `results.md`. Charter: `README.md`. Theory: `THEORY.md`.
> This file is the defensible one-page statement of the milestone, its scope, and its future work.

---

## ❄ MILESTONE FROZEN — chart-coupled-attention (B0–B5 + B2-followup + B3) · 2026-06-26

The constructive arc of this experiment is complete and **frozen**. The core claim, the five rung verdicts, and
the scope box below are **locked**: later work (B4, the dynamic-cell probe, a content-bearing task) does not edit
them. All results are on the **controlled synthetic modular transformer** (the sibling's Rung-13/14 model), 4
seeds, seeded/reproducible. Registration of the registry entity remains the user's human-gated G0 step; the runs
are kept registry-ready (`results.md` + run dirs).

**What is frozen:** the core claim, the 5 rung verdicts, the scope. **What is *not* claimed:** see Scope.

---

## Core frozen claim

> For positional/chart heads in the controlled modular transformer, recovered FDRS charts compile into **exact
> cylinder-membership support**. **Pure averaging is sufficient only in some models.** In many cases, the residual
> in-class weighting compiles to a **small 3–4-bit offset/Toeplitz table**; in a real minority, it **remains
> dynamic**. **Diffuse/non-chart heads do not compile**, except where ablation already shows the head is
> unimportant.

The constructive turn (from the sibling milestone): the sibling *recovered* the mixed-radix charts a float
attention head had learned and showed (causally) they are used; this experiment *compiles* a recovered chart into
an exact integer coupling operator that **replaces** the head — interpretability → compilation. The membership
(which positions a head pools over) is the robust, lossless compile; the within-class weighting is sometimes a
tiny static table and sometimes genuinely input-dependent; and the construction correctly **fails** on non-chart
heads.

---

## Milestone rungs (verdicts)

| Rung | What ran | Verdict |
|---|---|---|
| **B0** — construction | build `C₃,C₄,C₅` over [24]; verify `Cₚ(i,j) ⟺ i≡j (mod p)`; class sizes | ✓ **exact & verified** (`[8,8,8]`/`[6,6,6,6]`/`[5,5,5,5,4]`; C₅ = one-hole cover) |
| **B1/B2** — per-head replacement | replace one chart-head's attention with the exact coupling; per-input agreement, 4 seeds | **Outcome 2 dominant** (membership reproduces, pure-average does not); pure-`(b)` "lossless" hits partly **redundancy artifacts** → motivated the set-level fix |
| **B2-followup** — set-level | replace **all** same-period heads at once (by period, not ID); 12 cells | **MEMBERSHIP-ONLY CONFIRMED** — redundancy resolved in all 12 (wrong-coupling fails 0.18–0.33); membership `(c)` **lossless** (0.96–1.00 everywhere); pure averaging `(b)` sufficient in **6/12** only |
| **B5** — compile the weighting `w` | characterize/compile the in-class weighting; law ladder vs `(c)`, 12 cells | **PARTIAL** — **7/12** compile to an **offset/Toeplitz table, 3–4-bit quantizable**; **3/12 DYNAMIC** (input-dependent, no static table reproduces). Weight-variability ≠ output-dependence |
| **B3** — negative control | exact couplings must **fail** on diffuse heads; gated on ablation, 6 diffuse heads | **B3 PASSED** — 2 **load-bearing** diffuse heads not reproduced (best ≤0.93 < 0.98, non-positional); 4 unimportant (vacuous); **0 red flags** |

**Headline:** a **two-sided** result — positional/chart heads compile (membership exact and lossless; weighting
mostly a tiny quantized table); content/diffuse heads do not. The compiled operator for a chart head is **exact
cylinder coupling `C_P` + (mostly) a small 3–4-bit offset table** (`enclosure`/`exact` decoration); a minority of
heads keep an input-dependent residual (`float`).

---

## Scope & limits (locked)

- **Synthetic / controlled task only** (the modular mod-3/4/5 transformer; small models trained from scratch).
- **No pretrained-model claim.**
- **No universal "attention is coupling" claim** — only positional/chart heads; content heads do not compile (B3).
- **No pure-average claim** — pure averaging suffices in only some models/cells (6/12); membership, not averaging,
  is the robust compile.
- **No robotics-equivalence claim** — any cross-domain resonance is shared vocabulary/method, not a law.
- **B4 / gated coupling layer is future work.**
- **Content-bearing-task negative control is future work** (this task is purely positional, so most non-chart heads
  are unused rather than load-bearing-content; the strong content-head control needs a content component).
- **Dynamic-cell probe is future work** (what the 3 B5-DYNAMIC cells' `w` depends on).

---

## Preliminary note (for a semi-technical reader)

*The question.* The sibling project found that a trained attention head can carry a hidden "mixed-radix chart" — a
coordinate system (like reading a clock in hours-and-minutes) that says *which* other positions it pools together —
and that this chart is causally used. This experiment asks the next thing: can we **replace** that learned head
with an **exact, integer "coupling" operator** built from the chart, and have the model behave the same? If so,
the head was *compilable* — interpretability turns into compilation.

*What we found.* For the positional heads, the **membership** half compiles perfectly: replacing the head with
"pool exactly over the cylinder class the chart names" reproduces the model **per input**, robustly across seeds —
and using the *wrong* class breaks it. So the chart is exactly the support the head uses. The **weighting** half —
*how much* it weights each in-class position — is more varied: in most cases it's a tiny, shift-invariant table you
can store in **3–4 bits**; in some models even uniform averaging is enough; but in a real minority the weighting
depends on the input and can't be frozen into a fixed table. And — the control that completes the story — the
*non*-chart ("diffuse") heads **cannot** be compiled this way: the ones that actually matter resist every coupling
we tried.

*What this is NOT.* All synthetic, all small models we trained. No claim about real/pretrained models, no claim
that "attention is just couplings" (it isn't — content heads don't compile), no claim that plain averaging works
(it often doesn't). It's a clean demonstration that the *positional* part of attention, where it exists, can be
compiled to an exact integer operator — and a disciplined method (ablation gate, wrong-coupling, shuffle controls,
per-input agreement) for not fooling yourself.

---

## Future work (NOT in this package)

- **B4 — gated coupling layer:** a small/bounded gate over `{C₃,C₄,C₅}` (content stream selecting an exact chart
  route); does it recover full-task accuracy without per-head learned attention?
- **Dynamic-cell probe:** for the 3 B5-DYNAMIC cells, is the input-dependent `w` actually a *second chart* (another
  digit channel) rather than genuine content-dependence?
- **Content-bearing task:** the *strong* B3 negative control needs load-bearing content heads (a task with a
  semantic component), which a purely-positional modular task does not provide.

None of these is started; none is merged into the frozen result above.

---

## Reproduce

Rust/Burn 0.21 (`Autodiff<NdArray>`); no torch. Seeded, reproducible.

```
cd source/capture && cargo run --release        # trains 4 seeds; runs B0, B1/B2, B2-followup, B5, B3
```

Writes `runs/2026-06-26-couple{,-setlevel,-weighting,-b3}/` (each: `summary_*.txt` + `metrics_*.json`). The model,
task, and chart-head identification are reused verbatim from the sibling's Rung-13/14 transformer.

---

## Inventory

- **Docs:** `README.md` (charter + pre-registered protocol), `THEORY.md` (exact coupling operator ladder, FDRS
  parents, `ChartCompile`, Part C commutant prediction), `NEGATIVE.md` (8 traps + falsifier table), `results.md`
  (full per-rung log), this `SUMMARY.md`, `registry-entity.draft.yaml` (proposed; not committed).
- **Code:** `source/capture/` (one seeded Burn binary: train + B0 + per-head B1/B2 + set-level B2-followup + B5
  weighting ladder + B3 negative control).
- **Runs:** `runs/2026-06-26-couple/` (B0 + per-head), `-couple-setlevel/` (B2-followup), `-couple-weighting/` (B5),
  `-couple-b3/` (B3).

---

## Status & provenance

- **Scientific status:** `cross-checked` **within synthetic scope only** (4 seeds, seeded/reproducible; adversarial
  controls — wrong-coupling, shuffle-in-class, ablation gate; corroborates the sibling's Rung-14 causality at the
  membership level). **Speculative** as to any real-model relevance.
- **Decoration:** B0 construction `exact`; model comparison `float`. The compiled operator (exact membership +
  quantized offset table) is `enclosure`/`exact` for the ~7/12 static cells; the dynamic residual keeps `float`.
- **Lineage:** input = the frozen sibling `experiment-fdrs-attention-mixed-radix` milestone (builds on its
  positional positive, not the value null; does not merge into it; corroborates its Rung-14 causal reading).
- **Posture:** ADR-007 (pre-registration before each run — runs were user-directed ahead of the formal commit,
  reported conservatively) + ADR-008 (connection + curation + verified artifact; never "FDRS-novel"; no
  performance claim).

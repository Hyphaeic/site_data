# fdrs-chart-coupled-attention — can a recovered positional chart be *compiled* into an exact integer coupling that replaces a float attention head? (charter)

> **Working title:** *Chart-Coupled Attention — Exact Integer Coupling Operators from Recovered Charts.*
> **Alternate names** (pick at registration): *FDRS Exact Coupling Operators*, *Integer Chart Attention*.
> **Posture:** a **constructive** experiment. Where the sibling `fdrs-attention-mixed-radix` *recovered* the
> mixed-radix coordinate charts a float attention head had learned (and showed, causally, that they are used),
> this experiment asks the next question: **can that recovered chart be compiled into an exact integer coupling
> operator that replaces the head with no loss of behavior?** If yes, the structure was *compilable out of
> floating-point attention* — interpretability becomes compilation.

> **❄ MILESTONE FROZEN (B0–B5 + B2-followup + B3, synthetic) · 2026-06-26 — see `SUMMARY.md`.** Charter +
> pre-registered protocol; B0–B2, the set-level B2-followup, B5, and the B3 negative control executed by user
> greenlight, ahead of the formal G0/G1 commit; reported conservatively and kept registry-ready (`results.md`,
> seeded/reproducible). The frozen claim, rung verdicts, and scope live in `SUMMARY.md`. Registration of the
> registry entity remains the user's human-gated step. Scope strictly **synthetic**. Per ADR-007 the
> pre-registration becomes binding on commit; each protocol step was fixed *before* its run.

**Follows `ADR-007` (pre-registration before results; negatives first-class; controlled comparison + exact
arithmetic as the gate; honest novelty) and `ADR-008` (FDRS = connection + curation + verified artifact; never
"FDRS-novel"; no performance claim).**

- **Registry ID:** `experiment-fdrs-chart-coupled-attention` (proposed; G0 needs the registry entity + human approval)
- **Scientific status:** **`candidate`** (B0–B2 + B2-followup run; synthetic; B0 construction `exact`, model
  comparison `float`-tagged; seeded/reproducible, 4 seeds). Result: **MEMBERSHIP-ONLY CONFIRMED** at set level —
  exact cylinder membership compiles **losslessly** (operator `(c)`, 0.96–1.00 across all 12 seed×period cells; 
  redundancy resolved, wrong-coupling fails); pure averaging `(b)` suffices in only **6/12** cells (the within-class
  weighting `w` is load-bearing in the rest). No "lossless pure coupling" claim. **B5 (PARTIAL):** where `w`
  compiles (**7/12**) it is an **offset/Toeplitz table, 3–4-bit quantizable** — so the compiled operator (exact
  membership + a tiny integer table) reaches an `enclosure`/`exact` decoration, a *stronger* ceiling than the fully
  `float`-tagged sibling; **3/12** cells have **input-dependent `w` (DYNAMIC)** that keeps a `float` tag. **B3
  PASSED:** diffuse/content heads are **not** chart-compilable (load-bearing ones resist; rest are unimportant; 0
  red flags) — completing the two-sided thesis (positional heads compile, content heads do not) on this synthetic
  task.
- **Parent:** `project-fdrs-formal` / `program-fdrs-core`.
- **Input (lineage):** `experiment-fdrs-attention-mixed-radix` (the **frozen Rungs 0–14 milestone** — its
  recovered charts and its Rung-13/14 modular transformer are this experiment's *starting material*). Sibling of
  `experiment-fdrs-adaptive-attention`.
- **Workspace:** `workspace-math-proof-env` (SageMath — exact coupling construction, integer normalization,
  verification). Replacement + training reuse **Rust/Burn** (`fdrs-adaptive-train`; the Rung-13/14 transformer in
  `…/fdrs-attention-mixed-radix/source/capture/`). **No Python as the main implementation** (repo rule).
- **Owner:** `volition-billy`
- **Risk class:** low (internal, synthetic, exploratory; no external commitment). The epistemic risk — declaring a
  head "compiled" when accuracy matched for a trivial reason — is the whole subject of the controls (§5, NEGATIVE.md).

---

## 1. Thesis

The sibling milestone established (synthetic, controlled): a trained attention head can carry a **positional
mixed-radix chart** that a blind search recovers, and chart-aligned interventions show the chart is **causal**.
A coupling `C ⊆ [N]×[N]` defined by an exact **digit condition** (cylinder co-membership) is the natural
*constructive* dual of a recovered chart. This experiment tests the **compilability claim**:

> **For an attention head whose behavior is well-explained by a positional chart, replacing it with the exact
> integer coupling operator compiled from that chart reproduces its function — up to the value-quantization
> bound — and a head *not* so explained (content/diffuse) is *not* reproducible this way.**

That second clause is as important as the first: the method must **fail where it should** (content heads), or it
proves nothing.

## 2. Relation to the frozen milestone (what this does and does not inherit)

- **Builds on the POSITIONAL positive** (Rungs 7–14), **not** the value-arithmetic null. The value lens stays
  frozen-null and is never reopened here.
- **Does not merge into** the sibling's result. A compilability finding is a *different, stronger* claim
  (constructive) and is reported on its own ledger. It can, however, act as an **independent cross-check** of the
  sibling's Rung-14 causal reading: if exact couplings reproduce the masked heads, that corroborates causality;
  if they cannot, that is a real tension to record (see falsifiers, §4).
- **Reuses, does not rebuild:** the Rung-13/14 modular transformer (mod 3/4/5) and its recovered charts are the
  starting material — B0–B2 need no new model and no new data.

## 3. The object

An **exact coupling operator** replaces learned scalar similarity with exact chart membership
`Cᵣ(i,j) = [digit condition over the chart (b, ι)]` (e.g. `i ≡ j (mod p)`; `πk(ι(i)) = πk(ι(j))`). The membership
`Cᵣ` is **always exact**; what varies is the *aggregation inside the class* — and this is a **ladder of
increasingly expressive operators**, the rung that fits being itself a finding:

```
  (a) class sum           yᵢ = Σ_{j∈Cᵢ} vⱼ                         exact, unnormalized
  (b) pure class average  yᵢ = (1/|Cᵢ|) Σ_{j∈Cᵢ} vⱼ                exact; THE clean compilation target
  (c) mask + intra-weights yᵢ = (1/Zᵢ) Σ_{j∈Cᵢ} w(i,j) vⱼ          exact Cᵢ, small learned/fixed-point w
  (d) gate over couplings  yᵢ = Σ_r g_r(xᵢ) (1/|Cᵢʳ|) Σ_{j∈Cᵢʳ} vⱼ  content stream selects an exact route
```

`(b)` is the strongest result (membership *and* weighting compiled away). `(c)` is the plausible middle — the
head may use the **correct cylinder class but learned non-uniform weights inside it** — and is still a strong
result (exact class, small `w`). The chart-masked head (keep in-class weights, renormalize) *is* operator `(c)`
with the head's own learned `w`, so comparing `(b)` against the chart-masked head measures whether intra-class
weighting matters. `(d)` is the hybrid: a **content stream** beside a **chart stream** (deferred to B4). Full
definitions, FDRS parents (cylinders `U(s)`, partition law, interface balance), candidate Lean objects, and the
`ChartCompile` map are in **`THEORY.md`**.

## 4. Pre-registered protocol (the bets, with falsifiers)

Rungs `B0–B5`. Every comparison is **matched by recovered chart, not head ID** (the sibling's seed-instability
rule holds). Each rung names its falsifier — the observation that would kill the bet.

| Rung | Bet | Primary metric | Falsifier |
|---|---|---|---|
| **B0** — anchor (deliberately boring, claim-free) | build only `C₃,C₄,C₅` from the known Rung-13/14 charts; verify `Cₚ(i,j)=1 ⟺ i≡j (mod p)`; print class sizes | construction verifies; `\|Cᵢ\|` exact | n/a (demo; no model, no performance) |
| **B1** — fidelity vs masked head (**first**) | operator `(b)` pure-average reproduces the **chart-masked** head — *before* comparing to the raw learned head | **per-input agreement** (primary), per-mod acc Δ (secondary) | `(b)` ≠ masked head ⇒ chart causal but **not losslessly compilable** (a tension to record, not hide — see outcomes) |
| **B2** — 4-way replacement | learned / chart-masked / **exact `(b)`** / `(c)` mask+intra-weights, per head; record **which ladder rung** fits | **per-input agreement on held-out inputs** (NOT accuracy) | no rung up to `(c)` reproduces the head ⇒ outcome-3 null/tension |
| **B3** — scope boundary (must fail) | exact couplings **fail** on content/diffuse heads | acc drop on non-positional heads | couplings "match" *everywhere* ⇒ task trivial / metric leaks (NEG) |
| **B4** — gate selection | small learned gate over `{C₃,C₄,C₅}` recovers full-task accuracy | full-task acc; gate sparsity | only a high-capacity gate works ⇒ couplings aren't carrying it |
| **B5** — exactness ledger | with integer/fixed-point V, the operator is exact / bounded-rational | decoration tag achieved | float leaks in ⇒ tag stays `float` |

### Three pre-registered outcomes (no premature "lossless")

B1/B2 have **three** honest outcomes, not pass/fail. The experiment records *which*, and the operator ladder rung
that fits:

1. **Lossless / near-lossless** — operator `(b)` pure-average reproduces the head at a strict per-input threshold.
   The clean compilation: membership *and* weighting compiled away.
2. **Partial (intra-class weights)** — `(b)` fails but `(c)` (exact class `Cᵢ` + small learned/fixed-point
   `w(i,j)`) reproduces it. The head uses the **right cylinder class but non-uniform weights inside it**. Still a
   strong result — exact membership, small residual weighting.
3. **Null / tension** — even `(c)` / the chart-masked head does not reproduce the function, despite Rung-14 showing
   the chart was *causal*. An important tension (causal support ≠ sufficient for the function), recorded openly.

**Terminology discipline:** results are **`candidate-compilable`** until B1/B2 pass at a **strict per-input
agreement threshold** (pre-registered, e.g. ≥ 0.98 on held-out inputs). The phrase **"losslessly compilable" is
reserved** for outcome 1 at that threshold. The headline *if it lands* is: B2 (an exact rung `(b)`/`(c)` reproduces
the head **per input**) **and** B3 (couplings fail on content heads) ⇒ *"positional/chart heads are compilable into
exact cylinder-coupling operators; content heads are not."* Accuracy parity alone is **never** the headline (a head
can match accuracy while computing a different function — NEGATIVE trap #4).

## 5. Controls & discipline

- **Match by recovered chart, not head ID** (head permutation across seeds; ≥2 seeds).
- **Non-degenerate task only.** If uniform attention already solves the task, any coupling "matches" — the
  modular task is pre-checked non-degenerate (max-weight ≈ 1/B, aggregation required). (NEGATIVE trap #1.)
- **Wrong-coupling control.** `C₄` applied to a mod-3 head **must fail**; a coupling must beat the wrong one.
- **Per-input agreement, not just accuracy.** Same accuracy ≠ same function; require output agreement on held-out
  inputs, not only aggregate score. (NEGATIVE trap #4.)
- **Gate-capacity ablation.** Constrain and ablate the gate so a successful B4 is the *couplings'* doing, not a
  large gate's. (NEGATIVE trap #3.)
- **Normalization-leak control.** Integer normalization must not encode the label; shuffled-V / wrong-coupling
  pin this. (NEGATIVE trap #2.)
- **Exactness ladder (ADR-007):** coupling construction is exact (Sage); the float-model comparison is the only
  `float`-tagged part; with quantized V the operator side is `enclosure`/`exact`. Decoration composes weakest-tag.

## 6. Honest positioning (ADR-008)

The contribution would be a **connection + a verified artifact** (recovered chart → exact coupling, and the
measured fidelity), never "FDRS-novel attention." The honest claim is bounded: *"for heads well-explained by
positional charts, softmax attention can be compiled into exact chart couplings"* — **never** "attention is
couplings." **No performance claim** (this is not a speed/accuracy pitch; if anything it trades capacity for
exactness/legibility). Method pivots get their own ADR.

## 7. Scope & non-goals

- **Synthetic / controlled only.** Same as the sibling. No real/pretrained-model claim — that is the *other*
  future track (Track A, `…/fdrs-attention-mixed-radix/FUTURE-DIRECTIONS.md`), kept separate.
- **Not all heads.** Only positional/chart-dominated heads are in scope; content/semantic heads are explicitly
  out (and are the B3 negative control).
- **Robotics is analogy, not equivalence.** The "sparse system embedded in a larger admissible coordinate chart"
  resonance (local-map holes ≈ cover-volume holes) is shared *vocabulary/method*, not a proven law. Nothing here
  is evidence about a robot.

## 8. Status — ❄ FROZEN MILESTONE (B0–B5 + B2-followup + B3, synthetic) · 2026-06-26 (see `SUMMARY.md`)

- [x] direction scoped (sibling `FUTURE-DIRECTIONS.md`, Track B) and promoted to its own charter
- [x] **B0** — exact `C₃/C₄/C₅` construction + congruence verify (`runs/2026-06-26-couple/`)
- [x] **B1/B2** — per-head exact coupling replacement, per-input agreement, 4 seeds (seeded) → **Outcome 2 dominant** (16 informative heads need intra-class weights); pure-`(b)` "lossless" hits partly redundancy artifacts (flagged by wrong-coupling) → motivated the followup. See `results.md`
- [x] **B2-followup** — **set-level** same-period replacement (4 seeds × 3 periods; `runs/2026-06-26-couple-setlevel/`) → **MEMBERSHIP-ONLY CONFIRMED**: redundancy resolved in all 12 cells (wrong-coupling fails 0.18–0.33); membership `(c)` compiles **losslessly** (0.96–1.00 everywhere); pure-average `(b)` sufficient in **6/12** only (`w` load-bearing in the rest). No "lossless pure coupling" claim
- [x] **B5** — characterize/compile the intra-class weighting `w(i,j)` (`runs/2026-06-26-couple-weighting/`) → **PARTIAL**: where `w` compiles (**7/12 cells**) the law is **offset/Toeplitz (rank-1, shift-invariant), 3–4-bit quantizable** (LOW-RANK-COMPILED); **3/12 DYNAMIC** (`w` input/query-dependent, no static table reproduces `(c)`). Weight-variability ≠ output-dependence (CV doesn't predict compilability). Membership stays the robust compile. See `results.md`
- [x] **B3** — diffuse/content-head negative control (`runs/2026-06-26-couple-b3/`) → **B3 PASSED**: the 2 **load-bearing** diffuse heads are NOT reproduced by any coupling (best ≤0.93 < 0.98; partial fit non-positional), the other 4 are unimportant (vacuous), **0 red flags**. Clean positional/content separation. *Caveat:* the modular task is purely positional, so the strong "load-bearing content head" control needs a content-bearing task (future). See `results.md`
- [ ] **B4** (optional) — gate over the coupling library (content stream selecting an exact chart route)
- [ ] (optional) **dynamic-cell probe** — what does `w` depend on in the 3 DYNAMIC cells (a second chart vs genuine content)?
- [ ] (optional) **SUMMARY.md / milestone freeze** — core (B0–B5 + followup + B3) complete; available on request
- [ ] **B3** — diffuse heads must FAIL to compile (theory-predicted negative control; 2 diffuse heads already set aside)
- [ ] **B4** — gate over the coupling library
- [ ] G0 registry entity reviewed + committed (human-gated; user handles registry — `registry-entity.draft.yaml` drafted)

## File layout (planned)

```
  README.md                  (this charter + pre-registration)
  THEORY.md                  (exact coupling operator; FDRS parents; ChartCompile; candidate Lean objects)
  NEGATIVE.md                (compilation-specific false-positive traps + falsifier table)
  registry-entity.draft.yaml (proposed entity — NOT committed; user handles registry)
  source/                    (later, gated: Sage coupling construction + Burn replacement bins)
  runs/                      (later: B0–B5 run dirs)
  results.md, SUMMARY.md     (later: per-rung log + frozen statement)
```

## Sources inspected

- Sibling frozen milestone: `…/fdrs-attention-mixed-radix/` (`SUMMARY.md`, `THEORY.md` Part E, `results.md`
  Rungs 7–14; Burn `source/capture/{capture_transformer,capture_intervene}.rs`).
- FDRS backbone: `…/fdrs_formal/docs/fdrs.md` (cylinders `U(s)`, partition law, prefix gauges, interface balance);
  `…/Sage/fdrs_exp73*` (radix selection / digit channels — the recovered-chart lens).

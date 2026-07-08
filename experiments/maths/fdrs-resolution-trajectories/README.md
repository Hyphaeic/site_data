# Experiment: FDRS Resolution Trajectories (mass-carry routes through confluent rewrites)

**Charter stage (G0/G1). Pre-registered 2026-07-07, BEFORE code.** Successor family; sibling to
`fdrs-hj-singularities` (P1–P7), `fdrs-star-quotients`, `fdrs-value-semigroup`,
`fdrs-mcf-threefolds`. Rules: ADR-007, ADR-008.

## The move (what every prior family quotiented out)

Every closed family verified **endpoint** structure — values, gauges, totals — all invariant
under the order the process runs. P7 was the lone exception: the strict ledger
`issued = consumed + pending` is a *per-step* statement, non-vacuous only because pending is
nonzero mid-sweep. This family generalizes P7's move to the **trajectory space** of a confluent
resolution process, under a three-layer separation:

- **value layer** (abelian): endpoint — schedule-invariant, settled by the prior families,
  re-verified here only as the **control**;
- **flag layer** (combinatorial): which chart/filtration — settled by P3/P5;
- **process layer** (the new object): the **route** — carry cascades, deposit order, pending
  curves. Order-sensitive even when value and flag are fixed.

## Honest-scope (per-claim novelty grading)

This is the family closest to *contribution* rather than *curation* — but the route-space objects
are **not** without a home: they are Phase-14 §14.6 (`Def 199` schedules / trace equivalence /
projections; `Thm 91` the scalar trace-gauge no-go), which this family **geometrically instantiates
and numerically witnesses** (both are `❌ missing` / `⚪ excluded` in Lean). `F-novel` is graded
**per claim**: confluence (Newman), Castelnuovo calculus, the Noether recursion, Thm-89 remain
classical; a route statistic is stated as an **instance of / witness for a named corpus object**
(Def 199, Thm 91; H-T1d → Phase-9 `Def 149`/`Thm 61` carry-as-route) — never as new geometry. See
`results.md` "Corpus placement."

## THE GOVERNING FALSIFIER (stated before the hypotheses, deliberately)

**F-traj-invariant** — claiming a route statistic as a process-layer finding when it is derivable
from the endpoint (invariant under schedule permutation). E-5's lesson promoted to a design rule:
**every trajectory statistic ships with a mutant schedule demonstrated to change it.** A statistic
no schedule can move is a value-layer quantity in a costume; reporting it as dynamics **voids the
phase**. *Corollary (the Exp38 lesson):* any time-averaged / lag-collapsed co-occurrence object is
presumed value/flag-layer until a **lag-indexed or order-indexed** refinement is shown to vary.

---

## Phase T1 — Castelnuovo cascades (the anchor; dim 2, exact, cheap)

**Setup.** For a canonical chain `C` (all `aᵢ ≥ 2`) and a blow-up word `w` (interior blow-ups,
P2's machinery), `B = w(C)` contains `1`-entries (`−1`-curves). Castelnuovo reduction is confluent
back to `C` (P2, theorem-backed). **Battery is `B = w(C)` only** — words applied to canonical
chains — which guarantees clean confluence and excludes degenerate configs (`[2,1,2]→[1,1]→[0]`
never arises from a `w(C)`). The **reduction graph** `G(B)` is the DAG of chains reachable by
single contractions, rooted at `B`, sinking at `C`. A **schedule** is a contraction policy
(leftmost-`1`, rightmost, priority, adversarial). A **cascade** is a maximal run of forced
contractions — a contraction that drops a neighbor to `1` extends it (carry propagation).

**Hypotheses.**
- **H-T1a (control; expected HOLD).** Endpoint and path length are schedule-invariant: every
  maximal path in `G(B)` ends at `C`, length `|B|−|C|`, and `(n,q)` is preserved at every node
  (P2's oracle). Graded as the value/gauge control — a theorem (each contraction shortens by one),
  **never a finding**.
- **H-T1b (the process layer exists; expected HOLD).** Cascade-depth distributions / visited-state
  sets differ across schedules on the same `B`. The mutant demanded by `F-traj-invariant` is
  built-in: leftmost vs rightmost *is* the mutant pair. **Report the fraction of the battery where
  a schedule swap actually moves the profile** — not merely that it can.
- **H-T1c (route-space geometry; measured, OPEN).** Characterize `G(B)`: width (# intermediate
  chains), depth-profile per schedule, visited-state overlap. Pre-registered *question*, not claim:
  does any classical invariant of `(C,w)` predict the width, or is width process-native? Either
  answer recorded.
- **H-T1d (cascade ↔ carry; the FDRS placement).** The cascade is carry propagation: a contraction
  dropping a neighbor to `1` forces the next contraction. The corpus home is **Phase-9 `Def 149
  (carry-as-route)` / `Thm 61 (carry is overflow route)`** — recursive carry ≡ event-driven overflow
  routing. Castelnuovo reduction is its **time-reversed dual** (Phase-9 routes `+1` on overflow; a
  contraction routes `−1` on blow-down), so the placement is *carry-as-route up to the
  increment↔decrement duality* — the direction difference is the finding, not an open placement.

**Oracles.** Sage: brute-force enumeration of `G(B)` with `(n,q)`-preservation at every node (P2's
oracle reused). Rust mirror: schedule simulator + cascade logger, battery checksum pinned. All ℤ.

---

## Phase T2 — Coupling-order pending curves (extends P7)

**Setup.** P7 verified the strict ledger on one schedule (level-sweep). A **coupling route** is an
order of processing the shared resolution tree of a `≥3`-branch germ (level-sweep,
branch-incremental, interleaved, adversarial). The **pending curve** `p_s(t)` is the ledger's
pending term over step `t` under schedule `s` (**step-indexed, not time-averaged** — Exp38 lesson).

**Hypotheses.**
- **H-T2a (conservation is route-free; expected HOLD — control).** The strict ledger holds at
  every step of every schedule; totals agree with the Sage-native oracle (P7, quantified over
  routes).
- **H-T2b (pending curve is a route signature; expected HOLD).** `p_s(t)` differs across schedules
  on the same germ — same start (`issued`), same end (`0`), different debt trajectory. Statistics:
  **peak pending, time-to-half-discharge, curve shape**. Mutants: the P7 mis-crediting mutants +
  schedule swaps.
- **H-T2c (route extremes; measured, OPEN).** Which schedules extremize peak pending?
  Pre-registered *candidate* (to be tested, not assumed): **level-sweep minimizes peak pending**
  among natural schedules on satellite-heavy germs. If false, the true extremizer is the finding.

**Oracles.** P7's machinery reused verbatim; the only new code is the scheduler. Battery: the P7
3- and 4-branch germs + satellite-contact configs (P4 proximity).

---

## Phase T3 — Dim-3 cone scheduling (the prize; **GATE OPEN — M1 landed 2026-07-07**)

**GATE OPEN.** `fdrs-mcf-threefolds` M1 landed PASS (551/551, Sage↔Rust parity). T3 registers
against the **frozen M1 law** (the Ashikaga CF recursion for `1/r(1,a,r−a)`; reused, not modified).
The refinements below are pre-registered from M1's structure **before T3 code**.

**Setup.** The M1 anchor law is tree-shaped: each node emits the Oka center `C=(P₁+a₂P₂+a₃P₃)/r`
and recurses on **two disjoint, branch-independent** subcones; `r−1` emitting nodes, `2r−1` leaves,
each cone subdivided **exactly once**. A **schedule** chooses which active cone to subdivide next.
The **deposit stream** is the sequence of discrepancies `k/r` as centers are introduced, per schedule.

**M1-sharpened predictions (pre-registered).** M1's branch-independence + fire-once structure
partition the statistics *before* measurement:
- **No cascade signal exists — structurally.** Every cone is subdivided exactly once, so the
  "firing vector" is the all-ones vector: `T1`'s cascade-count layer is **degenerate here by
  construction**. Pre-registered so nobody hunts a cascade signal that cannot exist at the anchor.
- **Multiset / value-layer statistics are degenerate (schedule-free).** Branch-independence ⇒ the
  emitted-digit multiset, the discrepancy multiset `{k/r}`, and the tree shape are order-free. Any
  statistic derivable from the multiset is a **pre-registered negative** (the "degenerate route
  space at the terminal anchor" outcome, honestly predicted).
- **Working set and deposit order are LIVE (scheduling-pure).** Max active-cone count varies over
  even an uncoupled tree — DFS holds `O(depth)`, BFS holds `O(width)`; with `2r−1` leaves that is a
  real spread. Deposit **order** (order-indexed, not the multiset) varies with schedule. These are
  the T3 process-layer signals.

**Hypotheses.**
- **H-T3a (control).** Final fan, discrepancy multiset `{1/r,…,(r−1)/r}`, cone count, **and the
  all-ones firing vector** are schedule-invariant on the M1 battery (value-layer, graded as control).
- **H-T3b (deposit order + working set are route signatures).** Working set (peak active cones) and
  the order-indexed deposit stream vary with schedule (BFS/DFS/largest-gauge-first/adversarial); the
  **multiset-derived** statistics do **not** (degenerate — the honestly-predicted negative). Each
  "moves" claim ships its mutant (schedule swap); the degenerate ones are reported as value-layer.
- **H-T3c (scheduling theory).** Per-schedule working-set profiles over the battery: `BFS≈O(width)`
  vs `DFS≈O(depth)`. If — contrary to the prediction — even working set is schedule-invariant, that
  is the stronger **first-class negative** ("terminal anchor route space fully degenerate") and the
  question relocates to M2's non-terminal family (OB-1 debt). Either way, **the value layer is
  degenerate here by canonicity; the live process layer, if any, is pure schedule geometry.**

---

## Falsifiers (family-wide, seeded before code)

- **F-traj-invariant** — the governing one (above); every statistic ships with a firing mutant.
- **F-traj-average** — presenting a lag-collapsed / time-averaged object as process structure (the
  Exp38 instrument error, named).
- **F-traj-schedule-cherry** — route statistics from a single schedule without the pre-registered
  battery of schedules (cherry-picked dynamics).
- **F-traj-latency-leap** — reading cascade/pending/working-set statistics as physical timing (RTOS
  latency) without a cost model. Geometry supplies **structure, not milliseconds**; the RTOS reading
  is motivation, not a result of this family.
- **F-exact / F-novel** — all ℤ/ℚ; per-claim novelty grading (above).

## Success criteria

- **T1:** controls hold; cascade profiles shown schedule-dependent with mutants (+ battery fraction);
  `G(B)` characterized; H-T1d **placed at Phase-9 carry-as-route** (`Def 149`/`Thm 61`, up to the
  increment↔decrement duality).
- **T2:** ledger route-free; pending curves shown route-dependent; extremizer identified or the
  pre-registered candidate refuted.
- **T3 (post-M1):** controls hold; deposit-order signatures shown, or the degenerate-route-space
  negative recorded and relocated to M2.

## Status

- [x] Charter (this document) — pre-registered before code
- [x] **T1 (Castelnuovo cascades) BUILT (2026-07-07) — PASS.** `runs/2026-07-07-t1-cascades/`:
  H-T1a control holds (endpoint/length/`n` invariant — theorem); **H-T1b process layer real** —
  visited-state set moves 72%, cascade depth 5% (deep cascades) under the leftmost/rightmost mutant;
  **carry-step count & front peak are value-layer conservation laws (0% on 1247 B)** — the
  `F-traj-invariant` catch (route = dynamics, magnitude = value); H-T1c width process-native;
  H-T1d **placed at Phase-9 carry-as-route** (`Def 149`/`Thm 61`, up to increment↔decrement duality).
  Rust mirror 2/2.
- [x] **T2 (coupling-order pending curves) BUILT (2026-07-07) — PASS (corrected, erratum E-T2-1).**
  `runs/2026-07-07-t2-pending/`: H-T2a ledger route-free **and fully discharging** (`curve[-1]=0`, the
  previously-missing check) at every step of every *legal* schedule, total = Sage-native oracle.
  **H-T2b (CORRECTED):** the original "separation" (adv 6/13) was an **illegal-schedule artifact**
  (never-discharged pending); the original germs are **chains — 1 legal schedule each (route-vacuous)**.
  On **bushy** germs the signature is real but *functional- and germ-dependent* — bushy-4 peak-range
  **[7–10]** over 70 schedules; **bushy-5/6 peak-blind but curve-live** (peak invariant, 4/22 distinct
  curve shapes). **H-T2c RETRACTED** — BFS gives the *max* peak, DFS the min (reversed); replaced by the
  pending-favours-depth-first / working-set-shape-dependent trade-off. Rust `t2` upgraded from an
  illustrative toy to a **genuine germ-data mirror** (bit-matches Sage on all 6 germs). Rust 5/5 total.
- [x] **T3 (dim-3 cone scheduling) BUILT (2026-07-07) — PASS.** Gate opened by M1 (551/551).
  `runs/2026-07-07-t3-scheduling/`: reuses the **frozen M1 Ashikaga law**; H-T3a control holds
  (multiset `{k/r}`, cone count `r−1`, **all-ones firing vector** — value layer degenerate, **no
  cascade signal by construction**, as predicted); **H-T3b process layer = pure schedule geometry**
  (working set moves 59%, deposit order 85%; multiset 0%); H-T3c BFS=width/DFS=depth, neither
  dominates (80/60/103). Two review catches: a recursion bug (`r` vs current `rr`) and an over-strong
  `BFS≥DFS` assertion (Rust mirror caught it). Rust mirror +1 (5/5 total). M2 (OB-1) owed the
  value-relevant route question.

## References

Newman's lemma / abstract rewriting (confluence vs route structure); Isaksen, *A cohomological
viewpoint on elementary school arithmetic* (carry as a 2-cocycle) — H-T1d; the closed sibling
families (P2 reduction, P4 proximity trees, P7 ledger + mutants, M0/M1 anchor). FDRS corpus
(read-only): Phase 1 odometer/carry, Phase 9 walls, Phase 14 coupling + Thm 89 + Prop 148.

# Negative results & fraud gallery — fdrs-resolution-trajectories

Seeded **before code** (ADR-007). This family is the closest to contribution, so the traps are
sharper: the whole risk is dressing a value-layer quantity as dynamics.

## Fraud gallery — spins this family must NOT be used to support

1. **"Route statistic X is a process-layer finding."** VOID unless a **mutant schedule** is shown
   to change X. E-5's vacuity lesson as a design rule: a statistic no schedule can move is the
   endpoint wearing a costume. Every trajectory claim ships with its firing mutant or it does not
   ship (`F-traj-invariant`).
2. **"The (time-averaged / lag-collapsed) co-occurrence M shows route structure."** The Exp38
   instrument error. A collapsed `M` is presumed value/flag-layer; only a **lag-indexed** `M_τ`
   (or order-indexed statistic) that is shown to *vary* is process structure (`F-traj-average`).
3. **"Schedule s gives this cascade/pending profile" (from one schedule).** Cherry-picked dynamics.
   Route statistics require the **pre-registered battery of schedules**; a single schedule reports
   nothing about the route space (`F-traj-schedule-cherry`).
4. **"Peak pending / cascade depth = RTOS latency / working-set milliseconds."** The geometry
   supplies **structure, not timing**. Without a cost model, cascade/pending/working-set numbers are
   combinatorial, not physical. The RTOS reading is motivation, never a result (`F-traj-latency-leap`).
5. **"H-T1a (endpoint / path length invariant) is a finding."** No — it is the value-layer
   **control**, and its invariance is a theorem (confluence + one-node-per-contraction). Reporting
   the control as a discovery inverts the whole point of the three-layer separation.
6. **"Cascade = carry (proved isomorphism)."** H-T1d is a *placement*, not a proved identity. The
   home is now named — Phase-9 `Def 149 (carry-as-route)` / `Thm 61 (carry is overflow route)` — but
   Castelnuovo reduction is its **time-reversed dual** (blow-down routes `−1`; Phase-9 overflow routes
   `+1`). Asserting a strict identity that erases the increment↔decrement reversal, or matching
   depth-statistics not actually computed, is the fraud; the honest record is **"placed at Phase-9
   carry-as-route, up to the (real) direction duality."**
7. **"T3 delivered."** T3 is **GATED on `fdrs-mcf-threefolds` M1**. No T3 result exists until M1
   lands; any T3 number before then is fabricated.

## Falsifier table (T1+T2 landed 2026-07-07)

| ID | Fires when | Kills | Status |
|---|---|---|---|
| **F-traj-invariant** | a route statistic reported without a firing mutant schedule | the process-layer claim | **HONORED & LOAD-BEARING** — every process claim ships its mutant; **caught 3 value-layer quantities** (T1 carry count, front peak; T2 3-branch peak) masquerading as dynamics and reported them as value-layer |
| **F-traj-average** | a lag-collapsed/time-averaged object presented as process structure | H-T1b/H-T2b | **HONORED** — T2's `p_s(t)` is step-indexed, never time-averaged |
| **F-traj-schedule-cherry** | route stats from one schedule, no pre-registered battery | route-space claims | **HONORED** — batteries of schedules × objects; the shallow-battery cascade-depth false-negative was caught and a stress battery added |
| **F-traj-latency-leap** | cascade/pending/working-set read as physical timing w/o a cost model | the honest-scope contract | **HONORED** — peak pending / cascade depth are combinatorial; no millisecond claim |
| **F-traj-discharge** *(added by E-T2-1)* | a schedule's pending curve does not return to `0` (`curve[-1]≠0`) — deposits issued but never consumed | the ledger's route-freedom claim (H-T2a) | **NOW HONORED** — the previously-**missing** check; it catches the old illegal `adversarial` (`curve[-1]=6`). The founding rule "checks must be able to fail" turned on the checks themselves. |
| **F-traj-route-vacuous** *(promoted this round; FAMILY-WIDE)* | a route-statistic verdict reported without **≥2 legal schedules that separate ≥1 pre-registered functional** — count them AND report *which functionals they separate* in the run record (a count of 2 differing only by a symmetric-sibling swap is still vacuous) | any process-layer claim on that battery | **PROMOTED** — three instances of the same wall (T1 shallow battery hid cascade depth; T3 small-`r` trees collapse all schedules; **T2 chain shared-trees = exactly 1 legal schedule**) show an empty route space *precedes* any statistic. `F-traj-discharge` guards *illegal* schedules, this guards *vacuous batteries*; the "which functionals" clause guards the subtler vacuity where freedom exists but no *coarse* functional reads it (bushy-5/6: 34650 schedules, peak-blind, curve-live). |
| **F-exact** | any float in the rewriting / ledger / gauge arithmetic | the `exact` tag | **SILENT** — ℤ throughout (Sage + Rust) |
| **F-novel** | a route statistic stated as a new geometry theorem | per-claim novelty grading | **HONORED — strengthened.** The route objects are **corpus objects**, not novel: the family instantiates & witnesses Phase-14 §14.6 (`Def 199` schedules/trace-equivalence/projections; `Thm 91` scalar-no-go), and H-T1d is placed at Phase-9 `Def 149`/`Thm 61` carry-as-route. Both `❌ missing`/`⚪ excluded` in Lean ⇒ geometric witnesses for un-formalized theorems |

## Recorded negatives (bounded-completeness statements)

- **T1 carry magnitude is value-layer, not dynamics.** The carry-step count and carry-front peak
  are schedule-invariant (0% on 1247 B, incl. deep cascades) — a conservation law, **not** a
  process-layer statistic. Reported as value-layer, not sold as dynamics (the `F-traj-invariant`
  catch). **Follow-up now supplied (E-T1-1):** the conserved magnitude is `Σc = (|B|−|C|) − #ones(B)`
  by counting (total contractions = initial `−1`'s + created ones), schedule-free. The code's
  `mv_carrycount` measures *step-count*, which equals `Σc` only absent double-creations (`c=2`); none
  occur here (0 / 1247 `B`), so the observed invariant is the proved `Σc` law on this battery — a
  battery fact, distinguished in `results.md`.
- **T1 cascade depth is a false negative on a shallow battery.** It reads 0% on the base battery
  (no deep cascades to move); only the long-2-run stress battery surfaces the 5%. Coarse batteries
  can hide a real process-layer signal — a battery-adequacy negative.
- **T2 E-T2-1 — the missing-check catch (the family eating its own dogfood).** The shipped
  `adversarial` schedule sorted by `(group_size, depth)`, violating the ledger's parent-before-child
  contract (deep before root); a pair closed early while its root deposit landed later into a
  `pending` that was never consumed, so **the pending curve ended nonzero** — invisible because the
  one check that would catch it (`curve[-1]==0`) **did not exist**. A founding-rule violation *by the
  checks themselves*. The published H-T2b "separation" (adv 6, 13) *was* that never-discharged
  pending. **Compounded** by inadequate germs: the original 3/4/5-branch germs' shared trees are
  **chains — exactly one legal schedule each** — so no route freedom exists there at all. Corrected:
  discharge check added (catches the old illegal order, kept as a mutant); `adversarial` made legal;
  **bushy** germs added — bushy-4 shows a genuine signature (peak-range **[7–10]**, 70 legal schedules);
  **bushy-5/6 are peak-blind but curve-live** (peak *and* half-discharge invariant, but the full curve
  takes **4 / 22** distinct shapes across 70 / 34650 schedules — a live route space the peak alone would
  have mis-filed as degenerate); and **H-T2c reverses** (BFS max, DFS min: pending discharges at
  separation, so DFS races to it → min peak, BFS holds debt open → max) and is retracted for the sharper
  **pending-favours-depth-first / working-set-shape-dependent trade-off**. The Rust `t2` "mirror" — which
  computed a *different* toy battery and so could never have caught the Sage divergence — is **upgraded to
  the real germ data** (same inputs, bit-matching peaks incl. B4 10/7). The catch this round is the
  family's own missing check — the sharpest vindication of "checks must be able to fail." See `results.md`
  erratum E-T2-1.
- **T3 value layer is degenerate at the canonical anchor (honestly PRE-PREDICTED negative).** On the
  frozen M1 law, the discrepancy multiset `{k/r}`, cone count, and the all-ones firing vector are all
  schedule-invariant — the value/multiset layer carries no route information, exactly as M1's
  branch-independence + fire-once structure predicted before T3 code. Recorded as the honest
  degenerate-route-space outcome, paired with the live process layer (working set 59%, deposit order
  85%). Not a failure — the pre-registered prediction landing.
- **T3 has no cascade signal — structurally.** Each cone is subdivided exactly once (firing vector
  all-ones), so T1's cascade-count layer is empty by construction here. Pre-declared so nobody hunts
  a cascade signal that cannot exist at the anchor.
- **T3 review catches (both fixed).** (i) A recursion bug used the original `r` instead of the current
  denominator `rr` for child weights (M1 uses `rr`) — corrupted deep nodes; caught because H-T3a
  control failed (multiset ≠ `{k/r}`), fixed, tree now matches M1. (ii) An over-strong `BFS≥DFS`
  working-set assertion — the **Rust mirror caught it**; the truth is a two-way spread (BFS>DFS 80,
  DFS>BFS 60, equal 103). Both are the exactness ladder doing its job.
- **M2 (OB-1) owed.** The value-relevant route question — flop-connected *distinct* endpoints, the
  first place the endpoint itself depends on the route — is not at the terminal anchor; it is owed at
  M2 (non-terminal / canonical quotients). T3's degenerate-value-layer negative is inherited there
  with interest: *route space degenerate where the endpoint is canonical; the moment canonicity
  fails, routes start choosing endpoints.*

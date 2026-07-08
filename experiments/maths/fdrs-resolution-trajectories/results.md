# Results — FDRS Resolution Trajectories (mass-carry routes through confluent rewrites)

The process layer as the third stratum under the **gauge** (value, abelian) and the **flag**
(chart, combinatorial): the **route** a confluent resolution takes — order-sensitive even when
value and flag are fixed. Governing rule: **every trajectory statistic ships with a mutant
schedule shown to move it** (`F-traj-invariant`); a statistic no schedule moves is a value-layer
quantity in a costume — but *value-layer with respect to which functional?* is this round's sharpest
refinement (the coarseness hierarchy, in "Method hardened" below).

| Phase | Hypothesis | Verdict | Evidence |
|---|---|---|---|
| **T1** | H-T1a control (endpoint/length/n invariant) | **HOLD (theorem)** | unique endpoint C, path length `\|B\|−\|C\|`, `n` preserved on every `G(B)` |
| **T1** | H-T1b process layer exists | **PASS** | visited-state set moves **72%**, cascade depth **5%** (deep cascades) under leftmost/rightmost mutant |
| **T1** | — carry magnitude is value-layer | **CONSERVATION LAW (proved, E-T1-1)** | `Σc = (\|B\|−\|C\|)−#ones(B)` schedule-free; step-count & front peak move **0%** on 1247 B (its shadow — no `c≥2` here) |
| **T1** | H-T1c route geometry | **OPEN** | width `\|G(B)\|` 2..16, *not* determined by (path-length, #ones) — process-native |
| **T1** | H-T1d cascade↔carry | **PLACED — Phase-9** | = `Def 149`/`Thm 61` **carry-as-route**, up to the increment↔decrement duality (Castelnuovo is the time-reversed dual) |
| **T2** | H-T2a ledger route-free | **HOLD (control)** | `issued=consumed+pending` **and** `pending→0` (new discharge check) every step, every *legal* schedule; total = oracle |
| **T2** | H-T2b pending curve = route signature | **CORRECTED (E-T2-1)** | orig. "separation" was an **illegal-schedule artifact**; on *legal* schedules the signature is **real but germ-dependent** — bushy-4 peak-range **[7–10]** (70 schedules); chain germs admit **1** legal schedule |
| **T2** | H-T2c level-sweep minimizes peak | **RETRACTED (E-T2-1)** | read off the artifact; on bushy-4 **BFS gives the *max* peak, DFS the min** — reversed |
| **T3** | dim-3 cone scheduling (M1 anchor) | **PASS** | value layer degenerate (multiset/firing invariant), process layer = schedule geometry (working set 59%, deposit order 85%) |

## T1 — the route is dynamics, the carry magnitude is value

`B = w(C)` (blow-up word on canonical `C`); Castelnuovo reduction is confluent to `C` (P2). The
**route space** `G(B)` is the DAG of chains reachable by single contractions. Under the built-in
mutant (leftmost vs rightmost `−1`), the three-layer separation becomes **quantitative** on a
battery of 1283 `(C,B)` pairs (base + a deep-cascade stress battery of long 2-runs):

| statistic | moves under the mutant | layer |
|---|---|---|
| endpoint `C`, path length, gauge `n` | 0% (theorem) | **value** (control) |
| carry-step count | **0%** (1247 B, incl. deep cascades) | **value** (conservation law) |
| carry-front peak (# simultaneous −1's) | **0%** | **value** |
| **visited-state set** | **72%** | **process** |
| **max cascade depth** | **5%** (deep cascades only) | **process** |

The clean statement: **the route (which states, which cascade depths) is process-layer; the
*amount* of carrying (count, peak) is a value-layer conservation law fixed by `B`.** This is
`F-traj-invariant` doing exactly its job — it separated a conservation law from genuine dynamics
and **killed two would-be process statistics** (carry-step count, carry-front peak) as value-layer.
Witness (route):
`B=[4,1,3,1,4]` → same endpoint `[2,2]`, leftmost via `[3,2,1,4]`, rightmost via `[4,1,2,3]`.
Witness (cascade depth): `B=[2,2,4,2,1,4,1,4,2]`, leftmost max-cascade `2 ≠ 3` rightmost.

A battery-adequacy note (`F-traj-schedule-cherry`'s cousin): cascade depth reads 0% on the shallow
base battery — there are no deep cascades to move — so a long-2-run **stress battery** was added;
only then does the 5% signal surface. The shallow reading would have been a false negative.

**Erratum E-T1-1 (the conservation law has a free proof; the code measures a proxy).** The conserved
"carry magnitude" is properly `Σc` (total new `−1`'s created over the reduction), and it has a
one-line **schedule-free proof**: every contraction removes exactly one `−1`, so total contractions
`= |B|−|C|` (path length, H-T1a) `= #ones(B) + Σc` (initial ones + created ones), giving
**`Σc = (|B|−|C|) − #ones(B)`** — pure counting, no schedule. (This is the proof the `NEGATIVE.md`
follow-up asks for.) The code's `mv_carrycount`, however, counts **steps with `c>0`**, not `Σc`; the
two coincide only when no step creates two `−1`'s at once (`c=2`, the interior `[·,2,1,2,·]` pattern).
On this battery **no `c=2` step occurs (0 / 1247 `B`)**, so step-count `= Σc` and the observed
`0%`-moves *is* the proved `Σc` law — but that is a battery fact (worth its own small lemma), not the
identity. So: `Σc` invariant is a **theorem**; the step-count invariant is its **shadow here**.

**H-T1c:** the width of `G(B)` (2..16) is not fixed by (path-length, #ones-in-`B`) — same
signature gives different widths — so width is **process-native** on this battery (a subtler
classical predictor may exist; not claimed). **H-T1d (corpus home found — Phase-9 `Def 149` /
`Thm 61`):** contraction moves a single `−1` along the chain (the front never grows —
peak-invariance), which *is* an odometer carry propagating. The corpus already names this:
**`Def 149 (carry-as-route)` — an OVERFLOW routes an inject to the next digit — and `Thm 61
(carry is overflow route)`**, proving recursive carry ≡ event-driven overflow routing. Our
Castelnuovo cascade is its **time-reversed dual**: Phase-9's carry-as-route is the *increment*
direction (digit overflows → +1 to the neighbor); a contraction is the *decrement* mirror (blow
down a `−1` → −1 to the neighbor). So the earlier "placement open" is upgraded to **placement =
Phase-9 carry-as-route, up to the (real) increment↔decrement duality** — the direction caveat is
the finding, not a failure to place. (Ref: `docs/fdrs.md` §9.9, `Modes/BaseZeroSea`.)

## T2 — the pending curve is a route signature (extends P7) — CORRECTED, erratum E-T2-1

P7 verified the strict ledger on one schedule (level-sweep). Here the **schedule is the object**:
process the shared resolution tree of a germ in different orders and read the **step-indexed
pending curve** `p_s(t)` (never time-averaged — `F-traj-average`).

> **Erratum E-T2-1 (schedule bug + missing check + inadequate germs — the family's own rule bit
> back).** The original `adversarial` schedule sorted shared nodes by `(group_size, depth)`. Group
> size is non-increasing with depth along a shared path, so this processed **deep nodes before the
> root — violating the ledger's own "parent before child" contract.** A pair then closed at its
> early-processed deepest node while its root deposit landed *later*, into a `pending` that was
> never consumed: **the pending curve ended nonzero.** Both shipped checks missed it (per-step
> balance moves both sides together; total is order-independent), because **the one check that
> would have caught it — `curve[-1]==0`, pending must fully discharge — did not exist.** The
> published "separation" (adv peaks 6, 13) *was* the never-discharged pending (6=6, 13=13), not a
> route signature. Compounding it: the original germs' shared trees are **chains — exactly one
> legal schedule each** — so they could not exhibit route freedom at all. **Fixes:** the discharge
> check is added (a check that *can* fail — it now catches the old illegal order, kept as a
> mutant); `adversarial` is a **legal** topological order (defer-consumption); **bushy germs** are
> added. Re-run below.

- **H-T2a (control) — HOLDS, now with teeth:** `issued = consumed + pending` at every step **and
  `pending` fully discharges (`curve[-1]=0`)** under every *legal* schedule; total equals the
  Sage-native `intersection_multiplicity` oracle. Conservation is route-free. The guards fire:
  `forget_decrement` breaks the balance, `double_issue` breaks the total, **and the old illegal
  `adversarial` is now caught by the discharge check** (`curve[-1]=6≠0`) — the previously-missing
  test doing its job.
- **H-T2b (route signature) — CORRECTED, germ-dependent.** On *legal* schedules the peak is a route
  signature **only where the shared tree branches and the branching lifts to peak variation.**
  - chain germs (orig. 3/4/5-branch): **1** legal schedule — no route freedom; peak trivially fixed;
  - **bushy-4** (two tight pairs, distinct tangents): **70** legal schedules, **peak-range [7,8,9,10]**
    (`bfs 10 / dfs 7 / adv 10`), all discharged — **a genuine route signature;**
  - bushy-5 / bushy-6: **70 / 34650** legal schedules with peak **and** time-to-half-discharge both
    invariant (`[10]`/`[15]`; half=`1`) — **but the full pending curve takes 4 / 22 distinct shapes**.
    So these are **peak-blind but curve-live**: the route space is genuinely non-trivial; the *coarse*
    functionals (peak, half-discharge) merely happen to be schedule-invariant while the finer
    curve-shape signature moves. (The charter pre-registered curve shape as a statistic — it is what
    decides this; peak alone would have mis-filed a live route space as degenerate.)
    **Mechanism (checked, not asserted).** In every legal schedule the root is processed first (forced —
    no parent), depositing every pair's depth-0 contribution *at once*, unstaggerable. For root-dominated
    germs with shallow separations (bushy-5/6) pending is already maximal the instant the root step
    completes — verified: the peak's **argmax is at step 1 in all 70 / 34650 schedules** — so everything
    after is closing order (curve shape) and the peak is pinned. Bushy-4 is the opposite: deep shared
    paths spread the deposit mass, the peak lands **deep** (argmax at steps 5–8, never the root), where
    schedules stagger which debts co-exist and the peak moves. So the invariance is **not a symmetry of
    the functional** — it is the **topological-order constraint pinning the extremum to the one step every
    schedule shares.** Design rule: **a peak-separating germ needs deposit mass off the root.**
  So the pending signature is real but the *functional* matters: peak separates on bushy-4, curve-shape
  on bushy-5/6, nothing on chains. The original claim conflated all this with the E-T2-1 artifact.
- **H-T2c (level-sweep minimizes peak) — RETRACTED, and replaced by a sharper statement.** Read off the
  artifact. On bushy-4 the relation **reverses**: BFS gives the **maximum** peak (10), DFS the
  **minimum** (7). *Why:* pending is debt that discharges at **separation**, and separations live deep
  in the tree — so **DFS races to separations, closing pairs early → minimum peak**, while **BFS holds
  every pair's debt open across the level sweep → maximum peak**. The original "level-sweep minimizes"
  borrowed *working-set* intuition; pending has the opposite grain. The replacement is sharper than the
  claim it lost: **pending favours depth-first; the working set is shape-dependent (T3's 80/60/103
  BFS/DFS/tie); and the two objectives can directly oppose** — no single schedule jointly minimizes peak
  pending and peak working set. That is the first hint of a real **trade-off structure** in resolution
  scheduling. Peak pending is combinatorial, not a latency (`F-traj-latency-leap`).
- **Genuine parity (E-T2-1 ladder fix).** The Rust `t2` mirror — formerly an illustrative toy on a
  different (hand-built) config — now runs the **same** shared-node-tree ledger on the **same** germ
  data (mults + tag-labels extracted from the tracker) and **reproduces the Sage bfs/dfs/adv peaks
  bit-for-bit on all six germs** (B4 10/7/10, chains single-peak, B5/6 invariant), with the discharge
  check catching the old illegal order. A "mirror" now mirrors.

## T3 — the trajectories thesis at the dim-3 anchor (gate opened by M1)

`fdrs-mcf-threefolds` **M1 landed** (551/551), opening the gate. T3 reuses the **frozen M1
Ashikaga law** (the resolution of `1/r(1,a,r−a)`; `r−1` emitting nodes, `2r−1` leaves, each cone
subdivided once, branch-independent) and asks which trajectory statistics move under a schedule
swap (BFS / DFS / largest-gauge / adversarial), on 245 anchors `2≤r≤40`. **Every M1-sharpened
prediction confirmed:**

| statistic | moves under schedule swap | layer |
|---|---|---|
| discrepancy multiset `{k/r}`, cone count `r−1` | 0% (invariant) | **value** (control) |
| **firing vector** (each cone fired once) | all-ones — no cascade *exists* | **value** (structurally degenerate) |
| **working set** (peak pending *emitting* nodes) | **59%** | **process** (schedule geometry) |
| **deposit order** (order-indexed) | **85%** | **process** |

*(Two wording notes: "working set" counts pending **emitting** nodes, excluding smooth leaves — not
all "active cones"; and the `adversarial` policy is min-depth, which coincides with BFS on the peak
— so T3 ran **three** distinct peak-behaviours (bfs≡adv, dfs, largest), not four. Neither touches the
verdict; the mutant pair that matters is BFS/DFS.)*

The **value layer is degenerate at the canonical anchor** — exactly the pre-registered negative:
branch-independence makes the multiset and tree shape order-free, and fire-once makes the cascade
layer *structurally empty* (no cascade signal to hunt — pre-declared). What survives as dynamics is
**pure schedule geometry**: working set and deposit order. Witness: `1/7(1,2,5)` peaks `bfs 2 / dfs
3 / largest 3 / adv 2`.

**H-T3c (honest correction).** BFS realizes the tree **width**, DFS the **depth** — but neither
dominates: over the 243 anchors with ≥3 emitting nodes (of the 245), `BFS>DFS` on 80, `DFS>BFS` on 60,
equal on 103 (the `a=1` anchors are
pure chains, `BFS=DFS=1`). My first pass asserted `BFS≥DFS`; the **Rust mirror caught it** as
over-strong, and it's corrected to the real two-way spread. A recursion bug (child weight used the
original `r`, not the current denominator `rr` — M1 uses `rr`) was also caught in review; after the
fix the tree matches M1 exactly (`r−1` nodes, `{k/r}` multiset).

**What T3 means.** This is the three-layer separation at the dim-3 terminal corner: **the endpoint
is canonical, so the value layer is silent; the route lives entirely in schedule geometry.** It is
both the honestly-predicted degenerate-value-layer negative *and* a live-process-layer positive —
together. The deeper question (route freedom becoming *value*-relevant — flop-connected distinct
endpoints) is owed at **M2** (OB-1), where canonicity fails and routes begin choosing endpoints.
The M1 law is reused unmodified; `F-traj-latency-leap` honored (working set is combinatorial, not
milliseconds).

## Through-line

Every prior family verified the **endpoint** — invariant under how the process ran. This family
finds the **process layer** and measures it across three dimensions of the ecosystem: the route is
genuinely order-sensitive (T1 visited states 72%, cascade depth 5%; T2 pending-curve shape, on germs
with route freedom; **T3 working set 59%, deposit order 85%**), *while* the conserved quantities
(endpoint, gauge, carry magnitude,
ledger total, **T3 discrepancy multiset**) stay route-free. The sharpest result is the **separation
itself** — `F-traj-invariant` forced each candidate statistic to prove it moves, and cleanly split
the value-layer conservation laws from the process-layer dynamics. **T3 is the separation at its
limit:** at the dim-3 *canonical* anchor the value layer is fully silent (multiset degenerate,
firing all-ones, no cascade), so the route survives *only* as schedule geometry — the
honestly-predicted degenerate-value-layer negative and a live-process-layer positive, together. The
value-relevant route question (route choosing the endpoint) is owed at M2, where canonicity fails.
No new geometry theorem; classical objects (Castelnuovo, Noether, P7, the frozen M1 Ashikaga law)
read through **corpus objects that already exist** (Phase-14 §14.6, below), verified exact with
independent mutants.

## Corpus placement (Phase-14 §14.6 — Def 199 / Thm 91)

This family is **not** a fresh set of FDRS-side definitions — it is the **geometric instantiation
of, and numerical witness for, Phase-14 §14.6**, which the first pass under-cited:

- **Def 199 (schedules, trace equivalence, projections)** *is* the trajectories object. A schedule
  is a word of `(place, digit)` events; **trace equivalence** identifies schedules up to adjacent
  swaps of events at *different places* (Mazurkiewicz / place-disjointness); the **projections**
  `π_v` are schedule-invariant. Our three-layer split is exactly that: **value layer = the
  projections** (schedule-invariant), **process layer = the schedule modulo trace-equivalence**.
  T3's headline — *branch-independence ⟹ value layer degenerate* — **is** Def 199's
  *place-disjointness ⟹ trace-equivalence* read on the M1 cone tree: branch-independent subcones
  are place-disjoint events, so every schedule is trace-equivalent and the projections (multiset,
  endpoint, firing vector) cannot move.
- **Thm 91 (the scalar trace-gauge no-go): "a scalar refinement metric cannot price concurrency"**
  — witness `aⁿ, bᵐ` both trace-prefixes of `aⁿ·bᵐ`. That is **T1's headline as a theorem**: the
  scalar carry-magnitude (count, peak) is value-layer and cannot separate routes; only the full
  trace (visited-state set / cascade structure) can. `F-traj-invariant` — *a statistic no schedule
  moves is a projection* — is the operational form of trace-invariance; T1's `Σc` conservation law
  (E-T1-1) is a projection in exactly Def 199's sense.
- Both `Def 199` and `Thm 91` are `❌ missing` / `⚪ excluded` in the Lean corpus, so **T1/T2/T3 are
  geometric evidence for un-formalized corpus theorems on real resolution processes** — a stronger,
  more honest claim than "novel definitions." `F-novel` is honored *because* the objects are corpus
  objects (Def 199 / Thm 91), not new geometry. (Ref: `docs/fdrs.md` §14.6,
  `Modes/SyntheticPlace/TraceGeometry.lean`.)

## Method hardened this round (guards & the coarseness hierarchy)

**Battery route-freedom as a precondition (family-wide, promoted this round).** Three phases have now
hit the same wall from different angles: T1's shallow battery hid cascade depth (fixed by a stress
battery); T3's small-`r` trees collapse all schedules; and T2's chain-shaped shared trees admit
**exactly one legal schedule** — an empty route space *before any statistic is measured* (BFS=DFS was
identity, not a tie). Three instances is a pattern, and it earns a precondition: **before a route
statistic's verdict means anything, count the legal schedules and require ≥2, reported in the run
record.** `F-traj-discharge` catches *illegal* schedules; **`F-traj-route-vacuous`** catches *vacuous
batteries* — the two distinct ways a route claim can be empty, now both guarded. The pending-peak
route signature is genuine only where this precondition holds (bushy germs), and even there the right
*functional* is germ-dependent (peak on bushy-4, curve-shape on bushy-5/6) — a much sharper, more
honest map of the process layer than the pre-erratum version.

**Route-liveness is statistic-relative (the round's real lesson).** Bushy-5/6 are neither degenerate
nor live *simpliciter* — they are peak-blind *and* curve-live. So "is this route space degenerate?"
was never well-posed; only "degenerate with respect to which functional?" is. Statistics sit in a
**coarseness hierarchy** — peak ≺ time-to-half-discharge ≺ curve shape — and a battery can be vacuous
at one level while carrying **22 distinct shapes** at another. This retroactively qualifies every
**0%** in T1–T3: each was a statement about *one functional*, not about the route space, and
`F-traj-invariant`'s taxonomy now carries that qualifier. It also sharpens the precondition above:
**≥2 legal schedules is necessary but not sufficient** — two schedules differing only by a
symmetric-sibling swap are vacuous for every functional — so the honest registration requirement is
**≥2 legal schedules *and* a report of which functionals they separate** (the parity machinery makes
that cheap). And the mechanism behind the hierarchy is concrete (H-T2b): the topological-order
constraint forces the forced-root step to be shared by all schedules, so any functional whose extremum
lands there is pinned — coarseness is about *where in the tree the functional reads*.

**Reproduce.** `cd source/sage && sage t1_cascades.sage && sage t2_pending.sage && sage t3_scheduling.sage` ·
`cd source/rust && cargo test --offline`

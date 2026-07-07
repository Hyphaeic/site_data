# Experiment: FDRS MCF Threefolds (3-fold cyclic quotients as an algorithm-space problem)

**Charter stage (G0/G1). Scoping-gated. Pre-registered 2026-07-07, BEFORE any code.**
Sibling to `experiment-fdrs-hj-singularities`. The difference is internal structure, not
label: **Phase M0 is a scoping phase — report only, no run-emitting code — and every later
phase is gated on M0's human review.** Rules: ADR-007 (this charter, including M0's
deliverables, is pre-registered before any code) and ADR-008 (honest-broker; never
FDRS-novel; the contribution is the encoding + verified artifact).

- **Registry ID:** `experiment-fdrs-mcf-threefolds` (proposed; G0 registry entity is the
  owner's human-gated step).
- **Parent:** `project-fdrs-formal` / `program-fdrs-core`. Sibling of the surface families
  (`fdrs-hj-singularities`, star-shaped). Corpus is read-only.
- **Workspace:** `workspace-math-proof-env` (SageMath; dim-3 toric may need
  Normaliz / polymake / Magma — the oracle question is itself part of M0, see F-3-anchor).
- **Owner:** `volition-billy` · **Risk:** low (exploratory, report-first; the honest
  outcome may be "scoped and parked").

## The honest-scope contract (stated first)

Multidimensional continued fractions (MCF), terminal-quotient classification, and economic
(Danilov) resolutions are **classical** (Reid, Danilov, Mori, Morrison–Stevens, Klein,
Karpenkov). This experiment claims **no new singularity or number theory.** Its intended
contribution — *if M0 clears the gate* — is an **algorithm-space encoding**: reading MCF
digit-rules as FDRS Phase-7 radix laws `Ω(s,c)` over `ℤ³`, so that the *choice of
subdivision strategy* becomes a point in a space of laws, and geometric properties of the
resulting resolution become properties of the **law**, not the singularity. **`F-3-canon`
is the governing guard:** there is no canonical multidimensional continued fraction (a
famous open problem); presenting any one algorithm as "the" generalization is the field's
classic trap and is forbidden.

## Why this experiment opens with a scoping phase (the dim-2 → dim-3 break)

The surface families rest on a fact that **fails in dimension 3: there is no canonical
algorithm.**

- In dim 2, the HJ continued fraction *is* the minimal resolution — unique, canonical. That
  uniqueness is exactly what made P1 a clean anchor (`Ω = ⌈n/q⌉` fixed once; gauge = |det| =
  |group|).
- In dim 3, minimal resolutions do not exist in general; the CF generalizations
  (Jacobi–Perron, Brun, Selmer, Klein polyhedra/sails, Mönkemeyer, …) are **many,
  inequivalent, none distinguished**; toric desingularizations = fan subdivisions are
  **choices**; and different MCF algorithms are different subdivision strategies.

This is the first FDRS-shaped situation where the framework might **contribute** rather than
curate: **a context-dependent radix function is a point in algorithm space.** The
digit-extraction rule that P1 fixed becomes the object of study.

**The P5 precedent is load-bearing.** P5 (sibling, closed) proved the Wahl move is a
*value-changing law morphism that conserves the stratum `d`* — "value dies, `d` survives."
The dim-3 conjecture is the exact analog: **discrepancy/crepancy data is the conserved
quantity classifying transports between subdivision laws** — what `d` was to the Wahl moves,
discrepancies are to MCF-algorithm changes. This is the experiment-level bet, to be
**sharpened, not assumed** (M0.3 grades it testable / not-yet-testable).

## Phase M0 — scoping (report only; gates everything below)

Deliverable: `SCOPING.md`. Four questions, each graded honestly (answered / partial / open):

- **M0.1 — Landscape.** Which MCF algorithms have explicit toric-subdivision readings, and
  what is *actually known* (convergence; periodicity for cubic irrationals — the Hermite
  problem, where the honest answer is mostly "open/negative"; geometric meaning of digits)?
  Minimum coverage: Jacobi–Perron, Brun, Selmer, Klein-polyhedral (sail); Mönkemeyer /
  fully-subtractive if cheap. For each: can its digit step be written as a Phase-7
  `(state, Ω, Γ)` triple over `ℤ³`? **Deliverable: a table — algorithm ↔ radix-law form ↔
  subdivision move ↔ known guarantees**, sourced (no periodicity claim stated from memory).
- **M0.2 — The decidable anchor.** The experiment needs its `A_n`. Candidate: **terminal
  3-fold cyclic quotients `¹⁄ᵣ(1,a,r−a)`, `gcd(a,r)=1`** — classified (terminal lemma /
  White), admitting distinguished **economic resolutions** (Danilov; weighted-blow-up
  ladder). The report must confirm, not assume: (i) is the economic ladder expressible as a
  *single* radix law? (ii) does a `gauge = |det| = group`-style datum survive — and is it
  the crude `r` or the discrepancy/age vector (expect the abelianization-style correction
  the surface law needed)? A worked `¹⁄ᵣ(1,a,r−a)` example by hand.
- **M0.3 — Algorithm space as an FDRS object.** Formalize "the space of admissible `Ω`":
  what makes a digit rule admissible (termination? unimodularity of the step? positivity?),
  and which corpus objects already fit (Phase-7 law families, timelines-of-laws, Phase-5.3
  recharts between laws — recalling P5's F5-transport: these transports *change value*).
  Grade the conserved-discrepancy conjecture **testable / not-yet-testable**.
- **M0.4 — The negative to design for.** Pre-identify what dim 3 will refuse — a precise
  statement of what a single Phase-7 law provably **cannot** capture (the Catalan-no-go
  analog), so a refutation is a **boundary theorem**, not a disappointment. Known walls:
  **flops** (a deterministic law picks one subdivision; the flop-equivalence class it can't
  hold) and **non-periodicity** (Hermite — cubic irrationals generally lack eventually-
  periodic MCF, so a finite-state law can't capture them).

## Guards (seeded before M0 — see `NEGATIVE.md`)

- **F-3-canon** — presenting any one MCF algorithm as "the" canonical generalization.
- **F-3-anchor** — running anything before the M0.2 anchor battery is fixed *and* its
  independent oracle (dim-3 toric: Sage / Normaliz / polymake / Magma) is identified.
- **F-3-scope** — any claim about general 3-fold singularities; **cyclic quotients only,
  terminal-first**.
- **F-novel** — MCF theory, terminal classification, economic resolutions are classical
  (Danilov, Reid, Mori, Klein, Karpenkov); the contribution is the algorithm-space encoding.

## Deliverables (Phase M0)

1. `SCOPING.md` — the M0.1 table; M0.2 confirmation with a worked `¹⁄ᵣ(1,a,r−a)` example by
   hand; M0.3 formalization sketch graded for testability; M0.4 designed negative.
2. `M1-draft.md` — the pre-registered protocol for the first runnable phase (expected: the
   M0.2 anchor — economic resolutions of terminal cyclic quotients as a radix law),
   **written but NOT registered** until the scoping report is reviewed.
3. `READING.md` — two or three sources per needed item (Reid's *Young Person's Guide*;
   Danilov; Karpenkov's MCF geometry book for M0.1).

## What this is NOT

Not a commitment to the later phases. The scoping report may honestly conclude that the
anchor is thinner than it looks, or the oracle situation is inadequate (dim-3 toric support
is weaker everywhere), in which case the recorded outcome is **"scoped and parked"** — a
success of the process, not a failure.

## Status

- [x] Charter (this document) — scoping-gate structure, guards, M0 questions — before any code
- [x] `NEGATIVE.md` guards seeded (+ `F-3-essential-tautology` added in M0.3; statuses filled)
- [x] M0 scoping — grounded (deep-research: 23 sources, 22/25 claims verified) + in-workspace
  Sage oracle probe → **`SCOPING.md`** · **verdict: GATE CLEARS, recommend proceed to M1**
- [x] `M1-draft.md` (written, **unregistered**) · `READING.md`
- [ ] **← GATE: human review of `SCOPING.md`** → register M1, or "scoped and parked" *(yours)*

### M0 headline findings
- Anchor **confirmed**: terminal ⟺ `¹⁄ᵣ(1,a,r−a)` (Reid Thm 5.2); economic resolution has
  discrepancies **exactly `1/r,…,(r−1)/r`**, no crepant divisor. Worked `¹⁄5(1,2,3)` by hand
  + Sage-verified (4 anchors smooth).
- Anchor law **exists in the literature**: Ashikaga CF → Fujiki–Oka resolution (Sato–Sato) —
  a named MCF whose digits are the anchor's subdivision moves. M1 = encode it as Phase-7.
- Gauge-analog: coarse `|det|=r` survives (P1); the **rich** invariant is the discrepancy
  vector `(1/r,…,(r−1)/r)` — the abelianization-style correction the charter predicted.
- `F-3-canon` well-founded (Hermite open; Karpenkov reaches only totally-real cubics).
- Oracle **adequate**: elementary age formula + Sage *verify*-mode (law generates, Sage
  certifies) — the correct exactness-ladder shape.
- Designed negatives: Wall 1 (Hermite non-periodicity) + Wall 2 (toric-flip non-uniqueness).

## References

Reid, *Young Person's Guide to Canonical Singularities*; Danilov (economic resolutions);
Mori, Morrison–Stevens (terminal quotient classification); Karpenkov, *Geometry of Continued
Fractions* (MCF / sails); Fulton, Cox–Little–Schenck (toric, all dimensions). FDRS corpus
(read-only): Phase 7 law families, the P5 transport finding (`fdrs-hj-singularities`
Amendment 2), Phase 8 multi-timeline routing, Phase 5.3 rechart.

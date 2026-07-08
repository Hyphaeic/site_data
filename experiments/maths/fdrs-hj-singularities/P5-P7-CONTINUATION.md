# Amendment 2 (P5–P7) — the Wahl-path law, CS component adjacency, and the strict ledger

**Pre-registered 2026-07-07, BEFORE its code.** Continuation of
`experiment-fdrs-hj-singularities` (P1–P4 closed). Same charter rules: ADR-007
(pre-registration before code, exactness ladder, negatives first-class), ADR-008
(honest-broker; never FDRS-novel). Three phases; P5 is the main event.

## Honest-scope contract (stated first)

Everything invoked is **classical**: the two Wahl moves and the d-stratified generation of
T-singularities (Kollár–Shepherd-Barron; Wahl); Christophersen–Stevens zero-chains and
deformation-component adjacency; Stern–Brocot ↔ continued fractions; Noether/Enriques and
Phase-14 interface balance. P5–P7 claim **no new singularity theorem.** The contribution is
(i) encoding the *change of law* between the HJ chart and the Wahl-path chart and asking what
is conserved across it, (ii) promoting the P3-deferred CS component adjacency, and (iii) making
H4c's strict ledger genuinely refutable. The one thing that must not happen: presenting a
tautology of the chart as a discovery (F5-tautology).

---

## P5 — the Wahl-path law and the HJ↔path transport (the main event)

### Setup
- **Path law:** each T-singularity is `(root, word)` with `root ∈ {[4]} ∪ {[3,2ᵐ,3] : m≥0}`
  (the root selects the **d-stratum** = a timeline) and `word ∈ {m1,m2}*` (the move
  sequence). Constant radix 2, context-free — the simplest law in the family.
- **HJ law:** the P1 Phase-7 law, restricted to T-chains.
- Both laws name the same objects; the object of study is the **pair and the map between**.

### Hypotheses

**H5a — the path law is an exact bijective encoding (anchor; expected HOLD).**
`(root, word) → chain → (n,q)` round-trips; distinct `(root, word)` give distinct
singularities; every T-singularity in the battery is reached. The Wahl forest is 8 trees
(`502 nodes − 494 edges = 8` roots), so each node is a unique path — the bijection is
structural. Verified against the **corrected `is_t`** (E-1 form) and the **P1 HJ round-trip**
as the two independent non-fabrication oracles (both independent of the move recursion).
Integer-only.

**H5b — adjacency = prefix in path coordinates (TRUE BY CONSTRUCTION — a smoke test, not a
finding).** QG-smoothing adjacency was *defined* in P3 as Wahl-tree edges, so in path
coordinates "adjacency = parent–child = one-move prefix" is a **tautology**. Its only
legitimate content: verify the implementation realizes it, and record the honest framing —
**P3's `0/494` (HJ chart) and P5's `494/494` (path chart) are the same fact in two charts.**
Any stronger claim is F5-tautology.

**H5c — the FDRS home of the Wahl move (the real question; OPEN).**
The Wahl move **changes `(n,q)`** — it is NOT a Phase-5.3 rechart / carry-normalization (P2
already showed value-changing edits are not normalization; that home is unavailable). The
pre-registered candidate placement, to be **tested, not assumed**:
- in **path coordinates** the move is **digit emission** — a successor-like tick of the
  constant-radix path law (extend the word by one);
- in **HJ coordinates** the same operation is a **non-local two-ended rewrite**
  (`m1: [b] → [2,b₁..bₑ₋₁,bₑ+1]`, `m2: [b] → [b₁+1,b₂..bₑ,2]`).
- Conjecture: **one law's tick is the other law's non-local edit**, and HJ↔path is a lawful
  FDRS map between a Phase-7 law and a constant-radix law that does **not** preserve `(n,q)`.

  **Testable core — what IS conserved?** Pre-registered candidate: **`d` (the stratum) is the
  invariant**; `(n,q)` grows. *"Value dies, `d` survives"* is the P5 headline **iff** it
  verifies: for **all 494 edges**, `d(parent) == d(child)` and `(n,q)` strictly changes; and
  the growth law of the continuant `n` along paths is recorded **per root if visible, not
  forced**. If `d` is not always preserved, the exceptions are enumerated and the true
  invariant sought — a first-class outcome either way.

**H5d — Stern–Brocot correspondence (bonus; gated).** The two-move word tree is
Stern–Brocot-shaped; SB paths ↔ continued fractions is classical. Test whether the
**run-length encoding of the path word** relates to the HJ digits (or the dual chain
`n/(n−q)`'s) by an **exact rule on the whole forest**. If a rule is found it is the explicit
transport of H5c; if none is visible, **record the negative — do not fit one** (F5-fitted).

### Falsifiers (pre-registered)
- **F5-tautology** — presenting H5b as a discovery rather than a definition. The chart was
  built so it holds; the finding is the *chart change*, never the hit rate.
- **F5-independence** — validating H5a against the path construction itself rather than the
  corrected `is_t` and the P1 HJ law.
- **F5-transport** — calling HJ↔path a Phase-5.3 rechart. It cannot be: recharts preserve
  value; this map changes `(n,q)`. If no corpus home fits, the record is **"placement open,"**
  not a forced fit.
- **F5-fitted** — any H5d rule stated without exact verification on the full forest, or tuned
  per-stratum after looking.
- **F-exact / F-novel** — everything ℤ; Wahl trees, SB, T-singularity theory are classical.

### Protocol
- **P5.1** — implement the path law; H5a battery = the corrected Wahl forest (roots through
  d=8, length ≤ 8; extend depth if cheap). Oracles: `is_t` + P1 HJ round-trip.
- **P5.2** — H5c per-edge conservation sweep (`d` invariant, `(n,q)` changed) on all 494
  edges; record any exact growth law of the continuant along paths, per root.
- **P5.3** — H5d run-length ↔ HJ-digit comparison, exact rule or clean negative.
- Rust mirror of the path law + conservation sweep; Sage stays the oracle.

---

## P6 — Christophersen–Stevens component adjacency (the deferred contested middle)

The P3 deferral, promoted. Enumerate the CS deformation components (zero-chains `[k₁,…,kₑ]`,
`kᵢ≥1`, minus-continuant `K=0`, dominated componentwise by the HJ chain), build the
component-adjacency poset per Stevens on a small battery (`n ≤ 40`), and test the
**path-coordinate** and **coupled multi-line** encodings against it — **not** the HJ prefix
(P3 already proved that negative via the Catalan no-go; re-testing it would be F-circular's
cousin).

- **H6a (anchor; expected HOLD):** zero-chain enumeration matches the Catalan count `C_{e−1}`
  exactly per length (verified by hand: len 2 → `[1,1]` = `C₁`; len 3 → `[1,2,1],[2,1,2]` =
  `C₂`). The non-fabrication anchor.
- **H6b (OPEN; the genuine bet):** a singularity's **component set**, encoded as a coupled
  multi-line object (P4 machinery: one line per zero-chain, domination as coupling), carries
  the adjacency poset — measured **hit / partial / miss** on the decidable battery only.
- **F6-forest:** encoding the component set as any **single line** (the Catalan no-go applies
  to every single-line prefix metric, dual-augmented or not — P3's generalization, now
  load-bearing).
- **Honest scope:** Stevens' full component-adjacency is research-level; H6b is exploratory,
  reported as whatever it is. H6a is the solid deliverable.

---

## P7 — the strict Thm-89 ledger on ≥3-branch networks (NEG-2's continuation)

H4c is untested and its weak form vacuous (E-5). The strict `issued = consumed + pending`
needs a configuration where **"pending" is nonzero mid-computation**. Pre-registered design:
process the shared resolution tree of a ≥3-branch germ **level by level** (by infinitely-near
depth), maintaining a ledger where at each depth `issued` = the total intersection to account,
`consumed` = contributions from branch-pairs already **separated**, `pending` = contributions
from pairs still **coupled**. At the final depth `pending = 0`, `consumed = total`; the claim
is `issued = consumed + pending` **at every intermediate depth** (a genuine conservation, not
`ord(gh)=ord g+ord h`).

- **H7 (OPEN; genuinely refutable):** the incremental level-sweep ledger satisfies strict
  interface balance at **every step** on a battery of 3- and 4-branch germs (satellite contact
  included, per P4's proximity requirement). A **miss is NEG-3** and closes H4c negatively — a
  fully acceptable outcome.
- **F7-vacuous:** any balance check that reduces to a valuation axiom. The test **must be able
  to fail**: pre-register a **mutant** (deliberately mis-ordered coupling — e.g. crediting a
  pair's contribution one depth after they separate) that **MUST violate** the balance, and
  demonstrate it firing live. If the mutant does not break the check, the check is vacuous and
  the result is void.

---

## Success criteria
- **P5:** H5a exact on the forest; H5c sweep exact (`d` invariant on 494/494 or enumerated
  exceptions; n-growth law stated or absent); H5b recorded as tautology-with-smoke-test; H5d
  exact rule or clean negative.
- **P6:** Catalan counts exact; H6b measured with enumerated hits/misses; no single-line claim.
- **P7:** strict ledger verified per-step **with a firing mutant**, or NEG-3 recorded.

## Deliverables
Sage oracles + Rust mirrors; per-run manifests; `results.md` rows; `NEGATIVE.md` fraud entries
(F5-tautology, F5-transport, F6-forest, F7-vacuous) seeded pre-run; findings notes.

## Status
- [x] Amendment (this document) — pre-registered before code
- [ ] P5.1/P5.2/P5.3 · Rust mirror
- [ ] P6.1 (Catalan) / P6.2 (poset, exploratory)
- [ ] P7 (strict ledger + firing mutant, or NEG-3)

## References
- Kollár–Shepherd-Barron; Wahl (T-singularities, the two moves, d-strata).
- Stevens; Christophersen (zero-chains, component adjacency); Altmann (Minkowski
  decompositions) — P6.
- Stern–Brocot / Calkin–Wilf ↔ continued fractions — H5d.
- FDRS corpus (read-only): Phase 7 laws, Phase 5.3 rechart (the thing H5c is **not**),
  Phase 8 multi-timeline routing, Phase 14 coupling + Thm 89 + Prop 148.

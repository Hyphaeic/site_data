# Amendment 1 (P4) — Puiseux multi-branch as a coupled radix network

**Pre-registered 2026-07-07, BEFORE its code.** Gated amendment to
`experiment-fdrs-hj-singularities`, opened after P1–P3 landed. Exploratory / qualitative
scope, per the charter. This document is the P4 protocol; its code and run records follow
this commit.

## Honest-scope contract (stated first)

Everything invoked here is **classical**: Puiseux expansions and characteristic exponents
(Wall); the multiplicity sequence / Enriques diagram / proximity of infinitely near points;
and **Max Noether's intersection formula**
`(C_1 · C_2) = Σ_p m_p(C_1)·m_p(C_2)` summed over shared infinitely near points. P4 claims
**no new singularity theorem.** Its contribution is a **verified FDRS encoding**: the
multi-branch configuration as a Phase-14 **coupled radix network**, with the intersection
multiplicity recovered as the network's coupling accounting, checked against an independent
Sage oracle, integer-only, and with the **raggedness the corpus predicts named and
measured, not hidden**. Where the coupled-network reading diverges from the geometry, that
divergence is the result.

## The key insight (why P4 is worth running after P3)

P3 established a sharp negative: the prefix ultrametric **misses** deformation (Q-Gorenstein)
adjacency. P4 targets the **opposite** geometric question, where prefix/contact structure
should be *faithful*:

> **Intersection multiplicity is a coupled-prefix conservation quantity.** Noether's
> formula sums `m_p(C_1)·m_p(C_2)` over exactly the infinitely near points the two branches
> **share** — the shared initial **subtree** of their resolutions (infinitely near points
> *with proximities*), i.e. their *contact*. Once the branches separate in the tree, the sum
> stops. So `(C_1·C_2)` is a function of the shared subtree and the multiplicities along it.

Same prefix ultrametric as P3, opposite verdict expected: **P3 miss (deformation) ⟂ P4 hit
(contact/intersection).** That contrast — one ultrametric, faithful to resolution/contact,
blind to smoothing — is the through-line P4 completes.

## The encoding (Phase-14 coupled radix network)

> **The "prefix" lives in the Enriques diagram, not the multiplicity sequence.** Two
> branches can share a prefix of their multiplicity *sequences* while separating at
> different points of the infinitely-near tree; the **free-vs-satellite (proximity)**
> structure is what decides which points actually count as shared. Keying the coupling on
> a digit-string lcp would pass free-point calibration and fail the first satellite-contact
> pair. The encoding therefore carries the **proximity matrix**, not the bare sequence.

- **Each branch is a radix line — its Enriques diagram, proximities included.** A plane
  branch's resolution is a sequence of infinitely near points `p_0, p_1, …` carrying (i)
  multiplicities `m_0 ≥ m_1 ≥ …` **and** (ii) a **proximity matrix** — for each `p_j`, which
  earlier points it is proximate to (a point is *free* if proximate to one predecessor,
  *satellite* if to two). This is exact integer data (the branch's Enriques / dual graph),
  and it is the FDRS radix line — **not** the bare multiplicity sequence, which is a lossy
  projection of it. The CF machinery of P1–P3 generates the sequence; the proximity matrix
  is the tree it lives in.
- **Coupling = shared infinitely near points, keyed on the tree.** Two branches are
  **coupled** on exactly the points they *both* pass through — the shared initial segment of
  their point-sequences **as embedded in the common blow-up tree**, determined by the
  **proximity relations**, never by agreement of multiplicity numbers. The multi-branch germ
  is a Phase-14 coupled network: nodes = branch lines, edges = shared-subtree couplings; the
  coupled fiber reads the partner's tree (Def 193), proximities included.
- **The conserved interface quantity is the intersection multiplicity.** Over the shared
  subtree, each shared point contributes `m_p(C_1)·m_p(C_2)` to `(C_1·C_2)` (Noether) — the
  coupling ledger.

## Hypotheses

### H4a — coupling accounting reproduces the invariant (expected HOLD, the positive)
The FDRS coupled sum `Σ_{p ∈ shared subtree} m_p(C_1)·m_p(C_2)` — where the shared set is the
common infinitely-near **subtree, proximity-determined** (free/satellite), **not** a
multiplicity-sequence lcp — **equals** the intersection multiplicity `(C_1·C_2)` computed
**independently** (Sage: resultant / local-ring `dim O/(f,g)`), exactly, integer-only. Extends
additively over ≥2 branches (`C·(C_1+C_2) = C·C_1 + C·C_2`) and is symmetric.

### H4b — raggedness (expected HOLD, the Phase-14 thesis instance)
When coupled branches carry **different** multiplicities at a shared point, the joint
coupled tree has **unequal sibling completion counts** — it is **ragged** (Prop 148): there
is *no single radix line / no joint odometer* for the multi-branch configuration, yet the
conserved quantity `(C_1·C_2)` survives as the interface sum. "Value dies, conservation
survives" (Phase-14 thesis), made concrete.

### H4c — interface-balance ledger form (OPEN — tested, not assumed)
Whether the accumulation obeys the **specific** `issued = consumed + pending` interface
balance (Thm 89), or only the **weaker** symmetric-additive conservation of Noether's
formula. Pre-registered as open; claiming the strict ledger without demonstrating it is a
falsifier.

## Falsifiers (named before code)

- **F-P4-exact** — any float in the multiplicity-sequence / CF / intersection arithmetic
  (all `ℤ`; a float voids exactness).
- **F-P4-oracle** — H4a agreement measured against anything but an **independent** Sage
  intersection-multiplicity computation (resultant / local ring), not a restatement of the
  coupled sum.
- **F-P4-proximity** — keying the coupling on the **lcp of multiplicity sequences** rather
  than the **proximity-aware infinitely-near tree** (the Enriques diagram / free–satellite
  structure). Such an encoding passes free-point calibration and mis-scores the first
  satellite-contact pair; it is the pre-registered gap to close now, not an `F-P4-oracle`
  to discover later.
- **F-P4-ledger** — asserting the `issued = consumed + pending` interface balance (H4c) when
  only the weaker additive conservation is demonstrated.
- **F-P4-clean** — claiming a *clean* single-odometer routing reproduced the multi-branch
  tree. The corpus predicts raggedness (Prop 148); a "clean" reproduction is suspect and
  must be scrutinized, not celebrated.
- **F-novel** — any "new singularity mathematics" claim; the artifact is the encoding +
  verification of a classical invariant.

## Protocol

- **P4.1 — calibration (known answers), free AND satellite contact.** Explicit factored
  germs, computing `(C_1·C_2)` two independent ways — Sage oracle (resultant / local ring)
  **and** the proximity-keyed coupled sum — requiring exact agreement (H4a), integer-only:
  - *free-point contact*: node `xy` (→1); tacnode `(y−x²)(y+x²)` (→2); smooth-tangent
    `(y−x²)(y−x³)` (→2).
  - *satellite contact (the decisive case, mandatory)*: at least one pair that **separates
    after a satellite point** — two cusps with equal characteristic exponents diverging past
    the first satellite (`y²=x³` vs `y²=x³+x⁴` territory). This is exactly where a
    multiplicity-sequence lcp over-identifies the shared points and the proximity encoding
    must get it right (`F-P4-proximity`). Free-point cases alone do **not** exercise
    proximity, so the satellite pair belongs in P4.1 — not as a surprise in P4.2.
- **P4.2 — the headline.** `x²y² + x⁵ + y⁵`-type (tangent cone `x²y²` ⇒ branches tangent to
  both axes): factor into branches (Sage Puiseux/Newton), compute all pairwise
  `(C_i·C_j)` and the total, verify the coupled-network accounting reproduces it (H4a),
  and exhibit the ragged coupled tree (H4b) with the unequal-sibling witness.
- **P4.3 — raggedness + ledger.** Characterize the raggedness explicitly (the unequal
  completion counts), and test H4c (does `issued = consumed + pending` hold, or only
  additive conservation) — report whichever is true, gated by F-P4-ledger.

## Acceptance (qualitative, pre-registered)

- **H4a HOLDS** on P4.1 calibration (free-point **and** the mandatory satellite pair) **and**
  the P4.2 headline: the proximity-keyed coupled sum = independent Sage intersection
  multiplicity, exactly, integer-only (`F-P4-exact`, `F-P4-oracle`, `F-P4-proximity` silent).
- **H4b DEMONSTRATED**: an explicit ragged witness (unequal sibling completion counts;
  no joint radix line) with the invariant nonetheless recovered.
- **H4c REPORTED HONESTLY**: interface-balance ledger if it holds, else the weaker
  additive conservation, with the stronger claim gated (`F-P4-ledger`).

The pre-registered *expectation* is **positive on H4a/H4b** (a clean contrast with P3's
miss) and **open on H4c** — and, per the honest-scope contract, a partial or negative P4 is
a first-class result, not a failure.

## Exactness ladder

```
Sage oracle                    →   Rust / FDRS coupled-network    →   (G4, if promoted)
intersection multiplicity          the coupling accounting             Lean proof_wanted:
via resultant / local ring         (coupled-prefix sum, ℤ),             intersection-mult =
+ Puiseux factorization            ragged-tree witness                  coupled-prefix sum;
(the independent verifier)                                              contact = lcp
```

## Deferred / open

- Networks of **>2 branches** as full Phase-14 configurations (this charter does pairwise +
  total).
- The **interface-balance ledger** (H4c) as a theorem, and its link to the Phase-14 **SU7**
  machine (`network-core`) — recorded, not attempted here.
- Any general-curve claim beyond the pre-registered test cases.

## Status

- [x] Amendment (this document) — pre-registered before code
- [x] Revision (owner review, 2026-07-07): the coupling is keyed on the **proximity-aware
      Enriques diagram**, not the multiplicity sequence (`F-P4-proximity` added); a
      **satellite-contact pair is now mandatory in P4.1**. H4c grading unchanged.
- [x] **P4.1 BUILT (2026-07-07) — H4a HOLDS.** Proximity-tree tracker == oracle on 8/8 cases;
      the satellite falsifier fired (`y²=x³ vs y²=x⁵` separates at a satellite, seqlcp 4 ≠ 6);
      owner's `y²=x³ vs y²=x³+x⁴` logged (equisingular, free separation). `F-P4-proximity`
      justified. Run `runs/2026-07-07-p4-calibration/`.
- [x] **P4.2/P4.3 BUILT (2026-07-07; corrected on review) — PASS (H4a/H4b), H4c open.**
      Headline oracle = Sage-native `intersection_multiplicity`; factored `(y²−x³)(x²−y³)`
      `(C₁·C₂)=4=coupled`, and the **literal `x²y²+x⁵+y⁵` run over ℚ(i)** (its branches are
      not ℚ-rational, `c²=−1`) also = 4 — equisingular, caveat closed. **H4b** raggedness
      exhibited. **H4c** corrected: strict Thm-89 ledger **untested**, the additive form is a
      **vacuous** valuation axiom (not evidence); `F-P4-ledger` respected. δ label oracle
      (10/10) + `(2,q)` satellite check added; separation guard added. Run
      `runs/2026-07-07-p4-headline/`. Errata E-4/E-5/E-6 in `NEGATIVE.md`.
- [x] Rust mirror BUILT — truncated rational power-series blow-up tracker reproduces the
      ledger sums independently (`mod p4`, `cargo test` 9/9).

## References (in addition to the charter's)

- Max Noether's formula; intersection multiplicity of plane branches (Wall,
  *Singular Points of Plane Curves*, ch. on intersection & the Enriques diagram).
- Puiseux characteristic exponents ↔ multiplicity sequence / proximity of infinitely near
  points (classical; Enriques–Chisini, Casas-Alvero *Singularities of Plane Curves*).
- FDRS corpus (read-only): Phase 8 multi-timeline routing; Phase 14 coupled networks —
  raggedness (Prop 148), interface balance (Thm 89), the coupled-fiber law (Def 193).

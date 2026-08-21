# Experiment: FDRS Star-Shaped Resolutions (coupled HJ laws at a hub)

**Charter stage (G0/G1). Pre-registered 2026-07-07, BEFORE the battery code.** Successor
family to `experiment-fdrs-hj-singularities` (P1–P7 closed). A non-cyclic quotient surface
singularity `ℂ²/G` resolves to a **star-shaped** dual graph: one central curve `−b` and
**three arms, each an HJ chain** (Brieskorn). So it is **three P1 laws coupled at a hub** —
the smallest Phase-14 network built from an already-verified law.

- **Registry ID:** `experiment-fdrs-star-quotients` (proposed; G0 registry entity is the
  owner's human-gated step).
- **Parent:** `project-fdrs-formal` / `program-fdrs-core`. Reuses the P1 `hj-radix` law.
- **Workspace:** `workspace-math-proof-env` (SageMath + GAP for group theory). Rust mirror.
- **Owner:** `volition-billy` · **Risk:** low (internal, exact).
- **Follows** ADR-007 (pre-registration, exactness ladder, negatives first-class), ADR-008
  (never FDRS-novel).

## Honest-scope contract (stated first)

All of it is **classical**: the star-shaped resolution of quotient singularities (Brieskorn
1968), the Seifert invariants and plumbing calculus (Neumann; Orlik), the Riemenschneider
tables, and `coker(resolution form) ≅ H₁(link)` (**Mumford 1961**). This family claims **no new
theorem.** The
contribution is the **exact FDRS network encoding** (three P1 laws at a hub) and its **verified
gauge law**, with the naive generalization refuted and the boundary of verifiability drawn
honestly (F-S-tables).

## The load-bearing subtlety (the seeded fraud, stated up front)

P1's headline was `gauge = |det| = n = |group|`. **This does NOT generalize.** For any
negative-definite resolution graph, `coker(intersection form) ≅ H₁(link)` (**Mumford 1961**), and
for a quotient singularity the link is `S³/G` with `π₁ = G`, so `H₁ = G^{ab}` and thus
**`coker(form) ≅ G^{ab}` — the abelianization, not the group** (in particular `|det| = |G^{ab}|`).
The cyclic case masked this (cyclic groups are abelian). The extreme witness: the binary
icosahedral group `2I = SL(2,5)` is **perfect** (`G^{ab} = 1`), and the `E₈` intersection form
is **unimodular** — `det = 1` while `|G| = 120`. The naive `|det| = |G|` is `F-S-naive`; the
corrected `coker(form) ≅ G^{ab}` (verified as a group isomorphism) is the headline hypothesis.

## Hypotheses

**H-S1 — arms are P1 laws (anchor; expected HOLD).** For every entry in the battery, the three
arm chains of the resolution graph are exactly the HJ chains of their Seifert pairs `(nᵢ,qᵢ)`,
extracted by the verified P1 law; round-trip per arm; integer-only.

**H-S2 — the network gauge law (headline; expected HOLD, sharp form).**
`|det(star intersection form)| = |G^{ab}|`, verified two **independent** ways:
(a) exact ℤ determinant of the plumbing matrix; (b) `G^{ab}` from the **group presentation**
(GAP, pure group theory, no geometry — the F-S-circular guard). Includes the perfect-group
witness (`2I`: `det = 1`). The naive `|det| = |G|` **must FAIL** on every nonabelian entry —
the failures are enumerated; they are the point.

**H-S3 — hub–arm coupling identity (the network ledger; expected HOLD).**
The star-shaped determinant factorization
`|det| = n₁n₂n₃ · |b − Σᵢ qᵢ/nᵢ|` — **network gauge = (product of arm gauges) × (orbifold Euler
number)**. The hub carries the correction the arm gauges alone miss — the star analog of P4's
coupling ledger. Exact rational arithmetic; verified broadly on **arbitrary** star data (no
group needed), so it is a rigorous network-ledger test independent of the group tables.

**H-S4 (OPEN) — where the hub lives in FDRS.** The central node is not a digit of any arm law.
Candidate placements — coupling interface (Def 193) vs a fourth degenerate timeline — tested
against H-S3's factorization, or recorded **"placement open"** (the P5 F5-transport lesson: no
forced fits).

## Scope split (pre-registered, honest)

- **Verified group-connected core:** the SL(2,ℂ) / ADE quotients — `A_n` (cyclic, the P1
  regression anchor), `D_n` (binary dihedral, a family), `E₆/E₇/E₈` (`2T/2O/2I`). Here the
  plumbing (Dynkin) AND the group (GAP) are both independently available, so H-S1/S2 are
  verified two ways, with the `E₈` witness and the `F-S-naive` failure set.
- **Broad network-ledger battery:** H-S3 on **arbitrary** star Seifert data `⟨b;(nᵢ,qᵢ)⟩` —
  no group required, so a large rigorous sweep.
- **Honestly deferred:** the general non-Gorenstein GL(2,ℂ) quotients (`D_{n,q}`, the
  `T/O/I` central extensions) require the Riemenschneider tables; per **F-S-tables** we do NOT
  trust a table without an independent construction, so these are recorded as
  bounded-completeness unless constructed two ways.

## Convention watch-point (pre-registered)

The arm contributes `qᵢ/nᵢ` or its Riemenschneider dual `qᵢ'/nᵢ` (`qᵢqᵢ' ≡ 1 mod nᵢ`) to the
orbifold Euler number depending on convention — exactly the P1 toric-cone / dual-chain issue.
The convention is **calibrated on the ADE cases** (where `det` is known) before any sweep; a
mismatch is a calibration item, not a finding.

## Falsifiers (pre-registered)

- **F-S-naive** — stating or implying `|det| = |G|` generalizes; the truth is `|G^{ab}|`, and
  P1's version was an abelian coincidence.
- **F-S-circular** — "verifying" `|det| = |H₁(link)|` by computing `H₁` as `coker(intersection
  matrix)`: that identity is a theorem, so the check is circular. `G^{ab}` must come from the
  **group presentation**, independently of the graph.
- **F-S-tables** — trusting one Seifert table without an independent plumbing cross-check
  (classical-table transcription is a known hazard).
- **F-exact / F-novel** — everything ℤ/ℚ; Brieskorn/Riemenschneider/Neumann/ADE are classical.

## Protocol

- **PS.1** — build the battery: ADE data (Dynkin, verified), the binary polyhedral/dihedral
  groups (GAP), and arbitrary star Seifert data for H-S3. Two sources where possible.
- **PS.2** — H-S1 arm extraction via the P1 crate (reuse `hj-radix`, don't rewrite).
- **PS.3** — H-S2 gauge law `|det| = |G^{ab}|` on the group-connected core + the enumerated
  `F-S-naive` failures + the `E₈`/perfect witness (`det = 1`).
- **PS.4** — H-S3 factorization sweep (broad, arbitrary star data); H-S4 placement notes.
- Rust mirror: plumbing determinant + arm HJ law (reuses the verified P1 functions); Sage +
  GAP stay the oracle.

## Success criteria

H-S1..S3 exact on the verified core + broad H-S3 sweep, with the `F-S-naive` failure set
enumerated and the `det = 1` perfect-group witness confirmed; H-S4 honestly placed or open;
the general GL(2) tables honestly deferred (F-S-tables) rather than trusted.

## Status

- [x] Charter (this document) — pre-registered before the battery code
- [x] **PS.1–PS.4 BUILT (2026-07-07) — PASS.** `runs/2026-07-07-ps-battery/`:
  - **H-S1** arms are P1 HJ laws (anchor).
  - **H-S2 headline (sharp form)** `coker(star form) ≅ G^ab` **as groups** on all 7 SL(2)/ADE
    core entries — SNF of the plumbing (graph) ≅ `AbelianInvariants` (GAP, independent of the
    graph). **Two witnesses:** E₈ perfect (`det=1`, `|2I|=120`) on magnitude; **D₄=C₂×C₂ vs
    D₅=C₄ both at `|det|=4`** on structure (order-blind, SNF-sharp).
  - **F-S-naive CONFIRMED FIRING** — naive `|det|=|G|` fails on all 6 nonabelian entries.
  - **H-S3** network ledger `|det| = ∏nᵢ·|b−Σqᵢ/nᵢ|` exact on **1089 arbitrary plumbing forms**
    (a superset of quotient-realizable stars; Sage exact-det + Rust Bareiss det).
  - **H-S3b** closes the triangle `det ↔ Seifert ↔ group`: `∏nᵢ·|b−Σqᵢ/nᵢ| = |G^ab|` directly.
  - **H-S4** hub placement recorded **open**. Convention calibrated (`q` as-is).
- [x] Rust mirror `star-plumbing` (5/5, incl. coker structure via determinantal divisors); run
  record; `results.md`.
- [ ] **PS.5** (next): non-Gorenstein GL(2) battery via independent construction (invariant
  theory / Riemenschneider dot-diagram) with tables as the *third oracle* — richer abelianizations
  (`C₂×C₄`, `C₃×C₃`) stressing the SNF structure. H-S4 corpus placement.

## References

Mumford (1961), *The topology of normal singularities of an algebraic surface and a criterion for
simplicity* (Publ. Math. IHÉS 9) — **the source of H-S2's verified statement**:
`coker(resolution form) ≅ H₁(link)`, whose group-level form (composed with `π₁(S³/G) = G`,
`H₁ = G^{ab}`) is what this family checks. Brieskorn (1968), *Rationale Singularitäten* (the
star-shaped resolution); Riemenschneider, quotient-singularity tables; Neumann, plumbing calculus;
Orlik, *Seifert Manifolds*; the ADE / binary polyhedral groups. FDRS corpus (read-only): Phase 7
(arm laws), Phase 14 (coupling Def 193, Thm 89). P1 `hj-radix` (the reused arm law).

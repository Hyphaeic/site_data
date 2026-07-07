# Experiment: FDRS Hirzebruch–Jung Singularities (resolution chains as a context-dependent radix law)

**Charter stage (G0/G1). Pre-registered 2026-07-07, BEFORE any code.** This family
tests whether the Hirzebruch–Jung (HJ) resolution of a cyclic quotient surface
singularity `(n,q)` can be encoded **exactly** as an FDRS context-dependent radix
*law* (Phase 7), and where that encoding faithfully carries the geometry vs where it
breaks. Negatives are first-class; the encoding is on trial, not assumed.

- **Registry ID:** `experiment-fdrs-hj-singularities` (proposed; G0 registry entity is
  the user's human-gated step — runs, if directed ahead of it, are kept registry-ready).
- **Parent:** `project-fdrs-formal` / `program-fdrs-core`. Upstream corpus is
  **read-only**; nothing here feeds back as a corpus claim except a G4 `proof_wanted`
  candidate, gated.
- **Workspace:** `workspace-math-proof-env` (**SageMath** = exact probe + reference
  oracle: HJ continued fractions and toric resolutions are library-native — the
  non-self-authored verifier). A Rust mirror crate implements the FDRS-shaped law
  (the fidelity rung). No Python as the main implementation (repo rule); Sage is the
  oracle, Rust is the substrate.
- **Owner:** `volition-billy` · **Risk:** low (internal, exploratory, correctness-only).
- **Follows `ADR-007`** (pre-registration before results, exactness ladder, negatives
  first-class, honest novelty) and the standing **`ADR-008`** posture (FDRS = connection
  + curation + verified artifact; never "FDRS-novel").

## The honest-scope contract (the whole point, stated first)

**HJ ↔ continued fractions ↔ toric resolution is classical** (Hirzebruch; Jung;
Riemenschneider; Fulton §2.6; CLS Ch. 10). This family claims **no new singularity
theorem.** Its one legitimate contribution is a **verified exact encoding**: the HJ
recursion realized as an FDRS Phase-7 stateful radix system, integer-arithmetic
end-to-end, mirrored against an independent Sage oracle, with the correspondence's
**boundary proven or measured, not asserted.** A rendered resolution graph is an
illustration, never evidence. Where the FDRS encoding diverges from the geometry, that
divergence is the result.

## What this is, precisely (the Phase-7 framing, chosen deliberately)

The HJ expansion of `n/q` (with `0 < q < n`, `gcd(n,q)=1`) is the **negative-regular**
continued fraction `n/q = a₁ − 1/(a₂ − 1/(a₃ − ⋯))`, all `aᵢ ≥ 2`, extracted by

```
state (n,q)  →  digit a = ⌈n/q⌉ ,  next state (q, a·q − n)      terminate when q = 0
```

Each `aᵢ` is one exceptional divisor `Eᵢ` with self-intersection `Eᵢ·Eᵢ = −aᵢ`; the
chain is linear. We encode this as a **deterministic context-dependent radix system**
(Phase 7, Def 89 / Def 103), NOT as a Phase-13 generated gauge:

- **context** `C = {(n,q) : 0<q<n, gcd=1} ∪ {⊥}`; **initial context** `c₀ = (n,q)`;
- **evolution** `Γ((n,q)) = (q, a·q − n)` with `a = ⌈n/q⌉` (deterministic);
- **radix oracle** `Ω(s, c) = ⌈n_c / q_c⌉ = aᵢ` — the radix at position `|s|` is the
  emitted partial quotient / self-intersection. Phase-7 radices are **unbounded by
  definition** (`Ω → ℕ_{≥2}`), so the `aᵢ` legitimately *are* radices; this is the
  clause that makes the literal H1 wording admissible.
- **terminal** `q = 0` is a **Base-0 Wall** (Phase 9, Def 135–137) — the resolution is
  complete; carry cannot enter.

**Load-bearing consequence, pre-registered:** under this framing a singularity is a
radix **law** (a finite word over `{2,3,4,…}` = its chain), **not a point on one line.**
The space of singularities is the tree of admissible laws; the bijection
`{finite words, aᵢ≥2} ↔ {cyclic quotient singularities (n,q)}` is what H2's metric
lives on. Contextual sibling uniformity (Def 86) holds trivially (one radix per
context), so Thm 45 applies and each snapshot is a valid SU odometer.

## Hypotheses

### H1 — the encoding is exact (the anchor; expected to hold)
The HJ law above reproduces reference expansions exactly, integer-only, and round-trips
(chain → `n/q` via the minus-CF continuant). **Promoted sub-claim (bonus, not in the
RFME):** the FDRS **gauge / place value of the law equals the minus-CF continuant `= n
= |det of the −aᵢ tridiagonal intersection form| = |cyclic group|`.** The odometer's
accumulated place value *is* the order of the singularity.

### H1c — cylinder ≡ partial-resolution class (the structural core; expected to hold)
A length-`L` prefix `(a₁,…,a_L)` of the law is the class of all singularities whose HJ
resolution begins with those `L` divisors (leaving residual `(n_L,q_L)`). Cylinder =
subtree = partial-resolution class. This is Phase 14's prefix-gauge keystone (Def 192,
Thm 83) instantiated with `gauge = continuant`; it hands the ultrametric + `ball =
cylinder` for free.

### H2 — prefix ultrametric vs singularity adjacency (expected PARTIAL)
The prefix ultrametric `δ(x,y) = gauge(lcp(x,y))⁻¹` on the space of laws is compared to
**Arnold-style adjacency / the deformation order** (does one singularity degenerate to
the other). Pre-registered expectation: prefix-sharing captures the **blow-down
(chain-truncation) sub-order** of adjacency and **misses cross-chain deformation
adjacencies** (T-singularities; Kollár–Shepherd-Barron / Wahl). H2 is therefore a
*bounded correspondence* claim, tested only on the adjacency-decidable sub-battery — a
likely first-class negative, not a 95%-of-arbitrary-pairs headline.

### Demoted from the RFME — moved to falsifiers (see below)
- **"Carry ≡ blow-down" — reassigned to carry's normalization role, not its successor
  role.** FDRS carry plays two distinct roles the corpus keeps separate: **successor**
  (`Tick = +1`, Phase 1 Def 6 / Phase 9 Thm 61 — value-*changing*) and **normalization**
  (value-*preserving* re-canonicalization — the carry inside `⊕ = enc(dec+dec)`, i.e.
  `enc∘dec`; rechart Phase 5.3 Def 68–69; exact nesting Phase 14.9 Thm 97–98 — *"exact
  nesting buys resolution, never arithmetic; both lines enumerate the same ℕ"*).
  Castelnuovo contraction `(a,1,b) → (a−1,b−1)` is the **minus-CF reduction identity**:
  it rewrites a non-reduced chain to the reduced HJ form (all `aᵢ ≥ 2`) **preserving
  `n/q`** — exactly the *normalization* role (canonicalization *toward* the minimal
  chain, which by construction carries no `(−1)`-curve). So **blow-down ≡
  carry-as-normalization is the intended positive P2 mapping**; only "blow-down ≡
  carry-as-**successor**" is the (false) fraud-gallery entry.

## Falsifiers (named before code)

- **F-exact** — any float in the digit/gauge/state arithmetic of P1–P2 (Sage and Rust
  cores are exact `ℤ`/`ℚ`; a float there voids the exactness claim and is recorded).
- **F-oracle** — any P1 agreement measured against a self-authored reference rather than
  the independent Sage toric/CF oracle (the non-exploitable-verifier rule).
- **F-carry** — implementing blow-down via carry's **successor** role (`Tick = +1`,
  value-*changing*) rather than carry's **normalization** role (value-preserving
  re-canonicalization: `enc∘dec` / rechart Def 68–69 / exact nesting Thm 97–98);
  equivalently, any P2 contraction that fails to preserve `n/q`. The negative is
  **narrow** — *carry-as-successor* ≠ blow-down — not the broad "carry ≠ blow-down":
  *carry-as-normalization* is the intended positive.
- **F-circular** — validating H2 against any target derived from the HJ prefix itself
  (e.g. resolution-tree edit distance); the adjacency target must be independent.
- **F-lawpoint** — treating a singularity as a point on one shared line rather than as a
  radix law (would silently import a false "one odometer" picture into H2).
- **F-novel** — any statement, in a manifest or note, that this produces new singularity
  mathematics (it curates a classical correspondence into a verified artifact).

Full fraud gallery (tempting-but-wrong spins, seeded pre-run): `NEGATIVE.md`.

## Protocol — phases (escalating; exactness-gated)

Each phase pre-registers acceptance before its code; later phases are gated on earlier.

- **P1 — digit extraction as radix law (exact anchor).** Implement `Ω/Γ` above; run the
  battery **all `(n,q)`, `0<q<n ≤ 200`, `gcd(n,q)=1`**. Gate: chain matches the **Sage**
  reference exactly (integer-only); round-trip `chain → n/q` exact; `gauge = continuant
  = n = |det intersection form|` verified on the battery. Tag: `exact`.
- **P2 — blow-down as carry-normalization / rechart (not carry-as-successor).**
  Implement the Castelnuovo reduction `(a,1,b) → (a−1,b−1)` (the minus-CF reduction
  identity) and the toric blow-up/down as an FDRS value-preserving re-canonicalization —
  carry's normalization role (`enc∘dec`) / rechart (Def 68–69) / exact nesting
  (Thm 97–98). Gate: every contraction **preserves `n/q`** (birational invariant) and
  matches Sage's toric subdivision/contraction; the reduced chain is the canonical
  (all `aᵢ ≥ 2`) form. `F-carry` (a successor / value-changing implementation) must stay
  silent. Tag: `exact`.
- **P3 — prefix ultrametric vs adjacency (bounded correspondence, three strata).** Build
  cylinder ultrametric with `gauge = continuant`. The **adjacency-decidable sub-battery**
  is stratified so all three outcomes are represented:
  1. **A_n chains `[2ⁿ]`** — the trivial anchor; adjacency `A_n → A_{n−1}` **is** the
     prefix-truncation relation (expected clean **HIT**).
  2. **T-singularities** (`(dn², dnq−1)`-type; KSB/Wahl Q-Gorenstein smoothings) —
     cross-chain deformation adjacencies the charter predicts the prefix metric
     **misses** (expected **MISS**, first-class).
  3. **Christophersen–Stevens components** for `n ≤` a small bound — the deformation
     components of a cyclic quotient singularity are classified by **continued-fraction
     representations of zero** (chains that minus-CF-evaluate to 0 and are dominated by
     the HJ chain), an itself-CF-shaped, fully decidable adjacency criterion. This is
     the **contested middle** where the prefix metric has a real chance of *partial*
     correspondence rather than guaranteed hit or miss.
  Gate: on each stratum, prefix-order agreement with the blow-down sub-order of adjacency
  is measured; every cross-chain adjacency the prefix metric misses is enumerated. No
  claim outside the decidable sub-battery. The finding is the **shape** of the
  correspondence across the three strata (hit / contested / miss), not a single
  percentage. Tag: `exact` inputs, correspondence measured.

### P4 — Puiseux branches as a coupled network (gated amendment, pre-registered here, its code deferred)
Multi-branch plane curves: one FDRS timeline per Puiseux branch (characteristic
exponents), contact orders as **cross-timeline coupling** — a **Phase-14 coupled radix
network**, where the corpus *predicts raggedness* (coupling destroys the odometer;
Prop 148). Pre-registered hypothesis: **total intersection multiplicity is an
interface-balance quantity (Thm 89, `issued = consumed + pending`), not a clean-routing
scalar.** Acceptance (qualitative): a working two-branch example (test case
`x²y² + x⁵ + y⁵`-type) with correct total intersection multiplicity, and the raggedness
characterized. Begun only after P1–P3 land.

## Success criteria (corrected from the RFME)

- **P1–P2:** exact agreement on the battery, integer-only (`F-exact`, `F-oracle`,
  `F-carry` all silent); round-trip exact; `gauge = n` verified; blow-down
  value-preserving.
- **P3:** across the three strata — clean **hit** on A_n, characterized **partial**
  correspondence on the Christophersen–Stevens components (the contested middle),
  documented **miss** on T-singularities. The finding is the *shape* across strata, not
  a single percentage. (The original "≥95% of sampled pairs vs edit distance" is retired
  as circular, `F-circular`.)
- **P4:** qualitative — a two-branch example with correct total intersection
  multiplicity and a characterized ragged regime.

## Exactness ladder (ADR-007)

```
Sage reference oracle   →   Rust FDRS mirror        →   (G4, if promoted)
(HJ CF + toric fan;         (Phase-7 law, ℤ-exact;      Lean proof_wanted:
 the independent verifier)   fidelity-tested vs Sage)    HJ-as-Phase-7 law;
                                                         cylinder=partial-res;
                                                         gauge=continuant=n
```
A Rust result contradicting the Sage oracle is a bug, not a finding. Lean is touched
only at G4, gated on a confirmed, promotable claim (the `Conjectures/` namespace).

## Non-goals (pre-committed)

- **No general (Hironaka-scale) resolution** — cyclic quotient / plane-curve HJ only.
- **No performance claim** — correctness only in this charter (no timing, no FLOPs).
- **No new singularity mathematics** — classical correspondence, verified encoding.
- **No H2 claim off the adjacency-decidable sub-battery** — untested ≠ confirmed.

## Deliverables

1. `source/sage/` — HJ reference + toric oracle + adjacency sub-battery (Sage).
2. `source/rust/` — Rust mirror crate: the Phase-7 HJ radix law, ℤ-exact, tested
   against the Sage battery.
3. `results.md` — per-phase verdicts; `runs/<date>-*/manifest.yaml` provenance triples.
4. Findings note — where FDRS carry/rechart semantics matched or diverged from chain
   contraction, and exactly how far H2 held against adjacency.

## Proposed file layout

```
experiments/maths/fdrs-hj-singularities/
  README.md            # this charter (G0/G1)
  NEGATIVE.md          # seeded fraud gallery + falsifier table (pre-run)
  results.md           # (later) per-phase verdict table
  source/
    sage/              # HJ CF + toric reference oracle, adjacency sub-battery
    rust/              # Phase-7 HJ radix-law mirror crate
  runs/
    <date>-p1-battery/ # (later) one dir per executed run + manifest.yaml
    ...
  evidence/            # (later) artifacts supporting promoted claims
```

## Status

- [x] Charter (this document) — honest-scope contract, hypotheses, falsifiers, phases,
      seeded fraud gallery — authored BEFORE any code
- [x] Charter refinements (owner review): F-carry narrowed to *carry-as-successor* vs
      *carry-as-normalization*; P3 stratified with Christophersen–Stevens as the
      contested middle
- [~] Registry entity — deferred by owner ("handle it later"); run kept registry-ready
- [x] **P1 BUILT (2026-07-07) — Sage side, exact anchor PASS.** HJ chain as a Phase-7
      radix law; 12231-pair battery (`0<q<n≤200`), **0 failures** across three
      independent oracles (round-trip · determinant · toric); **gauge = |det| = n =
      |group|** confirmed; integer-only. Run `runs/2026-07-07-p1-battery/`;
      verdict `results.md`. Rust mirror of the same law is the remaining P1 rung.
- [x] **P1 Rust mirror BUILT (2026-07-07)** — `source/rust/hj-radix` (`no_std`, zero
      deps) reproduces the Sage battery **bit-for-bit** (u64 checksum pinned; 3/3 tests).
      P1 exactness ladder complete (Sage oracle + Rust mirror).
- [x] **P2 BUILT (2026-07-07) — PASS.** Blow-up/down preserve `(n,q)` on 3043 pairs
      (`n≤100`), reduction confluent to the canonical chain; **F-carry exercised** (4/4
      successor edits break `(n,q)`); toric star-subdivision 2443/2443; Rust mirror 5/5.
      Run `runs/2026-07-07-p2-blowdown/`. => blow-down ≡ carry-as-normalization.
- [x] **P3 BUILT (2026-07-07) — PARTIAL (as pre-registered).** S1 A_n **hit** (59/59,
      prefix = truncation order); S2 T-singularities **miss** (0/254 QG-adjacencies
      prefix-related, 255/255 verified as `(1/dn²)(1,dnq−1)`); S3 corr `+0.193` + the
      linear-vs-Catalan no-go. First-class negative NEG-1. Run
      `runs/2026-07-07-p3-adjacency/`; Rust mirror 7/7.
- [ ] P4 (Puiseux multi-branch, Phase-14 coupled network) — amendment, not begun

**THE P1–P3 ARC IS COMPLETE (2026-07-07).** The HJ resolution is an exact FDRS Phase-7
radix law (P1, gauge = |det| = n = |group|, three oracles + bit-identical Rust mirror);
blow-down is carry-*normalization* not the successor (P2, `(n,q)`-preserving + confluent,
F-carry exercised); and the prefix ultrametric is a faithful shadow of the resolution order
but a coarse, mostly-blind shadow of the deformation order (P3, partial — hit on A_n, miss
on T-singularities, Catalan no-go). Every core exact and mirror-checked; every image would
be an illustration, never evidence.

## Next steps (DRAFT → G2)

1. Human review of this charter; confirm the Phase-7-law framing and the adjacency
   sub-battery scope (which families count as "adjacency-decidable").
2. Register the entity (`registry-entity.draft.yaml` → `corp/registry/_staging/` →
   validate → materialize; flip `lifecycle:proposed → active`).
3. Commit the charter (pre-registration) **before** any run-emitting code, per ADR-007.
4. Build P1 (Sage oracle + Rust mirror together) — the anchor and its verifier — then
   proceed.

## References

- HJ continued fractions / cyclic quotient singularities: Fulton, *Toric Varieties*
  §2.6; Cox–Little–Schenck (CLS) Ch. 10; Riemenschneider (point rule, dual chains).
- Castelnuovo contraction / `(−1)`-curves; toric blow-up = fan subdivision.
- Deformation adjacency: Arnold (adjacency); Kollár–Shepherd-Barron, Wahl
  (T-singularities, Q-Gorenstein smoothings); **Christophersen; Stevens** (deformation
  components of cyclic quotient singularities ↔ continued-fraction representations of
  zero) — the P3 adjacency oracle, esp. the contested-middle stratum.
- Puiseux / characteristic exponents (P4): Wall, *Singular Points of Plane Curves*.
- FDRS corpus (`projects/fdrs-formal/docs/fdrs.md`, read-only): Phase 7 context-dependent
  radix (Def 84–90, 103; CSU Def 86; Thm 45), Phase 9 Base-0 Wall (Def 135–137),
  Phase 5.3 rechart (Def 68–69), Phase 14 prefix-gauge keystone (Def 192, Thm 83) +
  interface balance (Thm 89) + raggedness (Prop 148) + exact nesting (Def 204, Thm 97–98).
- Method: `decisions/ADR-007` (gates, exactness ladder, negatives-first-class),
  `ADR-008` (honest-broker posture); sibling charters
  `experiments/maths/fdrs-{attention-mixed-radix,radix-shaders}/README.md`.

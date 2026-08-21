# Results — FDRS Star-Shaped Resolutions (coupled HJ laws at a hub)

Successor family to `fdrs-hj-singularities`. A non-cyclic quotient `ℂ²/G` resolves to a
**star**: central `−b` + three arms, each an HJ chain (Brieskorn) — three P1 laws at a hub.
All classical (Brieskorn/Riemenschneider/Neumann/ADE); the artifact is the exact network
encoding and its **corrected** gauge law.

| Hypothesis | Claim | Verdict | Evidence |
|---|---|---|---|
| **H-S1** | arms are P1 HJ laws | **HOLD** | arm chain = `hj_chain(nᵢ,qᵢ)`; ADE arms `[2^l]=(l+1,l)`; Rust + Sage |
| **H-S2** | **`coker(star form) ≅ G^ab` as GROUPS** (not just `\|det\|=\|G\|`) | **PASS · headline** | 7/7 SL(2)/ADE core; SNF of the plumbing (graph) ≅ `AbelianInvariants` (GAP, independent); **sharp: D₄=C₂×C₂ vs D₅=C₄ both at `\|det\|=4`**; E₈ perfect (trivial, `det=1`, `\|2I\|=120`) |
| **F-S-naive** | naive `\|det\|=\|G\|` fails | **CONFIRMED FIRING** | fails on all 6 nonabelian (`4≠8, 4≠12, 4≠16, 3≠24, 2≠48, 1≠120`) |
| **H-S3** | `\|det\| = ∏nᵢ·\|b−Σqᵢ/nᵢ\|` | **HOLD** | **1089 arbitrary plumbing forms** (a *superset* of quotient-realizable stars), **0** failures; two det methods (Sage exact + Rust Bareiss) |
| **H-S3b** | `∏nᵢ·\|b−Σqᵢ/nᵢ\| = \|G^ab\|` directly | **HOLD** | Seifert ↔ group with **no determinant between** — closes the triangle `det ↔ Seifert ↔ group`, each edge independently computed |
| **H-S4** | FDRS home of the hub | **OPEN** | hub carries the orbifold-Euler correction; placement recorded open (F5-transport lesson) |

## The headline — the gauge law corrects itself

P1's result was `gauge = |det| = n = |group|`. **It does not generalize.** For a quotient
singularity the link is `S³/G` and `coker(resolution form) ≅ H₁(link)` (**Mumford 1961**)
`≅ H₁(S³/G) ≅ G^ab` — the **abelianization** (using `π₁(S³/G) = G`). The cyclic P1 case was an
*abelian coincidence*. **H-S2 as stated verifies the group-level form of Mumford's theorem**, so
the reference belongs on the claim, not just in the bibliography.

The claim is verified **as an isomorphism of groups**, not merely of orders: the Smith normal
form of the plumbing matrix (graph side) against `AbelianInvariants(G)` from GAP (group side,
independent). The verified core:

| type | group | `\|det\|` | `coker` (SNF) | `G^ab` (GAP) | `\|G\|` | `coker≅G^ab` | naive `det=\|G\|` |
|---|---|---|---|---|---|---|---|
| A₅ | cyclic C₆ | 6 | C₆ | C₆ | 6 | ✓ | ✓ *(abelian)* |
| **D₄** | 2D₂ = Q₈ | **4** | **C₂×C₂** | **C₂×C₂** | 8 | ✓ | ✗ |
| **D₅** | 2D₃ = Q₁₂ | **4** | **C₄** | **C₄** | 12 | ✓ | ✗ |
| **D₆** | 2D₄ = Q₁₆ | **4** | **C₂×C₂** | **C₂×C₂** | 16 | ✓ | ✗ |
| E₆ | 2T = SL(2,3) | 3 | C₃ | C₃ | 24 | ✓ | ✗ |
| E₇ | 2O | 2 | C₂ | C₂ | 48 | ✓ | ✗ |
| **E₈** | **2I = SL(2,5), perfect** | **1** | **1** | **1** | **120** | **✓** | **✗** |

Two sharp witnesses, one for each way order alone is blind:

- **E₈** — magnitude: `2I` is **perfect** (`G^ab = 1`), the form is **unimodular** (`det = 1`),
  while `|2I| = 120`. `det = |G|` is off by two orders of magnitude; the corrected law holds.
- **D₄ vs D₅** — structure: **both have `|det| = 4`**, but `Q₈^ab = C₂×C₂` and `Q₁₂^ab = C₄`.
  The determinant cannot tell them apart; the **coker structure** does, and matches the group on
  the nose. This is the isomorphism verified where the order is silent — checking the *object*,
  not a number.

`G^ab` is computed from the **group presentation** (GAP), independent of the graph — the
`F-S-circular` guard: we never read `H₁` off the matrix we are trying to explain. Both the graph
side (Sage `elementary_divisors`) and an independent Rust computation (invariant factors via
determinantal divisors `f_k = D_k/D_{k−1}`) agree on the coker structure.

## The network ledger (H-S3) and the closed triangle (H-S3b)

`|det| = (∏nᵢ) · |b − Σᵢ qᵢ/nᵢ|` — **network gauge = (product of arm gauges) × (orbifold Euler
number)**. This is the star analog of P4's coupling ledger: the arm gauges `∏nᵢ` are the local
P1 data, and the **hub** contributes the orbifold-Euler correction `|b − Σqᵢ/nᵢ|` that the arms
alone miss. Verified exactly by two independent determinant methods (Sage's exact det and the
Rust fraction-free Bareiss det).

**Domain note (important):** the sweep runs **1089 arbitrary star plumbing forms**
`⟨b;(n₁,q₁),(n₂,q₂),(n₃,q₃)⟩` with a negative-definite `b` — this is a **superset** of the
quotient-*realizable* stars. H-S3 is therefore a statement about **plumbing forms**, not about
groups: it makes the hub ledger a property of the network encoding itself, not of the ADE list.
Read `1089` as *plumbing configurations*, **not** 1089 quotient singularities.

**The closed triangle (H-S3b).** Three quantities, three independent computations:

```
        coker(plumbing matrix)  ──(H-S2, groups: SNF ≅ GAP)──  G^ab
                 │                                              │
       (H-S3: |det| = ∏nᵢ·|b−Σqᵢ/nᵢ|)              (H-S3b: ∏nᵢ·|b−Σqᵢ/nᵢ| = |G^ab|)
                 └─────────────── ∏nᵢ·|b−Σqᵢ/nᵢ| ──────────────┘
                        (Seifert data — orbifold Euler number)
```

H-S3b is the edge with **no determinant in the middle**: for the actual quotients, the Seifert
data alone (`∏nᵢ·|b−Σqᵢ/nᵢ|`, pure rational arithmetic) equals `|G^ab|` (pure group theory) —
verified on all core entries. It is implied by H-S2 ∧ H-S3, but computing it as its own edge
closes the triangle `det ↔ Seifert ↔ group` with **each of the three edges independently
computed** — the strongest single consistency statement the family makes.

The convention watch-point resolved cleanly: the arm `hj_chain(n,q)` uses `q` as-is (the non-ADE
case `q≠n−1` disambiguates — `formula(q)=8=det`, `formula(q')=12`), calibrated on ADE before the
sweep as pre-registered.

## Honest scope

- **Verified two ways:** the SL(2)/ADE core (plumbing *and* GAP group both available) — H-S1/S2
  (as a group isomorphism) with both witnesses and the `F-S-naive` failure set — plus the
  group-free H-S3 sweep and the closed triangle H-S3b.
- **Deferred (F-S-tables):** the general non-Gorenstein GL(2,ℂ) quotients (`D_{n,q}`, the `T/O/I`
  central extensions) need the Riemenschneider tables; we do **not** trust a table without an
  independent construction, so they are recorded as bounded-completeness, not claimed.
- **Open (H-S4):** the FDRS home of the hub (coupling interface Def 193 vs a degenerate 4th
  timeline) — not forced.

### PS.5 (next phase) — the non-Gorenstein battery with tables as the *third oracle*

The `D_{n,q}` deferral is correct, and the unlock is already in the toolkit: the GL(2) quotients'
resolution data can be **derived, not copied** — via invariant theory or the Riemenschneider
cyclic-cover / dot-diagram construction — at which point the classical tables become **the thing
being checked** rather than the first source (turning `F-S-tables` from a limit into a test).
Two payoffs: (i) H-S2's isomorphism form gets exercised on **richer abelianizations** (e.g.
`C₂×C₄`, `C₃×C₃`) beyond the ADE core's `{cyclic, C₂×C₂}`, stressing the Smith-normal-form
structure, not just its magnitude; (ii) the triangle H-S3b extends to genuinely non-Gorenstein
Seifert data. A natural, self-contained continuation.

**Through-line.** P1 said a cyclic singularity's gauge is its group order. The network says the
truth is subtler and sharper: **the star gauge is the abelianization — and not just its size, its
group** (`coker(resolution form) ≅ G^ab`), factoring as arm gauges times the hub's orbifold-Euler
number. Two witnesses pin it where order alone is blind: the perfect-group `E₈` (`det=1`,
`|G|=120`) on magnitude, and `D₄` vs `D₅` (both `det=4`, but `C₂×C₂` vs `C₄`) on structure. The
triangle `det ↔ Seifert ↔ group` closes with each edge computed independently. No new mathematics;
a classical correspondence, encoded as a Phase-14 network and verified as an isomorphism.

**Corpus placement (Phase-13 + Phase-14).** Each **arm gauge** `nᵢ` is an HJ continuant — Phase-13's
`Def 181` convergent-pair gauge `q_k` (the arm chains are minus-CFs, `Thm 72` `|det|=1`, `Thm 73`
growth); the **network** glues them at a hub, so the star gauge is a **coupled convergent-pair
ledger** — `Def 181` in its Phase-14 §14.6 coupled form, the same object as P4's ledger and the
star analog of H-S3. `Def 181` is `❌ missing` in Lean; this family (with the HJ P1/P4) is a
geometric witness for it. (Ref: `docs/fdrs.md` §13.2, §14.6.)

**Reproduce.** `cd source/sage && sage ps_star_quotients.sage` · `cd source/rust && cargo test --offline`

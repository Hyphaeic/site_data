# Negative results & fraud gallery — fdrs-value-semigroup

Seeded **before any run** (ADR-007: negatives first-class; tempting-but-wrong spins written
down so they cannot be quietly used). Recorded negatives are bounded-completeness statements.

## Fraud gallery — spins this family must NOT be used to support

1. **"The value semigroup is FDRS-novel."** FALSE. Γ(C), its generators, δ, the conductor,
   Gorenstein symmetry, the Apéry set, free/telescopic semigroups — all classical (Zariski,
   Apéry, Kunz, Delgado). This encodes the ring's order filtration as an FDRS gauge/mixed-radix
   and verifies it; connection + curation, never new singularity mathematics (`F-novel`).
2. **"A gap, because we didn't observe that order."** FALSE method. `n ∉ Γ` must be
   **certified**: no element of the ℚ-span of monomials up to `N = c+2m` achieves order `n`.
   Finite *monomial-order* sampling yields only `⟨v̄₀,v̄₁⟩` (a proper subsemigroup for `g>1`);
   claiming a gap from it is `F-V-sample`. The span (with cancellation combinations like
   `y²−x³`) up to the conductor bound is what makes the enumeration complete.
3. **"Two-path Γ agreement — using monomial orders for path (a)."** FALSE for `g>1`: monomial
   orders give `⟨v̄₀,v̄₁⟩ ⊊ Γ`, so the paths would disagree on the multi-exponent battery. Path
   (a) must be the linear span (`F-V-sample`). If they "agree" via monomials it is only because
   the battery was accidentally all `g=1`.
4. **"The conductor IS the Base-0 Wall."** FALSE. The Base-0 Wall is **source-side** (the
   *process* stops — no representable digit, Phase 9). The conductor is **target-side** (the
   *image* saturates — past `c` the valuation is onto `ℕ`). They are dual boundary objects;
   conflating them is `F-V-wall`. (If the encoding ever forced them to coincide, that collapse
   would be the finding — it does not.)
5. **"`c = 2δ` shows the encoding captures the geometry."** FALSE. `c = 2δ` is the Gorenstein
   symmetry theorem — true for every plane branch regardless of encoding. It is an **oracle on
   the implementation** (does the *computed* `c` equal `2×` the *computed* `δ`?), never a
   discovery (`F-V-gorenstein`).
6. **"Mixed-radix uniqueness, without checking freeness."** FALSE precondition. Unique bounded
   digits `0 ≤ cᵢ < nᵢ` require the semigroup to be **free/telescopic** (`nᵢ v̄ᵢ ∈ ⟨v̄_{<i}⟩`).
   A non-free semigroup breaks uniqueness. Freeness must be verified, and the representation
   round-tripped, or it is `F-V-free`.
7. **"The Apéry form is the mixed-radix result."** Understated. Apéry `n = w + k·m` is a
   single-radix-`m` shadow; the genuine mixed-radix statement is the free-semigroup standard
   form `n = Σ cᵢ v̄ᵢ`, `0 ≤ cᵢ < nᵢ`, with radices `nᵢ = e_{i−1}/eᵢ`. Reporting only Apéry
   sells the result short; reporting mixed-radix without freeness (item 6) over-sells it.
8. **"H-V4: the pair semigroup is the coupling ledger."** OVERCLAIM if asserted. H-V4 is gated
   and exploratory (Delgado's multi-branch symmetry is subtle); one worked pair maximum, or an
   explicit deferral — never a claimed general correspondence.

## Falsifier table (after PV.1–PV.4)

| ID | Fires when | Kills | Status |
|---|---|---|---|
| **F-V-sample** | a gap claimed from monomial sampling without the span+conductor completeness | H-V1 / the gap set | **DEMONSTRATED** — `(4;6,7)` monomials call `13∈Γ` a fake gap; span recovers it. Main run uses the span → **HONORED** |
| **F-V-wall** | conductor conflated with the Base-0 Wall | the duality claim | **HONORED** — conductor finite (target saturation) vs unbounded odometer top digit (source process); `a_max=c+m−1≠c` |
| **F-V-gorenstein** | `c=2δ` cited as evidence of the encoding, not an oracle on it | H-V2's honesty | **HONORED** — `c=2δ` used only as an oracle-on-implementation |
| **F-V-free** | mixed-radix uniqueness asserted without freeness + round-trip | H-V3 | **DEMONSTRATED** — `⟨5,6,7,8⟩` symmetric yet non-free ⇒ no mixed-radix; H-V3 shown independent of H-V2. Main run checks freeness + round-trips → **HONORED** |
| **F-exact** | any float in the semigroup/valuation/normal-form arithmetic | the `exact` tag | **SILENT** — everything ℤ/ℚ (Sage `QQ`, Rust `i64`) |
| **F-novel** | any "new singularity mathematics" claim | the honest-scope contract | **HONORED** — Zariski/Apéry/Kunz/Delgado, all classical |

## Recorded negatives (bounded-completeness statements)

**NEG-V1 — my `F-V-free` control was wrong; the check caught it.** I first chose `⟨5,6,9⟩` as
the "symmetric but not free" control and asserted non-freeness by hand. The `is_free_semigroup`
permutation search (Rust) and `is_free_any` (Sage) **refuted this**: `⟨5,6,9⟩` *is* free via the
generator order `(6,9,5)` (gcd tower `6>3>1`, with `9·2=18∈⟨6⟩`, `5·3=15∈⟨6,9⟩`). Freeness
permits *any* generator ordering, not the multiplicity-first one I assumed. Corrected to
`⟨5,6,7,8⟩`: multiplicity `5` is prime, so `gcd(5,·)=1` forbids a two-step gcd descent and the
semigroup is provably non-free in **every** order, while remaining symmetric (`c=10=2δ`). Bound:
this is a statement about *my* first candidate, not about which numerical semigroups are free —
the tool corrected a hand-analysis slip, exactly as the ladder is meant to.

*(No hypothesis was falsified. H-V1–H-V4 all hold; H-V4 scoped to one pair by charter.)*

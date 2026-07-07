# Experiment: FDRS Value Semigroup (the ring's order-filtration as a mixed-radix gauge)

**Charter stage (G0/G1). Pre-registered 2026-07-07, BEFORE any code.** Successor family to
`experiment-fdrs-hj-singularities`. The third bridge: everything prior encoded the *resolution
process* of a singularity; this encodes its **ring** — the value semigroup Γ(C) of a plane
branch as the image of the order filtration, and its Apéry / free-semigroup structure as a
genuine mixed-radix normal form.

- **Registry ID:** `experiment-fdrs-value-semigroup` (proposed; G0 registry entity is the
  owner's human-gated step — runs kept registry-ready).
- **Parent:** `project-fdrs-formal` / `program-fdrs-core`. Upstream corpus read-only.
- **Workspace:** `workspace-math-proof-env` (**SageMath** exact ℚ oracle: valuations through
  `LaurentSeriesRing(ℚ)` + the classical generator formula) + a Rust `no_std` mirror.
- **Owner:** `volition-billy` · **Risk:** low (internal, exploratory, correctness-only).
- **Follows `ADR-007`** (pre-registration before results, exactness ladder, negatives
  first-class) and **`ADR-008`** (honest-broker; never FDRS-novel).

## Honest-scope contract (stated first)

Everything invoked is **classical**: the value semigroup Γ(C) as a complete equisingularity
invariant (Zariski); its generators from the characteristic exponents; gaps, the delta
invariant δ, the conductor c; Gorenstein ⇒ symmetric ⇒ `c = 2δ` (Kunz); the Apéry set (Apéry
1946); free/telescopic numerical semigroups. This family claims **no new singularity theorem.**
Its contribution is the **verified FDRS encoding**: Γ as a gauge image, the conductor as a
*dual* Base-0 Wall, and the free-semigroup standard representation as an **exact mixed-radix
system on the ring's filtration** — two independent computations, integer-only, with the δ
cross-check tying this family to `fdrs-hj-singularities`.

## The FDRS reading (what is actually claimed)

- **Γ is the gauge image**: `Γ(C) = { ord_t h(x(t),y(t)) : h ∈ 𝒪_C } ⊆ ℕ` — the values the
  order filtration *reaches*. Gaps = unreachable values.
- **The conductor is a DUAL Base-0 Wall** (a distinction, pre-registered, not a collapse — see
  `F-V-wall`): the Phase-9 Base-0 Wall (Def 135–137) is **source-side** — where the *process*
  terminates (no representable digit). The conductor `c` is **target-side** — where
  *unreachability* terminates (past `c` the valuation is surjective onto `ℕ`). They are dual
  boundary objects; the encoding keeps them distinct.
- **The free-semigroup standard form is mixed-radix** (the deliverable, strengthened from
  Apéry): plane-branch semigroups are **free/telescopic**, so every `n ∈ Γ` has a **unique**
  `n = Σᵢ cᵢ v̄ᵢ`, `0 ≤ cᵢ < nᵢ` (`i ≥ 1`), with **radices `nᵢ = e_{i−1}/eᵢ`** (`eᵢ =
  gcd(β₀,…,βᵢ)`) and **place values `v̄ᵢ`**. This is FDRS Phase-1 mixed-radix on the ring's
  filtration — digits are semigroup coordinates, radices are the `eᵢ` ratios. The **Apéry
  form** `n = w + k·m` (`m = v̄₀`, `w ∈ Ap(Γ,m)`, `|Ap|=m`) is its single-radix-`m` shadow;
  symmetry of Γ becomes an exact involution `w ↦ (c−1+m) − w` on `Ap`.

## Hypotheses

**H-V1 — two-path agreement (anchor; expected HOLD).** Γ computed two independent ways agrees
up to `c + 2m` on the battery: (a) **linear-span valuation** — the ℚ-span of monomials
`x(t)^a y(t)^b` up to degree `N = c+2m`, row-reduced; the pivot t-orders are `Γ ∩ [0,N]` (the
span captures cancellation combinations like `y²−x³`, so it reaches the higher generators — NOT
individual monomial orders, which give only `⟨v̄₀,v̄₁⟩`; see `F-V-sample`); (b) the **classical
generator formula** `Γ = ⟨v̄₀,…,v̄_g⟩` with `v̄` from the characteristic exponents (Zariski).
Exact, integer-only.

**H-V2 — the conductor wall and symmetry (expected HOLD).** `c = 2δ` on every branch
(Gorenstein), with `δ = #gaps` **and** `δ` independently from the `fdrs-hj-singularities` P4
tracker's `δ = Σ mᵢ(mᵢ−1)/2` **and** `δ = (p−1)(q−1)/2` for `(p,q)` cusps — a **four-way δ
check** binding this family to the previous. `c = 2δ` is an oracle on the implementation
(`F-V-gorenstein`), never a discovery.

**H-V3 — mixed-radix normal form (the deliverable; expected HOLD).**
- **Freeness/telescopic:** `nᵢ v̄ᵢ ∈ ⟨v̄₀,…,v̄_{i−1}⟩` for all `i` (verified exactly).
- **Unique mixed-radix representation:** every `n ∈ Γ` has a unique `n = Σ cᵢ v̄ᵢ`, `0 ≤ cᵢ <
  nᵢ` — a genuine mixed-radix system (radices `nᵢ`, places `v̄ᵢ`). Verified by round-trip on
  `Γ ∩ [0, c+2m]`.
- **Apéry shadow + symmetry:** `|Ap(Γ,m)| = m`; the `w + k·m` form is unique; the involution
  `w ↦ (c−1+m) − w` maps `Ap → Ap` bijectively ⟺ Γ symmetric — verified exactly.

**H-V4 (OPEN, gated) — semigroup of the pair.** For two branches, the value structure of the
pair with the intersection multiplicity (P4) as the coupling datum — whether the P4 coupling
ledger reappears as the correction term (Delgado's symmetry of the multi-branch semigroup).
Exploratory; one worked pair maximum; **deferred by default**.

## Falsifiers (pre-registered)

- **F-V-sample** — asserting a gap `n ∉ Γ` from finite *sampling* without the completeness
  argument. A gap below `c` must be **certified** (no element of the ℚ-span up to `N=c+2m`
  achieves order `n`), not merely unobserved. Monomial-order sampling (which yields only
  `⟨v̄₀,v̄₁⟩`) is the seeded trap — path (a) must be the full linear span.
- **F-V-wall** — conflating the conductor with the Base-0 Wall. Source-side process termination
  vs target-side image saturation are **dual**; the encoding must keep them distinct (or the
  collapse itself, if it happened, is the finding — it does not).
- **F-V-gorenstein** — citing `c = 2δ` as evidence of the *encoding*. It is a classical theorem
  for plane branches; the test is that the encoding's computed `c` and `δ` satisfy it — an
  oracle on the implementation, never a discovery.
- **F-V-free** — asserting the mixed-radix uniqueness without verifying freeness
  (`nᵢ v̄ᵢ ∈ ⟨v̄_{<i}⟩`) and the round-trip; a non-free semigroup would break unique bounded
  digits, so freeness is the load-bearing precondition and must be checked, not assumed.
- **F-exact / F-novel** — everything ℤ/ℚ; Zariski/Apéry/Kunz/Delgado are classical.

## Protocol

- **PV.1** — parametrization → Γ by both paths (linear span + generator formula); H-V1 battery.
- **PV.2** — gaps, δ, conductor; H-V2 four-way δ check (reuse the P4 tracker `δ = Σmᵢ(mᵢ−1)/2`).
- **PV.3** — freeness, the mixed-radix representation (unique bounded digits, round-trip), the
  Apéry set + symmetry involution; H-V3.
- **PV.4** — (gated) one coupled pair, H-V4 exploratory note or explicit deferral.
- Rust mirror: semigroup enumeration + mixed-radix / Apéry normal form (ℤ only). Sage oracle:
  valuations through `LaurentSeriesRing(ℚ)` and the generator formula independently.

## Battery

All `(p,q)` cusps `p < q ≤ 30`, `gcd=1` (single characteristic pair), plus a curated set of
multi-exponent branches — e.g. `(4;6,7)`, `(6;8,9,19)`-type — where the generator formula is
nontrivial (`g > 1`, so the span-vs-monomial distinction and freeness are actually exercised).
Every branch carried as an exact parametrization over ℚ.

## Success criteria
- **PV.1–PV.3** exact on the full battery: two-path Γ agreement to `c+2m`; the four-way δ check
  closed; freeness + unique mixed-radix round-trip + Apéry symmetry all exact.
- **PV.4** one honest exploratory paragraph or an explicit deferral.

## Deliverables
Sage oracle + Rust mirror; per-run manifests; `results.md`; `NEGATIVE.md` (fraud entries
`F-V-sample`, `F-V-wall`, `F-V-gorenstein`, `F-V-free` seeded pre-run); findings note.

## Status
- [x] Charter (this document) — pre-registered before code
- [x] `NEGATIVE.md` seeded (fraud gallery + falsifier table, before any run)
- [x] **PV.1 / PV.2 / PV.3** — H-V1/H-V2/H-V3 all PASS (248/248 cusps + 3/3 multi-exponent, exact)
- [x] **PV.4** (gated) — one worked pair: `(C₁·C₂)=4` = δ correction term (both oracles); semimodule symmetry deferred
- [x] Rust `no_std` mirror — 7/7, checksum pinned; falsifiers demonstrated firing
- See `results.md` (verdicts + three-bridge closure) and `NEGATIVE.md` (NEG-V1, falsifier table).

### Next charter owed (not in this family)
The **value-semimodule `Γ(C₁∪C₂) ⊆ ℕ²`** (pair of branches) and its **Delgado symmetry** — the
2-branch analogue of `c=2δ` — are a separate phase with their own pre-registration. The value set
of a pair is a semimodule, not a semigroup; the symmetry theory is subtler. `H-V4` above is only
the one-pair anchor (the `δ(C₁∪C₂)=δ₁+δ₂+(C₁·C₂)` coupling-term identity) that justifies opening
it. Do **not** extend PV.4 in place — open the new charter.

## References
- Zariski, *Le problème des modules pour les branches planes*; Apéry (1946); Kunz (Gorenstein
  ⟺ symmetric semigroup); Delgado (symmetry of the value semigroup of several branches);
  Casas-Alvero, *Singularities of Plane Curves* (the semigroup chapter). Free/telescopic
  numerical semigroups (Bertin–Carbonne / the standard-basis literature).
- Sibling: `experiments/maths/fdrs-hj-singularities/` (the P4 tracker `δ = Σmᵢ(mᵢ−1)/2` reused
  for the four-way δ check).
- FDRS corpus (read-only): Phase 1 mixed-radix (Def 1–4, place values), Phase 7 gauge, Phase 9
  Base-0 Wall (Def 135–137, for the duality), Phase 14 coupling (for H-V4).

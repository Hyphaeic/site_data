# Results — fdrs-value-semigroup (PV.1–PV.4)

Executed 2026-07-07 against the pre-registered charter. Exactness ladder: **SageMath** oracle
(`LaurentSeriesRing(ℚ)` valuations + Zariski generator formula) and a **Rust `no_std`** mirror
(independent ℤ-only reimplementation). All figures exact; no floats anywhere.

## Verdict

| Hyp | Statement | Verdict |
|---|---|---|
| **H-V1** | Γ two ways (linear span up to `c+2m` ; generator formula) agree | **PASS** — 248/248 cusps + 3/3 multi-exponent |
| **H-V2** | `c = 2δ`, four-way δ (`#gaps` ; `Σmᵢ(mᵢ−1)/2` tracker ; `(p−1)(q−1)/2`) | **PASS** — 248/248 + 3/3 |
| **H-V3** | freeness + **mixed-radix** round-trip + Apéry symmetry involution | **PASS** — 248/248 + 3/3 |
| **H-V4** (gated) | pair semigroup: `(C₁·C₂)` as the δ correction term | **PASS (one pair)** — `I=4` exact, both oracles; full semimodule symmetry deferred |

Rust mirror: **7/7** tests, cusp-battery checksum `8560710631153725800` pinned.

## Per-hypothesis detail

### H-V1 — Γ is the gauge image, reachable two independent ways (PV.1)
For every branch, `Γ ∩ [0, c+2m]` computed by **(a)** the ℚ-linear span of monomials `x(t)^a
y(t)^b` (row-reduced; pivots = achievable orders) and **(b)** the classical generator semigroup
`⟨v̄₀,…,v̄_g⟩` **coincide exactly**. The span path is what makes this non-trivial for `g>1`:
monomial *orders* alone give only `⟨v̄₀,v̄₁⟩`; the higher generators are reached only by
cancellation combinations (e.g. `y²−x³ = 2t¹³+… ` supplies `v̄₂=13` for `(4;6,7)`), which the
linear span captures and monomial sampling cannot. This is the completeness that certifies each
gap (`F-V-sample`).

### H-V2 — conductor wall + symmetry, four ways (PV.2)
On the full battery, `c = 2δ` with δ agreeing across **four independent computations**:
`#gaps(Γ)`, the exact free-semigroup formula `c = 1 + Σ(nᵢ−1)v̄ᵢ − v̄₀` (`δ=c/2`), the
`fdrs-hj-singularities` **P4 multiplicity-sequence tracker** `δ = Σmᵢ(mᵢ−1)/2`, and (for cusps)
the closed form `(p−1)(q−1)/2`. The P4-tracker leg is the concrete **cross-family tie**: the
same resolution-side δ that counted blow-up multiplicities in the previous family equals the
gap-count of the ring-side semigroup here. `c=2δ` is used strictly as an *oracle on the
implementation* (`F-V-gorenstein`), never as evidence for the encoding.

### H-V3 — the order filtration is an exact mixed-radix gauge (PV.3, the deliverable)
For every branch:
- **Freeness/telescopic** `nᵢ v̄ᵢ ∈ ⟨v̄₀,…,v̄_{i−1}⟩` holds (the load-bearing precondition).
- Every `n ∈ Γ ∩ [0,c+2m]` has a **unique** mixed-radix representation `n = Σ cᵢ v̄ᵢ`,
  `0 ≤ cᵢ < nᵢ`, with **radices `nᵢ = e_{i−1}/eᵢ`** and **place values `v̄ᵢ`** —
  encode→decode round-trips exactly. Radices seen on the multi-exponent battery: `(2,2)`,
  `(3,2)`, `(2,2,2)`.
- The **Apéry set unifies with the mixed radix**: the `∏nᵢ = m` bounded-digit tuples are
  exactly `Ap(Γ,m)` (m distinct residues mod m, each the smallest Γ-element in its class); the
  Apéry form `n = w + k·m` is the single-radix-`m` shadow. The **symmetry involution**
  `w ↦ (c−1+m) − w` permutes `Ap` (⟺ Γ symmetric).

This is the precise sense in which the ring's order filtration **is** an FDRS Phase-1 mixed-radix
system: digits are semigroup coordinates, radices are the `eᵢ`-tower ratios, places are the
value-semigroup generators.

### H-V4 — the coupling datum is the pair-δ correction (PV.4, one worked pair)
For `C₁: y²=x³` and `C₂: x²=y³` (each `δ=1`), the intersection multiplicity `(C₁·C₂)=4`
computed two independent ways (parametrization order `ord_t(x₁²−y₁³)=ord(t⁴−t⁹)=4`; Sage-native
`intersection_multiplicity` at the origin) **agree**, and
`δ(C₁∪C₂) = δ₁ + δ₂ + (C₁·C₂) = 1+1+4 = 6`. The P4 intersection-multiplicity ledger reappears
**verbatim** as the off-diagonal correction term of the reducible-curve δ. Honestly scoped: only
the δ correction is verified; the full value-semimodule `Γ ⊆ ℕ²` and its Delgado symmetry are
deferred (one pair, per charter — no general correspondence claimed).

> **Deferred to its own charter (pre-registration owed).** The pair case is not scope creep to be
> smuggled in here: the value set of two branches is a **semimodule in ℕ², not a semigroup**, and
> its symmetry theory (Delgado's 2-branch analogue of `c=2δ`) is a genuine phase's worth of new
> machinery. It gets its own pre-registered charter — `H-V4` here is the one-pair anchor that
> establishes the coupling-term identity and justifies opening that phase, nothing more.

## Falsifiers — demonstrated firing, honored by the main run

| ID | Demonstration | Outcome |
|---|---|---|
| **F-V-sample** | monomial-order semigroup of `(4;6,7)` is `⟨4,6⟩`, so it reports `13 ∈ Γ` as a **fake gap**; the span recovers it via `y²−x³` | **FIRES** — main run uses the span → honored |
| **F-V-free** | `⟨5,6,7,8⟩` is symmetric (`c=10=2δ`) but **not free** in any order (m=5 prime) ⇒ no mixed-radix form | **FIRES** — H-V3 shown independent of H-V2 |
| **F-V-wall** | conductor is finite (target saturation); the mixed-radix odometer top digit `c₀` is unbounded (source process never terminates); `a_max=c+m−1 ≠ c` | **HONORED** — kept categorically distinct |
| **F-V-gorenstein** | `c=2δ` used only as an oracle-on-implementation | **HONORED** |
| **F-exact / F-novel** | every figure ℤ/ℚ; Zariski/Apéry/Kunz/Delgado classical | **HONORED** |

## Recorded negative (caught error, kept first-class)
**NEG-V1.** My first `F-V-free` control `⟨5,6,9⟩` was asserted "not free" by hand — the Rust/Sage
`is_free_(any/semigroup)` check **refuted this**: `⟨5,6,9⟩` *is* free via the order `(6,9,5)`
(gcd tower `6>3>1`, with `9·2=18∈⟨6⟩` and `5·3=15∈⟨6,9⟩`). Corrected to `⟨5,6,7,8⟩` (multiplicity
5 prime ⇒ provably non-free in **every** order, still symmetric).

Two things worth keeping prominent:
- **Freeness of a semigroup depends on generator ordering.** The telescopic tower need not start
  at the multiplicity; `⟨5,6,9⟩` is free only via `(6,9,5)`, base 6 ≠ m = 5. My slip was assuming
  a multiplicity-first tower — which is precisely the trap this control was meant to expose. A
  numerical semigroup is free iff *some* permutation of its minimal generators is telescopic;
  checking one order is not enough.
- **The verifier was independent enough to correct its author.** This is the exploitable-verifier
  argument running in reverse: the permutation search (written to test the control) refuted the
  hand-label of the person who wrote it. That the check had no shared failure mode with my
  reasoning is exactly why the ladder is load-bearing and not ceremonial. Recorded, not silently
  patched.

## Through-line
Everything prior in this ecosystem encoded a singularity's **resolution process**; this family
encodes its **ring**. The value semigroup Γ is the gauge image of the order filtration; its
free/telescopic structure makes that filtration an **exact mixed-radix system** (radices from the
gcd tower, places from the generators), with the Apéry set as the single-radix shadow and the
symmetry involution as the Gorenstein signature. The conductor is a **target-side dual** to the
source-side Base-0 Wall (image saturation vs process termination — provably non-collapsing).
Freeness — the plane-branch property — is strictly stronger than and independent of symmetry
(`⟨5,6,7,8⟩` witnesses the gap). No new singularity mathematics: connection, encoding, and exact
verification.

### The three-bridge closure (the sentence to promote)
The original program named three bridges: toric/HJ resolution, Puiseux coupling, and the
order-filtration. This family is the third, and PV.4 is where all three meet in one identity:
> **`δ(C₁∪C₂) = δ(C₁) + δ(C₂) + (C₁·C₂)`**

The left side and the first two right-side terms are purely **ring-theoretic** (gap counts of
value semigroups); the cross term `(C₁·C₂)` is the **Puiseux/P4 coupling datum** (intersection
multiplicity), and each `δ` also equals the **resolution-side** blow-up sum `Σmᵢ(mᵢ−1)/2` via the
other family's tracker. So the intersection multiplicity appears **verbatim as the off-diagonal of
a purely ring-theoretic quantity** — the filtration bridge and the Puiseux bridge touching in a
single exact equation. Combined with the four-way δ (`#gaps = c/2 = Σmᵢ(mᵢ−1)/2 = (p−1)(q−1)/2`),
the three-bridge claim is now closed end-to-end, each leg computed by an independent oracle.

## Reproduce
```
sage source/sage/pv_semigroup.sage       # PV.1-PV.3, full battery
sage source/sage/pv_falsifiers.sage      # trap-falsifier demonstrations
sage source/sage/pv4_pair.sage           # PV.4 one worked pair
cd source/rust/vs-radix && cargo test --release   # 7/7 mirror
```

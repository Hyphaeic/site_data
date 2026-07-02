# Theory track — fdrs-chart-coupled-attention

**Posture (ADR-008): no new mathematics is claimed.** FDRS supplies the objects (cylinders, partitions, prefix
gauges, interface balance); the contribution would be a *connection* (recovered chart → exact coupling operator)
and a *verified artifact* (the measured fidelity of the replacement), never "FDRS-novel." This file outlines the
central object, the existing FDRS items leaned on, the candidate definitions to formalize **only if** the empirics
land, and the one sharp prediction. **No Lean/Sage code here** — outlines only.

This experiment is the **constructive dual** of the sibling `fdrs-attention-mixed-radix`. There, the object was the
*recovery* of a chart from a float head (analysis). Here, the object is the *compilation* of that chart into an
exact operator that replaces the head (synthesis). It builds on the sibling's **positional** positive result; it
does **not** touch the value-arithmetic null.

---

## §0 — The central object: the exact coupling operator (and the compiler)

A recovered chart is a triple `(b, ι, M)`: a mixed-radix gauge `b`, an embedding `ι : [N] ↪ ∏[bᵢ]` of the `N`
positions into the radix volume, and the occupancy mask `M = ι([N])` (Part E regimes of the sibling). From it,
define an **exact coupling** — a relation over positions given by an exact digit condition:

```
  Cᵣ ⊆ [N] × [N] ,     Cᵣ(i,j) = [ φᵣ(ι(i)) = φᵣ(ι(j)) ]
```

where `φᵣ` reads a digit coordinate, a digit subset, or a cylinder prefix. Canonical families:

```
  C_same-block(i,j)      = [ block(i) = block(j) ]                 # a single high digit agrees
  C_same-role(i,j)       = [ role(i)  = role(j)  ]                 # a single low digit agrees
  C_period-p(i,j)        = [ i ≡ j  (mod p) ]                      # a residue class
  C_digit-k(i,j)         = [ πk(ι(i)) = πk(ι(j)) ]                 # the k-th mixed-radix digit agrees
  C_cylinder-prefix(i,j) = [ π_{≤L}(ι(i)) = π_{≤L}(ι(j)) ]         # SAME CYLINDER U(s) — the FDRS bridge
```

The last line is the key identity: **a coupling is cylinder co-membership.** `C_cylinder-prefix` partitions `[N]`
into the cylinder classes of `U(·)` at depth `L`; this is exactly the FDRS clopen basis (Def 8, Prop 5), so the
coupling inherits the partition/measure structure for free.

**The operator family (a ladder).** Membership `Cᵣ` is always exact; the aggregation *inside* the class varies,
and which rung fits is itself the finding:

```
  (a) class sum            yᵢ = Σ_{j∈Cᵢ} vⱼ
  (b) pure class average    yᵢ = (1/|Cᵢ|) Σ_{j∈Cᵢ} vⱼ            ← the clean compilation target
  (c) mask + intra-weights  yᵢ = (1/Zᵢ) Σ_{j∈Cᵢ} w(i,j) vⱼ       ← exact Cᵢ, small learned/fixed-point w
  (d) gate over couplings   yᵢ = Σ_r g_r(xᵢ) (1/|Cᵢʳ|) Σ_{j∈Cᵢʳ} vⱼ
```

`|Cᵢ|` is an integer; with integer / fixed-point `v` (and `w`), `yᵢ` is exact or bounded-rational — no IEEE-754 in
the routing. The "similarity score" is gone, replaced by membership in a chart relation. **Outcome 2 — operator
`(c)` — is the plausible middle:** a head may attend to the right cylinder class but with **learned non-uniform
weights inside it**, so the clean `(b)` fails while `(c)` (exact class, small residual `w`) succeeds. The
chart-masked head (in-class weights kept, renormalized) *is* `(c)` with the head's own `w` — so `(b)` vs
chart-masked is the test of whether intra-class weighting is load-bearing. `(c)` is still a strong, exact result;
only `(b)` is "weighting fully compiled away."

**The hybrid (content + chart streams).** A small gate selects among a coupling library:

```
  yᵢ = Σ_r g_r(xᵢ) · (1/|Cᵢʳ|) Σ_{j : Cᵣ(i,j)} vⱼ
```

`g_r` is the *only* learned, possibly-float part (eventually integer/fixed-point). The positional routing is
exact; the content stream chooses which exact route to take.

**The compiler.** The whole experiment is one map and its fidelity:

```
  ChartCompile : (recovered chart (b,ι,M))  ↦  exact coupling operator Couple_C
  Fidelity     : how closely  Couple_C  reproduces the float head it was compiled from
```

The compilability claim is that for chart-explained heads, `Fidelity` is high (up to the value-quantization
bound), and for content heads it is low.

---

## Part A — Existing FDRS items leaned on

| FDRS item | Notation / fact | Used here for |
|---|---|---|
| Cylinder sets | `U(s)`; clopen basis; `U(s) ↔ ≡ r_L(s) (mod B_L)` (Def 8, Prop 5) | **a coupling = cylinder co-membership**; the partition the operator aggregates over |
| Mixed-radix space | `ℛ^(k)`, place values `B_m = ∏ bᵢ` (Def 1–4) | the chart `(b, ι)` the coupling is read from |
| Partition law / conservation | `setMass_partition`; "no anonymous change" (SU4a) | the integer normalization `Σ over class`, mass-preserving |
| Interface balance | `issued = consumed + pending` (Phase 14) | exact normalization / accumulator conservation in the operator |
| Prefix gauge | `prefixGauge`, `π_L` (Def 192, Prop 147) | `C_cylinder-prefix` and digit-coordinate couplings (no fishing — the chart is given by recovery, not searched here) |
| Refinement embeddings | digit-conditional refinement (Def 20, Phase 11) | composing couplings across depths / multi-gauge heads |
| Commutant / block-diagonal | operator commutes with every `P_L` iff scale-block-diagonal (sibling Part E) | characterizes which operators a coupling *can* express (the scope boundary, B3) |

---

## Part B — Candidate new definitions (formalize **only if** B1–B3 land)

Outlines only; none enters the corpus before a confirmed claim (G4, ADR-007). The exactness here is a feature:
several of these are *provable now* and would harden `fdrs-formal` regardless of the empirics.

1. **`ExactCoupling`** — *intent:* a coupling relation from a chart. *Parent:* cylinders `U(s)`. *Informal:*
   `Cᵣ : [N]→[N]→Bool` from a digit condition `φᵣ`. *Formalize:* `Cᵣ` is an equivalence relation ⇒ partitions
   `[N]`; for `C_cylinder-prefix`, the classes are exactly the cylinders at depth `L`. *proof_wanted:* "cylinder
   couplings partition the index set" — **provable now** (a clean number-system fact).

2. **`ChartCouplingOperator`** — *intent:* the exact aggregation operator. *Parent:* partition law + interface
   balance. *Informal:* `Couple_C v = (1/|Cᵢ|) Σ_{class} vⱼ`. *Formalize:* mass conservation
   `Σᵢ |Cᵢ| yᵢ = Σ class-sums`; exactness when `v` integer/fixed-point. *proof_wanted:* the conservation identity
   — **provable now**.

3. **`ChartCompile`** — *intent:* the compiler map (recovered chart ↦ operator). *Parent:* none direct.
   *Informal:* total function on admissible charts. *Formalize:* well-defined; equivariant under the chart's
   symmetry (head permutation). *proof_wanted:* none (a construction).

4. **`CompilationFidelity`** — *intent:* the reporting currency of B1/B2. *Parent:* none (a metric). *Informal:*
   `fidelity = baseline_adjusted( agreement(Couple_C, head) )` on held-out inputs (per-input, not just accuracy).
   *Formalize:* the metric + its null (wrong-coupling / shuffled-V). *proof_wanted (empirical):* "for
   chart-explained heads fidelity > τ; for content heads fidelity ≈ null" — the **headline conjecture**, B2∧B3.

5. **`CouplingLibrary` / `ChartGate`** — *intent:* the hybrid. *Parent:* refinement embeddings. *Informal:* a set
   `{Cᵣ}` + a capacity-bounded gate `g_r`. *Formalize:* the gate's capacity bound (so a positive B4 is the
   couplings' doing). *proof_wanted (empirical):* B4 recovery at bounded gate capacity.

6. **`ExactnessTag`** — *intent:* the decoration on a compiled operator. *Parent:* ADR-007 ladder. *Informal:*
   `exact | enclosure | float`, weakest-tag composition; integer V ⇒ operator is `exact`, float-model comparison
   is `float`. *Formalize:* the tag algebra (already in the sibling's def 1). *proof_wanted:* none.

> **Discipline:** defs 1, 2 are **provable now and are not findings** — they are the structural facts the empirical
> conjecture (def 4) must *beat*. Stating them in Lean first keeps B1–B2 honest: a coupling reproducing a head is
> only interesting *beyond* the partition/conservation structure that holds for any coupling.

---

## Part C — A sharp prior (what *can't* be compiled)

The sibling's commutant fact (an operator is scale-block-diagonal iff it commutes with every block projection
`P_L`) gives a hard prediction here: **a chart coupling can only express the block-diagonal / cylinder-measurable
part of a head.** Therefore:

> **A head whose function is *not* expressible as cylinder co-membership (content/semantic similarity,
> token-identity routing) is *provably* not reproducible by any exact chart coupling.**

This is the theory-level reason B3 must succeed (couplings fail on content heads): it is not just an empirical
caveat, it is what the commutant structure predicts. If exact couplings reproduced a *content* head, that would be
surprising *relative to FDRS itself* and a red flag for a leak (NEGATIVE trap #2), exactly as the sibling's Part C
treats spurious additive/multiplicative agreement.

---

## Part D — Promotion path (ADR-007 §4)

- The provable lemmas (defs 1, 2 — couplings partition; the operator conserves mass) can be contributed to
  `fdrs-formal` **independently** of any empirical result; they are clean and harden the corpus regardless.
- A confirmed fidelity result (def 4) is stated as a `proof_wanted`/`conjecture` under
  `fdrs-formal/FdrsFormal/Conjectures/` (directory created only when the first claim is ready), referencing the run
  transcript across the two-repo boundary.
- Because the operator is exact, a confirmed B1/B2 can reach a **higher decoration tag** than the sibling's
  float-capped result — the constructive direction is where the exactness ladder actually pays out.

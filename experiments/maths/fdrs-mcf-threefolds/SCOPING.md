# SCOPING.md — Phase M0 (report only; gates M1+)

**Experiment:** `fdrs-mcf-threefolds`. **Phase:** M0 (scoping, no run-emitting code).
**Date:** 2026-07-07. **Rules:** ADR-007 (this report answers the pre-registered M0
questions), ADR-008 (honest-broker). Literature grounded via the deep-research harness
(23 sources, 22/25 claims survived 3-vote adversarial verification) + an in-workspace Sage
oracle-capability smoke test (below). Every claim is graded; every "open" is flagged.

---

## Verdict (read first)

**M0 CLEARS THE GATE. Recommendation: proceed to M1** (not "scoped and parked"). The three
gates the charter set are met:

1. **Anchor is real (M0.2).** Terminal `¹⁄ᵣ(1,a,r−a)` is classified (terminal lemma;
   Reid YPG Thm 5.2), and its **economic (Danilov–Barlow) resolution is a fully-determined,
   distinguished construction** with exceptional discrepancies **exactly `1/r,…,(r−1)/r`**.
   Better than the charter hoped: there is a *named algorithm* — **Ashikaga's continued
   fraction → the Fujiki–Oka resolution** — that generates this resolution's subdivision
   moves as continued-fraction digits (Sato–Sato, arXiv:2108.02402). The M1 anchor law is
   not hypothetical; it exists in the literature and awaits Phase-7 encoding.
2. **Oracle is adequate (M0.3 / F-3-anchor).** The numerical oracle (discrepancy,
   terminality) is *elementary* (the age formula) and owned in-house; the fan oracle is
   **Sage toric in verify-mode**, smoke-tested here on 4 anchors (all certified smooth).
   The division of labor is exactly the exactness-ladder shape: **the radix law generates
   the subdivision; Sage verifies smoothness; the age formula gives discrepancies** — three
   independent computations that already agree.
3. **The negative is designed (M0.4).** Two theorem-shaped boundaries are stated below
   (Hermite non-periodicity; toric-flip non-uniqueness), so a refutation lands as a
   boundary, not a disappointment.

**The single most important honest caveat:** the strong claim that "every 3-fold terminal
singularity is resolved by a minimal-discrepancy weighted-blow-up ladder" was **refuted**
in verification (0–3 against arXiv:1310.6445). Only the **cyclic-quotient** economic
resolution is established, and *its distinguishedness/uniqueness among all toric resolutions
of the cone was not confirmed*. So the anchor is solid **only inside `F-3-scope`** (cyclic
quotients, terminal-first) — which is exactly where the charter drew the line.

---

## M0.1 — Landscape (grounded; the two real bridges, and the honest Hermite status)

### The dim-2 template the experiment generalizes (fully proven — this is what P1–P3 verified)

Every affine toric-surface singularity **is** a cyclic quotient `¹⁄d(1,k)`, and the HJ
minus-continued-fraction `d/k=[[b₁,…,bᵣ]]` (all `bᵢ≥2`) computes **exactly** its minimal
toric resolution; the CF ray-generators are simultaneously (a) the cone's Hilbert basis and
(b) the lattice points on the bounded edges of `Conv(σ∩(N∖0))` — the **2-D Klein sail** —
with `Eₖ²=−bₖ` and dual graph a chain (Cox–Little–Schenck GSM 124 §10.1–10.2, Thms 10.2.3/
10.2.5/10.2.8, credited to Klein; Popescu–Pampu arXiv:math/0506432 Prop 6.2). *This is the
one place "continued-fraction = resolution" is a theorem; the whole experiment is the
question of what survives the loss of its dim-2 canonicity.*

### The landscape table

| Algorithm | Step rule (Ω) | Convergence | Periodic on cubics? | Explicit toric-**resolution** reading? | Phase-7 encodable? |
|---|---|---|---|---|---|
| **HJ (dim 2)** | `(n,q)↦(⌈n/q⌉, …)` minus-CF | terminates (rational) | — (Lagrange, dim 2) | **YES, theorem** — minimal resolution (CLS §10) | yes (P1) |
| **Klein sails** (geometric MCF) | boundary of `Conv(σ∩(N∖0))`; digit = next sail vertex/facet | geometric object, well-defined | **totally-real cubics: PROVEN** (Korkina/Lachaud, Lagrange-type); complex-conjugate: **OPEN** | **YES** — sail = Hilbert-basis structure of the cone (Karpenkov, *Geom. of Continued Fractions*; German, Moussafir) | as a set-valued law, not a simple sequential digit |
| **Ashikaga CF → Fujiki–Oka** ★ | round-down polynomial + remainder polynomial on proper fractions | terminates (resolves a rational cone) | N/A (finite on rational data) | **YES, EXPLICIT** — generates the economic resolution of `¹⁄ᵣ(1,a,r−a)` step-by-step (Sato–Sato arXiv:2108.02402, citing Ashikaga, Kyoto J. Math. 2019) | **yes — this is the M1 anchor law** |
| **Jacobi–Perron (JPA)** | `α↦({α₂/α₁},…,{1/α₁})`-type map (Schweiger 2000) † | weak conv. known; strong conv. not always | **OPEN / mostly negative**; Karpenkov's sin²-variant proven only for **totally-real** cubics (arXiv:2101.12707) | steps are unimodular (act on fans) but **no verified reading as a cyclic-quotient resolution** | yes (deterministic digit rule) |
| **Brun** | subtract 2nd-largest from largest coordinate † | weak conv. a.e. | OPEN (same front) | **not established/verified this pass** | yes |
| **Selmer** | subtract smallest from largest † | weak conv. a.e. | OPEN | **not established/verified** | yes |
| **Mönkemeyer / fully-subtractive** | piecewise-linear subtractive maps † | partial | OPEN | **not established/verified** | yes |

★ the anchor's algorithm. † **step rules for JPA/Brun/Selmer/Mönkemeyer/fully-subtractive
are stated at textbook level (Schweiger, *Multidimensional Continued Fractions*, OUP 2000,
flagged as the standard reference) and were NOT independently verified in this research pass
— a coverage gap, recorded honestly. Their exact maps and convergence are an M0.1-addendum
item if the experiment ever needs them; the anchor (M1) does not.**

### The two honest headlines of the landscape

- **The bridge to *resolutions* runs through only two constructions, not the whole zoo.**
  The classical *arithmetic* MCFs (JPA, Brun, Selmer, …) are number-theoretic; **none has a
  verified reading as a resolution procedure for cyclic quotients.** The verified bridges are
  (i) **Klein sails** (geometric, = Hilbert-basis/convex-hull structure) and (ii) **Ashikaga
  → Fujiki–Oka** (the anchor). *This sharpens the algorithm-space thesis: encoding an
  arithmetic MCF as a subdivision law is itself exploratory and a likely first-class
  negative ("MCF X does not yield a resolution"), not a given.*
- **`F-3-canon` is confirmed well-founded, with a precise current front.** No classical MCF
  is periodic exactly on cubics (the Hermite problem). Karpenkov's sin²-algorithm (Acta
  Arith. 203, 2022) is the **first** Jacobi–Perron-type algorithm proven periodic on cubics
  — **but only totally-real cubics; the complex-conjugate-root case is OPEN for all
  MCF-type algorithms** (arXiv:2101.12707; corroborated by EPSRC EP/W006863/1, ongoing).
  Klein sails have proven Lagrange-type periodicity for hyperbolic operators (totally-real),
  but this is **not** Hermite's converse (German–Lakshtanov arXiv:math/0607084 corrected the
  converse). **No periodicity claim in this experiment may exceed "totally-real cubics."**

---

## M0.2 — The decidable anchor: terminal `¹⁄ᵣ(1,a,r−a)` (CONFIRMED, worked by hand)

**Classification (the terminal lemma).** A 3-fold cyclic quotient `X=A³/μᵣ` is **terminal**
iff, up to permutation of coordinates and change of generator, it is of type `¹⁄ᵣ(1,a,r−a)`
with `gcd(a,r)=1` (Reid YPG Thm 5.2, attributed to White, Morrison–Stevens, Danilov,
Frumkin; restated as Thm 1.1 in Sato–Sato arXiv:2108.02402; geometric normal form =
White's empty-tetrahedron theorem, arXiv:1004.3411). Decidable, enumerable, isolated — the
dim-3 `A_n`.

**Age criterion (Reid–Tai).** `X` of type `¹⁄ᵣ(a₁,…,aₙ)` is terminal (resp. canonical) iff
for every `k=1,…,r−1` the **age** `αₖ = (1/r)·Σᵢ (k·aᵢ mod r) > 1` (resp. `≥1`); the
**discrepancy** of the corresponding exceptional divisor is `αₖ − 1` (Reid YPG Thm 4.11).

**Economic resolution (Danilov–Barlow).** Subdivide the cone along the `r−1` lattice points
`v_k = (1/r)(k, ak mod r, (r−a)k mod r)`; the result is smooth with **exactly `r−1`
exceptional divisors of discrepancies precisely `1/r, 2/r, …, (r−1)/r`**, all in `(0,1)`.
These are the **essential** divisors — they occur in *every* resolution (Bouvier–González-
Sprinberg: essential = Hilbert-basis elements). *(Reid YPG, Danilov §4 with R. Barlow;
Sato–Sato arXiv:2108.02402; Chen arXiv:1310.6445 gives minimal discrepancy `1/r`.)*

### Worked example by hand — `¹⁄5(1,2,3)` (`r=5, a=2, r−a=3, gcd(2,5)=1`)

Because `3 ≡ −2 (mod 5)`, for `0<k<5` we have `{2k/5}+{3k/5}={2k/5}+{−2k/5}=1`, so the age
telescopes:
```
age(k) = {k/5} + {2k/5} + {3k/5} = {k/5} + 1  = 1 + k/5.
  k=1: 6/5   k=2: 7/5   k=3: 8/5   k=4: 9/5      (all > 1  ⇒ TERMINAL)
  discrepancies:  1/5,     2/5,     3/5,     4/5   (all in (0,1) ⇒ NO crepant divisor)
```
Economic rays `v_k=(1/5)(k, 2k mod 5, 3k mod 5)`: `v₁=(1,2,3)/5, v₂=(2,4,1)/5,
v₃=(3,1,4)/5, v₄=(4,3,2)/5`. In the toric chart `σ=Cone((5,−2,−3),(0,1,0),(0,0,1))⊂ℤ³`
(basis `{f=(1/5)(1,2,3), e₂, e₃}` of `N=ℤ³+(1/5)(1,2,3)ℤ`, so `e₁=5f−2e₂−3e₃`), these are
`(1,0,0),(2,0,−1),(3,−1,−1),(4,−1,−2)`.

**Oracle-verified (Sage, in-workspace):** `σ` has multiplicity `|det|=5`, is not smooth;
subdividing along the four `v_k` yields a **smooth** fan (Sage `Fan.is_smooth()==True`),
`2r−1=9` maximal cones, and the four exceptional discrepancies computed via the toric
support function `φ` (with `φ=1` on the three generators) reproduce `{1/5,2/5,3/5,4/5}` —
**agreeing with the elementary age formula**. Same result verified for `¹⁄7(1,3,4)`,
`¹⁄11(1,3,8)`, `¹⁄13(1,5,8)`. *(Scripts: `m0-oracle-probe/oracle_probe{,2}.sage` — scoping
reconnaissance, not a run; to be promoted to `source/` under M1's provenance.)*

### The two charter questions, answered

- **(i) "Is the economic ladder expressible as a single radix law?"** — **YES.** Ashikaga's
  continued fraction (round-down + remainder) generates exactly this subdivision as a digit
  sequence (Sato–Sato). Each step is a **weighted blow-up = star subdivision along a
  primitive ray** (Chen arXiv:1310.6445). So M1 is well-posed: encode Ashikaga-CF as a
  Phase-7 `(state, Ω, Γ)` triple. **Caveat:** the resolution's *uniqueness/distinguishedness
  among all toric resolutions* was not confirmed by the literature pass; it is **canonical
  as a construction, not proven the unique minimal object** (there is no minimal object in
  dim 3). Do not call it "the" resolution — `F-3-canon`.
- **(ii) "Does `gauge = |det| = group` survive; is it `r` or the discrepancy vector?"** —
  **Both, at different resolutions of granularity, exactly as the surface lesson predicted.**
  The crude datum survives: `|det(σ)| = r = |μᵣ| = mult(X)` (P1's gauge, verified above). But
  the **rich** dim-3 invariant is the **ordered discrepancy vector `(1/r, 2/r, …, (r−1)/r)`**
  — the essential-divisor spectrum. The naive "gauge = `r`" is the *coarse shadow*; the
  discrepancy vector is the object that actually indexes the resolution. **This is the
  abelianization-style correction the charter told us to expect** (the P1 gauge was `|det|`
  but the informative content was finer): here `r` is a scalar, the discrepancy vector is
  the true gauge.

---

## M0.3 — Algorithm space as an FDRS object (formalized; conjecture graded)

**Admissibility of a digit rule `Ω` (what makes a point of algorithm space a *subdivision
law*).** Four conditions, all Phase-7-native:

1. **Lattice/unimodular:** every step is a star subdivision along a **primitive** lattice
   vector; the step's transition matrix lies in `GL(3,ℤ)` on the active chart (a genuine
   toric morphism, not a lossy map).
2. **Gauge-monotone (progress):** each step strictly decreases the multiplicity `|det|` of
   the active cone toward the smooth terminal `|det|=1`. *This is the direct Phase-7 analog
   of the HJ recursion decreasing `n`, and of the "Base-0 Wall terminal" — smoothness is the
   Wall.*
3. **Containment:** subdivision rays lie inside the active cone (the fan is refined, never
   coarsened).
4. **Termination:** on rational input (a cyclic quotient) the law halts in finitely many
   steps at a smooth fan.

`Ω` satisfying (1)–(4) = a point in the **admissible algorithm space** = a **Phase-7 law
family** member. The economic/Ashikaga law is the distinguished, verified point; JPA/Brun/…
are candidate points whose (1)–(4) status for cyclic-quotient resolution is *unestablished*
(see M0.1). Corpus fit: the admissible-`Ω` space ↔ **Phase-7 law families**; transports
between laws ↔ **Phase-5.3 recharts** (recall P5's `F5-transport`: recharts *change value*);
sequences of laws ↔ **Phase-8 multi-timeline routing**.

**The experiment-level conjecture — "discrepancy data is the conserved quantity classifying
transports between subdivision laws" (the dim-3 analog of P5's `d`).** Grade:
**TESTABLE ONLY AFTER SHARPENING — and it carries a tautology risk that must be pre-guarded.**

- *Why it is at risk of being vacuous.* The essential discrepancies `{1/r,…,(r−1)/r}` occur
  in **every** resolution (they are intrinsic to the singularity). So "discrepancy is
  conserved across laws that resolve the *same* singularity" is **true by definition of
  *essential*, and says nothing about the transport** — the exact shape of P5's `F5-tautology`
  ("a valuation axiom is not evidence"). A positive result of this naive form would be a
  fraud, not a finding.
- *Why P5 escaped it, and how M1 must too.* P5's `d` was non-trivially conserved because the
  **Wahl move changed the singularity** `(n,q)↦(n',q')` while preserving `d` ("value dies,
  `d` survives"). The honest dim-3 test therefore needs a **law-morphism that changes the
  singularity** (a Wahl-analog acting on `(r,a)`), and asks whether some discrepancy datum
  transports across it; **or** it must look at the **non-essential** divisors a given law
  adds *beyond* the essential spectrum, and ask whether *their* structure is law-invariant.
  Either is a real test; the same-singularity/essential-only version is not.
- **New guard seeded: `F-3-essential-tautology`** (see `NEGATIVE.md`) — any "discrepancy is
  conserved" claim that reduces to "essential divisors are intrinsic" is refuted in advance.

---

## M0.4 — The designed negative (two boundary theorems)

Dimension 3 will refuse something; here is *what*, stated so a refutation is a boundary
theorem (the role the Catalan no-go played in the surface family's P3/P6).

**Wall 1 — Hermite non-periodicity (sourced, sharp).**
*A finite-state Phase-7 radix law cannot realize the resolution combinatorics of a
non-totally-real cubic cone.* For cubic irrationals with a complex-conjugate pair of roots,
**no MCF of any known type is eventually periodic** (open since the 19th century; still open
after Karpenkov 2022, which reaches only totally-real cubics). A Phase-7 law with finitely
many states produces eventually-periodic digit strings on algebraic input; therefore it
**provably cannot** capture the (non-periodic) sail/expansion of a non-totally-real cubic
direction. *This bounds the algorithm-space thesis precisely: the encoding is faithful for
rational cones (the anchor, always finite) and totally-real cubic directions, and provably
fails past that line.* Falsifier-shaped: exhibiting a finite-state law periodic on a
complex-root cubic would refute the wall (and solve a famous open problem — so the wall is
safe, and any such claim is almost certainly a bug).

**Wall 2 — toric-flip non-uniqueness (the flop analog, made toric-precise).**
*A single deterministic law selects one triangulation of the resolving fan; the set of
smooth triangulations is a flip-connected poset (bistellar flips = toric flops), which one
value cannot hold.* Terminal `¹⁄ᵣ(1,a,r−a)` has **no crepant divisor**, so classical crepant
flops are absent — but the cone admits **many** smooth triangulations on the same ray set,
connected by bistellar flips (the secondary-polytope / GKZ structure). A deterministic `Ω`
outputs exactly one; the flip-equivalence class is genuinely larger and **provably not a
single Phase-7 value**. *This is the sharpest contrast with the surface case: in dim 2 the
triangulation is unique (the chain), so `Ω` and the geometry coincide; in dim 3 the value is
an irreducibly non-canonical choice — which is the whole reason the experiment exists.*

Either wall, hit cleanly, is a first-class negative recorded in `NEGATIVE.md` — the honest
"what one law cannot do."

---

## Part C — Oracle adequacy (F-3-anchor): assessed by direct probe, not hearsay

The research pass returned **no** verified claim on software adequacy (an honest gap). Rather
than hand-wave, the oracle was smoke-tested in-workspace (SageMath, the P1–P7 environment):

| Oracle need | Tool | Verdict | Evidence |
|---|---|---|---|
| discrepancy / age / terminality | **elementary** (age formula, integer arithmetic) | **owned in-house; self-verifying** | `oracle_probe.sage`: terminal + `{k/r}` reproduced for `r∈{5,7,11,13}` |
| certify a proposed subdivision is smooth | **Sage toric** `Fan.is_smooth()` | **adequate (verify-mode)** | `oracle_probe2.sage`: 4/4 anchors certified smooth |
| *generate* a smooth resolution of a singular simplicial cone | Sage `resolve()` | **NOT available** (no-op without supplied rays) | probe v1: `resolve(make_simplicial=True)` added 0 rays |
| Hilbert basis / essential divisors (cross-check) | **Normaliz** | available (not exercised this pass) | Normaliz computes cone Hilbert bases (docs) |

**Conclusion:** the oracle situation is *adequate and, crucially, correctly shaped* — Sage is
a **verifier**, not a generator, which is exactly the exactness-ladder role: the radix law
(the experiment's object of study) *generates* the subdivision; the oracle *independently
certifies* smoothness; the discrepancy invariant is elementary and closed-form. `F-3-anchor`
is satisfiable. (polymake/Magma were not needed and not assessed; Normaliz is the natural
second independent check for M1.)

---

## Sources (verified; full list in `READING.md`)

Reid, *Young Person's Guide to Canonical Singularities*, PSPUM 46 (1987), Thms 4.11 & 5.2,
economic resolution (Danilov §4 w/ Barlow) — *theorem labels not OCR-confirmable (image
scans); mathematical content verified against full copies; "semicrepant" is Reid's informal
coinage, standard term is "essential."* · Sato–Sato, arXiv:2108.02402 (Fujiki–Oka via
Ashikaga CF; economic resolution of `¹⁄ᵣ(1,a,r−a)`). · Morrison–Stevens, Proc. AMS 90 (1984);
White, arXiv:1004.3411 (empty-simplex normal form). · Karpenkov, *Geometry of Continued
Fractions* (Springer, 2013) + habilitation + arXiv:math/0411031 (Klein sails; Korkina/Lachaud
periodicity). · Karpenkov, arXiv:2101.12707 (sin²-algorithm; totally-real cubics; complex
case open). · Lee, arXiv:1810.11676 (AJPA = enumerated families). · German–Lakshtanov,
arXiv:math/0607084 (converse corrected). · Cox–Little–Schenck, *Toric Varieties* GSM 124 §10;
Popescu–Pampu arXiv:math/0506432 (dim-2 template). · Chen, arXiv:1310.6445 (weighted blow-up
= subdivision; min discrepancy `1/r`; **general "ladder for all terminals" REFUTED 0–3**). ·
Tsuchihashi (Tohoku 35, 1983), Moussafir (FAA 34, 2000), German (Proc. Steklov 239, 2002)
(periodic MCF ↔ cusps; sails ↔ Hilbert bases). · Schweiger, *Multidimensional Continued
Fractions* (OUP, 2000) — step-rules reference, **not independently verified this pass**.

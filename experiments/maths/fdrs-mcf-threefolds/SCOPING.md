# SCOPING.md — Phase M0 (report only; gates M1+)

**Experiment:** `fdrs-mcf-threefolds`. **Phase:** M0 (scoping, no run-emitting code).
**Date:** 2026-07-07 (rev. after review). **Rules:** ADR-007 (answers the pre-registered M0
questions), ADR-008 (honest-broker). Grounded via two deep-research passes (landscape +
Ashikaga rule) with adversarial verification and explicit folklore flags, plus in-workspace
Sage oracle/calibration probes (`m0-oracle-probe/`). Every claim graded; every "open" flagged;
sourced-vs-inferred separated.

---

## Verdict (read first)

**M0 CLEARS THE GATE. Recommendation: proceed to M1.** The anchor is not just real — it is
*cleaner than the charter hoped* — and the review cycle **corrected two priors** and
**dissolved one designed negative into a canonicity result**, all of which strengthen M1.

1. **Anchor real and canonical (M0.2).** Terminal ⟺ `¹⁄ᵣ(1,a,r−a)` (Reid Thm 5.2); economic
   resolution has discrepancies **exactly `1/r,…,(r−1)/r`**, no crepant divisor. Its law
   **exists and is sourced**: Ashikaga's continued fraction (round-down + remainder maps) →
   the Fujiki–Oka resolution, which *coincides with* the economic resolution for this family
   (Sato–Sato, arXiv:2108.02402 §3). Worked authentically for `¹⁄7(1,3,4)` below.
2. **Anchor is a *canonical* corner (new, from the review).** The economic resolution is the
   **unique** smooth toric resolution on the essential ray set — verified `1`-of-`{32…2768}`
   across 5 anchors (`wall2_multi.sage`). So a single deterministic law captures it with **no
   choice** — the P1-like clean anchor.
3. **Oracle adequate and correctly shaped (Part C / F-3-anchor).** Discrepancy/terminality =
   *elementary* age formula (owned); smoothness = Sage *verify*-mode (law generates, Sage
   certifies). Three independent computations agree.

**Two priors corrected this cycle (the honest-broker dividend):** (a) "JPA/Brun have special
subdivision readings" — **no**: simplex-splitting (Lagarias) is a whole-family property, and
*toric-resolution* readings belong to none of the arithmetic MCFs; (b) "some MCFs have known
non-periodic cubic counterexamples" — **no**: Hermite is open both ways for all classical
MCFs, with no proven non-periodic classical cubic.

**One designed negative relocated (M0.4):** both candidate walls fail *as no-gos at the
anchor* — Wall 2 dissolves (canonical resolution), Wall 1 is Hermite-open (a frontier, not an
impossibility). The terminal anchor admits **no** clean no-go; the negatives live off-anchor
(non-terminal/canonical family — genuine flops) and are owed at M-later, not M1.

**Standing scope caveat:** the "general 3-fold terminal resolved by a weighted-blow-up ladder"
claim was **refuted** in verification (0–3, arXiv:1310.6445). Only the *cyclic-quotient*
economic resolution stands — the anchor is solid **only inside `F-3-scope`**.

---

## M0.1 — Landscape: two senses of "subdivision," and the honest Hermite status

### The dim-2 template the experiment generalizes (fully proven — what P1–P3 verified)

Every affine toric-surface singularity **is** a cyclic quotient `¹⁄d(1,k)`; the HJ minus-CF
`d/k=[[b₁,…,bᵣ]]` (`bᵢ≥2`) computes **exactly** its minimal toric resolution, the CF
ray-generators being both the cone's Hilbert basis and the lattice points on the 2-D Klein
sail, with `Eₖ²=−bₖ` (Cox–Little–Schenck GSM 124 §10; Popescu–Pampu arXiv:math/0506432
Prop 6.2). *The one place "continued-fraction = resolution" is a theorem; the experiment asks
what survives the loss of its dim-2 canonicity.*

### The distinction that governs the whole table (this is where the folklore lives)

- **(S) simplex-splitting** — the step subdivides a simplex/cone as a dynamical Markov
  partition. **Genuine geometric content** (Lagarias, *Monatsh. Math.* 115, 1993). Shared by
  JPA, Brun, Selmer, Mönkemeyer **on the same footing** — *not* exclusive to any.
- **(T) toric resolution of singularities** — the fan subdivision *resolves* a singularity
  (algebraic-geometry payload). Belongs to **HJ (dim 2), Klein sails, and Ashikaga** — and to
  **none** of the arithmetic MCFs. **Attributing a (T)-reading to JPA/Brun is a folklore
  error** (expository "MCFs resolve singularities" silently swaps in HJ or Klein sails).

The experiment's object is **(T)**. So the arithmetic MCFs are candidate laws whose
(T)-status is *itself* the open question — and the likely honest outcome of encoding one is a
**negative** ("arithmetic MCF X is sense-S dynamics, not a sense-T resolution").

### The table

| Algorithm | Step rule (sourced) | Subdivision reading | Periodic on cubics? | Phase-7 (T)-law? |
|---|---|---|---|---|
| **HJ** (dim 2) | `(n,q)↦(⌈n/q⌉,…)` | **(T)** minimal resolution — *theorem* | — (Lagrange, quadratics) | yes (P1) |
| **Klein sails** | boundary of `Conv(σ∩(N∖0))`; digit = next sail facet | **(T)** = Hilbert-basis structure (Tsuchihashi 1983; Karpenkov) | totally-real: **proven** (Korkina/Lachaud); complex: **open**; *not* Hermite's converse (German–Lakshtanov) | set-valued, not a sequential digit |
| **Ashikaga → Fujiki–Oka** ★ | round-down `Zᵢ` + remainder `Rᵢ` (below) | **(T) EXPLICIT** — economic resolution of `¹⁄ᵣ(1,a,r−a)` (Sato–Sato 2108.02402 §3) | N/A (finite on rational data) | **yes — the M1 anchor** |
| **Jacobi–Perron** | `T(x)=(x₂/x₁−⌊·⌋,…,1/x₁−⌊·⌋)` | **(S)** yes (Lagarias 1993); **(T) NO** | **(a)** open both ways; periodic families (Dubois–Paysant-Le-Roux 1975, Bernstein); **no proven non-periodic cubic** | candidate only (S≠T) |
| **Brun** | subtract 2nd-largest from largest, reorder | **(S)** yes (Lagarias; Garrity TRIP literal triangle-subdivision); **(T) NO** | **(a)** open; convergent a.e.; **no proven non-periodic cubic** | candidate only |
| **Selmer** | subtract smallest from largest, reorder | **(S)** yes (BST/JEMS 2023 groups it *with* Brun/JPA); **(T) NO** | **(a)** open; ergodic; **no proven non-periodic cubic** | candidate only |
| **Mönkemeyer** | 2-branch fractional map split at `x₁+xₙ=1` | **(S)** yes — canonical triangle-subdivision base map (Garrity; Panti 2008); **(T) NO** | **(a)** open | candidate only |
| **Fully-subtractive** | subtract smallest from every other | **(S)** genuine but **dynamically degenerate** (Rauzy gasket; diverges a.e. for `d≥3`, Kraaikamp–Meester 1995); **(T) NO** | **(a)** open; distinctive proven a.e.-divergence, but **no named cubic** proven divergent | candidate only |

★ the anchor. **Sourcing honesty:** step rules for the five arithmetic MCFs are verbatim from
Labbé (arXiv:1511.08399), Berthé–Steiner–Thuswaldner (arXiv:1910.09386), Mercat
(arXiv:2311.10046), Panti (arXiv:0705.0584) — **not** from Schweiger's OUP 2000 book directly
(paywalled; cited via those). No "known non-periodic cubic" is claimed for any classical MCF
(none exists in the swept literature). Confidence: step rules HIGH; (S)/(T) split HIGH;
"(T)-absent for arithmetic MCFs" MOD–HIGH.

### Two headlines

- **The resolution bridge is narrow.** Sense-(T) — the experiment's actual subject — runs
  through **HJ / Klein sails / Ashikaga only**. The arithmetic zoo is sense-(S). This is the
  sharpened algorithm-space thesis (M0.3).
- **`F-3-canon` is well-founded, precisely.** Hermite is open both directions for every
  classical MCF; **no** MCF's periodicity characterizes cubics. Karpenkov's sin²-algorithm
  (Acta Arith. 2022) reaches **totally-real cubics only, via a non-classical algorithm** —
  the complex-conjugate case is open. Folklore ("JPA periodic ⇔ cubic", "Karpenkov solved
  Hermite", Garrity-family "iff cubic") **flagged and forbidden**.

---

## M0.2 — The decidable anchor `¹⁄ᵣ(1,a,r−a)`: confirmed, with the law worked authentically

**Classification / age / economic resolution:** unchanged and sourced — terminal ⟺
`¹⁄ᵣ(1,a,r−a)`, `gcd(a,r)=1` (Reid Thm 5.2); age `αₖ=(1/r)Σ(k·aᵢ mod r)>1`; economic rays
`vₖ=(1/r)(k, ak mod r, (r−a)k mod r)`, discrepancies `1/r,…,(r−1)/r`, no crepant (Reid,
Danilov §4; Sato–Sato; the exact "`1/r..(r−1)/r`" sentence is *assembled* from sourced pieces,
verified in-workspace, not a verbatim quote).

### The anchor law (sourced — the M1 target is not hypothetical)

Ashikaga's CF as a Phase-7 triple (from Sato–Sato 2108.02402 / crepant-paper 2004.03522,
reproducing Ashikaga Defs 3.1/3.2; both maps self-verified against the papers'
`¹⁄11(1,2,8)` example; full extraction in `m0-oracle-probe/ashikaga-fujiki-oka.md`):

- **State** = semi-unimodular proper fraction `(1,a₂,…,aₙ)/r`.
- **Digit `Ω` = round-down `Zᵢ`** = componentwise `⌊·/aᵢ⌋` with `⌊−r/aᵢ⌋` at slot `i` — the
  HJ generalization (its `n=2` coefficient series *is* the HJ CF).
- **Ray + `Γ`** = emit the Oka center `C=(P₁+Σaᵢ Pᵢ)/r`, star-subdivide at `C`; successor
  type = remainder `Rᵢ` (components mod `aᵢ`, `(−r) mod aᵢ` at slot `i`). Branch over
  `i∈{2,…,n}`; halt at smooth (`|det|=1`) — the Base-0 Wall.

### Worked calibration point `¹⁄7(1,3,4)` — the dim-3 analog of `7/3=[3,2,2]`

Running the *sourced* Ashikaga rule (execution independent; cross-validated against
`calibration_r7.sage`, same 13 cones & discrepancies). The recursion emits `r−1=6` Oka
centers in tree order `v₁,v₃,v₂,v₅,v₄,v₆`:

```
()      (1,3,4)/7 → v1=(1/7)(1,3,4)
 ├R2→ (2)   (1,2,1)/3 → v3=(1/7)(3,2,5)
 │     └R2→ (2,2) (1,1,1)/2 → v5=(1/7)(5,1,6)  [smooth leaf]
 └R3→ (3)   (1,3,1)/4 → v2=(1/7)(2,6,1)
       └R2→ (3,2) (1,2,1)/3 → v4=(1/7)(4,5,2)
             └R2→ (3,2,2) (1,1,1)/2 → v6=(1/7)(6,4,3)  [smooth leaf]
```
Discrepancies `age(vₖ)−1 = k/7` for `k=1..6` (ages `8/7,…,13/7`); **13 smooth maximal cones**
(Euler: `2·6+3−2=13`). And the **ladder closes as a gauge-monotone descent** — the max
cone-multiplicity drops `7→4→3→3→2→2→1` digit by digit to smooth (`calibration_r7.sage`).
*This is the "radix-law reading closes" that a bare economic-resolution table would not show.*

### The two charter questions, answered

- **(i) economic ladder = a single radix law?** **Yes, sourced** — Ashikaga's CF, self-verified.
  The identification "Ashikaga ≡ economic for `¹⁄ᵣ(1,a,r−a)`" is Sato–Sato §3 (M1's H-M1c
  hand-checks it on the battery).
- **(ii) `gauge = |det| = group`, or the discrepancy vector?** **Both, at different
  granularity** (the abelianization-style correction the charter predicted): coarse `|det|=r=
  |μᵣ|` survives (P1), but the *rich* invariant is the ordered **discrepancy vector
  `(1/r,…,(r−1)/r)`** — the essential-divisor spectrum, which *indexes* the resolution.

---

## M0.3 — Algorithm space as an FDRS object (formalized; conjecture graded; sharpened by S/T)

**Admissibility of a digit rule `Ω`** (Phase-7-native): (1) each step is a star subdivision
along a **primitive** ray (transition in `GL(3,ℤ)`); (2) **gauge-monotone** — the *active
cone's* multiplicity strictly decreases toward the smooth Wall `|det|=1` (the HJ-`n`-descent
analog; note the *global max* may plateau — `7→4→3→3→2→2→1` — while the active cone strictly
drops, which is the well-founded termination measure); (3) subdivision rays lie in the cone;
(4) termination on rational input. `Ω` satisfying (1)–(4) = a point in the admissible
algorithm space = a **Phase-7 law family** member.

**Sharpened by the (S)/(T) split (M0.1):** the arithmetic MCFs (JPA/Brun/…) are sense-(S)
dynamics; whether any satisfies (1)–(4) *as a resolution of the anchor* (sense-(T)) is the
open, exploratory content — the space of admissible `Ω` is the space of **(T)-laws**, and
much of the classical MCF zoo may lie *outside* it. Corpus fit: admissible-`Ω` ↔ Phase-7 law
families; transports ↔ Phase-5.3 recharts (P5's `F5-transport`: recharts change value);
law-sequences ↔ Phase-8 multi-timeline.

**Experiment-level conjecture — "discrepancy is the conserved quantity across subdivision-law
transports" (the P5-`d` analog).** Grade: **testable only after sharpening; carries a
pre-guarded tautology risk.** The essential discrepancies `{1/r,…,(r−1)/r}` are *intrinsic*
(occur in every resolution — Bouvier–González-Sprinberg), so "conserved across laws resolving
the *same* singularity" is vacuous — P5's `F5-tautology`. The real test needs a **Wahl-analog
move on `(r,a)`** (a law-morphism that *changes* the singularity), as P5's Wahl move changed
`(n,q)` while preserving `d`. **Guard `F-3-essential-tautology`** (see `NEGATIVE.md`); deferred
to M4, and forbidden in the same-singularity form.

---

## M0.4 — The designed negative: examined, and honestly relocated

Per the charter, the negative must be a *statement*, not a vibe. Making both candidate walls
precise and testing them, **neither survives as a no-go at the terminal anchor** — and that
finding is itself the M0.4 content.

**Wall 2 (non-uniqueness / flops) — DISSOLVES at the anchor.** Statement tested: *"a
deterministic law picks one of many smooth resolutions."* Test (`wall2_multi.sage`): the
economic resolution is the **unique** smooth toric resolution on the essential ray set —
`1` of `{32, 280, 256, 2768, 2412}` triangulations across `¹⁄5(1,2,3)`, `¹⁄7(1,2,5)`,
`¹⁄7(1,3,4)`, `¹⁄9(1,2,7)`, `¹⁄9(1,4,5)`. The terminal anchor's resolution is **canonical**;
a single `Ω` faces no choice. Wall 2 relocates to the **non-terminal / canonical** cyclic
quotients (which *have* crepant divisors ⇒ genuine minimal-model non-uniqueness / flops —
**the reviewer's original "Y", correctly located one scope-level out**) and general 3-folds —
both outside `F-3-scope`.

**Wall 1 (Hermite non-periodicity) — an OPEN frontier, not a proven no-go.** A finite-state
Phase-7 law produces eventually-periodic digits (pigeonhole on states), so it captures a
direction iff that direction has an eventually-periodic expansion. **Rational cones (the
anchor): always finite, always captured.** **Cubic directions: gated on Hermite** — whether a
non-totally-real cubic admits an eventually-periodic MCF is **open both ways** (no classical
MCF proven periodic *or* non-periodic on complex-conjugate cubics). Hence a finite-state law
capturing such a cubic would *resolve Hermite* — so Wall 1 is **not a proven impossibility**;
it is the frontier where the encoding's reach meets a famous open problem. Honest: a
*principled boundary* (provably works on rational cones; extension to cubic directions
Hermite-open), **not** a Catalan-style no-go.

**Conclusion + grade.** The terminal anchor is the **clean corner**: it admits **no designed
no-go** (Wall 2 dissolves; Wall 1 is open) — which is *exactly why it is the anchor* (P1 had
none either). The loss-of-canonicity the experiment is about lives **off** the anchor. Honest
grade: **"designed negative relocated off-anchor — owed at the non-terminal/flops phase
(M-later), not at the terminal anchor."** Gate implication: like P1, **M1 is an
exactness/existence result and need not be gated on a no-go**; the designed negative is owed
before the off-anchor phase. *(The gate is yours — if you'd rather M1 be gated on siting the
negative first, that is a defensible call.)*

---

## Part C — Oracle adequacy (F-3-anchor): by direct probe

| Oracle need | Tool | Verdict | Evidence |
|---|---|---|---|
| discrepancy / age / terminality | **elementary** age formula | **owned; self-verifying** | `oracle_probe.sage` (r∈{5,7,11,13}), `calibration_r7.sage` |
| certify a subdivision is smooth | **Sage** `Fan.is_smooth()` | **adequate (verify-mode)** | `oracle_probe2.sage` (4/4), `calibration_r7*.sage` |
| *generate* a resolution of a singular simplicial cone | Sage `resolve()` | **not available** (no-op) | probe v1 (0 rays) |
| count smooth resolutions / triangulations | Sage `PointConfiguration` | **adequate** | `wall2_multi.sage` (uniqueness across 5 anchors) |
| Hilbert basis cross-check | **Normaliz** | available (unused) | docs |

**Conclusion:** adequate and *correctly shaped* — Sage is a **verifier**, not a generator,
which offloads exactly the thin dim-3 toric machinery the RFME worried about: the **law
generates**, Sage **certifies smoothness** (determinant checks — the robust part), the
**discrepancy is elementary**. `F-3-anchor` clears; a battery-scale timing check is an
M1-kickoff item. *"Scoped and parked" was a live, respectable exit — it is not the outcome
because the hard work moved to the law and to closed-form arithmetic.*

---

## Sources (verified; full list + the corrections in `READING.md`)

**Anchor:** Reid, *YPG* PSPUM 46 (1987) Thms 4.11/5.2 + economic resolution (Danilov §4 w/
Barlow) — *image-scan, not OCR-quotable; "semicrepant"=Reid's coinage, std "essential."* ·
Sato–Sato arXiv:2108.02402 (*canonical* cyclic quotients; Fujiki–Oka≡economic) + arXiv:
2004.03522 (defines the round-down map) reproducing **Ashikaga, Kyoto J. Math. 59(4) (2019)**
Defs 3.1/3.2 (*paywalled — via Sato–Sato*) · Y. Sato, *Tokyo J. Math.* 45(1) (2022) (binary
trees; abstract only) · Morrison–Stevens *Proc. AMS* 90 (1984); White arXiv:1004.3411 ·
Cox–Little–Schenck GSM 124 §10; Popescu–Pampu arXiv:math/0506432 · Chen arXiv:1310.6445
(**general ladder REFUTED 0–3**) · Tsuchihashi (*Tohoku* 35, 1983); Bouvier–González-Sprinberg.
**MCF landscape:** Lagarias *Monatsh. Math.* 115 (1993) (simplex-splitting) · Berthé–Steiner–
Thuswaldner arXiv:2005.13038 (JEMS 2023), arXiv:1910.09386 · Panti arXiv:0705.0584 ·
Dasaratha–Flapan–Garrity et al. arXiv:1206.7077, arXiv:1208.4244 (TRIP) · Fougeron
arXiv:2001.01367 · Labbé arXiv:1511.08399; Mercat arXiv:2311.10046 (step rules) · Karpenkov
arXiv:2101.12707 (Acta Arith. 2022) + arXiv:2101.12627 (Monatsh. Math. 2024); Karpenkov–van
Son arXiv:2410.13091 (proven-aperiodic cubic — JPA *variant*) · Murru arXiv:1305.3285;
Řada–Starosta–Kala arXiv:2307.00898 (Hermite open) · Kraaikamp–Meester 1995 (fully-subtractive
a.e. divergence — *result high-confidence, not verbatim*) · Dubois–Paysant-Le-Roux 1975;
Bernstein LNM 207 (1971). Schweiger, *Multidimensional Continued Fractions*, OUP 2000 — **not
fetched directly**.

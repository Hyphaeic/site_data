# Negative results & fraud gallery — fdrs-hj-singularities

Seeded **before any run** (ADR-007: negatives first-class; tempting-but-wrong spins
written down so they cannot be quietly used). Refuted sub-hypotheses will be recorded
here at full weight as they arise, as bounded-completeness statements ("checked the
battery `n ≤ N` with exact method M; transcript at P").

---

## Fraud gallery — spins this experiment must NOT be used to support

1. **"FDRS gives a new resolution of singularities."** FALSE. HJ ↔ continued fractions
   ↔ toric resolution is classical (Hirzebruch, Jung, Riemenschneider). This encodes a
   known correspondence as a Phase-7 radix law and verifies it; it is connection +
   curation + verified artifact, never FDRS-novel geometry. (`F-novel`.)

2. **"FDRS carry-as-successor IS blow-down."** FALSE — but name the role, because the
   broad "carry ≠ blow-down" would itself be wrong. Carry has two roles the corpus keeps
   separate: **successor** (`Tick = +1`, value-*changing*) and **normalization**
   (value-*preserving* re-canonicalization — `enc∘dec`, rechart Def 68–69, exact nesting
   Thm 97–98). Castelnuovo contraction `(a,1,b)→(a−1,b−1)` is the minus-CF **reduction
   identity**: it preserves `n/q` and rewrites toward the reduced chain — the
   *normalization* role. So **carry-as-normalization ≡ blow-down is the intended
   positive**; only **carry-as-successor ≡ blow-down is the falsehood**. `F-carry` fires
   only on a successor / value-changing P2 implementation, or one that fails to preserve
   `n/q`.

3. **"HJ is a context-dependent radix (so the aᵢ are digits)."** Half-true, and the half
   matters. The `aᵢ` are **radices**, not digits-within-a-radix: Phase-7 radices are
   unbounded (`Ω → ℕ_{≥2}`), which is what makes the encoding admissible. A singularity
   is a radix **law** (a word over `{2,3,…}`), not a point on one shared line. Treating
   it as a point silently smuggles a single-odometer picture into H2 (`F-lawpoint`).

4. **"The ultrametric matches the resolution tree (≥95% of pairs) — H2 confirmed."**
   CIRCULAR. The resolution-tree edit distance *is* the HJ-prefix tree (by the
   cylinder ≡ partial-resolution identity), so it confirms the prefix ultrametric
   against itself. Any H2 number stated against a prefix-derived target is `F-circular`
   and is not a finding. H2 is validated against **independent** singularity adjacency,
   on the decidable sub-battery only.

5. **"Prefix distance = singularity proximity."** OVERCLAIM (pre-registered as likely
   partial). Prefix-sharing is a chain-*truncation* relation and is expected to capture
   only the **blow-down sub-order** of deformation adjacency, missing cross-chain
   adjacencies (T-singularities, KSB/Wahl smoothings). The honest statement is a bounded
   correspondence with an enumerated failure set — not "the natural proximity."

6. **"The gauge growing to n is deep FDRS content."** Read it honestly: `gauge =
   minus-CF continuant = n = |det of the −aᵢ intersection form| = |group order|` is a
   *classical* continuant identity, surfaced through the FDRS gauge. It is a clean
   anchor and a nice bonus, not a theorem this family owns.

7. **"A rendered resolution graph / dual graph is a result."** No. Images illustrate;
   results live in the exact battery agreement and the measured adjacency correspondence.
   A picture of one instance is not evidence (house rule).

8. **"P1 passing (exact digits) means H2 holds."** Necessary, not sufficient. Exact
   digit extraction is the Rung-0 anchor; the geometric-proximity claim (H2) is a
   separate, adjacency-gated bet that may well be refuted while P1 stands.

9. **"Sage agreed with itself, so the encoding is verified."** `F-oracle`. The Rust
   mirror must be checked against the **independent** Sage toric/CF oracle; a reference
   the experiment authored is exploitable. If both are ours, at least keep them
   algorithmically independent (Sage: toric fan subdivision; Rust: the direct HJ
   recursion) and record it.

10. **"Multi-branch (P4) works — routing reproduced the resolution tree."** Watch the
    corpus prediction: coupling is generically **ragged** (Prop 148), so a *clean*
    single-odometer routing reproducing the tree would be surprising. The pre-registered
    honest claim is that total intersection multiplicity is an **interface-balance**
    quantity (Thm 89), and the finding is whether that balance reproduces the
    multiplicity — not that routing is clean.

---

## Falsifier table (P1–P4 landed 2026-07-07; statuses below reflect the corrected runs)

| ID | Fires when | Kills | Status |
|---|---|---|---|
| **F-exact** | any float in P1–P2 digit/gauge/state arithmetic | the `exact` tag on the anchor | **SILENT** — ℤ/ℚ only; the O3/P2 toric sorts made exact-ℤ (E-2) |
| **F-oracle** | P1 agreement measured vs a self-authored reference | the verification claim | **SATISFIED** — 3 independent oracles (round-trip · exact det · toric), none self-authored |
| **F-carry** | blow-down as `+1` Tick, or contraction that changes `n/q` | the P2 (blow-down ↔ rechart) mapping | **EXERCISED & correct** — 4/4 successor edits break `n/q`; normalization preserves it |
| **F-circular** | H2 validated vs any prefix-derived target | the H2 correspondence finding | **AVOIDED** — adjacency (A_n order; Wahl forest) defined independently of the prefix |
| **F-lawpoint** | singularity treated as a point on one shared line | H2's object (space of laws) | **HONORED** — encoded as a radix law (finite word) throughout |
| **F-novel** | any "new singularity mathematics" claim in a note/manifest | the honest-scope contract | **HONORED** — HJ/CF/toric/Wahl/CS/Noether cited as classical |
| **F-P4-exact** | float in the multiplicity/CF/intersection arithmetic | P4 exactness | **SILENT** — exact over ℚ and ℚ(i) |
| **F-P4-oracle** | H4a checked vs anything but an independent intersection-mult | H4a | **SATISFIED — and it worked**: the symmetry cross-check **caught a parametrization bug** (`√(1+t⁴)`→`√(1+t⁸)` on `y²=x³+x⁷`) mid-development; final oracle is Sage-native `intersection_multiplicity` |
| **F-P4-proximity** | keying the coupling on multiplicity-sequence lcp not the proximity tree | the P4 encoding | **DEMONSTRATED** — bare-sequence lcp mis-scores satellite contact (`y²=x³ vs y²=x⁵`: `4 ≠ 6`); the proximity-tree encoding is the one used |
| **F-P4-ledger** | asserting strict `issued=consumed+pending` when only the weak form shown | the H4c claim | **RESPECTED** — strict form untested; the additive form is a *vacuous* valuation axiom, not asserted as evidence (E-5) |
| **F-P4-clean** | claiming a clean single-odometer routing reproduced the tree | the raggedness narrative | **HONORED** — no clean routing claimed; raggedness exhibited (unequal shared multiplicities, P4.3) |

---

## Errata (owner code-review, 2026-07-07 — corrected before finalization)

Three genuine defects were found in the original P1–P3 Sage/Rust and fixed; the
verdicts are unchanged but two scope claims were overstated and are now corrected.
(The first `site_data` publish predates these fixes and must be re-synced.)

- **E-1 (scope, real).** The T-singularity check keyed `a = (q+1)/nT` with a guard
  `d·nT·a − 1 == q` that is algebraically satisfiable **only when d = 1**; it silently
  rejected every genuine `d ≥ 2` T-singularity. Masked because the Wahl tree rooted at
  `[4]` generates only the d=1 stratum, so `255/255` was *accidental correctness*. Fix:
  `a = (q+1)/(d·nT)`; and the S2 battery now uses a Wahl **forest** (roots `[4]` and
  `[3,2ᵐ,3]`), so **S2 is now `0/494` prefix-related across d = 1..8** (was `0/254`,
  d=1 only). The MISS verdict holds and is now the claim the doc states — corrected in
  both Sage (`p3_adjacency.sage`) and the Rust mirror (`is_t`, forest).
- **E-2 (exactness, real by the letter).** The toric oracle (P1-O3) and P2's
  star-subdivision grounding sorted rays with `float(atan2(...))` — ordering, not value
  arithmetic (and unmis-sortable at `n≤60`), but the manifests said "ℤ/ℚ only." Fixed to
  an exact **ℤ cross-product comparator**; the "ℤ/ℚ only" claim is now literal. Results
  unchanged (1101/0, 2443/0).
- **E-3 (labeling/sample, real).** S3's statistic was called a rank correlation but was
  plain Pearson on raw values over a short-chain-biased sample `Tchains[:80]`. Fixed to a
  genuine **Spearman** over **all same-component pairs**: **ρ = 0.026** (was the mislabeled
  `+0.193`). The sign anomaly and the Catalan no-go are unaffected; S3 still leans MISS.
- **Non-issue (recorded as such).** `reduce_castelnuovo` tests one contraction order, so
  confluence is not *empirically* exercised across orders — but it need not be: minus-CF
  value-preservation + uniqueness of the reduced chain give confluence as a **theorem**;
  the round-trip test is the right check. No change.

### P4 review (second round, 2026-07-07)

- **E-4 (unstated real reason, now stated + closed).** The headline swapped the literal
  `x²y²+x⁵+y⁵` for `(y²−x³)(x²−y³)` as "same 2-cusp structure" (true — both are two (2,3)
  cusps with distinct tangents, `(C₁·C₂)=4`, confirmed by Sage-native `intersection_multiplicity`
  and by `multiplicity 4, tangents [y,x]`). But the *forcing* reason was hidden: the literal's
  branches are **not ℚ-rational** (`c²=−1` on the Newton edge ⇒ `c∈ℚ(i)`), so the QQ tracker
  can't hold them. Fixed both ways — the obstruction is stated, **and** the literal is now run
  over **ℚ(i)** (exact Newton branch, coupled = 4). Also the P4 oracle was upgraded from
  param-plug-in to Sage-native `intersection_multiplicity`.
- **E-5 (vacuous positive, relabeled).** H4c's "weaker bilinear conservation HOLDS"
  (`ord(fK·f₂|S)=ord(fK|S)+ord(f₂|S)`) is the **valuation axiom** `ord(gh)=ord g+ord h` — it
  cannot fail for any encoding, correct or broken, so it is **evidentially vacuous**. Relabeled
  as a smoke test. H4c true status: **strict Thm-89 ledger UNTESTED, weak form VACUOUS**
  (the honest half — `F-P4-ledger` respected — was already right). See NEG-2 (corrected).
- **E-6 (labels had only one direct test).** The free/satellite labeler was validated by a
  single assert (the (2,3) cusp). Added an **independent oracle on the labels**: δ = Σ mᵢ(mᵢ−1)/2
  from the tracker vs the independent `δ=(m−1)(n−1)/2` on 10 cusps (10/10), plus the classical
  `(2,q)`-cusp single-satellite fact — a check on the labels, not the totals.
- **Minor (fixed).** The coupling tracker now **guards** against two non-separating branches
  (identical params / infinite intersection) instead of silently summing to the step cap.

## Recorded negatives (bounded-completeness statements)

### NEG-1 — H2 is PARTIAL: the prefix ultrametric misses deformation adjacency (pre-registered as expected)

**Pre-registered (README P3):** the prefix ultrametric captures the blow-down/truncation
sub-order of adjacency and misses cross-chain (Q-Gorenstein) adjacencies; expected
**partial**.

**Result (`runs/2026-07-07-p3-adjacency/`; figures corrected per Errata E-1/E-3 — earlier
drafts stated the d=1-only numbers 255/254, `0/254`, Pearson `+0.193`, 7/7).** Confirmed
partial, and the contested middle came out on the *miss* side:
- **S1 A_n: hit.** 59/59 adjacent `A_k → A_{k−1}` pairs are prefix-related; prefix-order =
  truncation order.
- **S2 T-singularities: miss (all d strata).** The Wahl **forest** (roots `[4]` and `[3,2ᵐ,3]`)
  → **502** chains, **502/502 verified** as genuine `(1/(d·n²))(1,d·n·a−1)` T-singularities
  spanning **d = 1..8**; of **494** Q-Gorenstein-smoothing adjacencies, **0** are prefix-related.
- **S3 contested: leans miss.** a genuine **Spearman** over all 42,933 same-component pairs is
  **ρ = 0.026** (wrong sign for the hypothesis), and a counting no-go settles it: prefix
  predecessors are linear in chain length while Christophersen–Stevens deformation
  components are Catalan-many (`C₇ = 429` at length 8) — a prefix order provably cannot
  encode them.

**Honest statement.** The prefix ultrametric is a *faithful shadow of the resolution
(blow-down) order* and a *coarse, mostly-blind shadow of the deformation order*. This is
the pre-registered ¬(strong-H2) outcome, recorded at full weight, not oversold as a hit.
`F-circular` avoided (adjacency defined independently of the prefix). Method: `A_n` order
(classical); Wahl forest, every node verified as a T-singularity across d=1..8 (non-fabrication);
Rust mirror reproduces the S1/S2 combinatorics (502/494/0), `cargo test` 9/9.

### NEG-2 — H4c strict interface-balance ledger NOT established (pre-registered as open)

**Pre-registered (P4-PUISEUX.md, H4c):** whether intersection-multiplicity accumulation obeys
the strict `issued = consumed + pending` interface balance (Thm 89), or only the weaker
symmetric-additive conservation of Noether's formula — flagged OPEN, with `F-P4-ledger`
guarding against over-claim.

**Result (`runs/2026-07-07-p4-headline/`), corrected per E-5.** The strict Thm-89 ledger is
**untested**. The additivity `ord(fK·f₂|S)=ord(fK|S)+ord(f₂|S)` (`5=3+2`) that an earlier draft
counted as "the weaker form holding" is the **valuation axiom** `ord(gh)=ord g+ord h` — it holds
for *any* encoding and is therefore **evidentially vacuous** about the FDRS coupling; it is now
recorded only as a code smoke test. **H4c true status: strict UNTESTED, weak VACUOUS** — honest
and open. `F-P4-ledger` respected (no corpus-thesis claim). Establishing (or refuting) the
strict ledger, and extending to ≥4-branch networks, is the natural P4 continuation.

### Deferred (bounded-completeness "not computed here")

- **Full Christophersen–Stevens component-adjacency.** Only the component *count* (Catalan)
  is cited and its prefix-inexpressibility proven by the linear-vs-Catalan no-go. Which
  milder singularity sits on which CS component boundary — the complete deformation
  adjacency poset — is **not** enumerated in this charter, so no direct CS-adjacency vs
  prefix percentage is claimed. A future charter could compute it (Stevens' zero-chains /
  Altmann's Minkowski decompositions) and is the natural continuation.
- **P4 strict ledger + ≥4-branch networks** — see NEG-2; the strict Thm-89 balance and full
  multi-branch networks are deferred (H4a/H4b landed; H4c weaker-only).

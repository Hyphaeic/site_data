# Results — fdrs-hj-singularities

Per-phase verdicts. Scientific status: `cross-checked` within the exact-arithmetic
scope of each phase (three independent oracles on P1). No performance claim; no new
singularity mathematics (HJ↔CF↔toric is classical — the artifact is the exact FDRS
encoding + verification).

## Verdict table

| Phase | Claim under test | Verdict | Key evidence |
|---|---|---|---|
| **P1 — exact anchor** | HJ chain of `(n,q)` = an FDRS Phase-7 radix law; exact extraction, round-trip, and `gauge = n` | **PASS (exact)** | `runs/2026-07-07-p1-battery/`: 12231 pairs (`0<q<n≤200`), **0 failures** across O1 round-trip + O2 determinant; toric O3 0/1101 on `n≤60`; **Rust mirror bit-identical** (u64 checksum pinned, 3/3 tests); integer-only |
| **P2 — blow-down ≡ carry-normalization** | Castelnuovo `(a,1,b)→(a−1,b−1)` ≡ value-preserving rechart/`enc∘dec` (NOT successor); preserves `(n,q)` | **PASS (exact)** | `runs/2026-07-07-p2-blowdown/`: 3043 pairs (`n≤100`), blow-up/down preserve `(n,q)`, reduction confluent; **F-carry exercised** — 4/4 successor edits break `(n,q)`; toric star-subdivision 2443/2443; Rust mirror 5/5 |
| **P3 — ultrametric vs adjacency** | prefix ultrametric (gauge=continuant) vs deformation adjacency, 3 strata (A_n hit · CS contested · T-sing miss) | **PARTIAL (as pre-registered)** | `runs/2026-07-07-p3-adjacency/`: S1 **hit** 59/59; S2 **miss** 0/494 across **d=1..8** (502/502 T-verified); S3 Spearman **0.026** + Catalan no-go; Rust mirror 9/9 |
| **P4 — Puiseux multi-branch (Amendment 1)** | intersection multiplicity as the coupling ledger of a Phase-14 network (proximity-keyed) | **PASS (H4a/H4b) · H4c open** | `runs/2026-07-07-p4-{calibration,headline}/`: tracker=Sage-native oracle 8/8, satellite falsifier fired (seqlcp 4≠6), headline `(C₁·C₂)=4` (literal over ℚ(i)), raggedness exhibited, δ label oracle 10/10; H4c strict untested/weak vacuous; Rust mirror 9/9 |
| **P5 — Wahl-path law (Amendment 2)** | HJ↔path transport; what is conserved across the Wahl move | **PASS · headline** | `runs/2026-07-07-p5-path-law/`: H5a bijection; H5b tautology (P3's `0/494` = this `494/494`, two charts); **H5c d-invariant `494/494`, (n,q) grows** ("value dies, d survives"); H5d clean negative; Rust 10/10 |
| **P6 — CS components (Amendment 2)** | zero-chain count; component-set encoding | **H6a PASS · H6b NEGATIVE** | `runs/2026-07-07-p6-cs-components/`: H6a admissible zero-chains = Catalan (corrected from bare `K=0`); H6b naive characterization **refuted by A_n**; F6-forest structural; poset deferred |
| **P7 — strict ledger (Amendment 2)** | H4c strict Thm-89 on ≥3-branch germs, non-vacuously | **H7 PASS** | `runs/2026-07-07-p7-ledger/`: balance every step, pending nonzero, total=oracle (11/19); **both mutants fire** (F7-vacuous); supersedes NEG-2 vacuity; Rust 13/13 |

**Through-line.** The HJ resolution *is* an exact FDRS Phase-7 radix law whose gauge is the
group order (P1); blow-down is carry's value-preserving **normalization** role, not the
successor (P2); the induced prefix ultrametric faithfully encodes the **resolution (blow-down)
order** but is a coarse, mostly-blind shadow of the **deformation order** (P3, partial); and
that **same contact/tree structure faithfully carries the intersection multiplicity** of
coupled Puiseux branches, as the proximity-keyed coupling ledger of a Phase-14 network (P4).
The sharp arc: **prefix misses deformation (P3) but captures contact (P4)** — one ultrametric,
opposite faithfulness on two geometric questions. Amendment 2 owns the *change of law*: the
Wahl move that P3's chart was blind to is a **value-changing law morphism** that preserves the
stratum `d` (P5 — "value dies, d survives"); the CS component structure is Catalan-many and
single-line-impossible, with the naive component characterization honestly refuted (P6); and
H4c's strict interface ledger is realized non-vacuously with firing mutants (P7). Everything
exact and mirror-checked where it is exact; the geometric hypotheses are honestly bounded (H2
partial; H4c strict now *realizable* per P7; H6b naive characterization negative). No new
singularity mathematics — classical correspondences (HJ, Wahl/KSB, Stevens, Noether, Thm 89),
encoded and verified.

## Corpus placement (Phase-13 gauge layer — the CF-gauge theory)

The **law** (digit emission `Ω=⌈n/q⌉`, `Γ`) is deliberately Phase-7 (Def 89/103) — the singularity
is a context-dependent radix system, not a subshift-*generated* gauge (README). But the **gauge
machinery** the phases build by hand *is* Phase-13's continued-fraction gauge theory, which the
first pass under-cited (the law/gauge split hid it):

- **P1's gauge** (`|det| = n = continuant`) is **`Def 181 (the convergent-pair ledger)`**: the
  `SL₂(ℤ)` state `(p_{k−1},p_k;q_{k−1},q_k)` under the convergent recurrence, whose gauge is the
  denominator `q_k`. HJ's minus-CF continuant `pᵢ = aᵢpᵢ₋₁ − pᵢ₋₂` is the `[[a,±1],[1,0]]` step; the
  transition `|det| = 1` is **`Thm 72 (the bracket invariant)`**. **`Def 181` is `❌ missing` in
  Lean** — so P1/P4 are geometric witnesses for it.
- **P4's coupling ledger** is `Def 181` in its coupled (multi-branch) form — the convergent-pair
  ledger with an interface, tying to the Phase-14 §14.6 balance.
- **P5's gauge growth** ("value dies, `d` survives"; `n = d·nT²` climbing along Wahl paths) is
  **`Thm 73 (gauge growth: qₖ > 0, qₖ → ∞, even for φ)`** — the corpus's theorem that the
  convergent denominator grows without bound (even for the all-1 golden-mean word).
- **P3's prefix ultrametric** (`δ = gauge(lcp)⁻¹`, gauge = continuant) is **`Def 183 (the
  gauge-induced CF distance `cfDist = 1/q_ℓ`)`**, with **`Thm 74` (cfDist is a genuine ultrametric)**
  and **`Thm 75` (ball = cylinder)** as its formal backing — P3 used exactly `1/q_ℓ`, the
  Phase-13 gauge, not the Phase-1 base product.

So: the **law is Phase-7**, the **gauge/ultrametric/ledger/growth are Phase-13** (Def 181/183, Thm
72/73/74/75). No new mathematics — the phases are geometric instances of, and witnesses for (Def 181
being unformalized), the corpus's CF-gauge layer. (Ref: `docs/fdrs.md` §13.2–13.3,
`Modes/VariableRadix/SubshiftWeight.lean`, `.../SubshiftMetric.lean`.) *Watch-point:* Phase-13's
`Thm 71` "free `d=1`" is the subshift's single-state case — **not** the T-singularity/star stratum
`d`; the two `d`'s are unrelated and the pun is not claimed.

## P1 — exact anchor (2026-07-07) · PASS

**Claim.** The Hirzebruch–Jung resolution of the cyclic quotient surface singularity
`(n,q)` is reproduced exactly by the FDRS Phase-7 radix law `Ω=⌈n/q⌉`,
`Γ(n,q)=(q, aq−n)`, terminating at a Base-0 Wall; it round-trips; and its FDRS gauge is
the group order.

**Result.** On the full battery **all `(n,q)`, `0<q<n≤200`, `gcd(n,q)=1` — 12231 pairs —
zero failures** against three independent oracles (integer/rational arithmetic only):

- **O1 (round-trip).** The minus-CF continuant *evaluation* of the extracted chain equals
  `n/q` on every pair — extraction and evaluation are opposite directions, so this
  catches any recursion/transcription error.
- **O2 (gauge = group order).** `|det(intersection form)| = n` and `|det(minor)| = q` via
  Sage's exact `ZZ` determinant (a different code path from the recursion) on every pair.
  **This is the promoted headline: the FDRS place value the odometer accumulates equals
  `n = |det of the −aᵢ tridiagonal| = |cyclic quotient group|`.** Stronger and cleaner
  than the RFME's original Phase-2 framing.
- **O3 (toric geometry).** On the `n≤60` sample (1101 pairs, 0 failures), the chain is
  reproduced by the *geometric* minimal resolution — the cone's Hilbert basis + wall
  relation `u_{i−1}+u_{i+1}=aᵢuᵢ` (convention `Cone([(1,0),(−q,n)])`, calibrated on
  `(7,3)→[3,2,2]`). The dual convention `(0,1),(n,−q)` returns the reversed chain,
  correctly identifying the Riemenschneider dual `(n,q′)` — a free confirmation the
  oracle distinguishes a singularity from its dual.

**Examples.** `(5,4)→[2,2,2,2]` (the A₄ chain), `(7,3)→[3,2,2]`, `(5,2)/(5,3)→[3,2]/[2,3]`
(dual pair, reversed), `(30,7)→[5,2,2,3]`, `(200,199)→[2¹⁹⁹]` (A₁₉₉). Max chain length 199.

**Falsifiers.** `F-exact` silent (no float in any core path). `F-oracle` satisfied
(agreement measured against two algebraic + one geometric oracle, each independent of the
digit recursion — not a self-authored reference). `F-lawpoint` honored: a singularity is
encoded as a radix *law*, not a point on one line.

**Scope / what is NOT claimed.** Correctness only — no timing. No new singularity theorem
(`F-novel` honored). P1 is the necessary anchor; it says nothing about H2 (P3, adjacency)
or the blow-down↔normalization mapping (P2), both of which are separate, gated bets.

**Mirror rung (exactness ladder).** The Rust `no_std` crate `source/rust/hj-radix`
implements the *same* Phase-7 law independently (integer-only, zero deps) and is pinned
to reproduce the Sage battery **bit-for-bit**: a folded u64 checksum over all 12231 pairs
matches Sage's (`7424009778405959836`), and the in-crate battery re-checks every invariant
(`a_i≥2`, `continuant=n`, `minor=q`, round-trip). `cargo test` → 3/3. So the anchor is not
Sage-only; a Rust result contradicting Sage would be a bug, and none does.

**Reproduce.** `cd source/sage && sage p1_verify.sage` · `cd source/rust && cargo test --offline`

## P2 — blow-down as carry-normalization (2026-07-07) · PASS

**Claim.** The Castelnuovo blow-down `(a,1,b)→(a−1,b−1)` is carry's **normalization** role
(value-preserving re-canonicalization: `enc∘dec` / rechart Def 68–69 / exact nesting
Thm 97–98), **not** the successor (`Tick = +1`). The negative is *narrow*:
carry-as-successor ≠ blow-down; carry-as-normalization ≡ blow-down.

**Result (`runs/2026-07-07-p2-blowdown/`).**
- **Positive — value preservation + confluence.** On all 3043 pairs `0<q<n≤100`: a
  deterministic schedule of interior blow-ups `(a_i,a_{i+1})→(a_i+1,1,a_{i+1}+1)` preserves
  `(n,q)` at **every** step (0 changes), and Castelnuovo reduction is **confluent** back to
  the canonical minimal chain (all `a_i≥2`; 0 off-canonical). Blow-up/down are
  value-preserving representation changes — carry-as-normalization.
- **Negative — F-carry exercised (not merely asserted).** A carry-*as-successor* edit
  (bump one radix like an odometer digit) **breaks `(n,q)` 4/4**: `(7,3)=[3,2,2]` → bump
  `a₀` → `[4,2,2] = (10,3)`; likewise `(5,4),(11,7),(30,7)`. So the successor reading is
  genuinely a different (value-changing) operation — the pre-registered narrow negative.
- **Geometric grounding.** 2443 interior-wall blow-ups equal the toric **star-subdivision**
  (insert ray `u_i+u_{i+1}`, recompute self-intersections) exactly — 0 mismatches.
- **Mirror.** Rust `mod p2` re-verifies value preservation + confluence and the
  successor-breaks witness independently (`cargo test` 5/5).

**Falsifiers.** `F-carry` exercised and correct (narrow negative confirmed); `F-exact`
silent (`ZZ/QQ` only). **Scope:** interior (chain-preserving) blow-ups only; boundary
`(−1)`-curves change the framing and are out of scope (asserted absent). No new
mathematics — the minus-CF reduction identity and toric blow-up are classical; the artifact
is the FDRS *normalization-vs-successor* placement, verified.

**Reproduce.** `cd source/sage && sage p2_blowdown.sage` · `cd source/rust && cargo test --offline`

## P3 — prefix ultrametric vs deformation adjacency (2026-07-07) · PARTIAL

**Claim (H2, refined).** The prefix ultrametric `δ(x,y) = gauge(lcp(x,y))⁻¹`
(gauge = continuant) captures the blow-down/truncation sub-order of deformation adjacency
and *misses* cross-chain Q-Gorenstein adjacencies. Pre-registered expectation: **partial**.
Adjacency is defined independently of the prefix, so `F-circular` is avoided.

**Result (`runs/2026-07-07-p3-adjacency/`) — three strata, and the shape is the finding.**
- **S1 — A_n: HIT.** For `A_k = [2ᵏ]`, all 59/59 adjacent pairs (`A_k → A_{k−1}`) are
  prefix-related and the prefix order equals the truncation order. On the A-family the
  prefix ultrametric **is** the deformation order.
- **S2 — T-singularities: MISS (all d strata).** The Wahl **forest** — rooted at `[4]` (d=1)
  *and* `[3,2ᵐ,3]` (d=2,3,…) — gives **502** chains up to length 8, **all 502 verified** as
  genuine `(1/(d·n²))(1, d·n·a−1)` T-singularities (the *corrected* non-fabrication check),
  spanning **d = 1..8**. Of its **494** Q-Gorenstein-smoothing adjacencies, **0 are
  prefix-related** — smoothing adjacency is orthogonal to the prefix ultrametric across every
  d stratum (witnesses at lcp 0).
- **S3 — contested middle: lands on miss.** A genuine **Spearman** rank correlation of
  prefix-shared depth vs Wahl-tree (deformation) distance over **all 42,933 same-component
  pairs** (unbiased) is **ρ = 0.026** — essentially uncorrelated, and the sign means
  prefix-close pairs trend deformation-*far*, so not even a partial hit. A counting no-go is
  decisive regardless: prefix predecessors are **linear** in chain length `e`, while
  Christophersen–Stevens deformation components are **Catalan-many** (`C₂=2, C₄=14, C₇=429`) —
  a linearly-branching order provably cannot encode them.

**Verdict.** H2 is **partial, exactly as pre-registered** (a first-class result, not a
failure): the prefix ultrametric is a *faithful shadow of the resolution (blow-down) order*
and a *coarse, mostly-blind shadow of the deformation order*. `F-circular` avoided,
`F-exact` silent, `F-novel` honored. Rust `mod p3` independently reproduces the S1 and
S2 combinatorics — the corrected Wahl forest (502 chains / 494 adjacencies / 0 prefix-related,
d≥2 stratum pinned) — `cargo test` 9/9. Three review errata (T-check d=1 bug, toric float
sort, S3 mislabel/bias) fixed pre-finalization; see `NEGATIVE.md` Errata.

**Scope / deferred.** The full Christophersen–Stevens component-*adjacency* (which milder
types sit on which component boundary) is not enumerated — only its count is cited and its
prefix-inexpressibility proven. A direct CS-adjacency comparison is a deferred item
(`NEGATIVE.md`), not claimed.

**Reproduce.** `cd source/sage && sage p3_adjacency.sage` · `cd source/rust && cargo test --offline`

## P4 — Puiseux multi-branch as a coupled network (2026-07-07; corrected) · PASS (H4a/H4b), H4c open

**Amendment 1** (`P4-PUISEUX.md`), executed after owner review that relocated the coupling
key to the **proximity-aware Enriques tree** (not the bare multiplicity sequence) and made a
**satellite-contact pair mandatory**. This is the contrast P3 set up: prefix/contact is
where the tree structure is *faithful*.

**P4.1 — calibration + the satellite falsifier (`runs/2026-07-07-p4-calibration/`).** An exact
blow-up tracker carries the (chart, shift) tree tag *and* the free/satellite proximity
(labeler validated: the `(2,3)` cusp is free,free,**SAT**). Per pair: ORACLE
(`ord_t f₂(param C₁)`, symmetry-checked), COUPLED (proximity-tree sum), SEQLCP (bare-sequence
lcp). **Tracker == oracle on all 8 cases (H4a).** The decisive **satellite** falsifier fired
as predicted: `cusp vs deeper (y²=x³ vs y²=x⁵)` **separates at a satellite**, and there the
bare SEQLCP gives a *wrong finite* `4` vs the true `6`. The owner-flagged `y²=x³ vs y²=x³+x⁴`
is **logged**: equisingular (identical sequences), shares 5 points **through** the satellite
p₂, **separates at a free point** (owner correct) — still discriminates because the bare
sequence can't distinguish equisingular branches. Every candidate logged, 0 non-discriminating,
nothing post-hoc. `F-P4-proximity` justified; the symmetry cross-check even caught a
parametrization bug mid-development (`F-P4-oracle` working).

**P4.2 — headline (`runs/2026-07-07-p4-headline/`).** Oracle upgraded to **Sage-native
`intersection_multiplicity`** (independent of the tracker). (a) The ℚ-rational anchor
`(y²−x³)(x²−y³)` — two (2,3) cusps, opposite tangents — has `(C₁·C₂) = 4 =` coupled. (b) The
**literal `x²y²+x⁵+y⁵` is run over ℚ(i)**, closing the swap caveat: its branches are *not*
ℚ-rational (on the Newton edge `y ~ c·x^{3/2}` gives `c²=−1`, so `c∈ℚ(i)` — the real reason a
representative was needed, now stated). The literal's Newton branch over ℚ(i) (leading `I·t³`,
residual valuation exact) runs through the tracker to **coupled = 4**, matching the
distinct-tangents oracle (`2·2`, Sage-confirmed tangents `[y,x]`). So literal and factored are
**equisingular**, both `(C₁·C₂)=4`, exact over ℚ and ℚ(i) respectively.

**P4.3 — raggedness (H4b) + ledger (H4c).** Witness `(y−x²)(y²−x³)` (smooth + cusp, same
tangent): the shared subtree carries **unequal** multiplicities `(1,2),(1,1)` → **ragged**
(no joint odometer), yet the invariant `3` is recovered exactly as the coupling ledger (H4a
via Sage-native oracle) — the Phase-14 thesis instance. **H4c — honest status:** the additivity
`ord(fK·f₂|S)=ord(fK|S)+ord(f₂|S)` is a **valuation axiom** (`ord(gh)=ord g+ord h`) — it cannot
fail for *any* encoding, so it is a **vacuous** smoke test carrying zero evidential weight about
the FDRS coupling; the **strict** `issued=consumed+pending` (Thm 89) is **untested**.
**H4c true status: strict UNTESTED, weak VACUOUS** — `F-P4-ledger` respected, no corpus-thesis
claim.

**Label oracle (independent of the sums).** The free/satellite labels are checked against
δ = Σ mᵢ(mᵢ−1)/2 read off the tracker vs the independent `δ=(m−1)(n−1)/2` on 10 cusps
(10/10 match), plus the classical `(2,q)`-cusp single-satellite fact (`(2,3..9)` all give 1
satellite) — a check on the labels, not the totals.

**Verdict.** H4a and H4b **hold** (prefix/contact is faithful — the positive contrast with
P3's deformation miss); **H4c is open** (strict untested, weak vacuous). Falsifiers all silent
or respected; exact over ℚ and ℚ(i); Rust mirror (a truncated rational power-series blow-up
tracker) reproduces the ledger sums independently (`cargo test` 9/9). No new mathematics —
Noether/Enriques classical.

**Reproduce.** `cd source/sage && sage p4_calibration.sage && sage p4_headline.sage` ·
`cd source/rust && cargo test --offline`

---

# Amendment 2 (P5–P7) — the Wahl-path law, CS components, the strict ledger

Charter `P5-P7-CONTINUATION.md`, pre-registered before code. P5–P7 own the *change of law*
between the HJ chart and the Wahl-path chart, promote the P3-deferred CS components, and make
H4c's strict ledger genuinely refutable.

## P5 — the Wahl-path law and the HJ↔path transport (2026-07-07) · PASS (headline)

**Setup.** Each T-singularity encoded two ways: the HJ Phase-7 law (P1) and the **Wahl-path
law** `(root, word)` — `root ∈ {[4]} ∪ {[3,2ᵐ,3]}` (the d-stratum), `word ∈ {m1,m2}*` (constant
radix 2). Study the pair and the map between.

- **H5a (bijection): HOLDS.** `(root, word)` reconstructs the chain; the 502 forest nodes are
  distinct paths, all verified T by the corrected `is_t`, all round-trip through the P1 HJ law —
  the two oracles independent of the moves (`F5-independence` honored).
- **H5b (tautology, smoke test):** every Wahl edge is a one-move path-prefix (494/494) *by
  construction*. **P3's `0/494` (HJ chart) and this `494/494` (path chart) are the same fact in
  two charts** — the finding is the chart change, never the hit rate (`F5-tautology` honored).
- **H5c (the real result): CONFIRMED — "value dies, d survives."** Across all **494** Wahl
  moves, `d(parent) = d(child)` (494/494) and `(n,q)` strictly changes (494/494). The Wahl move
  preserves the stratum `d` while changing the value. The continuant grows as `n = d·nT²` with
  `nT` ascending per depth (`2 / 3 / {4,5} / {5,7,8}` — mediant/Stern-Brocot-shaped), recorded
  not forced. One law's tick (path digit emission) is the other's non-local two-ended edit.
- **H5d (SB rule): clean negative.** The pre-registered run-length↔HJ-digit rule holds only
  trivially (length bookkeeping) or not at all (`2/494`); the genuine SB structure sits in the
  `nT` growth, recorded as an observation, not fitted (`F5-fitted` honored).
- **`F5-transport`:** HJ↔path is a **value-changing** law morphism (changes `(n,q)`), so **not**
  a Phase-5.3 rechart; its corpus placement is recorded **open**, not forced. Rust `mod p5`
  reproduces the bijection + d-invariance sweep (10/10). `F-exact` silent.

## P6 — Christophersen–Stevens components (2026-07-07) · H6a PASS, H6b NEGATIVE

- **H6a (anchor): CONFIRMED, with a corrected characterization.** The Stevens zero-chains are
  **admissible** (`kᵢ≥1`, minus-continuant `K=0`, **all proper-prefix continuants > 0**), *not*
  bare `K=0` — which over-counts from length 5 (`21,75,266`). Admissibility restores Catalan
  exactly (`1,2,5,14,42,132,429,1430`, e=2..9; max entry `e−1`, the triangulation bound).
- **H6b (the bet): NEGATIVE on the naive characterization.** "Components = admissible zero-chains
  dominated by the HJ chain" is **refuted by the A_n cross-check**: `A₁=[2]→0` though A₁ is a
  smoothable RDP (1 component); `A₃=[2,2,2]→2` though the RDP has 1. So the dominated-count is
  *not* the deformation-component number — the correct Stevens correspondence is subtler.
  Building the actual component-adjacency poset is **deferred** (bounded-completeness).
- **F6-forest CONFIRMED (structural).** Admissible zero-chains number `C_{e−1}` (super-linear)
  while a single prefix-line has ~`e` predecessors, so no single-line (dual-augmented or not)
  encodes the component set — the P3 Catalan no-go, now load-bearing. Rust `mod p6` mirrors the
  Catalan count and the A_n refutation (recorded as **NEG-3**).

## P7 — the strict Thm-89 interface ledger (2026-07-07) · H7 PASS

H4c was untested and its weak form vacuous (E-5). P7 makes the strict `issued = consumed +
pending` **non-vacuous**: sweep the shared resolution tree of a ≥3-branch germ **level by
level** — ISSUE a coupled pair's `mᵢ(d)·mⱼ(d)` into `(issued, pending)`; CONSUME a pair's pending
into `consumed` when it separates.

- **H7: HOLDS.** 3-branch `{y=x², y=x²+x⁵, y²=x³}`: total `11` = Sage-native oracle, balance
  `issued=consumed+pending` at **every** step, pending nonzero mid-sweep (max 8). 4-branch (adds
  `x²=y³`): total `19` = oracle, balance every step (satellite contact included).
- **`F7-vacuous`: guard fired.** Two mutants break the check — `forget_decrement` (consume
  without decrementing pending) **breaks the balance**; `double_issue` (inflate issued) makes the
  total `32 ≠ 19`. So the balance is a genuine machine invariant, **not** the `ord(gh)=ord g+ord
  h` valuation axiom of E-5.
- **Verdict.** Multi-branch intersection accounting **is realizable** as a strict Thm-89 interface
  ledger with a real in-flight register — a constructive realizability + non-vacuous check, not a
  new theorem (that's Noether). **Supersedes NEG-2's "weak form vacuous."** Rust `mod p7` mirrors
  the ledger + firing mutants (13/13). `F-exact` silent.

**Reproduce.** `cd source/sage && sage p5_path_law.sage && sage p6_cs_components.sage && sage p7_ledger.sage`
· `cd source/rust && cargo test --offline`

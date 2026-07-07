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

**Through-line.** The HJ resolution *is* an exact FDRS Phase-7 radix law whose gauge is the
group order (P1); blow-down is carry's value-preserving **normalization** role, not the
successor (P2); the induced prefix ultrametric faithfully encodes the **resolution (blow-down)
order** but is a coarse, mostly-blind shadow of the **deformation order** (P3, partial); and
that **same contact/tree structure faithfully carries the intersection multiplicity** of
coupled Puiseux branches, as the proximity-keyed coupling ledger of a Phase-14 network (P4).
The sharp arc: **prefix misses deformation (P3) but captures contact (P4)** — one ultrametric,
opposite faithfulness on two geometric questions. Everything exact and mirror-checked where it
is exact; the geometric hypotheses are honestly bounded (H2 partial; H4c weaker-conservation
only). No new singularity mathematics — a classical correspondence, encoded and verified.

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

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
| **P3 — ultrametric vs adjacency** | prefix ultrametric (gauge=continuant) vs deformation adjacency, 3 strata (A_n hit · CS contested · T-sing miss) | **PARTIAL (as pre-registered)** | `runs/2026-07-07-p3-adjacency/`: S1 **hit** 59/59; S2 **miss** 0/254 (255/255 T-verified); S3 corr +0.193 + Catalan no-go; Rust mirror 7/7 |
| P4 — Puiseux multi-branch (amendment) | intersection multiplicity as interface-balance in a Phase-14 coupled network | — | deferred, gated |

**Through-line.** The HJ resolution *is* an exact FDRS Phase-7 radix law whose gauge is the
group order (P1); blow-down is carry's value-preserving **normalization** role, not the
successor (P2); and the induced prefix ultrametric faithfully encodes the **resolution
(blow-down) order** but is a coarse, mostly-blind shadow of the **deformation order** (P3,
partial). The encoding is exact and mirror-checked where it is exact; the one geometric
hypothesis (H2) is honestly bounded. No new singularity mathematics — a classical
correspondence, encoded and verified.

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
- **S2 — T-singularities: MISS.** The Wahl tree from `[4]` (chains up to length 8) gives
  **255** chains, **all 255 verified** as genuine `(1/dn²)(1, dnq−1)` T-singularities (the
  non-fabrication check). Of its **254** Q-Gorenstein-smoothing adjacencies, **0 are
  prefix-related** — the smoothing adjacency is orthogonal to the prefix ultrametric
  (witness: `[4] ~Wahl~ [2,5]`, lcp 0). 
- **S3 — contested middle: lands on miss.** Prefix-shared depth vs Wahl-tree (deformation)
  distance correlate only **+0.193** on 3160 pairs — weak, and the *sign* means
  prefix-close pairs trend deformation-*far*, so not even a partial hit. A counting no-go
  is decisive: prefix predecessors are **linear** in chain length `e`, while
  Christophersen–Stevens deformation components are **Catalan-many** (`C₂=2, C₄=14,
  C₇=429`) — a linearly-branching order provably cannot encode them.

**Verdict.** H2 is **partial, exactly as pre-registered** (a first-class result, not a
failure): the prefix ultrametric is a *faithful shadow of the resolution (blow-down) order*
and a *coarse, mostly-blind shadow of the deformation order*. `F-circular` avoided,
`F-exact` silent, `F-novel` honored. Rust `mod p3` independently reproduces the S1 and
S2 combinatorics (`cargo test` 7/7).

**Scope / deferred.** The full Christophersen–Stevens component-*adjacency* (which milder
types sit on which component boundary) is not enumerated — only its count is cited and its
prefix-inexpressibility proven. A direct CS-adjacency comparison is a deferred item
(`NEGATIVE.md`), not claimed.

**Reproduce.** `cd source/sage && sage p3_adjacency.sage` · `cd source/rust && cargo test --offline`

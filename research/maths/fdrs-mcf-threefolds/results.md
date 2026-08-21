# results.md — M1: the terminal-anchor law (economic resolution as a Phase-7 tree-law)

**Phase M1. Executed 2026-07-07.** Exactness ladder: Sage oracle (`source/sage/`) + Rust
`no_std` mirror (`source/rust/mcf-radix`). Battery = **551** terminal anchors `¹⁄ᵣ(1,a,r−a)`,
`2≤r≤60`, `a↔r−a` collapsed, `a↔a⁻¹` distinct (registration condition #2). Provenance:
git `2f17518` (dirty), SageMath 10.9, cargo 1.93.0. Runs: `runs/2026-07-07-m1-*`.

## Verdict: **M1 PASS** — the economic resolution of terminal `¹⁄ᵣ(1,a,r−a)` IS an exact FDRS Phase-7 radix law, tree-shaped.

| Hyp. | Claim | Sage | Rust | Verdict |
|---|---|---|---|---|
| **H-M1a** | every leaf cone of the law's subdivision is smooth (`\|det\|=1`) | 551/551 | 551/551 | **PASS** |
| **H-M1b** | gauge `\|det\|=r=\|μᵣ\|`; discrepancies `1/r,…,(r−1)/r` by elementary age **and** toric φ | 551/551 | 551/551 | **PASS** |
| **H-M1c** | Ashikaga's emitted Oka centers == the economic ray set `{vₖ}` | 551/551 | 551/551 | **PASS** |
| **H-M1d** | Rust mirror reproduces Sage bit-for-bit (parity) | — | — | **PASS** (both 551/551) |
| **H-M1e** | economic resolution is the *unique* smooth resolution on the essential rays | 24/24 enumerated | — | **PASS on enumerable range** (compute wall — below) |
| **H-M1f** | law is tree-shaped; placement Phase-7-tree-state vs Phase-8, *tested* | 551/551 shape | 551/551 shape | **PASS → Phase-7 tree-state** |

No falsifier fired: `F-M1-smooth`, `F-M1-gauge`, `F-M1-ashikaga`, `F-M1-parity`, `F-M1-canon`
(on the enumerated range), `F-M1-chain` — all clear.

## The law (as executed, from the sourced Ashikaga rule)

State = the active singular cone (semi-unimodular proper fraction `(1,a₂,a₃)/r`). Each node
emits the **Oka center** `C=(P₁+a₂P₂+a₃P₃)/r`, star-subdivides at `C`, keeps `cone(C,P₂,P₃)`
smooth (Oka definition), and recurses on the two remainder-map children `Rᵢ` (see
`m0-oracle-probe/ashikaga-fujiki-oka.md`). Terminal = smooth (`|det|=1`), the Base-0 Wall.

- **H-M1a/b/c** confirm the law's output *is* the economic resolution, exactly, on all 551:
  every maximal cone smooth; gauge `r` with the ordered essential-discrepancy spectrum
  `(1/r,…,(r−1)/r)` reproduced two independent ways (elementary age = `1+k/r`, and the toric
  support function `φ`); the emitted digits set-equal the economic rays `vₖ=(1/r)(k, ak, (r−a)k
  mod r)`. Headline `¹⁄7(1,3,4)`: 6 nodes, 13 leaves, maxdepth 3, discrepancies `1/7…6/7`.
- **H-M1d** — the `no_std` Rust mirror (integer 3×3 dets + non-negative remainders) returns
  the identical per-anchor verdicts across the whole battery. Two implementations, one answer.

## H-M1f — the structural finding (the front-door question, answered)

**The dim-3 anchor law is a tree, not a chain — and its honest corpus placement is Phase-7
with tree-shaped state, not Phase-8 routing.** Confirmed 551/551: exactly `r−1` emitting
nodes and `2r−1` leaves (the star subdivision spawns `n−1=2` singular children per node; one
subcone is smooth by the Oka definition). The coupling test settles the placement:

- **same law at every node** (the identical `Rᵢ`/`Zᵢ` maps) → self-similar;
- **`Ω(node)` depends only on the node's own cone** (`C=(P₁+a₂P₂+a₃P₃)/r`) → no external context;
- **the two branches resolve disjoint subcones** meeting only along the pre-existing wall
  `cone(P₁,C)`, with no shared state → branch-independent;
- **the final fan is traversal-order-free** (unique — H-M1e) → order carries no **value-layer**
  information.

A single self-similar, context-local, branch-independent law with tree-shaped state **does not
need Phase-8 routing** (which exists to choose *between* laws/timelines; here there is no
choice and no coupling). **Placement verdict: Phase-7 extended from chain-state (dim 2) to
tree-state (dim 3).** The dimension is precisely the chain→tree operator (`branching = n−1`).
This is the first genuinely new structural demand dimension 3 makes on the framework, and it
is answered by *extension*, not by invoking a heavier corpus object.

> **Precision note (value-layer vs process-layer).** Point 4 is scoped to the **value layer**:
> the endpoint (final fan) is route-invariant, so *no choice is made at the value layer* — which
> is what the placement turns on (Phase-8 exists to choose, and here nothing is chosen). It does
> **not** say traversal order is informationless in general. Whether order carries *process-layer*
> information — working set / deposit order over the resolution tree — is a separate question, and
> precisely the one `fdrs-resolution-trajectories` **T3** is built to answer over this exact law.
> Endpoint-invariance is the *premise* of that three-layer separation (T1/T2), not a claim against
> it; given branch-independence, T3 is expected to find schedule-dependent working-set and
> deposit-order statistics here even though the multiset (and thus the value layer) is degenerate.

## H-M1e — unique smooth resolution: PASS on the enumerable range (honest boundary)

Every enumerated anchor has **exactly one** smooth toric resolution on its essential rays:
`r≤11` (all `a`-classes) + `¹⁄12(1,1,11)` = **24 anchors**, subdivision counts 2 → 57,783, all
`1 smooth`. This extends M0.4's 5 anchors and matches the essential-divisor structural reason
(the `vₖ` are forced in every resolution — Bouvier–González-Sprinberg).

**Compute wall (recorded per registration condition #2, not silently trimmed):** the
triangulation enumeration exceeds compute at `¹⁄12(1,5,7)` — killed even standalone in a fresh
process — and for all `r=13`. These are **untested by enumeration**. *Erratum E-M1-1: the
registration's `r≤13` feasibility estimate ("counts ≲10⁶") was optimistic; the actual wall is
`~¹⁄12(1,5,7)` (`r=11` complete).* A scalable structural-uniqueness proof remains an
M1-stretch, not a commitment. H-M1e is **strongly supported, not exhaustively verified** — the
honest grade.

## Through-line — what M1 establishes

The dim-2 anchor P1 showed *the HJ continued fraction = the minimal resolution* (a **chain**
Phase-7 law, gauge `=|det|=|group|`). **M1 is its faithful dim-3 analog:** the economic
resolution of the terminal anchor **= Ashikaga's continued fraction = an exact Phase-7 law**,
now with (i) gauge refined from the scalar `r` to the **discrepancy vector** `(1/r,…,(r−1)/r)`
(the abelianization-style correction M0.2 predicted), (ii) the canonical *target* (unique
resolution) but a **tree-shaped** law, and (iii) the loss-of-canonicity displaced entirely
off-anchor. The terminal corner is clean, exact, and now *executed* — the P1 of dimension 3.

**Still owed (OB-1):** the designed no-go was relocated off-anchor (M0.4). M1 being PASS does
**not** discharge it — it is owed at **M2** (non-terminal/canonical quotients, genuine flops).
The family cannot close until M2 sites it or records why not.

## Duality observation (post-hoc, NOT a pre-registered hypothesis)

The battery keeps `a ↔ a⁻¹` classes distinct deliberately, to observe the dim-3 shadow of the
dim-2 Riemenschneider duality (which P1-O3's dual convention caught for free as reversed chains).
It shows: for **every** dual pair `1/r(1,a,r−a)` and `1/r(1,a⁻¹,r−a⁻¹)`, the Ashikaga trees have
**identical node-depth and leaf-depth multisets** — the same shape by level — verified 194/194 on
`5 ≤ r < 30`. So `a ↔ a⁻¹` is a **tree-shape-preserving duality** here (the discrepancy multiset
`{k/r}` was already `a`-independent; the new content is that the *tree structure* is dual-invariant
too). Recorded as an observation, not a claim: depth-profile identity is verified, but whether it
lifts to a full tree isomorphism / mirror (R₂↔R₃ relabelling) is the natural next look, not
asserted here.

*Independently reproduced 2026-07-07 (`source/sage/m1_duality.sage`): **264/264** anchors on
`5≤r<30` have node- and leaf-depth multisets equal to their `a⁻¹` dual — the **194 non-self-dual
anchors + 70 self-dual (`a=a⁻¹`)**, which pins the "194" as exactly the non-self-dual count.*

## Provenance
`runs/2026-07-07-m1-battery` (H-M1a/b/c/d/f), `runs/2026-07-07-m1-uniqueness` (H-M1e). Sage
10.9 + Rust `no_std` (cargo 1.93.0), git `2f17518` dirty. All integer/ℚ-exact; no floats.
Duality observation: `runs/2026-07-07-m1-battery` data, post-hoc (2026-07-07).

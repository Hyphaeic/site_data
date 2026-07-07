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

## Falsifier table (mirrors the charter; filled as runs land)

| ID | Fires when | Kills | Status |
|---|---|---|---|
| **F-exact** | any float in P1–P2 digit/gauge/state arithmetic | the `exact` tag on the anchor | not yet run |
| **F-oracle** | P1 agreement measured vs a self-authored reference | the verification claim | not yet run |
| **F-carry** | blow-down as `+1` Tick, or contraction that changes `n/q` | the P2 (blow-down ↔ rechart) mapping | not yet run |
| **F-circular** | H2 validated vs any prefix-derived target | the H2 correspondence finding | not yet run |
| **F-lawpoint** | singularity treated as a point on one shared line | H2's object (space of laws) | not yet run |
| **F-novel** | any "new singularity mathematics" claim in a note/manifest | the honest-scope contract | not yet run |

---

## Recorded negatives (bounded-completeness statements)

### NEG-1 — H2 is PARTIAL: the prefix ultrametric misses deformation adjacency (pre-registered as expected)

**Pre-registered (README P3):** the prefix ultrametric captures the blow-down/truncation
sub-order of adjacency and misses cross-chain (Q-Gorenstein) adjacencies; expected
**partial**.

**Result (`runs/2026-07-07-p3-adjacency/`).** Confirmed partial, and the contested middle
came out on the *miss* side:
- **S1 A_n: hit.** 59/59 adjacent `A_k → A_{k−1}` pairs are prefix-related; prefix-order =
  truncation order.
- **S2 T-singularities: miss.** Wahl tree from `[4]` → 255 chains, **255/255 verified** as
  genuine `(1/dn²)(1,dnq−1)` T-singularities; of 254 Q-Gorenstein-smoothing adjacencies,
  **0** are prefix-related.
- **S3 contested: leans miss.** prefix-shared depth vs Wahl-tree distance correlate only
  `+0.193` (wrong sign for the hypothesis), and a counting no-go settles it: prefix
  predecessors are linear in chain length while Christophersen–Stevens deformation
  components are Catalan-many (`C₇ = 429` at length 8) — a prefix order provably cannot
  encode them.

**Honest statement.** The prefix ultrametric is a *faithful shadow of the resolution
(blow-down) order* and a *coarse, mostly-blind shadow of the deformation order*. This is
the pre-registered ¬(strong-H2) outcome, recorded at full weight, not oversold as a hit.
`F-circular` avoided (adjacency defined independently of the prefix). Method: `A_n` order
(classical); Wahl tree from `[4]`, each node verified as a T-singularity (non-fabrication);
Rust mirror reproduces the S1/S2 combinatorics (255/254/0), `cargo test` 7/7.

### Deferred (bounded-completeness "not computed here")

- **Full Christophersen–Stevens component-adjacency.** Only the component *count* (Catalan)
  is cited and its prefix-inexpressibility proven by the linear-vs-Catalan no-go. Which
  milder singularity sits on which CS component boundary — the complete deformation
  adjacency poset — is **not** enumerated in this charter, so no direct CS-adjacency vs
  prefix percentage is claimed. A future charter could compute it (Stevens' zero-chains /
  Altmann's Minkowski decompositions) and is the natural continuation.
- **P4 (Puiseux multi-branch)** — the pre-registered Phase-14 coupled-network amendment;
  not begun (gated on P1–P3, now landed).

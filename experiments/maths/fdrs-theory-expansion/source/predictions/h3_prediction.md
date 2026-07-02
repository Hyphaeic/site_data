# H3 (Reachability) — PRE-REGISTERED prediction curve

**Written before the H3 screen runs (anti-HARKing, ADR-007 §1 / NEGATIVE.md).**
Derived from THEORY.md Part C ("a sharp prior FDRS already implies"), Thm 65
(`orthogonalDecomposition_parseval`) + Thm 66 (`FourierCeiling`) + Lemma 3
(ContrastBasis). No screen has been run at time of writing.

Probe: **parity** `f(x) = (-1)^popcount(x)`, base 2, `n` positions, `N = 2^n`,
mean-zero, `||f||^2 = N`. This is the single Walsh character `W_{all-ones}`.

## Prediction P-H3a — tree variance face reports ~0 (the radix tree cannot see it)

For the homogeneous binary tree truncated at depth `k` (leaves = depth-`k`
cylinders, each of size `2^(n-k)`):

| depth k | leaf size | predicted rSquared(parity, T_k) |
|---|---|---|
| 0 | 2^n | **0** (trivial tree: P_T f = global mean = 0) |
| 1 .. n-1 | 2^(n-k) ≥ 2 | **0 (exactly)** |
| n | 1 | **1 (exactly)** — singleton leaves, memorization, *not* structure |

**Mechanism (exact, not approximate):** parity averages to 0 over any contiguous
block of size ≥ 2 (one free low bit ⇒ `sum (-1)^popcount = 0`), so every non-singleton
cell mean is 0 ⇒ `treeBlockProjection ≡ 0` ⇒ `explainedVar = 0` ⇒ rSquared = 0.
General law for ANY tree T: **rSquared(parity, T) = (#points isolated as singleton
leaves) / N.** Hence the only tree that "captures" parity is the fully-resolved tree
(leafCount = N), which memorizes rather than explains.

So the prediction is **stronger than "≈ 0"**: it is **exactly 0 at every depth k < n**,
jumping to the trivial 1 only when the tree degenerates to point cells.

## Prediction P-H3b — one character captures it exactly

Exact Walsh spectrum of parity (energies `energy_S = (Σ_x f(x) W_S(x))^2 / N`,
`Σ_S energy_S = ||f||^2 = N`):

- **Exactly one** nonzero coefficient, at `S = 2^n - 1` (the all-ones bitmask =
  top-order character), with `energy_S = N` (fraction **1** of the energy).
- `energy_S = 0` for **every** other `S` (all 2^n - 1 of them).

## Contrast controls (the screen must NOT be vacuously all-zero)

| probe | predicted tree behaviour | predicted Walsh |
|---|---|---|
| `top-bit` = `(-1)^(top bit)` | rSquared(T_k) = **1 for all k ≥ 1** (root-layer signal, captured at depth 1) | single coeff at `S = 2^(n-1)` (order-1), energy 1 |
| `digit-cond-2bit` (value = top 2 bits) | rSquared(T_1) **< 1** (partial), rSquared(T_k) = **1 for k ≥ 2** (adapted at depth 2) | energy only in characters supported on the top 2 bits (low order), **0** at `S = 2^n-1` |

These confirm the tree DOES capture root-/low-order structure — so a 0 on parity is
about parity, not a broken screen.

## Falsifier mapping (F3, three pre-registered outcomes)

- **(a) [PREDICTED]** no tree captures parity (rSquared = 0 ∀ k<n) AND one Walsh
  coefficient captures it (energy fraction 1) ⇒ the synergy extension is the character
  route — machinery the corpus already owns (`FourierCeiling`/`ContrastBasis`).
  *Confirms Part C.*
- **(b)** some tree T with all leaves size ≥ 2 has rSquared(parity, T) > 0 ⇒ violates
  Thm 65/66 ⇒ **suspect a generator/encoding artifact** (parity mis-aligned to a cell);
  escalate to method check, do not claim.
- **(c)** neither tree nor character captures it ⇒ synergy out of reach (hard limit).

**This run reports the F3 outcome as the headline result of the decisive pair.**

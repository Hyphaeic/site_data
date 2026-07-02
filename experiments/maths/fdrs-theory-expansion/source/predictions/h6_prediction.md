# H6 (characterSynergy) — PRE-REGISTERED prediction curve

**Written before the H6 screen runs (anti-HARKing, ADR-007 §1 / NEGATIVE.md F6 + the
H6 definitional-trap fraud line). mtime is the witness.** Derived from the Walsh order
algebra + the classical interaction-information definition. No screen has been run.

Measure (FDRS-native arbiter): `synergy_{>m}(f) = (Σ_{order(S)>m} energy_S) / (Σ_{order(S)≥1}
energy_S)`, exact QQ, `order(S) = popcount(S)`. Reuses the gate-green Walsh mirror; no new basis.

**Discipline (pre-committed): parity at top order is DEFINITIONAL (= H3), the NULL — never the
finding. The finding is (a) ∧ (b) ∧ (c) below, where the MIXED gates and the exact-zeros are the
content.**

## P-H6-native — predicted order grading (k = 2..5)

| function | order profile (non-constant energy) | `synergy_{>1}` | `synergy_{>k-1}` (top) |
|---|---|---|---|
| **parity-k** (null) | 100% at order k | **1** | **1** |
| single-bit | 100% at order 1 | **0 (exact)** | 0 |
| additive (Σ bits) | 100% at order 1 | **0 (exact)** | 0 |
| copy(native) | 100% at order 1 | **0 (exact)** | 0 |
| **AND-k** (mixed) | `C(k,j)/(2^k−1)` at order j | `1 − k/(2^k−1)` | `1/(2^k−1)` |
| **OR-k** (mixed) | same as AND-k (symmetric) | `1 − k/(2^k−1)` | `1/(2^k−1)` |
| random ±1 (control) | ≈ binomial `C(k,j)/(2^k−1)` (per-draw exact) | ≈ `1 − k/(2^k−1)` | **≈ `1/(2^k−1)` ≪ 1** |

Exact AND/OR values: k=2 → `synergy_{>1} = 1/3`; k=3 → `4/7` (top `1/7`); k=4 → `11/15` (top
`1/15`); k=5 → `26/31` (top `1/31`).

Note (pre-registered nuance): AND's energy is *uniform across all 2^k characters* (`ĥ_S =
(−1)^|S| 2^{−k}`), so its order profile is binomial — **AND is broadly mixed, not
top-concentrated**; its top-order fraction `1/(2^k−1)` equals the random control's *expected*
top-order fraction. So separation of "synergy" from "structureless" at the MAXIMAL order is
parity-vs-random (criterion b); the mixed-gate ranking (criterion c) uses `synergy_{>1}`
(beyond-additive / interaction energy), where AND `= 1 − k/(2^k−1) ≫ 0 =` copy.

## P-H6-classical — predicted neutral interaction-information II(X1;X2;Y) (k=2)

| gate | predicted II (exact) | sign |
|---|---|---|
| XOR (parity-2) | **+1** | synergy |
| AND | **+0.189** `= (3/4)log₂3 − 1` | synergy (mild) |
| OR | **+0.189** (= AND by symmetry) | synergy (mild) |
| UNIQUE | **0** | none |
| COPY (redundant inputs) | **−1** | redundancy |

## Inference criteria (decided in advance; verdict rests on a ∧ b ∧ c)

- **(a) exact zeros:** `synergy_{>m}(f) = 0` **exactly (QQ)** on every pure-≤m target —
  `synergy_{>1}` = 0 for single-bit, additive, copy; `synergy_{>k}` = 0 for parity-k.
- **(b) parity vs random:** `synergy_{>k-1}(parity-k) = 1` vs `synergy_{>k-1}(random) ≈ 1/(2^k−1)
  ≪ 1` (≥3 seeds), at k = 2..5.
- **(c) mixed-gate monotonicity + classical agreement:** `synergy_{>1}` ranks **parity > AND/OR
  > copy/additive/single-bit** (i.e. `1 > 1−k/(2^k−1) > 0`), monotone, and **agrees in
  sign/ordering** with classical interaction-information (`XOR +1 > AND/OR +0.189 > UNIQUE 0 ≥
  COPY −1`): every native-positive-synergy function has II > 0; every native-zero function has II
  ≤ 0.

## P-H6-scope (pre-registered honest bound)

`synergy_{>m}` is a **nonnegative** synergy fraction (top-order energy ∈ [0,1]). It does **not**
resolve redundancy as a negative quantity: COPY (classical II = −1) and UNIQUE (II = 0) both read
**`synergy_{>1} = 0`** — the order grading collapses the redundancy/unique side to 0. So
`characterSynergy` is a **synergy measure** agreeing with classical-II on the *synergy* side; the
full PID lattice (separating redundancy from uniqueness, the negative regime) is out of scope and
would need more than the order grading. This is reported as a characterization, not a failure.

## Verdict rule

- **H6 PASS / promote `characterSynergy`** iff (a) ∧ (b) ∧ (c) hold. Parity alone is the null —
  a pass on parity-only is NOT a result.
- **H6 FAIL (F6)** iff a redundant/additive function carries top-order energy, or parity-k does
  not concentrate at order k, or the mixed gates do not rank monotonically with the
  by-construction synergy and classical interaction-information. Then "synergy = top-order
  character energy" is false as stated — headline negative in NEGATIVE.md (bounded-completeness).

# Run notes — 2026-06-30 H1/H3 decisive pair

## What ran, in order
1. **Gate** (`source/gate.py`) — 10/10 exact-equality theorem-tests GREEN. The Sage
   mirror reproduces the machine-checked corpus: Thm 65 Parseval / ANOVA, Def 174
   rSquared, `cover_of_interval_sound` (3235 containment cases), Thm 69 homogeneous
   collapse, Lemma 3 Vilenkin/Walsh identities (over `QQ(ζ_b)` and `QQ`), and the Kraft
   bound `Σ 1/B_k < 2`. This is the artifact control (NEGATIVE.md): definability/soundness
   is *content-free as a finding* — the gate only certifies the mirror is faithful before
   the screens are trusted.
2. **H3 screen** (`source/screen_h3.py`) — the decisive scope screen.
3. **H1 screen** (`source/screen_h1.py`) — the non-vacuity screen.

## H3 — clean confirmation of the FDRS self-prediction (F3(a))
Parity `f(x) = (-1)^popcount(x)` over `N = 2^n`:
- `rSquared(parity, T_k) = 0` **exactly** for every depth `k < n`, `= 1` only at `k = n`
  (singleton leaves = memorization, not structure). Verified at `n = 3,4,5,6`, and the
  general law `rSquared(parity,T) = (#singleton-leaf points)/N` was asserted to match the
  measured value at every `(n,k)`.
- Robustness: heterogeneous and unbalanced trees with all leaves size ≥ 2 → `rSquared = 0`.
- Walsh spectrum: **exactly one** nonzero coefficient, at `S = 2^n − 1` (top-order
  character), carrying **100%** of the energy. All other `2^n − 1` coefficients = 0.
- Controls are alive: `top-bit` captured at depth 1 (`rSquared = 1, k≥1`), `digit-cond-2bit`
  captured at depth 2 (`rSquared = 4/5` at `k=1`, `1` at `k≥2`) — neither has any energy at
  the top-order character. So the 0 on parity is a property of parity, not a dead screen.

This is exactly THEORY.md Part C, observed: the variance branch is the L²/Gaussian shadow;
pure top-order synergy is structurally invisible to it but is one character. The synergy
extension lives in machinery the corpus already owns (`FourierCeiling` / `ContrastBasis`),
**not** in a new tree term.

## H1 — PASS, with a logged prediction deviation (honest-broker)
coverEntropy `= log2 |distinct depth-d value-cells|` separates the battery into ≥ 4 tiers at
matched `(d,b)` (constant 1 cell → i.i.d. at the `2^d`-cell base-counting envelope), so it is
**not** flat — F1 does not fire. It is a genuine covering-number / metric-ε-entropy quantity.

**Deviation from pre-registration (recorded, not hidden):** the pre-registered per-signal
table (P-H1a/P-H1b) predicted the `{0,1}`-valued sources (parity, golden-mean, markov) would
read 2 cells / 1 bit "at `d ≥ 1`". Observed: they read **1 cell (0 bits) until `d = 8`**,
reaching 2 cells only at the finest depth. Mechanism (verified): `cover_of` is **MSB-first**,
so coverEntropy is the *metric* covering number of the value-set; values 0 and 1 are
metrically adjacent (differ by `2^0`), so they share the top-`d` cell until `d = 8`, whereas
`{0,128}` (differ by `2^7`) separate at `d = 1`. The discrimination **verdict is unaffected**
(P-H1b holds exactly at every matched `d`), but the deviation **sharpens the scope bound**:
coverEntropy reads the *metric spread* of the range, blind to temporal structure (parity =
golden-mean = markov, all curves identical) **and** indifferent to value-multiplicity among
metrically-clustered values. This is the exact Kolmogorov ε-entropy of the value-range — a
real but range-only quantity. (Whether its *scaling* equals metric entropy quantitatively is
H2, deferred.)

## Falsifier status (NEGATIVE.md templates)
- **F1** (kills H1): **did not fire** — coverEntropy is structure-dependent (4 tiers).
- **F3** (scopes the line): outcome **(a)** — character route confirmed; not (b) artifact,
  not (c) hard-limit.

## Forward (deferred per charter)
Both decisive screens say "go": H1 non-vacuous, H3 confirms the character route. H2 (metric
calibration), H4 (non-stationary non-tautology), H5 (observer-entropy DPI) are now unblocked.
Promotion candidates: `coverEntropy_sound` (provable-now artifact control) and the
`characterSynergy` object on the Vilenkin basis (the genuine native extension H3 points to).
Not executed in this run.

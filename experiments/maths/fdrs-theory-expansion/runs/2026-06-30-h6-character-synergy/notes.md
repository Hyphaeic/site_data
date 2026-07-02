# Run notes — 2026-06-30 H6 (characterSynergy)

## What ran
1. **Gate** re-run — 10/10 GREEN (mirror unchanged from the G2 decisive-pair run; the H6
   machinery reuses `walsh_spectrum`/`walsh_characters` untouched, adds no new basis).
2. **H6 screen** (`source/screen_h6.py`, with `source/synergy.py`) — interaction-order
   grading of the exact Walsh spectrum, + the neutral classical interaction-information
   cross-check. H6 alone; H4 and H2a/H2b deferred.

## Result: H6 PASS — the order grading is a synergy measure (with a stated scope)

The finding rests on the **exact (a)** and the **cross-validated (c)** — *not* on parity:

- **(a) exact zeros (the artifact-faithful half).** `synergy_{>1} = 0` **exactly (QQ)** for
  single-bit, additive, and copy(native); `synergy_{>k} = 0`, `synergy_{>k-1} = 1` for
  parity-k. The grading leaks no additive/low-order energy into high orders. Parity's
  top-order concentration is **definitional (= H3)** and is the NULL, not the finding.
- **(c) the mixed gates (the real content).** AND-2 and OR-2 — genuinely mixed, not pure-order
  anything — read `synergy_{>1} = 1/3` (energy profile `o1:2/3, o2:1/3`), landing **strictly
  between** parity (1) and additive/copy (0). This ordering **agrees in sign and rank** with
  the independent classical interaction-information: `II(XOR)=+1 > II(AND)=II(OR)=+0.189 >
  II(UNIQUE)=0 ≥ II(COPY)=−1` (exact; `II_AND = (3/4)log₂3 − 1`). Two independently-defined
  quantities — Walsh top-order energy and Shannon interaction-information — rank the AND gate
  the same way. The AND/OR symmetry is preserved by both. **This is the non-definitional
  result.** (Agreement is ordinal — energy fraction vs bits are different units — not
  quantitative; `1/3 ≠ 0.189`.)
- **(b) parity vs random.** `synergy_{>k-1}(parity)=1` (exact) vs the random ensemble mean →
  `1/(2^k−1)` (the exact white-spectrum expectation), `≪ 1`. **Clean for k≥3**; see deviation.

## Scope (pre-registered P-H6-scope, confirmed)
`synergy_{>m}` is **nonnegative** — COPY (II=−1) and UNIQUE (II=0) both read `synergy_{>1}=0`.
The grading is a **synergy measure** (the positive PID atom), agreeing with classical-II on the
*synergy* side; it does **not** resolve redundancy as a distinct negative quantity. The full PID
lattice (separating redundancy from uniqueness) is out of scope — it would need more than the
order grading. Reported as characterization, not failure.

## Deviation logged (honest-broker; parallels the H1 deviation)
Pre-registered criterion (b) covered `k=2..5`. **At k=2 it fails:** a random ±1 function on the
4-point hypercube is *spectrally degenerate* — only 3 non-constant characters, so a single draw
frequently IS a pure character (one seed gave top-frac 1; the 8-seed mean is 1/2, not the
predicted `1/3`). So the prediction "random ≈ 1/(2^k−1) ≪ 1" holds for **k≥3** (means 0.158,
0.044, 0.072, 0.020 — tracking `1/(2^k−1)`) but **not k=2**.

**The k≥3 restriction is post-hoc and is attributed to the CONTROL, not the measure.** Why this
is not an F6 falsification:
- F6's kill conditions are *a redundant/additive function carrying top-order energy, or parity
  not concentrating, or the gates not ranking*. **None occurred** — additive/single-bit/copy are
  exactly 0; parity is exactly 1; the gates rank and cross-validate.
- "Random" is a low-synergy control only **in expectation / at large k**; a random function *can*
  be synergistic (it can equal parity), so high synergy on a coincidentally-high-order random
  draw is the measure being **correct**, not failing.
- **Non-vacuity at every k, including k=2, is independently established by the DETERMINISTIC
  battery**: additive (0) < AND/OR (1/3) < parity (1), three distinct exact values at k=2. The
  random control is a *supplementary* non-vacuity check; its k=2 degeneracy does not touch the
  deterministic discrimination.

## Falsifier status (NEGATIVE.md F6)
**F6 NOT triggered.** No redundant/additive function carried top-order energy (exact 0); parity
concentrated (exact 1); mixed gates ranked monotonically and agreed with classical
interaction-information. `characterSynergy` is warranted for `Conjectures/`.

## Forward (deferred per Amendment 1)
H6 returns PASS → H4 (sequential / non-stationary entropy — the entropy-rate route the decisive
pair left untouched) is next, then H2a/H2b (calibrating the now range-bounded coverEntropy). Not
run here. Promotion candidate `characterSynergy` must state the scope in the Lean: a nonnegative
top-order-energy synergy fraction, redundancy/uniqueness collapsed to 0.

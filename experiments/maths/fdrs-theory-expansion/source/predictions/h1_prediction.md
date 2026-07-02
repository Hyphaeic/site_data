# H1 (Discrimination) — PRE-REGISTERED prediction curve

**Written before the H1 screen runs (anti-HARKing, ADR-007 §1 / NEGATIVE.md).**
Derived from the `cover_of` mechanism (FdrsSensorFusion.lean) + the metric-entropy
reading (THEORY.md Part A). No screen has been run at time of writing.

Measure: `coverEntropy(signal, d) = log2 |distinct depth-d value-cells|` — the
covering number of the signal's VALUE-SET at resolution `b^-d` (Kolmogorov ε-entropy
of the range). The exact arbiter is the integer cell count; `log2` is monotone in it.

Base-counting NULL (F1): `coverEntropy(d) = d·log2(b)` for every signal (all `b^d`
cells occupied, independent of structure). The discrimination claim is that
structured signals fall **strictly below** this envelope, **tier-ordered**, at matched
`(d, b)`.

## Prediction P-H1a — monotonicity and the cell-count ladder (b = 2, D = 8, N = 256)

`coverEntropy` is monotone non-decreasing in `d` for every signal, and saturates at
`log2(value-set size)`. Predicted saturated values (cells, then bits) at depth `d ≥ 2`:

| signal | distinct values | predicted cells (d large) | coverEntropy (bits) |
|---|---|---|---|
| constant | 1 | 1 | **0** |
| parity (values {0,1}) | 2 | 2 | **1** |
| golden-mean / markov (values {0,1}) | 2 | 2 | **1** |
| periodic-2 (levels 0, 128) | 2 | 2 | **1** |
| digit-cond-1 (top 1 bit) | 2 | 2 | **1** |
| digit-cond-2 (top 2 bits) | 4 | 4 | **2** |
| i.i.d. uniform [0,256) | ≈ 256 | → 2^d (saturates the envelope) | **d** |

## Prediction P-H1b — discrimination at matched (d, b): NOT flat ⇒ F1 does not fire

At matched `(d, b)` with `d ≥ 2`, `coverEntropy` takes **≥ 4 distinct values** across
the battery — ordered tiers:

```
constant (0)  <  {2-level signals} (1)  <  digit-cond-2 (2)  <  i.i.d. (d)
```

Covering **deficit** `Δ(signal, d) = d·log2(b) − coverEntropy(signal, d)`:
- i.i.d.: `Δ = 0` (sits AT the base-counting envelope — correct for a structureless
  source).
- structured signals: `Δ > 0`, tier-ordered (constant has the largest deficit).

**F1 falsifier:** fires iff `coverEntropy` is flat across the battery at matched
`(d, b)` (every signal ≈ `d·log2 b`). **Predicted: does NOT fire** — constant is pinned
at 0, i.i.d. at the envelope, with ≥ 2 intermediate tiers. ⇒ coverEntropy is a genuine
covering-number (ε-entropy-flavoured) quantity, not base-counting.

## Prediction P-H1c — pre-registered SCOPE BOUND (honest, stated before the run)

`coverEntropy` reads the **value-set** covering number only. It is therefore
**blind to temporal / sequential structure**: parity, golden-mean, and markov all have
value-set `{0,1}` ⇒ **identical** `coverEntropy ≈ 1`, despite different sequence
entropy rates (parity deterministic; golden-mean rate `log2 φ ≈ 0.694`; markov `< 1`;
i.i.d.-binary rate `1`). **Predicted:** these three are indistinguishable to
`coverEntropy`. So H1's discrimination is of **amplitude/range** tiers, NOT of
sequential structure. This is the pre-registered bound on what passing H1 means — it is
NOT "coverEntropy captures all structure," only "it is a non-vacuous covering number of
the range." (Sequential/temporal entropy is a different object, out of H1's scope.)

## Verdict rule

- **H1 passes** iff P-H1b holds: coverEntropy separates ≥ 3 tiers at matched `(d, b)`,
  with constant pinned at 0 and i.i.d. at the envelope (NOT flat). Scope bound P-H1c is
  reported alongside as the characterization, not as a failure.
- **H1 fails (F1)** iff coverEntropy is flat (base-counting): then the candidate dies,
  recorded as the headline negative in NEGATIVE.md.

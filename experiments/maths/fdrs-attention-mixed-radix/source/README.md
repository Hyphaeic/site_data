# source/ — fdrs-attention-mixed-radix

Capture substrate = **Rust/Burn** (the house toolchain, reusing the sibling `fdrs-adaptive-train` machinery);
spectroscopy = **SageMath** exact lenses. Capture and analysis are physically separate (ADR-007 pattern).

## Layout

```
source/
  stage0_demo.sage   # [EXISTS] Rung-0 illustrative demo (lenses on exact attention + worked example)
  lenses.sage        # [EXISTS] spectroscopy engine — 3 layers (exact / approximation-bound / residual-stub); self-test OK
  analyze.sage       # [EXISTS] runs lenses over captured landscapes -> metrics + baseline-adjusted (RUN=<dir>)
  atlas.sage         # [EXISTS] confound visualization
  capture/           # [EXISTS] **CANONICAL** Burn capture crate — trains the model, emits landscapes.json
                     #          (reuses fdrs-adaptive-train Model/gen_batch; depends on it by path)
  capture.py         # [EXISTS] numpy cross-check capture (substrate-independence check; NOT canonical)
  baselines.sage     # [planned] standalone Rung-1 null harness (currently folded into capture + analyze)
  README.md          # this file
```

## The exact / float boundary (the discipline the engine must enforce)

- **Capture** (Burn) emits attention scalars as floats. The engine reconstructs each float's **exact dyadic
  rational** from its IEEE-754 bits — *lossless*, so the lens operates on the true machine value, tag `exact`.
- **Approximant** shadows (CF convergents at a stated tolerance) are a *separate*, tolerance-tagged step
  (`enclosure`); their denominators are a property of the approximation and require the Rung-1 baseline.
- By ADR-007 decoration composition, any claim about a *model's* landscape is ultimately `float`-tagged (the
  model produced the floats) and is gated by the baseline comparison. Only Rung 0 / rational-`φ` paths are
  end-to-end `exact`.

## Tooling

- **SageMath** (`/usr/bin/sage`, ≥10.9) — exact rationals, `factor`, `continued_fraction`, p-adic
  `valuation`, mixed-radix. This is the "number-theoretic probe" half of ADR-007. **No Python as the main
  implementation** (repo rule); Sage scripts are the sanctioned exception for exact number theory.
- **Rust/Burn** — landscape capture only (reuses `experiment-fdrs-adaptive-attention` / `fdrs-gpu-numerics`
  attention machinery). Exports high-precision/bit-exact dumps for Sage to read.

## Run

```bash
sage source/stage0_demo.sage     # Stage-0 demo; prints every lens + the worked row-gauge example
```
Verified to run under Sage 10.9. Produces no files and asserts nothing empirical — it only makes the analysis
objects legible before any scaling.

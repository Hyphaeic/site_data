# fdrs-gpu-numerics — experiment summary (for review)

**Status:** `cross-checked` (float candidates gated by an exact-rational mirror; ADR-007). GPU work ran
on a real NVIDIA RTX 4060 via CubeCL 0.10 / wgpu; CPU references used NdArray CPU; Burn 0.21.
Correctness-first throughout — **no performance claim anywhere.**

## The defensible claim

> **FDRS is useful as a schedule/layout algebra for GPU numerics:** it can generate deterministic
> sparse/block execution plans that become real GPU kernel contracts. Numerical benefit depends on
> matching the partition to the local reducer; backend floating-point semantics constrain which local
> reducers are portable.

No stronger claim is made. Every numerical *mechanism* used here (pairwise/tree summation, Kahan
compensation, magnitude ordering, online-softmax masking) is **classical**; the contribution is the
plan/partition algebra, the executable spec, determinism, and an experimentally checked
plan→GPU-kernel bridge.

## Result table (one page)

| # | Question | Verdict | Evidence (run) |
|---|---|---|---|
| H1 | fixed FDRS plan ⇒ bit-identical f32 across runs | ✅ | every cell bit-stable, CPU **and** GPU (`cpu-baseline`, `gpu`) |
| H2 | tree/pairwise error ≪ naive | ✅ *(classical)* | ~10× uniform, ~36× cancellation; beats Burn `sum()` (which tracks naive) |
| H3 | **naive** adaptive exponent-bucket tree > fixed tree | ❌ | loses 6/9 cells, worse at scale (the naive within-bucket kernel was the cause) |
| H4 | exact reduction is order-invariant (the gate) | ✅ | `fdrs-tree` theorem tests |
| H6 | binary local ≫ naive local (mechanism) | ✅ | **27×** — H3's loss was the kernel, not the partition (`run2-falsifier`) |
| H5 | partition helps once the local kernel is sane | ✅ *(with structure)* | exp-bucket + Kahan **machine-exact on cancellation** (CPU); no flat kernel matches |
| H7 | sign-split helps cancellation | ❌ *(inverted)* | sign-split is the **worst** method — total loss; wrong partition ≪ no partition |
| M1 | FDRS schedule becomes a real GPU kernel contract | ✅ structural / ❌ compensated | pairwise kernel **bit-matches** CPU ref 5/5; Kahan kernel silently degrades to naive (`gpu-kernel`) |
| M2 | the compensated kernel can be **defended** on GPU | ❌ **(negative, important)** | bitcast + memory barriers both fold to naive; compensation **not portable** here (`gpu-kernel-defended`) |
| M3 | FDRS CSR attention plan drives a real GPU block-attention forward | ✅ **(7/7 criteria)** | dense/local/causal; GPU vs fp64 ~1e-7; deterministic; masks exact (`gpu-attention`) |

## Negative findings (first-class)

- **NEG-1 / H3:** the *naive*-bucketed adaptive tree loses. (Later shown to be a kernel confound, not the partition — H6.)
- **NEG-3 / H7:** sign-split is **catastrophic** on matched-pair cancellation (total loss). A plausible but mismatched partition is worse than none.
- **NEG-4 / M1:** the GPU compiler (CubeCL GVN) folds the Kahan compensation `(t−sum)−y` to 0, silently degrading Kahan→naive. "It ran deterministically" ≠ "it computed what the CPU did."
- **NEG-5 / M2:** the compensation cannot be defended on this backend — bitcast barrier *and* global-memory barrier both fold; `fast_math` doesn't gate the fold; WGSL atomics are integer-only; no volatile/pass-disable API. **Conclusion: on CubeCL 0.10/wgpu, algebraic compensation is not a portable kernel contract — only structural accumulation order is.**

The full fraud gallery (12 tempting-but-wrong spins this work must not be used to support) is in `NEGATIVE.md`.

## Reproduce

```bash
cd source
cargo test                                   # gates: exact mirror (fdrs-tree) + host refs/repro (fdrs-reduce)
./run.sh                                      # CPU: reduction sweep (run 1) + Amendment-1 falsifier (run 2)
./run.sh --gpu                                # + Wgpu reduction pass, and the M1/M2/M3 CubeCL kernels
# (each GPU step skips cleanly and prints {"skipped":true} if no adapter is present)
```
Outputs land in `runs/<date>-*/transcript/` (machine-readable JSON + human summary); each run dir has a
`manifest.yaml` with the provenance triple (config+seed, toolchain, git commit/state) and verdict.
Pre-registration (charters/amendments, hypotheses, acceptance criteria) is in `README.md`, committed
**before** each execution (anti-HARKing); per-result verdicts in `results.md`; negatives in `NEGATIVE.md`.

## What is NOT claimed

- **No speed / performance claim.** No timing harness exists; every kernel is correctness-first (M3 is
  explicitly non-FlashAttention-grade). `runtime_ns` in run 1 is recorded but uninterpreted.
- **No backward pass.** Forward-only attention.
- **No FlashAttention competitiveness** (no tiling / shared-memory / vectorization / multi-head).
- **No generalized proof over all backends.** NEG-5 is specific to CubeCL 0.10 / wgpu; another backend
  with precise-math controls could preserve compensation.
- **No novel numerics.** The accuracy mechanisms are classical (Higham pairwise, Kahan, magnitude order).
- **No claim that exp() matches across devices** — M3's residual GPU-vs-CPU-f32 gap (~1e-7) is the WGSL
  `exp` vs Rust `f32::exp` transcendental difference, documented as such (structural accumulation itself
  is bit-preserved: scale exactly 0.25, QK dots + row max bit-identical).

## Next engineering forks (none started)

1. **Performance path** — tiling, shared-memory tree reductions, vectorization, multi-head, backward. This
   is where a timing harness and (carefully scoped) speed claims would first become appropriate.
2. **Exactness path** — a structural integer superaccumulator (Kulisch-style) — the only route to
   cancellation-exact *on GPU* that survives the optimizer (it's structural, not compensation). Heavy; a
   separate kernel family. Worth it only if "GPU cancellation exactness" becomes a product requirement.
3. **Model-design / adaptive-partition path** — use FDRS to *choose* the partition that matches the data
   (H5/H7): data-dependent block plans for attention/MoE-style routing, with the structural-only rule
   (NEG-5) as a hard constraint. This is the path that most directly extends the model-design question.

# Experiment: Digit-Conditional Activation (Tree-Conditional Periodic Features)

**First HiR FDRS-applied experiment. Charter stage (G0/G1): hypothesis, method, planned evidence recorded.**
**Calibration case for the FDRS experiments workflow (`ADR-007`).**

- **Registry ID:** `experiment-fdrs-digit-conditional-activation`
- **Upstream project:** `project-fdrs-formal` (Phase 11 — digit-conditional signal analysis; `FdrsFormal/Analysis/DigitConditional/`)
- **Program:** `program-variable-representation`
- **Workspace:** `workspace-math-proof-env` (Lean + SageMath) + a zero-dependency Rust runner (std-only; CPU — Burn/GPU deferred, see `results.md`)
- **Owner:** `volition-billy`
- **Scientific status:** **`tested`** (run `2026-06-10-baseline`; H1/H2/H3 confirmed — see `results.md`)
- **Risk class:** low (internal, no external commitment; no IP disclosure; CPU-only)

---

## Motivation

Standard periodic feature maps — Fourier features (Tancik et al. 2020), SIREN — encode an input with a **uniform geometric frequency ladder** (`2^k`). FDRS Phase 11 proves this is the *degenerate* case of a strictly larger class. The **Fourier ceiling** (Theorem 66, `FourierCeiling.lean`) shows that for a digit-conditional target with root-energy fraction α, no single Fourier/Vilenkin mode can capture more than fraction α of the signal energy; the **representation gap** (Theorem 67, `RepresentationGap.lean`) gives an exact count, `Gap = b₀·lcm(rⱼ)/Σrⱼ`, of how many more uniform cells a heterogeneous target costs; and the **orthogonal decomposition** (Theorem 65, `Decomposition.lean`, with machine-checked Parseval) is the basis that is *not* capped.

The proposed activation walks the input down a **non-stationary radix tree** (`Tree.lean`, the interval-partition `RadixTreeNode` representation) and emits, at each node, sin/cos of the within-cell phase at that node's scale — a **branch-dependent frequency ladder** instead of a uniform one. A homogeneous tree collapses it exactly to standard Fourier features (Theorem 69, `SpecialCase.lean`), so the baseline is the degenerate special case and the comparison is clean.

This family is also the **calibration case for `ADR-007`**: it exercises the full exactness ladder (Lean theorem → exact Rust mirror → Burn float experiment), the pre-registered-falsifier discipline, and the scientific-status promotion path, on a low-risk target.

## Hypothesis

1. **H1 (Dose–response):** The advantage of tree-conditional features over uniform Fourier features, at matched feature count and parameter budget, is **monotone increasing in Gap and in 1/α**, on regression of digit-conditional targets. Mechanism: uniform features are capped at energy fraction α per mode (Thm 66) and pay the Gap factor in cell count (Thm 67); tree-adapted features are not.

2. **H2 (Vanishing at the degenerate point):** At `Gap = 1, α = 1` (a homogeneous tree / purely root-periodic target), tree-conditional and uniform features are **statistically indistinguishable** — the advantage vanishes. This is the empirical shadow of Theorem 69 (Vilenkin is the homogeneous special case); a *non*-vanishing advantage here would indicate a confound, not a win.

3. **H3 (Exact-mirror fidelity):** The Rust/Burn `f32` implementation of every Phase-11 quantity (cellMean, nodeLayer, treeBlockProjection, rootPeriodicEnergyFraction, fStatistic) agrees with the exact-rational reference (`fdrs-signal` crate) within stated `f32` tolerance, and the exact reference satisfies the machine-checked theorems as equality tests (Parseval, exact reconstruction, Fourier-ceiling inequality, homogeneous collapse).

## Method

### Exactness ladder (per `ADR-007` §3)

- **Rung 1 — Lean (proven):** Phase 11 theorems already machine-checked in `FdrsFormal/Analysis/DigitConditional/` (Thm 65 Parseval, Thm 66 ceiling, Thm 67 gap arithmetic, Thm 69 collapse). *Honest scope:* `minUniformCells` and `digitConditionalComplexity` are stubbed (`:= N`) and `detectionPowerScaling` proves only positivity — these experiment-side quantities are computed in the mirror, not yet formalized, and are cited as prose Thm + Lean arithmetic lemma, never as fully formalized.
- **Rung 2 — exact mirror (`source/fdrs-signal`, Rust over `num-rational`):** transcribe each Phase-11 definition 1:1 from the Lean source; the proven theorems become the crate's `#[test]` suite (exact equality, no epsilon). Result tag `exact`.
- **Rung 3 — float experiment (`source/fdrs-activation`, Rust + Burn, wgpu):** the activation module + baselines + MLP head + Adam loop. Result tag `float` → `candidate` rank; the Thm 69 collapse is the integration smoke test (homogeneous tree must reproduce uniform Fourier within `f32` tolerance).

### Synthetic generator ((α, Gap) dials)

Depth-2 trees on `[0,1)`: root branching `b₀`, heterogeneous child branchings `(r₁,…,r_{b₀})`. Generate tree-adapted targets by sampling leaf values; mix root-layer vs deep-layer energy to set a measured α (Def 169 mirror); compute `Gap = b₀·lcm(rⱼ)/Σrⱼ` from the prose formula, cross-checked against the Lean inequality (`depth2GapFormula`, `#eval`-able for concrete numbers). Screen each generated target with the transcribed `fStatistic`.

### Feature maps (matched feature count + parameter budget)

- **(i) Uniform Fourier features** — geometric ladder (Tancik). Baseline.
- **(ii) SIREN** — sine layer. Baseline.
- **(iii) Tree-conditional** — fixed tree (from the generator); per-node soft child one-hot ⊗ `[sin(2πk·u), cos(2πk·u)]` at within-cell phase `u`. Fully differentiable in the input; no STE.

A small MLP head over each feature map; identical optimizer; **scientific variable = feature map**; **nuisance variables = learning rate, batch size (re-tuned per arm)**; **fixed = head width, depth, seed set**. Adopt a winner only beyond measured seed variance (≥3 seeds; Tuning-Playbook gate).

### Sweep

(α, Gap) grid from `(1, 1)` outward. CSV out (no Python; `plotters` or raw CSV inspection). Pre-registered prediction curve recorded **before** the sweep runs.

## Expected Evidence (H1/H2/H3 discrimination)

| Observation | Supports |
|---|---|
| Tree-feature advantage rises monotonically as Gap increases (fixed α) | H1 |
| Tree-feature advantage rises monotonically as α decreases (fixed Gap) | H1 |
| At Gap = 1, α = 1, advantage within seed-variance envelope of zero | H2 |
| Homogeneous-tree activation reproduces uniform-Fourier output (`f32` tol) | H2 / H3 |
| `fdrs-signal` exact crate passes Parseval + reconstruction + ceiling + collapse tests | H3 |
| Burn `f32` quantities match exact crate within tolerance on small instances | H3 |

## Falsification Criteria

- **H1 fails if:** the advantage is flat (within seed variance) across the (α, Gap) grid, i.e. no dose–response. This **kills the representational thesis cleanly** — uniform features at matched capacity lose nothing on digit-conditional targets, because a trained MLP recombines many capped modes. A first-class negative result.
- **H2 fails if:** tree features show a significant advantage *at* Gap = 1, α = 1. Indicates a confound (capacity mismatch, optimizer asymmetry, or a generator artifact), not a representational effect — escalate to a method check, not a claim.
- **H3 fails if:** the exact crate violates any Phase-11 theorem-test (transcription bug — fix before any float run is trusted), or the Burn `f32` path diverges from the exact crate beyond tolerance on the collapse case (implementation bug).

Any falsified hypothesis is a scientific result. The family passes regardless of outcome provided the sweep completes, the exact crate's theorem-tests are green, and the runs are reproducible from committed manifests. A flat dose–response (H1 refuted) is recorded as a bounded-completeness negative in `NEGATIVE.md` and promotes the family to `tested`, not failed.

## Promotion path (per `ADR-007` §4)

- If **H1 confirmed**: the confirmed structural claim is the priority formalization target — a real `minUniformCells` (wiring `depth2GapFormula` to actual signal partitions) and the ε₅₀ detection-power scaling become `proof_wanted` declarations under `FdrsFormal/Conjectures/`, counted as empirical debt; the experiment decides whether the proof effort is worth spending.
- If **H1 refuted**: the boundary (the (α, Gap) region where tree structure buys nothing) is documented as the durable output — the dataform's applicability boundary, made operational.

## Protocol Amendment 1 — runs 2–5 (pre-registered 2026-06-11, BEFORE execution)

Run 1 confirmed H1–H3 and surfaced three open threads (`results.md`, `NEGATIVE.md`). Amendment 1
registers the follow-on hypotheses. Committed-to-paper before any of runs 2–5 execute; anything
not stated here is exploratory and will be labeled as such.

### H4 (run 2 — what does the shortfall track?) — the saturation thread

At fixed feature budget D = Σrⱼ and fixed α = 0.5, noiseless: the measured tree-vs-uniform ridge
advantage is **predicted by the analytic uniform-projection shortfall** S(r, target) — the variance
the exact uniform-bin projection of the target fails to explain (computable deterministically,
no fitting) — and **not by the Gap value**.

- Inference criteria (decided in advance): (a) mean absolute error between analytic prediction and
  measured advantage ≤ 0.05 across ≥ 9 r-vectors; (b) |corr(adv, S)| > |corr(adv, log Gap)| (Pearson,
  over r-vectors with Gap > 1); (c) S = 0 exactly on Gap = 1 vectors (threshold consistency).
- Falsifier: MAE > 0.10, or correlation ordering reversed — then the shortfall is NOT projection
  geometry and the saturation anomaly needs a different explanation.
- Design note: r-vectors chosen to spread (Gap, S) — including Gap=1 anchors and high-Gap/varied-S
  pairs; Gap is permutation-invariant so decoupling uses different compositions, not permutations.

### H5 (run 3 — does a trained MLP close the gap?) — the strongest objection

A small trained MLP head (1 hidden layer, width 32, tanh; Adam full-batch; lr ∈ {3e-3, 1e-2, 3e-2}
re-tuned per arm on a validation split — nuisance variable per the Tuning-Playbook discipline) over
**Fourier features** closes part but not all of the linear-readout deficit on digit-conditional
targets: at strong Gap and α ≤ 0.3 (noiseless), MLP-Fourier test-R² remains below linear-tree
test-R² by ≥ 0.05.

- Also run: MLP over tree-leaf and uniform banks (completeness), and MLP over **raw x** (the
  practitioner's default, exploratory arm).
- Inference criteria: deficit(MLP-Fourier vs linear-tree) ≥ 0.05 at (Gap = 17.14, α ∈ {0.1, 0.3}),
  mean over 3 seeds, beyond the seed-variance envelope.
- Falsifier: MLP-Fourier matches linear-tree within seed variance at all (Gap, α) — **this kills the
  activation thesis's motivation** (a trained readout recombines capped modes at no extra cost) and
  the family records it as the headline negative.

### H6 (run 4 — can the tree be learned?) — the given-vs-discovered objection

Greedy 1-D segmentation (CART-style recursive split by max SSE reduction on train data — classical,
claimed as baseline machinery, not FDRS-novel) with a **leaf budget D = Σrⱼ** recovers the
generating partition well enough that its leaf-indicator ridge test-R² is within 0.05 of the
oracle (given-tree) R², for σ ∈ {0, 0.1}, strong Gap, α = 0.5, n_grid = 600.

- Secondary metric: boundary recovery — fraction of true leaf boundaries matched by a learned cut
  within tolerance 1/(2·lcm·b₀).
- Falsifier: learned-tree R² ≥ 0.10 below oracle, or boundary recovery at chance — "tree given, not
  learned" stands as a hard limitation.

### H7 (run 5 — detection-power scaling) — empirically testing the UNFORMALIZED stub

The F-statistic of the true-tree partition (Prop 137 mirror; the Lean `detectionPowerScaling` proves
only positivity — this run generates the data the formalization would need) scales **linearly in
sample count n** at fixed (α, σ): F̄(2n)/F̄(n) ≈ 2 (ratio in [1.6, 2.4]) across n ∈ {150, 300, 600,
1200, 2400}, strong Gap, α = 0.3, σ = 0.5, 5 seeds.

- This is the noncentrality prediction λ ∝ M of the prose Prop 137. Confirmation → the ε₅₀ ~ √(b₀/M)
  claim becomes a well-evidenced `proof_wanted` candidate; refutation → the prose claim is suspect
  and must NOT be promoted.

### Scope guard

Natural-data screening (the synthetic-to-real gap) remains **out of scope** for this amendment —
it requires a dataset-selection decision (human-in-loop, G0-level) and is deferred to a v3 charter.

## Run Configuration

See `run.sh` (to be written at G2). It will:
1. `cargo test -p fdrs-signal` — the exact mirror's theorem-test suite must be green (gate before any float run).
2. Generate the (α, Gap) target families into `runs/<date>/transcript/`.
3. Run the three feature maps × seed set via the Burn runner (wgpu).
4. Emit per-run `manifest.yaml` (config, seed, `git describe --dirty`, `lean-toolchain` + Cargo + GPU, result tag) and CSV outputs.
5. Reduce to `results.md` against the pre-registered prediction curve.

```bash
./run.sh
```

## Scientific Attribution & Provenance

- **Formal basis:** Phase 11 of `docs/fdrs.md` (§11.1–11.9) and `FdrsFormal/Analysis/DigitConditional/` (machine-checked: Thm 65/66/67/69; stubs noted above). Module-by-module status reviewed 2026-06-09.
- **Baselines:** Fourier features — Tancik et al., NeurIPS 2020 (`arXiv:2006.10739`); SIREN — Sitzmann et al., NeurIPS 2020 (`arXiv:2006.09661`). Prior-art check for per-bin/spline-modulated Fourier features pending before any external writeup (G5).
- **Workflow:** `ADR-007` (this family is its calibration case). Exact-mirror discipline, decoration tags, scientific-status ladder per that ADR.
- **Toolchain:** Lean + Mathlib (corpus, pinned by `lean-toolchain`); Rust 1.93; Burn (version pinned at G2 scaffold — API verified against current release before use), wgpu backend.

## Directory Contents (planned)

```
fdrs-digit-conditional-activation/
├── README.md                     ← this charter (G0/G1)
├── run.sh                        ← reproducible runner (written at G2)
├── source/
│   ├── fdrs-signal/              ← exact-rational mirror; theorems as #[test]
│   └── fdrs-activation/          ← Burn runner: generator, 3 feature maps, MLP, Adam
├── runs/
│   └── <date>-baseline/
│       ├── manifest.yaml         ← config · seed · git-hash+dirty · toolchain · GPU · tag
│       ├── transcript/           ← (generator config, target data, run output, witness)
│       └── notes.md
├── results.md                    ← G3 verdict vs pre-registered prediction
├── evidence/                     ← figures/tables backing any promoted claim
└── NEGATIVE.md                   ← bounded-completeness negatives + fraud gallery
```

## Decision Points Ahead

Captured as ADRs if they arise:
- If H1 confirmed with a clean dose–response → ADR recording "digit-conditional activation is a real representational win; formalize `minUniformCells`/DCC."
- If the soft-gate (learned-tree) variant is needed → ADR on reopening the trainability/STE question (deferred in v1).
- If Burn proves an awkward host for later FDRS components (odometer state, certificate-gated commits) → ADR on a bespoke stack vs Burn (flagged for the Certified Update Machine family, not this one).

## Status

- [x] Charter written (this document) — G0/G1
- [x] `fdrs-signal` exact mirror + theorem-tests green (7/7) — G2 rung 2 (the gate)
- [x] `fdrs-activation` runner + Thm 69 collapse smoke test + exact-mirror fidelity test — G2 rung 3
- [x] (α, Gap) dose–response sweep complete (`runs/2026-06-10-baseline/`, 250 runs) — G2
- [x] `results.md` vs pre-registered prediction; `NEGATIVE.md` boundaries — G3
- [x] **Scientific status → `tested`** (H1/H2/H3 confirmed)
- [x] **Amendment 1 pre-registered** (H4–H7, 2026-06-11, before execution)
- [x] Run 2 (H4 shortfall): **CONFIRMED** — advantage tracks analytic projection shortfall S (MAE 0.016, corr 0.95), not Gap; saturation anomaly resolved
- [x] Run 3 (H5 MLP): **CONFIRMED** — trained head closes most of the Fourier gap (0.58→0.92) but ≥0.08 deficit persists at α≤0.3 at 40× params; MLP-uniform unrecoverable (info destroyed)
- [x] Run 4 (H6 learned tree): **NOT CONFIRMED (partial)** — median-case learnable (4/5 seeds, σ=0.1 passes, recovery 83–89% vs 6% chance); worst case is a train-sample identifiability failure, budget-independent (exploratory annex)
- [x] Run 5 (H7 detection): **CONFIRMED** — F ∝ n across 16× range (ratios 1.94–2.08); the unformalized Prop 137 scaling is promotion-eligible
- [ ] Registry entity created (`experiment-fdrs-digit-conditional-activation.yaml`) — `propose`-gated
- [ ] (G4, `propose`-gated) `proof_wanted` debt staged in `FdrsFormal/Conjectures/`, ranked by evidence: (a) S-threshold theorem + S(r,α) bounds [run 2]; (b) ε₅₀/noncentrality scaling [run 5]; (c) information-destruction vs efficiency dichotomy [run 3]
- [ ] (v3 charter, human-in-loop) natural-data F-statistic screen; MLP capacity scaling; lookahead splitters for the run-4 tail

## Results (summary)

Run `2026-06-10-baseline` (250 runs, 5 seeds). All three hypotheses confirmed; no falsification.

- **H1 (dose–response):** advantage over Fourier **strictly monotone in 1/α** (+0.121 at α=0.9 → +0.422 at α=0.1, strong Gap); advantage over uniform **0 at Gap=1, positive for all Gap>1** (threshold form — magnitude saturates ~+0.32–0.40, does *not* scale with Gap value; recorded in `NEGATIVE.md`).
- **H2 (collapse):** advantage over uniform = **+0.0000 ± 0.0000 at Gap=1 for every α** — exact empirical Thm 69. The two baselines fail along orthogonal axes: uniform on heterogeneity (Gap, Thm 67), Fourier on depth (α, Thm 66).
- **H3 (fidelity):** exact mirror passes 7/7 Phase-11 theorem-tests; f64 ↔ exact agree to 1e-12.
- **Honest scope:** the tree win is partly structural (matched basis); the citable content is the dose-dependent baseline shortfall + the exact Gap=1 collapse, *not* a natural-data claim. Linear readout only; tree given not learned. See `results.md` / `NEGATIVE.md`.

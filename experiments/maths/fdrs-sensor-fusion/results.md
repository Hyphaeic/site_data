# Results — Rung 1 (Lean keystone)

**Date:** 2026-06-18 · **Gate:** G2 (rung 1 of 3) · **Result tag:** `proven` (exact, machine-checked)
**Toolchain:** `leanprover/lean4:v4.27.0-rc1`, no Mathlib/Batteries.

## What was verified

`lake build` of `lean/FdrsSensorFusion.lean` completes with **0 errors, 0 sorries**.
The keystone hypotheses H1 (soundness) and H2 (dual-belief coherence) are machine-checked.

### Axiom audit (`#print axioms`)

| Theorem | Claim | Axioms |
|---|---|---|
| `fuse_sound` | two sound readings fuse; result contains the truth | `propext, Classical.choice, Quot.sound` |
| `fuse_refuses_sound` | refusal ⇒ no common point (fault detection is sound) | `propext, Classical.choice, Quot.sound` |
| `fuse_none_iff` | refusal ⟺ genuine inconsistency (exact boundary) | `propext, Classical.choice, Quot.sound` |
| `fuse_length` | fusion = the finer sensor (`max` depth) | `propext, Quot.sound` |
| `condition_support` | soft posterior support ⊆ conditioning cylinder | **none** |
| `condition_two_support` | **hard = support of soft** (the dual link) | `propext` |
| `condition_le` | conditioning never creates mass | **none** |

All within (or below) the FDRS "clean" set `[propext, Classical.choice, Quot.sound]`;
the two purely-combinatorial supports are axiom-free.

### Executable witnesses (`#eval`, static scalar, true state `x* = 0.0110…₂`)

| Expression | Output | Reading |
|---|---|---|
| `fuse sensorA sensorB` (`[0,1]`, `[0,1,1,0]`) | `some [0,1,1,0]` | consistent → fuse to the **finer** cylinder (still contains `x*`) |
| `fuse sensorB sensorA` | `some [0,1,1,0]` | symmetric |
| `fuse sensorA sensorC` (`[0,1]`, `[1,0]`) | `none` | conflict at digit 0 → **refuse** (fault), no hallucinated estimate |
| `condition 1 sensorA [0,1,0,0]` | `1` | cell extends A → mass kept |
| `condition 1 sensorA [1,1,0,0]` | `0` | cell ⊄ A → pruned |
| `condition (condition 1 A) B [0,1,1,0]` | `1` | extends both → in the fused cylinder |
| `condition (condition 1 A) B [0,1,0,0]` | `0` | extends A not B → pruned |

## Honest read

- **Confirmed (Rung 1):** the certified set-membership keystone holds — sound bounded
  sensors always fuse conservatively to the finer cylinder; conflicts are refused, not
  averaged; the soft measure's support is exactly the hard cylinder. This is the
  structural core, and it is exact and axiom-clean.
- **Not yet tested:** everything practical. H3/F1 — the interval→cylinder snapping cost
  at radix boundaries — is **deferred to Rung 2** and is where the direction most
  plausibly dies. Rung 1 *assumes* cylinder readings, which begs exactly that question.
- **Not claimed:** that this beats a Kalman/particle filter (it does a *different*,
  guaranteed-not-optimal job), that set-membership estimation is novel (it is not — see
  README anti-confabulation), or that the "soft" layer is yet a real Bayesian posterior
  (it uses a hard {0,1} likelihood).

## F1 screen (Rung 2 — the make-or-break) — `runs/2026-06-18-f1-screen/`

Exact-rational screen (`source/f1_screen.py`, base 2, N=2000/ε, P=24, seed 20260618)
of how a bounded sensor interval `[m̂−ε, m̂+ε]` costs to represent as cylinder(s).
Metric: overhead = (cover width)/(2ε). Kill criterion: median > 2 under **every** strategy.

| strategy | ε=2⁻⁴ | ε=2⁻⁶ | ε=2⁻⁸ | cost |
|---|---|---|---|---|
| **single** (median / max) | 2.0 / 8 | 2.0 / 32 | **4.0 / 128** | 1 cell — but tail = 1/(2ε), worsens with ε; ~50% >2×, ~12% >10× |
| **union@ε** (median / max) | 1.5 / 1.5 | 1.5 / 1.5 | 1.5 / 1.5 | **≤ 3 cells, ε-independent** |
| **union@2ε** | 2.0 / 2.0 | 2.0 / 2.0 | 2.0 / 2.0 | ≤ 2 cells |
| **redundant K=2,4,8** | 2.0 | 2.0 | 2.0 | overhead ≤ 2.0 at K× memory |

**Verdict: PASS (restricted).** The naive **single-cylinder** hard object **fails**
(catastrophic, precision-worsening tail). But **union-of-cylinders** keeps overhead ≤ 1.5
at ≤ 3 cells *independent of sensor precision* — scale-free, embeddable. F1 does not
refute the thesis; it **restricts the hard belief to a bounded cylinder union**, which is
exactly the **support of the soft measure** already in the Rung-1 toy (`condition_support`).
The dual-belief design absorbs F1. Full record + design consequence in `NEGATIVE.md` (N1).

## Rung 1.5 — the union object, machine-checked (`lean/FdrsSensorFusion.lean`)

F1 said the hard belief must be a bounded cylinder **union**. Rung 1.5 lifts the keystone
to that object and proves the multi-IMU array directly. `lake build` green, axiom-clean.

- `fuseU` — fuse two covers = **intersection of unions** (pairwise `fuse`, finer-or-drop).
- `fuseU_sound` — two sound covers fuse to a cover still containing the truth (keystone, lifted).
- `fuseU_eq_nil_iff` — empty fusion ⟺ genuinely inconsistent covers (exact fault boundary).
- `fuseAll` / `fuseAll_sound` — **certified IMU-array consensus**: every sensor sound ⇒ the
  fused cover contains the true state.
- `coveredBy_fuseU`, `conditionU_fuseU_support` — **dual link, union form**: the soft measure
  conditioned on the fused cover has support ⊆ both inputs — *hard fused cover = soft support.*
- `tally` / `tally_le` — soft vote count (how many sensors cover a cell): the gesture-density
  / graceful-degradation seed.

**Multi-IMU demo** (`#eval`, each IMU a small cover of `[m̂±ε]`): three consistent IMUs fuse
to a tight 2-cell consensus `[[0,1,1,0],[0,1,1,1]]`; an outlier IMU forces strict refusal `[]`
(honest fault); `tally` stays 3 with the outlier present (it abstains, consensus survives).

Axioms: all in the FDRS-clean set `[propext, Classical.choice, Quot.sound]` (`tally_le` only
`propext`). The F1 restriction is now closed in the verified artifact.

*Honest scope:* `fuseAll` is **strict** (all-must-agree → a single outlier refuses). Graceful
*k*-of-*n* consensus is the `tally`/soft direction — demoed, but not yet a fusion *policy* with
its own soundness theorem. That, plus a noise model, is F2.

## F2 — robust k-of-n consensus: brittleness quantified, robustness proven

Strict `fuseAll` refuses on any single outlier. F2 builds and certifies the deployable
robust object. **Two parts, both landed:**

**(a) Lean — `kConsensus_sound`** (`lean/FdrsSensorFusion.lean`, axiom-clean): if a
sub-array `Gs` of sensors are all good (covers contain the truth), there is a cell
containing the truth that *every* one votes for — `tally Gs s = |Gs|`. So **≥ k good
sensors ⇒ a truth-bearing cell with ≥ k votes**, regardless of the other (arbitrary,
adversarial) sensors. The robust estimate (cells with `tally ≥ k`) provably contains the
truth. Via `good_covers_share_cell` (good covers share the *finest* witness, by
ultrametric nesting) + `tally_all`.

**(b) Exact screen — `runs/2026-06-18-f2-consensus/`** (exact binomial): the cost of
strict all-must-agree vs majority consensus, under each sensor independently a disjoint
outlier w.p. `p`.

| | strict refuse (any outlier) | majority k-consensus retain |
|---|---|---|
| n=3, p=0.1 | 27.1% | 97.2% |
| n=5, p=0.1 | 41.0% | 99.1% |
| n=7, p=0.1 | **52.2%** | **99.7%** |

**Strict refusal RISES with sensor count** (more sensors ⇒ more likely an outlier vetoes —
all-must-agree gets *worse* the more you add); **majority consensus retention stays ≳99%
and RISES with n** (more votes ⇒ more robust). The k-of-n object is the deployable one, and
`kConsensus_sound` certifies its truth-containment.

## Rung 3 — dynamics: recursive filter soundness + drift-filter vs Kalman

Static fusion becomes a *filter*. Pre-registered hypotheses (README §Rung 3 charter, before
execution); both rungs landed.

**(a) Lean proof rung — `runFilter_sound`** (`lean/FdrsSensorFusion.lean`, axiom-clean):
predict (push cover through a prefix-map motion `φ`) then update (`fuseU`) preserves
truth-in-cover; **iterated, the belief cover contains the moved true state at every step**,
given a sound motion model and sound measurements. With `predictU_sound`, `filterStep_sound`,
the uncertainty-growth instance `predictCoarsen_sound`, and `isPrefix_take`/`agree_coarsen`.
**H-R3a ✓** (and non-vacuous: the coarsening filter `#eval`-runs — predict drops the deepest
digit, a measurement re-sharpens).

**(b) Exact screen — `runs/2026-06-18-r3-filter/`**: FDRS cover-filter (exact rational) vs
textbook Kalman (float baseline) on a drifting scalar; M=5 sensors, k=3, fraction `q` gross
outliers.

| q (outlier) | FDRS contain | KF contain | FDRS width | KF width |
|---|---|---|---|---|
| 0.0 (clean) | **100.0%** | 94.1% | 0.0275 | 0.0106 |
| 0.1 | 99.2% | 27.7% | 0.0234 | 0.0106 |
| 0.2 | 94.4% | 13.4% | 0.0196 | 0.0106 |
| 0.3 | 84.4% | 8.1% | 0.0162 | 0.0106 |

- **H-R3b ✓** — clean: FDRS 100% containment, width bounded (0.0275 ≪ 1). (KF 94.1% = correct ±2σ.)
- **H-R3c ✓ (strong)** — outliers: FDRS containment ≫ KF, margin growing with `q` (84% vs **8%**
  at q=0.3); FDRS wider (2.6×). Vanilla KF collapses (no outlier rejection); FDRS k-consensus is
  robust *by construction* (`kConsensus_sound`).
- **H-R3d ✓** — the whole-line prior is pinned to ~0.02 by the first update; width tracks fusion.

**Honest scope (pre-registered + `NEGATIVE.md` N2/fraud gallery):** in the **clean** regime KF is
*better* (tighter, optimal) — FDRS's conservatism is not a win there. FDRS's edge is **robustness
under bound-violation**, and it is large. FDRS containment **degrades gently** under heavy outliers
(needs ≥k good sensors — the F2 boundary). A first run with a *reflecting* drift but a constant-`+V`
predict dropped FDRS to 89.9% / KF to 69.7% — empirically **vindicating** the Lean `hmove`
hypothesis (predict must track the motion); recorded as N2, not hidden. The vanilla-KF baseline is
weak under outliers; a gated/robust KF would close part of the gap.

**Scientific status → `tested`** (H-R3a/b/c/d resolved; H-R3c is the headline robustness result).

## Rung 4 — async routing / the fusion control surface

The multi-timeline async structure becomes the engineering substrate: sensors as independent
timelines, fusion as junction injection. The property that makes the control surface
well-defined — **async injection is confluent** (order-independent) — is proven; the screen
runs a heterogeneous-rate network and confirms operation. Pre-registered (README §Rung 4 charter).

**(a) Lean proof rung** (`lean/FdrsSensorFusion.lean`, axiom-clean):
- `agreeU_fuseAll_iff` — the fused belief = **intersection of all delivered covers** (the
  characterization that makes confluence immediate).
- **`fuseAll_confluent` / `tally_perm` (H-R4a)** — fused belief and consensus vote are invariant
  under injection order. *The async control surface is well-defined.*
- `routedStep` + **`routedStep_confluent` / `routedStep_sound` (H-R4a/b)** — the control-surface
  step (predict then fuse the due round): order-independent and truth-preserving.
- `Sensor`/`due`/`roundAt`/`runRouted` — the multi-rate scheduling abstraction; **`due_mul`
  (H-R4d)** — a period-p sensor fires at every multiple ⇒ staleness ≤ p.

**(b) Exact screen — `runs/2026-06-18-r4-routing/`** (heterogeneous network: 3 fast period-1 +
2 slow period-4 sensors):

| q (outlier) | containment | width | confluence mismatches | max staleness |
|---|---|---|---|---|
| 0.0 | **100.0%** | 0.0272 | **0** | 3 ≤ 4 |
| 0.2 | 90.6% | 0.0201 | 0 | 3 ≤ 4 |
| 0.3 | 80.5% | 0.0175 | 0 | 3 ≤ 4 |

- **H-R4c ✓** — multi-rate network keeps truth in belief (100% clean, graceful F2-style
  degradation under outliers); **0 confluence mismatches** across all runs (regression-confirms
  the proven order-independence).
- **H-R4d ✓** — max staleness 3 ≤ slow period 4.

**Honest scope (`NEGATIVE.md` Rung-4):** the "0 mismatches" is a *regression guard* (Python set
ops are order-free by construction) — the guarantee is the Lean theorem, not the screen.
Deadlock-freedom + worst-case composite latency are inherited from Phase 8 (Thm 52/53), not
re-proven; our star topology is trivially acyclic. Containment degradation under outliers is the
F2 boundary (≥k good per round).

**Scientific status stays `tested`.** The control-surface abstraction (the engineering API the
control plane targets) is defined and its load-bearing property (confluence) is certified.

## Rung 5 — the digit-forcing bridge: interval → cover → forced digit

**Date:** 2026-06-20 · **Result tag:** `proven` (exact, machine-checked).

The bridge from a fused set-membership belief to a **certified forced digit** — the connective
tissue for the frieren proprioceptive-node direction (each channel's belief → a resolution-tagged
digit; a node co-registers the channels). A channel's fused `Cover` forces exactly the digits on
which *every* surviving cell agrees; the rest is refused — the union-belief analogue of certified
emission (`emit_traps`): emit the agreed prefix, stop at the first divergence.

**(a) Lean proof rung** (`lean/FdrsSensorFusion.lean`, build green, 0 sorries):

- **`force_sound`** — `AgreeU U x → Agree (forcedDigit U) x`, where `forcedDigit U = lcp U`
  (longest common prefix of the cover): the truth agrees with the forced digit. *Two lines on the
  existing `agree_of_isPrefix`*, via `lcp_isPrefix_mem` (the LCP is a prefix of every cell — the
  forced digit is genuinely common) over a small `lcp`/`lcpAux`/`commonPrefix` tower.
- **`cover_of` / `cover_of_interval_sound`** — the integer quantizer (the F1 op): an integer
  interval `[lo,hi]` ↦ the depth-`d` cells of its values. **Soundness is constructive and by
  construction** — every value's own cell is in the cover and its stream agrees with it
  (`streamPrefix_agree`), for **any** depth `d`. The proof *never unfolds the base-`b` digits*: it
  is encoder-agnostic.
- **`forced_of_interval_sound`** — the end-to-end bridge (`force_sound ∘ cover_of_interval_sound`):
  truth in `[lo,hi]` ⇒ its stream agrees with the forced digit of the interval's cover.
  Quantize-then-force: a noisy integer bound becomes a certified, resolution-tagged digit.

**Forced-digit witnesses** (`#eval`, base 2, width 4 — the prefix DEPTH = certifiable resolution):

| Expression | Output | Reading |
|---|---|---|
| `lcp (cover_of 4 2 4 6 6)` | `[0,1,1,0]` | tight (single value) → **depth 4**, fully resolved |
| `lcp (cover_of 4 2 4 6 7)` | `[0,1,1]` | adjacent pair → **depth 3** (4th digit undetermined — honestly coarser) |
| `lcp (cover_of 4 2 4 7 8)` | `[]` | width-1 interval **straddling the midpoint seam** → **depth 0**: the F1 catastrophe, mechanized — and honest (could be 7 or 8) |

**Axioms:** `cover_of_interval_sound` is **fully constructive** (`[propext, Quot.sound]`, like
`agree_of_isPrefix`); `force_sound` / `forced_of_interval_sound` carry
`[propext, Classical.choice, Quot.sound]` — the toy's standard soundness set
(= `fuse_sound`, `fuseU_sound`, `kConsensus_sound`, `runFilter_sound`).

**Honest scope.** The forced digit `= lcp(cover)` is the *deepest commonly-agreed prefix*; it goes
coarse exactly when the cover straddles a quantization seam — the certified "too close to call," not
confabulation. Two things kept **separate**: *soundness* (proven here, any `d`) vs the *≤3-cell cost*
(the F1 screen, empirical — choose `d ≈` the interval width). No novelty is claimed: the cylinder/LCP
forcing is the toy's `fuse_length`/`agree_of_isPrefix` re-expressed in forcing language (cf
`NOVELTY.md`); `cover_of_interval_sound` is the from-scratch F1-quantizer lemma, which does **not**
borrow `condition_support` (the orthogonal soft-support direction). Downstream: each frieren channel's
fused interval → `cover_of` → forced digit, co-registered into a proprioceptive node; the runtime
migration target is `fusion-core::Cover` (integer, multi-run — it keeps the bimodality a single hull
smears).

## Novelty audit — done (see [`NOVELTY.md`](NOVELTY.md))

Adversarial deep-research audit (2026-06-18). **Verdict: algorithmic content is classical** — k-of-n
interval consensus **is Marzullo (1984/1990)** + Brooks–Iyengar; set-membership filter **is Schweppe
(1968)** / Kieffer–Jaulin–Walter; single strongest threat **Rushby (SRI, 2002)** already
machine-checked Marzullo-fusion soundness + fault detection in PVS. Only the *composed* Lean-4 stack
is narrowly unoccupied = connection + curation + verified artifact, **not new math**. Frame on
engineering value; cite Rushby/Marzullo/Schweppe. Full map + must-cite/must-not-claim in `NOVELTY.md`.

## Engineering integration — the embeddable control surface (`source/rust/`)

The verified surface is now runnable + embeddable. Rust workspace: `fusion-core` (`#![no_std]`,
0 deps, integer-only) + `fusion-demo` (closed control loop). Run `runs/2026-06-18-engineering-rust/`.

- **E1 (fidelity) ✓** — 7/7 `#[test]`s: the Lean theorems re-checked as runtime assertions (fuse
  contains truth, conflict ⇒ refuse, k-consensus tolerates outliers, **confluence** under shuffle,
  predict-then-fuse keeps truth, saturation ⇒ fault) **plus a fidelity vector matching the Lean
  `fuseAll` result** (the multi-IMU demo mapped to cells → consensus `[6,7]`).
- **E2 (embeddable) ✓** — `#![no_std]`, integer-only (no float), heap-free (`≤RUNS=8` interval-runs),
  **zero dependencies**; clean release build. Belief = a handful of integers (Marzullo's interval form).
- **E3 (actionable) ✓** — a closed 1-D control loop regulates the plant **80→300 using only the
  certified estimate** `(point ± half_width, fault)`, final |err|=1. Live at t=17: outliers broke the
  k-consensus → **fault fired → controller HELD** (didn't act on a bad estimate) → re-acquired t=18.
  *Certified-refusal driving safe control, not just a theorem.*

**Honest scope:** fidelity is *tested, not proven* (the proof is the Lean); fixed-capacity overflow
saturates → fault (`NEGATIVE.md`); host-built `no_std` (bare-metal target link is the next step); the
algorithm is classical Marzullo/Schweppe (`NOVELTY.md`) — this is the deployable artifact, not a claim.

## Probes — viability of ignored FDRS machinery (`runs/2026-06-18-probes/`)

Exact screens asking whether Tier-1 corpus machinery we did *not* use is worth adopting. A clean
viability map (experiments, not production):

| Probe (FDRS machinery) | Result | Verdict |
|---|---|---|
| **P-A** designed/adaptive resolution (Ph 6/7) | F1 straddle is a *coarse-fixed-grid* artefact; interval-runs (already in the Rust core) get overhead 1 at 2 ints; finer grids trade overhead for cells (ε/8 → 1.06× at 17 cells) | **don't invest** — engineering already at the good point |
| **P-B** graded disagreement (Ph 14 `netDist`) | binary empty-fusion fault is **blind** at 1–2 outliers (rate 0.00); graded hull-spread rises 1.7→9.5→14.3→17.2, detecting degradation at the *first* outlier | **ADOPT** — the near-term win |
| **P-C** multi-resolution belief (Ph 2 MRA) | multi-res 0.9× (worse) at d=1; 7× / 73× / 819× at d=2/3/4 | **defer** until state is multi-dimensional (SE(2)/SE(3)) |
| **P-D** real routing (Ph 8 `Composition/`) | out-of-order already covered by confluence (1000 shuffles invariant) | **defer** until dynamic/networked sensors |

**One adopt, two invest-WHEN triggers, one deflation.** The single thing worth doing soon is a
**graded sensor-disagreement health score** (P-B) — it strictly dominates the binary fault. The
rest have clear conditions (add dimensions → MRA; dynamic sensors → Composition) or are already
solved (P-A). Honest caveats in `NEGATIVE.md` (interval-runs lose the cylinder structure; the
netDist proxy; the MRA scaling sketch).

### P-B adopted — graded disagreement (Lean + Rust + demo)

The one near-term win is in. **Lean** (`FdrsSensorFusion.lean`, axiom-clean): `dissent Us cell =
n − tally`, with `dissent_perm` (order-independent, like the vote) and `dissent_le_iff_tally_ge` —
the binary k-consensus is *exactly* the bounded-dissent region, i.e. the threshold is the graded
score read at one cut. **Rust** (`fusion-core`): `Cover::max_agreement` (Marzullo's agreement count)
+ an `Estimate.dissent` field (`n − max_agreement`), wired through `Estimator::step`; `no_std`-clean,
8/8 tests (added `dissent_grades_outliers_before_fault`). **Demo**: the loop now shows a `dis` column
and the controller holds on high dissent — at **t=8→9**, `dis=3` triggers "sensors disagree → hold"
*while `fault` is still clear* (the graded signal caught degradation the binary fault missed),
distinct from the full fault at t=17. Exactly the P-B value, now actionable.

## Next

- **frieren proprioception (downstream consumer of Rung 5):** migrate frieren's belief core
  (`~/HiR/Projects/frieren`, separate repo) from f32 `Interval` + single-hull `consensus` onto
  `fusion-core::Cover` (integer, multi-run), then wire each channel's fused interval → `cover_of` →
  forced digit → co-registered proprioceptive node. Rung 5 is the fdrs-side half (landed); the
  migration lands on its pinned `cover_of` definition once frieren's `perception` files are quiescent.
- **Bare-metal target**: add a `#[panic_handler]` + a thumb (`thumbv7em-none-eabi`) build of
  `fusion-core`; measure the actual core `.text` size on an MCU; a C FFI shim for RTOS firmware.
- **2-D / SE(2) pose** (the geometry question deferred since F1): per-axis interval-runs vs a genuine
  box/zonotope cover; re-test the F1 straddle cost in 2-D.
- *(Optional formal):* drift-as-prefix-map via the FDRS `⊕` arithmetic layer (true translational
  predict in Lean); the union-cover bound as `proof_wanted`; bridge to corpus Phase-8 `Composition/`
  for compile-time deadlock/latency on richer routing topologies.

---

## Line B — Native Ultrametric Observer Fusion

**Status: THREE RUNS LANDED (all tag `exact`). (1) First screen `2026-06-30-lineb-screen`
— H-B1…H-B6 survive (6/6). (2) Scale diagnostic `2026-06-30-lineb-scale` — H-B2 RETIRED to a
secondary diagnostic per §0.5 (octree-as-yardstick). (3) THE deliverable `2026-06-30-lineb-selection`
(Sage) — the `Selection` formalized, H-B7 PASS (W/S/P/R/F), F-B7 does not fire. G2 executed;
G3 verdicts in the ledger below. Headline deliverable = the generalized Selection exists, is sound,
and faithfully represents the §0.5 voxel example — existence+faithfulness, not economy.**

Per `ADR-007`, no results precede the protocol. The pre-registration boundary is fixed
(and predates this run — the charter `LINE-B.md` / `NEGATIVE.md` falsifiers were written
first; nothing here altered an H-B*/F-B*):

- **Hypotheses pre-registered** (`LINE-B.md` §5): H-B1 (non-degenerate representation) · H-B2
  (embodiment controls branches) · H-B3 (cleaner refusal) · H-B4 (LCP keeps control resolution) ·
  H-B5 (`Ω` concrete/cheap/deterministic) · H-B6 (substrate-first, no float authority).
- **Falsifiers + fraud gallery pre-registered** (`NEGATIVE.md`): F-B1…F-B6 + the hyperbolic-as-substrate,
  abolish-octrees, new-math, combinatorial-magic, base-0-as-radix traps.
- **Grounding fixed** (`LINE-B.md` §2): `Ω`/`RadixLaw` (Phase 7), `RadixSeq`, `netDist` (Thm 92),
  scalar-trace no-go (Thm 91), synthetic place complex (Phase 14), base-0 sea, the Rung-5 toy
  `cover_of`/`lcp`/`force_sound`/`fuseU`/`dissent`.
- **First screen designed** (`LINE-B.md` §6): a 4-line toy embodied agent (intent · motor · contact ·
  range) with a concrete `Ω`/coupling table; measurements tied 1:1 to H-B1…H-B4 + H-B6; SageMath exact,
  no floats on the control path.

**Tooling note (transparent reconciliation).** The charter (§6) pre-registered "SageMath
exact"; the screen (`source/lineb_screen.py`) is implemented in **exact-integer Python
stdlib, zero deps** — matching the family's established F1–R4/probes convention and the
`run.sh` harness. Line B's math is integer prefix arithmetic + a coupling table + LCP
search; it needs no number field or tensor, so stdlib `int` is exactly exact. The
exactness-ladder tag is unchanged: `exact` (no float on the control path — that is M6).

### Verdict ledger (filled at G3, one row per screen)

Run `2026-06-30-lineb-screen` · `source/lineb_screen.py` · tag `exact` · Python 3.14.5, stdlib only.

| Screen | Run | Tag | Pre-registered prediction | Outcome | Status |
|---|---|---|---|---|---|
| degeneracy | `2026-06-30-lineb-screen` | exact | coupled belief distinguishes a state the interval cover cannot (H-B1) | states (Explore,fwd,clear,far) / (…,bump,far) share one Line-A position cover but split in the coupled belief (one admissible, one refused) | **H-B1 PASS** (non-degeneracy; necessary, not the win) |
| branch count | `2026-06-30-lineb-screen` | exact | `Ω`-admitted branches grow slower than octree/interval cells (H-B2) | `Ω`-admitted = 7 vs pre-generated octree = 96 (F-B2 does not fire); embodiment prunes 2 branches beyond a blind lazy octree (9→7) | **H-B2 PASS** (F-B2 clears; toy caveat: most of the gap is lazy-vs-eager — see scale rung below) |
| branch count (scale) — **SECONDARY DIAGNOSTIC** (H-B2 RETIRED per LINE-B §0.5; octree-as-yardstick is the trap, not the win) | `2026-06-30-lineb-scale` | exact | *[retired framing]* the coupling reduces branching entropy vs a uniform octree at scale (F-B2 sharpened: fires iff λ ≥ b) | coupling = subshift of finite type; `Ω`-admitted world grows as λ^D with **λ_Explore ≈ 4.562 < b = 6** (saving (b/λ)^D ≈ 1.315^D, 1.2×→24× over D=1..12); Survive Ω-collapse → **λ′ = φ² ≈ 2.618 < 4** (counts = even-indexed Fibonacci → golden-mean shift, Phase 13.5); **no-coupling control λ = b makes F-B2 fire** (test can fail); off-manifold tail grows 12→322 | **F-B2 does not fire, BUT this is NOT the deliverable** — it measures *coupling* economy on a *uniform*-base cell (no heterogeneity), keeping the octree as frame (LINE-B §0.5 / F-B7 fraud entry). The make-or-break moved to **H-B7 (the `Selection`)**, tested in Rung B-2. Kept as an archived diagnostic. |
| refusal map | `2026-06-30-lineb-screen` | exact | cleaner refusal boundary than Line-A consensus (H-B3) | coupled: 0 false-accept / 0 false-refusal; Line-A: 1 false-accept (cross-modality fwd+bump+open) + 1 false-refusal (base-2 seam straddle) | **H-B3 PASS** (the headline engineering win) |
| LCP resolution | `2026-06-30-lineb-screen` | exact | admissible transition survives each ascend (H-B4) | both conflicts ascend to a non-empty admissible motor set {turn_left, turn_right, halt} | **H-B4 PASS** |
| Ω specification | `2026-06-30-lineb-screen` | exact | `Ω` is concrete/cheap/deterministic exact-integer (H-B5) | finite table, O(1)/call, deterministic, integer bases≥2 or inert `SubstrateZero`, CSU(sibling-uniform) holds | **H-B5 PASS** |
| substrate audit | `2026-06-30-lineb-screen` | exact | no float on the control path; rendering read-only (H-B6) | every control-path value is `int`; no float; no Poincaré/hyperbolic rendering layer present | **H-B6 PASS** |
| **`Selection` formalization (Rung B-2) — THE deliverable** | `2026-06-30-lineb-selection` | exact (Sage) | the generalized Selection mechanism is **defined, well-formed, filtration-sound, projection-commuting, and faithfully represents the §0.5 voxel example without special-casing** (H-B7); need NOT beat a uniform tree | **W** valid cover ∀t · **S** conditioning only removes (365→315→155→93, ⊆; `condition_le` echo) · **P** fibered π_B commutes for base *and* cross-modality updates, forgetful voxel-shadow fails (31-voxel residual = Phase-6 Thm 42 implicate payload) · **R** refusal = empty selection · **F** arbitrary no-closed-form voxel shape, live (Sel₀≠Sel₁), temporal (Sel₀=Sel₆), cross-dim reshape (Explore 73 vs Survive 63), ONE general rule · headline: wall = 0-voxel coupling invariant vs octree's 50-voxel neighbourhood · heterogeneity {2,3,4,5,16}, lcm 240 | **H-B7 PASS** — the Selection EXISTS as one general, sound, faithful structure; F-B7 does not fire. Existence+faithfulness, **not** economy; no new math; **Lean rung now LANDED (row below)** |
| **`Selection` Lean rung + Rust mirror** | `2026-06-30-lineb-lean-rust` | proven (Lean) + exact (Rust) | the Selection's W/S/P/R are machine-checked (0 sorries, axiom-clean) and mirrored in embeddable Rust (H-B7 proof rung; closes N-B4 for the Selection) | **Lean** `lean/FdrsSelection.lean` (imports the toy, Mathlib-free): `select_wellformed` (W) · `condition_le`/`condition_subset` (S) · `projection_commute` (P) · `refusal_empty` (R) — all `[propext]`; + `baseOpt_ge_two` (PlaceKind, obj 1), `decodeMR_encodeMR` (codec round-trip, obj 2, `[propext, Quot.sound]`), `multiline_force_sound` (obj 6). **Rust** `source/rust/selection-core` (`no_std`, zero deps, additive per §7): PlaceKind/`encode_mixed_digits`/Selection/project; **7/7 E1 fidelity tests** each re-checking a Lean theorem (incl. the Phase-6 Thm 42 forgetful-shadow residual) | **H-B7 proof rung LANDED** — axiom-clean Lean + fidelity-tested `no_std` Rust; N-B4 closed for the Selection (faithfulness-for-all-fields + corpus port remain, N-B7) |
| **Selection visualizer** (engineering artifact) | `2026-06-30-lineb-visualizer` | exact (read-only view, H-B6) | a watchable terminal demo of the live Selection, driven by the verified ops (not a re-implementation) | `source/rust/selection-demo` (std bin, path-dep on `selection-core`, zero external deps): renders a 3-D voxel field's selection over time via `select`/`condition`/`project_shadow`. Shows the living fabric (flows, period W), cross-dim filter (Explore 225 vs Survive 129 cells), filtration-soundness (a base-measurable conditioning shrinks 129→70), refusal=empty, and the forgetful-shadow residual (`*`). `--animate` = ANSI live; `--report` = deterministic transcript (byte-for-byte reproducible) | **LANDED** — the Selection is now watchable; rendering holds no control authority (H-B6). Demonstrates, does not prove |

### Promotion staging (filled as claims confirm)

- Artifact-control lemmas (provable now, deposit independent of any screen): `PlaceKind`
  well-formedness, `encode_mixed_digits` correctness, the lifted `force_sound`.
- Empirical `conjecture` candidates (only on confirmation): the coupling refusal/forcing soundness
  (H-B1/H-B3) and the branch-economy result (H-B2).

_The exact screen is now **green** (6/6, tag `exact`); the run transcript is written
(`runs/2026-06-30-lineb-screen/`) but **not yet committed**. Per `ADR-007`, a Line-B claim
reaches `registered` only once that transcript is committed — and the charter/protocol
(`LINE-B.md`, `NEGATIVE.md`) must be committed **first** (protocol-before-results gate;
all three are currently untracked). Line A's `tested` status is unaffected — demoted to
baseline/adapter, not refuted. Nothing pushed (charter discipline; AI does not commit/push)._

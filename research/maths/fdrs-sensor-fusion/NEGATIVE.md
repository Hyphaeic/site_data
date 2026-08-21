# Negative results & boundaries — FDRS sensor fusion

Per ADR-007 §5: negatives recorded as bounded-completeness statements + a "fraud
gallery" of things that look like wins but are not (yet). Archive-never-delete.

## Bounded-completeness negatives

### N1 — The single-cylinder hard belief is NOT viable for Euclidean intervals (run 2026-06-18-f1-screen)

A bounded sensor reading `[m̂−ε, m̂+ε]` represented as the smallest **single** cylinder
containing it has catastrophic cover overhead when the interval straddles a shallow
radix boundary. Exact-rational screen (base 2, N=2000/ε, P=24, seed 20260618):

| ε | single-cyl median | p95 | max | frac >2× | frac >10× |
|---|---|---|---|---|---|
| 2⁻⁴ | 2.0 | 8.0 | 8.0 | 0.427 | 0.000 |
| 2⁻⁶ | 2.0 | 16.0 | 32.0 | 0.480 | 0.096 |
| 2⁻⁸ | 4.0 | 32.0 | 128.0 | 0.500 | 0.116 |

The worst case is exactly `1/(2ε)` (the whole line), and it **worsens as the sensor gets
more precise** — the opposite of what you want. ~half of all readings exceed 2× overhead.
**The single-cylinder object fails F1.** This is the ultrametric-vs-Euclidean mismatch,
made quantitative: a totally-disconnected ultrametric grid cannot cheaply bound a
connected Euclidean interval that happens to span a grid seam.

**This does not kill the thesis** — it kills the *single-cylinder* representation. The
**union-of-cylinders** representation passes cleanly (overhead ≤ 1.5, ≤ 3 cells,
*independent of ε*), and redundant offset charts cap overhead at 2.0 (K× memory).

### Design consequence (the durable output of N1)

The hard belief must be a **bounded cylinder union**, not a single cylinder. Crucially,
a cylinder union is exactly the **support of the soft measure** already carried in the
Rung-1 Lean toy (`condition` distributes mass over cells; `condition_support` bounds the
support). The dual-belief design absorbs F1 at no conceptual cost: *the hard object is
the soft support.* Rung 1.5 = generalise `fuse` / soundness from single cylinders to
unions and re-prove the keystone.

## Fraud gallery (apparent wins that are not claims)

- **"union-cover overhead 1.5 / 3 cells" is not free.** It is bounded and ε-independent,
  but it is a cost: every sensor reading now occupies ~3 cells, fusion is
  intersection-of-unions (not the trivial nesting of the single-cylinder toy), and the
  certified-emission "forced digit" only fires once the fused union collapses to cells
  sharing a prefix — i.e. the engine is *honestly uncertain near a decision boundary*,
  which is correct behaviour but is NOT the clean single-cylinder fusion of Rung 1.
- **The measurement-centred chart trivially gives overhead 1** (centre a depth-`e` cell
  on the reading `m̂`), but it moves the entire cost onto Phase-5.3 **recharting**: every
  reading lives in its own chart and fusion across charts needs the rechart protocol.
  Not a free win — a relocation of the cost. Untested.
- **`fuse_sound` / refusal are not yet about noise.** Rung 1 proves soundness for
  cylinder readings under the bounded-error model. It says nothing about Gaussian noise,
  statistical optimality, or how often real sensors violate their bound (→ spurious
  refusal). [F2 since tested — `runs/2026-06-18-f2-consensus/`; spurious-refusal quantified.]

## Rung 3 — dynamics (run 2026-06-18-r3-filter)

### N2 — a mis-specified motion model breaks containment (vindicates the Lean `hmove` hypothesis)

A first R3 run used a **reflecting** drift (velocity flips at band edges) while both filters'
predict assumed constant `+V`. The drift-sign mismatch dropped FDRS clean containment to
**89.9%** and Kalman to **69.7%** (q=0). This is not a filter bug — it is the predict step
violating the soundness hypothesis `hmove` (predict must track the true motion), exactly the
premise of `runFilter_sound`. Recorded as a finding: **the FDRS filter's guarantee is
conditional on a sound motion model; an unmodelled manoeuvre voids containment** — as the
theorem says. The reported run uses a soundly-modelled constant drift.

### Fraud gallery (Rung 3)

- **Clean-regime containment is NOT an FDRS win.** At q=0, FDRS contains truth 100% vs KF
  94%, but FDRS is **2.6× wider** (0.0275 vs 0.0106) and KF's 94% is the correct ±2σ
  calibration. KF is *better* (tighter, optimal) in the clean Gaussian regime — as
  pre-registered. Do not cite clean containment as an advantage.
- **Vanilla Kalman is a weak baseline under outliers.** This KF has NO outlier gating, so it
  collapses (8% at q=0.3). A robust/gated KF (Mahalanobis rejection, Huber, IMM) would
  recover much of the gap. The honest claim: FDRS k-consensus is robust *by construction*
  (no tuning, certified by `kConsensus_sound`), not that KF *cannot* be made robust.
- **FDRS containment is not 100% under outliers.** It degrades 100→99→94→84% as q→0.3 because
  at high outlier rates some steps have <k good sensors (the F2 boundary). Graceful, not a
  hard guarantee — honest scope, not a refutation.
- **FDRS width shrinking with q is an artefact, not precision.** Width drops 0.0275→0.0162 as
  q rises because more outliers trigger more consensus re-acquires to the tight good-cluster,
  resetting the predict-dilation accumulation. A side-effect of the fault-recovery rule.
- **Real translational drift is not yet in Lean.** The screen does true drift numerically;
  the Lean rung proves the filter *structure* + the coarsening (uncertainty-growth) instance.
  Drift-as-prefix-map needs the FDRS `⊕` arithmetic layer — deferred, flagged.

## Rung 4 — async routing (run 2026-06-18-r4-routing)

### Fraud gallery (Rung 4)

- **Confluence "0 mismatches" is a regression guard, NOT independent evidence.** The screen
  fuses via Python set / `Counter` operations, which are order-free *by construction* — so 0
  mismatches confirms the implementation carries no hidden order-dependence, but it does not
  independently establish confluence. The guarantee is the Lean theorem (`fuseAll_confluent`,
  `tally_perm`); the check would only ever catch a bug that *introduced* ordering.
- **Containment degrades under outliers (90.6% / 80.5% at q=0.2/0.3).** The same F2 boundary —
  a round needs ≥k good sensors. With multi-rate the round size varies (3 fast, +2 slow every
  4 ticks), so the consensus threshold and robustness vary across ticks. Honest scope,
  consistent with R3/F2; not a new result.
- **Deadlock-freedom + worst-case composite latency are NOT re-proven here.** They are corpus
  results (Phase 8 Thm 52/53, `FdrsFormal/Composition/`). Our star topology is trivially
  acyclic and single-junction; a richer routing graph (multi-hop, cycles, spawn/terminate)
  would need the corpus machinery. We cite, not re-derive.
- **Staleness ≤ period is structural, not a discovery.** A period-p sensor injects exactly at
  multiples of p (`due_mul`), so the gap is p by construction; the screen's max staleness =
  p−1 is bookkeeping confirming the model, not an empirical finding.

## Engineering integration — Rust mirror (run 2026-06-18-engineering-rust)

- **Fidelity is TESTED, not proven.** `fusion-core` is the exact mirror; 7 `#[test]`s re-check the
  Lean theorems on cases (+ one Lean fidelity vector), but there is **no machine-checked proof that
  the Rust matches the Lean** — a transcription bug could pass the tests. The guarantees live in the
  Lean; the Rust inherits them only by fidelity. Do not call the Rust "verified."
- **Fixed-capacity is a real failure mode.** `RUNS=8` / `MAX_SENSORS=16`: a belief fragmenting into
  >8 disjoint runs **saturates** — drops runs and flags fault. Safe (fault, not a silent wrong
  answer) but pathological disagreement can blank the estimate (observed at demo t=17).
- **The estimate is the HULL, not the exact set.** `estimate()` returns the convex hull (min..max) of
  the belief runs, so point/half_width can be **looser** than the exact union (a disconnected belief
  is reported as one wide bracket). Faithful to Marzullo's `[l,h]`, conservative vs the Lean cell-set.
- **`no_std` is host-built, not bare-metal-linked.** `cargo build -p fusion-core` proves the *source*
  is `no_std`-clean, but no `#[panic_handler]` / embedded target was linked; actual MCU `.text` size
  and real-time timing are unmeasured. The 360 KB figure is the *std demo binary* (with formatting),
  NOT the core.
- **The demo is a smoke test, not a benchmark.** One LCG seed, hand-picked params; it shows the loop
  closes and faults are handled, not statistical performance (that is R3/R4).
- **Algorithm is classical (Marzullo/Schweppe).** Restating `NOVELTY.md` so it travels with the code:
  the Rust implements a 1984 algorithm; the contribution is the embeddable certified-mirror packaging,
  not the method.

## Probes — viability of ignored FDRS machinery (run 2026-06-18-probes)

- **P-A's "interval-runs already solve it" has a hidden cost.** Dropping the fixed dyadic grid for
  interval-runs *does* kill the F1 straddle, but it also drops the clean cylinder/ultrametric
  structure (`ball = cylinder` and the corpus's proven theorems). If we ever want the multi-scale /
  designed-resolution machinery, we'd need the grid back — so "don't invest in Phase 6" is scoped to
  the *current* flat estimator, not forever.
- **P-B uses a netDist *proxy*, not netDist.** The graded score measured is the hull-spread of the
  sensor intervals; the corpus `netDist` (Thm 92) is `max` over *per-place* gauges and needs the
  network/observer structure. The probe confirms "a graded disagreement score beats the binary fault,"
  which is the actionable point — but adopting literal `netDist` is a bigger lift than the proxy.
- **P-C is a SCALING SKETCH, not a belief-memory model.** `flat = fine^d`, `multi = coarse^d + fine·d`
  are illustrative; the real multi-resolution memory depends on how the belief actually fragments per
  dimension. The exponential-vs-linear *shape* is the finding; the exact ratios are not load-bearing.
- **P-D re-confirms a proven property.** The 1000-shuffle out-of-order check just re-exercises
  `fuseAll_confluent`/`tally_perm` (already proven in Lean) — it is a sanity check, not evidence.
- **The probes assess *whether to invest*, not performance.** A "defer/don't-invest" verdict is a
  scoping decision under the current 1-D fixed-sensor setup; each has an explicit re-open trigger
  (multi-dimensional state → P-C; dynamic/networked sensors → P-D).

## Line B — Native Ultrametric Observer Fusion (pre-registered, charter stage)

Per `ADR-007` §5: opened at charter stage — falsifiers and fraud gallery committed BEFORE any run
(anti-HARKing). Bounded-completeness entries are templates the first screen fills. Charter: `LINE-B.md`.

### Pre-registered falsifiers (kill conditions, committed before data)

- **F-B1 — degeneracy (kills the fork).** The coupled observer-line belief degenerates to the same
  Euclidean interval map — it distinguishes no multi-sensor state the single Line-A cover cannot.
  Then Line B is a re-skin of Line A; abandon it. *(The first thing to rule out — the existence of
  an observer-line *representation* is content-free; the win is representational *content* Line A lacks.)*
- **F-B2 — branch explosion (the combinatorial trap returns).** The `Ω`-admitted active branch count
  grows ≥ the pre-generated octree/uniform-interval cell count at matched resolution. Then embodiment
  did not control the explosion and the "fewer irrelevant branches" thesis is dead.
- **F-B3 — no refusal improvement.** Multiline coupling does not refuse more cleanly than Line-A
  interval consensus (no fewer seam false-refusals, no fewer cross-modality false-accepts). Then there
  is no engineering win over the proven baseline.
- **F-B4 — LCP over-coarsening.** Ascending to the multiline LCP on disagreement leaves no admissible
  transition (the agent stalls). Then the refusal is too aggressive to control with.
- **F-B5 — `Ω` is hand-wavy.** The context oracle cannot be specified as a concrete, cheap,
  deterministic exact-integer function — the architecture rests on an unspecified magic branching rule.
- **F-B6 — substrate leak.** A float / hyperbolic-render value re-acquires control authority anywhere
  on the planning path. Then the epistemology did not change (only the picture did) and the §1
  hardening failed.
- **F-B7 — the `Selection` cannot be cleanly formalized (the make-or-break; RE-POSED 2026-06-30 per
  the owner correction).** *The earlier "a single uniform base reproduces it → octree in disguise"
  wording is RETRACTED — the structure need not beat any uniform tree.* The deliverable is the
  generalized selection mechanism *existing as one general structure* (`LINE-B.md` §0.5, §3 obj 7).
  F-B7 fires if that structure **cannot be defined cleanly / generally**: it collapses to a trivial
  set, needs ad-hoc per-case (per-property) rules instead of one parameterization, the base projection
  `π_B` does not commute with the live update, or the §0.5 example (arbitrary/no-closed-form, live,
  temporally-patterned, cross-dimensionally-filtered, implicate-projection) needs structure the
  framework cannot express. Then the generalized selection mechanism does not exist as claimed. It does
  **not** fire merely because a uniform tree could also represent the example — existence + faithfulness
  + generality is the bar, not out-performance. Tested in Rung B-2 (`LINE-B.md`).

### Fraud gallery (apparent wins that are NOT claims — named in advance)

- **"Fewer branches than an octree at matched resolution" is the trap, not the win.** It keeps the
  octree as the *frame/yardstick* — octree-thinking with smaller boxes. Two distinct effects hide in
  it: (1) **generic laziness** (materialize-on-visit, Phase 7 Thm 46) — *not* a Line-B effect, Line A
  could adopt it; (2) **coupling refusal** — real but small (2 branches on the toy, N-B1). Neither is
  the point. Per the §0.5 correction the deliverable is the **formalized `Selection` structure existing,
  sound, and faithful** — not an economy win over an octree. Do not cite "fewer branches than the
  octree" as a Line-B result; the octree is a strawman, never a yardstick, and out-performance was
  retracted as the goal (F-B7 re-posed to definability).

- **"Hyperbolic / Poincaré-disk space" is a *rendering*, not the substrate.** The moment an agent
  steers by float coordinates on a Poincaré disk it has smuggled Euclidean numerics back through the
  visualization layer. The substrate is integer prefix ancestry / LCP / admissible transitions /
  `netDist`. The disk is an optional view with zero control authority (F-B6). Cite "prefix complex,"
  not "hyperbolic coordinates."
- **"Abolish octrees" is an overclaim — abolish them as the *ontology*, not as a backend.** A
  quadtree/octree/voxel grid is a permitted local adapter inside a single spatial stalk. What dies is
  the idea that the world model *begins* as an empty Euclidean container divided into boxes. Replacing
  `(x,y,z)` with a giant hyperbolic octree changes nothing.
- **"Native observer fusion is new math" — it is not.** `Ω` (Phase 7), `netDist` (Thm 92), `cover_of`,
  `lcp` are existing FDRS objects; the new content is the **coupling relation + the multiline
  forcing/fusion wiring + the verified artifact**. Lineage stays classical (Marzullo/Schweppe/Rushby,
  `NOVELTY.md`); the win, if any, is engineering economy, measured against Line A.
- **"Mixed-radix coupling kills the combinatorial explosion" — only embodiment does, and only if it
  pays.** The explosion moves from *pre-generate all cells* to *generate only `Ω`-admitted branches*;
  whether that is actually cheaper is F-B2, an open measurement, not a guarantee. A lazy oracle that
  still admits everything explodes just the same.
- **"The sheaf Laplacian finds truth" — it measures disagreement.** Stalk variance is inconsistency
  *energy*; truth is certified only where restrictions agree or the surviving cover forces a common
  prefix. High Laplacian ⇒ ascend / refuse, not "compute the true value."
- **"Motion is purely an integer address rewrite" — at the control layer only.** Actuators stay
  continuous at the hardware boundary (PWM, voltages, encoders); they are quantized into certified
  integer transitions *before* planning. The control state is integer-first; the boundary IO is not
  the ontology.
- **Base 0 as an ordinary radix is a bug, not a feature.** `b = 0` must be `PlaceKind::SubstrateZero`
  (non-emitting, latent/transition), kept out of div/mod digit arithmetic. Forcing it into ordinary
  positional encoding breaks the encoder; the base-0 sea is a *substrate* state, not a digit place.
- **Line A is demoted, not refuted.** Nothing in Line B contradicts Rungs 1–4; the certified interval
  consensus remains proven, embeddable, and a valid stalk adapter. "Demote the interval to a boundary
  adapter" is a scoping move, not a negative result against Line A.

### Bounded-completeness (FILLED — run `2026-06-30-lineb-screen`, exact, `source/lineb_screen.py`)

The first exact screen ran the pre-registered battery (deterministic; exact-integer Python stdlib,
zero deps; transcript at `runs/2026-06-30-lineb-screen/transcript/output.txt`). **No falsifier
F-B1…F-B6 fired; all six hypotheses survived (6/6).** The honest bounded-completeness statements and
the negatives this run did *not* dispel:

- **N-B1 — the branch-economy win is mostly laziness, not yet embodiment (the F-B2 caveat made
  quantitative).** Over the scripted Explore→wall→Survive trajectory (+2 transient glitches), the
  `Ω`-admitted active branch count was **7** vs the pre-generated octree's **96** — so F-B2 (Ω ≥ octree)
  did **not** fire. But against a context- and coupling-**blind** *lazy* octree (materialize-on-visit,
  which Line A could equally adopt), Line B pruned only **2** branches (9→7) — exactly the two
  coupling-refused glitches. **The embodiment-specific economy beyond generic lazy-vs-eager (Phase 7
  Thm 46) is real but modest on this toy.** Searched: one 13-emission trajectory, exact. The "fewer
  irrelevant branches" thesis is **not** yet demonstrated at scale; that is the make-or-break for H-B2
  and is deferred to a larger-state rung (more lines, deeper `Ω` gating, a real glitch distribution).

- **N-B2 — H-B1 is content-free, as pre-registered.** The degeneracy PASS only shows a scalar position
  line cannot carry contact modality — trivially true, and flagged in `LINE-B.md` §5 as necessary-not-
  sufficient. It rules out the "pure re-skin" worry; it is **not** evidence the fork pays. Do not cite
  H-B1 as a win.

- **N-B3 — the refusal-map win is a mechanism demonstration on a 4-case designed battery, not a rate.**
  Coupled scored 0 false-accepts / 0 false-refusals vs Line-A's 1 + 1, but on hand-built scenarios
  (cross-modality conflict, base-2 seam straddle, two controls), **not** a sampled distribution. It
  shows the coupled boundary *can* be cleaner where Line A structurally fails (modality off its scalar
  line; radix seam on its fixed binary chart); it does **not** establish a false-accept/false-refusal
  *rate* over realistic noise. A statistical refusal-map sweep is the next screen.

- **N-B4 — no Lean for Line B; the artifact-control lemmas are unproven (only specified).** `PlaceKind`
  well-formedness, `encode_mixed_digits` correctness, and the lifted `force_sound` are *provable now*
  (LINE-B §3) but exist here only as Python behaviour, not machine-checked. Until the proof rung lands,
  Line B carries **none** of Line A's axiom-clean guarantees — the exactness ladder's Lean rung is empty.

  > **UPDATE — LARGELY CLOSED (run `2026-06-30-lineb-lean-rust`).** The Lean rung landed:
  > `lean/FdrsSelection.lean` (imports the Rung-5 toy, Mathlib-free, same `v4.27.0-rc1`) machine-checks
  > **0 sorries, axiom-clean** — `baseOpt_ge_two` (obj 1 PlaceKind), `decodeMR_encodeMR` (obj 2 codec
  > round-trip), `select_wellformed`/`condition_le`/`condition_subset`/`projection_commute`/`refusal_empty`
  > (obj 7 W/S/P/R, all `[propext]`), `multiline_force_sound` (obj 6). All within the FDRS clean set. An
  > embeddable Rust mirror `source/rust/selection-core` (`no_std`, zero deps, additive per §7) carries them
  > with **7/7 E1 fidelity tests**. So Line B now DOES carry axiom-clean guarantees for the Selection's
  > abstract properties. **What remains open:** (i) the W/S/P/R are proven for all lists/cells, but the
  > *faithfulness of a specific §0.5 voxel field* is still only Sage-demonstrated, not proven for all fields
  > (N-B7); (ii) these lemmas live in the *experiment toy* (`FdrsSelection.lean`), **not** ported into the
  > `FdrsFormal/` corpus (that promotion is a later `proof_wanted`/theorem PR, G4); (iii) the Rust is
  > fidelity-tested, not independently verified.

- **N-B5 — tooling deviated from the charter (SageMath → stdlib Python), benignly.** §6 pre-registered
  "SageMath exact"; the screen is exact-integer stdlib Python (the family's F1–R4 convention). Integer
  prefix arithmetic + coupling table + LCP need no number field, so exactness is unaffected — but the
  charter text and the artifact now differ, recorded here so the deviation is not silent.

- **Fraud-gallery confirmations (this run).** The pre-registered traps held: the control path is
  integer-only (H-B6, no hyperbolic/Poincaré value present — none was introduced); `SubstrateZero`
  stayed out of div/mod (the `place_base` assertion guards it); and the "coupling kills the explosion"
  claim was **not** asserted beyond what was measured (N-B1 bounds it to 2 branches on this toy).

### Bounded-completeness (run `2026-06-30-lineb-scale`, exact) — a SECONDARY DIAGNOSTIC, not the deliverable

- **N-B6 — the branch-count scale run fell into the octree-as-yardstick trap (F-B7 fraud entry), by
  construction.** `source/lineb_scale.py` scaled dimension `D` and showed the coupling (as a subshift of
  finite type, Phase 13.2) reduces the `Ω`-admitted growth rate to λ < b (λ_Explore ≈ 4.562 < 6;
  λ_Survive = φ² < 4, admissible counts = even-indexed Fibonacci → golden-mean shift), with a
  no-coupling control (λ = b) that correctly fires the sharpened F-B2 — a clean, exact result. **But it
  measures the WRONG thing per LINE-B §0.5 / §5 (H-B2 retired):** (i) it keeps the *octree as the frame*
  (the retired comparison), and (ii) it uses a *uniform* base-6 cell — **zero radix heterogeneity** — so
  it tests COUPLING economy, never the mixed-radix claim (F-B7). Recorded as an archived secondary
  diagnostic; it does **not** advance the deliverable. The make-or-break is **H-B7 (the `Selection`)**:
  defined, live, projectable, sound — not any economy. Do not cite this run as a Line-B win.

### Bounded-completeness (run `2026-06-30-lineb-selection`, exact Sage) — the `Selection` (H-B7) deliverable

The Rung B-2 screen formalized the `Selection` and verified W/S/P/R/F + headline + heterogeneity/substrate
exactly (transcript `runs/2026-06-30-lineb-selection/transcript/output.txt`). **H-B7 PASS; F-B7 did not
fire.** The honest scope — what this run does **not** settle:

- **N-B7 — existence + faithfulness on ONE instance, not a proof for all fields.** H-B7 is an *existence*
  claim (the structure is definable, sound, general) and it is demonstrated *faithfully on one deterministic
  ragged sensor field*. The W/S/P/R lemmas are **provable-now** (the heart of Line B's Lean rung) but here
  they are checked *computationally in Sage on this instance*, not machine-checked for all fields. Until the
  Lean rung lands (N-B4 extends), Line B still carries **no** axiom-clean guarantee. The "arbitrary,
  no-closed-form" field is a stand-in mix, **not** a claim about real sensor statistics.
- **N-B8 — projection-commute is the OBJECT's fibered π_B, and it is deliberately *trivial-by-design* for a
  cellwise update.** The fibered restriction commutes because both restriction and conditioning act
  cellwise — this is a *soundness* property (the object is a well-behaved sheaf), **not** a surprising
  result. The *content* is the contrast: the **forgetful voxel shadow does NOT commute** (31-voxel residual),
  which is the Phase-6 Thm 42 fact (classical), re-expressed to justify the fibered object. No new theorem.
- **N-B9 — H-B7 is NOT an economy or capability claim (§0.5).** The Selection is *not* shown to be smaller,
  faster, or able to do anything a uniform tree cannot — and per §0.5 it is not required to. Anyone citing
  this run must say "a general, sound, faithful *formalization* of the selection mechanism exists," never
  "Line B outperforms / beats an octree" (that framing is retired; F-B7 no longer means "a uniform base
  reproduces it").
- **Fraud-gallery confirmations.** Substrate held (H-B6: integer-only control path, no hyperbolic value);
  `SubstrateZero` stayed out of digit arithmetic (`base()` assertion); the "space is a derived stalk"
  headline allocated **0** voxels for the wall invariant (not a smuggled octree); heterogeneity was
  genuine (5 distinct bases exercised, lcm 240), not cosmetic.

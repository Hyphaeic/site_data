# Experiment: FDRS Sensor Fusion (Certified Set-Membership State Estimation)

**Charter stage (G0/G1) + Rung-1 Lean keystone landed (G2 partial). Static-scalar / two-bounded-sensor anchor.**

- **Registry ID:** `experiment-fdrs-sensor-fusion`
- **Upstream project:** `project-fdrs-formal` (Ph 1/6 cylinder ultrametric; Ph 13.6 certified emission `emit_traps`; Ph 14 admissibility trap + interface balance; Ph 2 conditional expectation)
- **Program:** `program-variable-representation` (robotics-stack exploration)
- **Workspace:** `workspace-math-proof-env` (Lean) — a self-contained Lean project, **no Mathlib/Batteries**, exact `Nat` arithmetic only (no floats)
- **Owner:** `volition-billy`
- **Scientific status:** **`tested`** (Rungs 1 / 1.5 / F1 / F2 / 3 landed — keystone + union + k-consensus + recursive-filter soundness all machine-checked & axiom-clean; F1/F2/R3 screens run with pre-registered hypotheses resolved; H-R3c outlier-robustness is the headline)
- **Risk class:** low (internal, exploratory, no external commitment)

---

## Tracks

This family now carries **two** investigation lines, sharing one workflow:

- **Line A — Certified Interval Consensus** (this README's Rungs 1–4, **`tested`**): the
  Euclidean-interval → cylinder → consensus → forced-digit pipeline, made exact, embeddable,
  digit-forcing. Classical lineage (Marzullo/Schweppe/Rushby, `NOVELTY.md`); the proven baseline.
- **Line B — Native Ultrametric Observer Fusion** (`LINE-B.md`, **`charter` + first exact screen
  landed, 6/6**): the mixed-radix sensorimotor fork — demote the Euclidean interval to a *boundary
  adapter*, make the native belief a coupled ultrametric sheaf over heterogeneous `Ω`-radix observer
  lines, fuse by forced common prefix. Pre-registered (H-B1…H-B6 / F-B1…F-B6); **no new math claimed**;
  Line A is demoted, not deleted. First exact screen `runs/2026-06-30-lineb-screen/` (4-line toy agent)
  — all six hypotheses survive; headline = cleaner refusal vs Line A (H-B3). Honest caveats in
  `NEGATIVE.md` N-B1…N-B5 (branch-economy win is mostly laziness; no Lean yet). The architectural
  rationale (and its hardening — substrate-first, hyperbolic-as-rendering, octree-as-adapter,
  base-0-as-substrate) lives in `LINE-B.md`.

## Motivation

Classical robotics state estimation (Kalman/EKF/UKF, particle/SMC filters) represents
belief as a **probability distribution** (Gaussian moments, or weighted samples) and
fuses via Chapman–Kolmogorov + Bayes. That probabilistic core is also its cost on
embedded targets: covariance loses positive-definiteness in fixed point, matrix
inverses are expensive, float is scarce on an MCU, and certifying real-time bounds +
correctness fights the adaptive float math.

This family asks a **first-principles** question, not "how do we improve the Kalman
filter": *strip fusion to what it must do — represent / predict / update / run
multi-rate — and ask what the FDRS apparatus (deterministic, exact-integer,
asynchronous-multi-timeline, ultrametric/cylinder, certified-emission) natively
provides.*

The honest finding that shapes the whole family: **FDRS does not natively give a
probability distribution; it gives a forced/undetermined boundary.** So the natural
FDRS-native estimator is a **certified set-membership (bounded-error) estimator**, a
*different* epistemics from Bayesian:

- Bayesian belief: "state is Gaussian, mean μ, covariance Σ" — soft, statistically optimal under its noise model.
- FDRS-native belief: "state lies in this cylinder; finer digits not yet forced" — hard, set-valued, **certified**.

The trade is **guaranteed-and-verifiable** in place of **statistically-optimal**:
where a Kalman filter is tight under Gaussian noise, this is conservative-but-certified
under *bounded* noise. We commit to the **dual-belief** form: a **hard** set-constraint
(a cylinder = digit prefix) and a **soft** measure, *both carried on the same cylinder
filtration*, with the hard cylinder = the support of the soft measure.

This is the chosen route precisely because it is the most differentiated and the most
provable; the bridge to fuller Bayesian-function parity (soft likelihoods, a real
measure-on-cylinders via the Ph 13.5 Parry/Markov layer) is a later rung.

## Hypotheses

- **H1 (keystone soundness — PROVEN, Rung 1).** With the *bounded-error* noise model
  (each sensor returns a cylinder guaranteed to contain the true state), fusion of two
  **sound** readings always yields a cylinder that still contains the truth and has the
  resolution of the **finer** sensor; two **inconsistent** readings are **refused**
  (a fault), never silently averaged. — the lifted analogue of the Gosper four-corner
  trap (`emit_traps`, Ph 13.6) and the admissibility trap (Thm 86, Ph 14).
- **H2 (dual-belief coherence — PROVEN, Rung 1).** A soft integer-mass measure carried
  on the same cylinder filtration, conditioned by each reading, has support contained in
  the hard fused cylinder (**hard = support of soft**), and conditioning only ever
  removes mass (no creation — the soft echo of the Ph 14 interface balance
  `issued = consumed + pending`).
- **H3 (practical viability — PRE-REGISTERED, UNTESTED, Rung 2+).** On a realistic
  bounded-noise model, representing a sensor's guaranteed interval `[m̂−ε, m̂+ε]` as a
  cylinder (or small union of cylinders) does **not** catastrophically lose precision at
  radix boundaries — or a chart choice (redundant/overlapping, balanced-digit, Gray)
  mitigates it. *This is the make-or-break question; see F1.*

## Method — exactness ladder (per ADR-007 §3)

- **Rung 1 — Lean (proven):** `lean/FdrsSensorFusion.lean`, this commit. Cylinders as
  digit prefixes; `Agree s x` = `x ∈ U(s)`; `fuse` = nest-or-refuse; soft belief =
  exact `Nat` mass + `condition`. Machine-checked, axiom-clean (see `results.md`).
- **Rung 2 — exact mirror (deferred):** Rust over `num-rational` / integer intervals.
  Transcribe `fuse`/`condition`; add the **interval → cylinder cover** that Rung 1 begs
  (H3/F1), and measure the boundary-straddle overhead exactly.
- **Rung 3 — float / dynamics (deferred):** add a motion model (predict = Tick +
  transfer map) and asynchronous multi-rate fusion (Phase-8 routing: sensors as
  timelines, fusion as injection at junction cylinders, with compile-time latency /
  deadlock guarantees). Benchmark *function* against an EKF/particle baseline on a 1-D
  pose task.

## Pre-registered falsification criteria

- **F1 (the make-or-break — ultrametric vs. Euclidean).** A bounded real interval is
  generally **not** a single cylinder: one straddling a major radix boundary (e.g.
  `[0.49, 0.51]` in binary) has *the whole line* as its smallest covering cylinder —
  total precision loss. **F1 kills (or restricts) the thesis if:** across uniformly
  random true states, the median cylinder-cover overhead `(cover width)/(2ε)` exceeds
  **2×** under *every* chart tried (plain mixed-radix, redundant/overlapping,
  balanced-digit, Gray). If so, the ultrametric is the wrong uncertainty geometry for
  raw Euclidean state, and the method is confined to inherently-hierarchical /
  coarse-to-fine quantities. *Honest: this is where the direction most plausibly dies,
  and the Rung-1 toy deliberately assumes cylinder readings to isolate it.*
- **F2 (fusion buys nothing).** If on the realistic model the fused cylinder is no finer
  than the coarser sensor in > 1/3 of states (boundary-straddle frequency too high), or
  refusal fires on > 1/3 of consistent-but-straddling pairs, fusion is not doing a
  filter's job.
- **F3 (dual link) — CLOSED.** Proven (`condition_two_support`): support ⊆ hard fused
  cylinder always. F3 cannot fail; recorded as resolved.

A falsified hypothesis is a scientific result. F1's boundary (which state quantities
admit a cheap cylinder cover) is the durable output even under refutation.

## Honest scope & anti-confabulation

- **Novelty audit DONE (2026-06-18) — verdict in [`NOVELTY.md`](NOVELTY.md); read it before any
  external claim.** The adversarial audit **refutes the algorithmic novelty**: every component is
  classical. The k-of-n interval consensus **is Marzullo (1984/1990)** ("smallest interval
  consistent with ≥ n−f sensors" = k=n−f majority) and Brooks–Iyengar (1996); set-membership belief
  + recursive predict/update **is Schweppe (1968)** / Kieffer–Jaulin–Walter (2002); and the single
  strongest threat — **Rushby (SRI, 2002)** — *already machine-checked Marzullo's interval-fusion
  soundness in PVS, including a fault-detection corollary*, so even our "certified" + refusal angle
  is, at the static level, a Lean re-expression of a 2002 result. The **only** narrowly-unoccupied
  territory is the *composed* stack (interval-consensus + recursive invariant + async confluence +
  certified-refusal + exact-integer, axiom-clean in Lean 4) — i.e. **connection + curation + the
  verified artifact, not new math.** Confluence is trivial (intersection commutativity / Kahn 1974).
  Frame this on **engineering utility** (a reusable certified fusion surface), never as research
  novelty; cite Rushby / Marzullo / Schweppe wherever described.
- **This is Bayesian-different, not Bayesian-better.** The Rung-1 "soft" layer is
  integer-mass conditioning with a hard {0,1} likelihood — **not** yet a probabilistic
  posterior with soft likelihoods. Calling it "dual Bayesian" would overreach; it is
  "dual: hard set + integer-mass measure with hard conditioning." Soft likelihoods and a
  real measure-on-cylinders (Ph 13.5 Parry/Markov) are a deferred rung.
- **Rung-1 assumes single-cylinder sensor readings** (F1 deferred), a **static** scalar
  (no dynamics/predict), and **no async** (Phase-8 integration deferred).
- The Lean toy lives **outside** `FdrsFormal` (this experiments tree), Mathlib-free; it
  does **not** yet connect to the corpus's verified gauge/cylinder theorems. Porting it
  in (and replacing `isPrefix`/`Agree` with the corpus `cfDist`/`ball_eq_cylinder`) is a
  future rung, gated on F1.

## Formal basis & provenance

- **Rung-1 Lean (machine-checked, axiom-clean):** `lean/FdrsSensorFusion.lean` —
  `fuse_sound`, `fuse_refuses_sound`, `fuse_none_iff`, `fuse_length` (hard keystone);
  `condition_le`, `condition_support`, `condition_two_support` (soft + dual link). See
  `results.md` for `#print axioms`.
- **FDRS analogues:** Ph 1/6 cylinder ultrametric (`ball = cylinder`); Ph 13.6
  `emit_traps`/`emitReady_traps` (emit only when forced; `√2·√2 → []` refusal); Ph 14
  Thm 86 admissibility trap, Thm 89 interface balance, Thm 92 observer-glued `netDist`
  (the multi-sensor / no-common-clock object); Ph 2 `P_L = E[·|ℱ_L]` (predict-coarsening).
- **Toolchain:** Lean `leanprover/lean4:v4.27.0-rc1` (matches `project-fdrs-formal`), no
  external Lean dependencies.

## Directory contents

```
fdrs-sensor-fusion/
├── README.md                  ← this charter (G0/G1) + ladder plan
├── results.md                 ← Rung-1 verified outcomes (build, axioms, demos)
├── lean/                      ← Rung 1: self-contained, Mathlib-free Lean keystone
│   ├── lean-toolchain
│   ├── lakefile.toml
│   └── FdrsSensorFusion.lean
└── (Rung 2/3: source/ exact mirror + dynamics — deferred)
```

## Status

- [x] Charter (this document) — G0/G1, dual-belief + bounded-error model committed
- [x] **Rung 1 Lean keystone — `lake build` green, 0 sorries, axiom-clean** (G2 rung 1)
  - [x] H1 soundness: `fuse_sound`, `fuse_length`, `fuse_none_iff`, `fuse_refuses_sound`
  - [x] H2 dual link: `condition_support`, `condition_two_support`, `condition_le`
  - [x] Executable witnesses (`#eval`): consistent→finer, conflict→refuse, soft pruning
- [x] **Rung 2 F1 screen — `runs/2026-06-18-f1-screen/`, verdict PASS (restricted)** (G2 rung 2)
  - [x] single-cylinder hard object FAILS (catastrophic, precision-worsening tail; `NEGATIVE.md` N1)
  - [x] union-of-cylinders PASSES (overhead ≤ 1.5, ≤ 3 cells, ε-independent) → hard belief = soft support
- [x] **Rung 1.5 — Lean union keystone landed, axiom-clean** (closes the F1 restriction in proof)
  - [x] `fuseU`/`fuseU_sound`/`fuseU_eq_nil_iff` (cover fusion = intersection; soundness + exact fault boundary)
  - [x] `fuseAll`/`fuseAll_sound` (certified multi-IMU array consensus)
  - [x] `coveredBy_fuseU`/`conditionU_fuseU_support` (dual link: hard fused cover = soft support)
  - [x] `tally`/`tally_le` + multi-IMU demo (consensus tightens; outlier ⇒ refusal; vote survives)
- [x] **F2 — robust k-of-n consensus landed** (strict brittleness quantified + robust policy proven)
  - [x] Lean `kConsensus_sound`/`good_covers_share_cell`/`tally_all`, axiom-clean (≥k good ⇒ truth-cell with ≥k votes)
  - [x] exact screen `runs/2026-06-18-f2-consensus/`: strict refusal rises with n (52% at n=7,p=0.1); majority retention ≳99% and rises with n
- [x] **Rung 3 — dynamics landed** (charter below; scientific status → `tested`)
  - [x] Lean `runFilter_sound`/`filterStep_sound`/`predictU_sound`/`predictCoarsen_sound`, axiom-clean (H-R3a)
  - [x] exact screen `runs/2026-06-18-r3-filter/`: clean FDRS 100% (H-R3b); outliers FDRS ≫ KF, 84% vs 8% at q=0.3 (H-R3c); width tracks fusion (H-R3d)
  - [x] N2 finding: mis-specified drift → containment loss, vindicating the `hmove` hypothesis
- [x] **Rung 4 — async routing / fusion control surface landed** (charter above)
  - [x] Lean `agreeU_fuseAll_iff`/`fuseAll_confluent`/`tally_perm`/`routedStep_confluent`/`routedStep_sound`/`due_mul`, axiom-clean (H-R4a/b/d)
  - [x] `Sensor`/`due`/`roundAt`/`runRouted` multi-rate abstraction; exact screen `runs/2026-06-18-r4-routing/`: 100% contain clean, 0 confluence mismatches, staleness ≤ period (H-R4c/d)
- [x] **Adversarial novelty audit DONE → [`NOVELTY.md`](NOVELTY.md)** — algorithmic content refuted as classical (Marzullo/Schweppe/Rushby); novelty = composed verified artifact only; must-cite threats logged
- [x] **Engineering integration DONE** (charter above) — `source/rust/` `fusion-core` (`#![no_std]`, 0 deps, integer) + `fusion-demo`; run `runs/2026-06-18-engineering-rust/`
  - [x] E1 fidelity: 7/7 `#[test]` theorem-checks + Lean `fuseAll` fidelity vector
  - [x] E2 embeddable: `no_std`, integer-only, heap-free, zero deps, clean build
  - [x] E3 actionable: closed control loop regulates 80→300 via the estimate alone; certified-refusal drove a safe hold-on-fault (live at t=17)
- [x] **Probes DONE → `runs/2026-06-18-probes/`** (viability of ignored FDRS machinery): P-A don't-invest (interval-runs already solve F1) · **P-B ADOPT** (graded `netDist`-style disagreement ≫ binary fault) · P-C defer→multi-dim (MRA) · P-D defer→dynamic sensors (Composition)
- [x] **P-B ADOPTED** — graded `dissent` health score: Lean `dissent`/`dissent_perm`/`dissent_le_iff_tally_ge` (axiom-clean), Rust `Cover::max_agreement` + `Estimate.dissent` (`no_std`, 8/8 tests), demo holds on high dissent *before* the binary fault fires (t=8→9)
- [ ] **Next: bare-metal target** (`#[panic_handler]` + `thumbv7em-none-eabi`; core `.text` size; C/RTOS FFI shim)
- [ ] 2-D / SE(2) pose (the deferred F1 geometry question: per-axis runs vs box/zonotope) — **subsumed by Line B's reframing** (the Euclidean box is a boundary adapter, not the belief; see `LINE-B.md`)
- [x] **Line B — Native Ultrametric Observer Fusion — first exact screen LANDED (`runs/2026-06-30-lineb-screen/`, tag `exact`, 6/6)** — the mixed-radix sensorimotor fork: demote Euclidean intervals to boundary adapters; native belief = coupled ultrametric sheaf over heterogeneous `Ω`-radix observer lines; fusion = forced common prefix across coupled lines. H-B1…H-B6 + F-B1…F-B6 pre-registered (`LINE-B.md` / `NEGATIVE.md`); first screen `source/lineb_screen.py` (4-line toy agent) — **no falsifier fired**. Headline H-B3 (cleaner refusal: coupled 0/0 vs Line-A 2 errors on the battery). **No new math** (engineering economy + cleaner refusal vs Line A is the only claim); Line A demoted-not-deleted. Honest negatives: `NEGATIVE.md` N-B1 (branch-economy win is mostly lazy-vs-eager, embodiment pruned only 2), N-B4 (no Lean yet).
  - [x] **branch-count scale diagnostic** — `runs/2026-06-30-lineb-scale/` (`source/lineb_scale.py`): coupling = subshift of finite type, `Ω`-admitted grows as λ^D with λ<b (Explore 4.562<6; Survive λ′=φ²), no-coupling control fires F-B2. **RETIRED to secondary diagnostic per §0.5** (octree-as-yardstick is the trap, not the win — it uses a uniform base, no heterogeneity). Kept archived.
  - [x] **THE deliverable — H-B7 / §3 obj 7: the `Selection` — LANDED** (`runs/2026-06-30-lineb-selection/`, `source/lineb_selection.sage`, Sage exact, closes N-B5): the generalized selection mechanism (union of admissible joint cells over the coupled complex + live update + base projection π_B) is **well-formed / filtration-sound / projection-commuting / refusal=empty** and **faithfully represents the §0.5 voxel example** (arbitrary no-closed-form, live, temporal, cross-dimensionally-filtered) from ONE general rule. **H-B7 PASS; F-B7 does not fire.** Headline: space is a derived stalk (wall = 0-voxel coupling invariant vs octree's 50-voxel neighbourhood); the forgetful voxel-shadow's 31-voxel non-commuting residual (Phase-6 Thm 42) is why the fibered object is needed. Existence+faithfulness, **not** economy; no new math; no Lean yet (`NEGATIVE.md` N-B7…N-B9).
  - [x] **`Selection` Lean rung + Rust mirror — LANDED** (`runs/2026-06-30-lineb-lean-rust/`): `lean/FdrsSelection.lean` machine-checks (0 sorries, axiom-clean) the Selection **W/S/P/R** (`select_wellformed`/`condition_le`/`projection_commute`/`refusal_empty`, all `[propext]`) + `PlaceKind` well-formedness + mixed-radix codec round-trip + lifted `force_sound`; embeddable Rust `source/rust/selection-core` (`no_std`, zero deps, additive per §7) mirrors them with **7/7 E1 fidelity tests**. Closes N-B4 for the Selection (faithfulness-for-all-fields + `FdrsFormal/` corpus port remain, N-B7).
  - [x] **Selection VISUALIZER — LANDED, now INTERACTIVE** (`source/rust/selection-demo`, `runs/2026-06-30-lineb-visualizer/`): a terminal view of the live voxel selection, **driven by the verified `selection-core` ops** — the living fabric (flows, temporal period), cross-dimensional filtering (Explore vs Survive reshape), filtration-soundness (a conditioning shrinks 129→70), refusal=empty, and the forgetful-shadow residual (`*` = Phase-6 Thm 42 payload). A **read-only view** (H-B6). **`cargo run -p selection-demo`** = interactive on a TTY (keys: space=play/pause · n/p or ←/→=step · e/s=Explore/Survive · i=toggle intent · f=filter · r=residual · x=refuse · w=wall · +/-=speed · q=quit; zero-dep raw terminal via `stty`). `-- --animate` = passive loop; `-- --report` = deterministic transcript.
  - [ ] **Other rungs:** statistical refusal-map sweep (N-B3); promote the Selection lemmas from the toy into the `FdrsFormal/` corpus (G4 `proof_wanted`→theorem); prove §0.5 faithfulness for a class of fields (N-B7); bare-metal-link `selection-core`.
- [ ] Registry entity (`propose`-gated); drift-as-prefix-map + union-cover bound as `proof_wanted`

## Rung 3 — dynamics charter (pre-registered 2026-06-18, BEFORE execution)

Static fusion (Rungs 1–F2) becomes a *filter* once the state moves: alternate **predict**
(propagate belief under a motion model — uncertainty grows) and **update** (`fuseU`/k-consensus
with the new measurements — uncertainty shrinks). Anything below not stated is exploratory and
labelled so.

**Exactness-ladder placement.** Rung-3 *proof rung* (Lean): the recursive soundness invariant
over an abstract prefix-map motion + the concrete uncertainty-growth (coarsening) instance.
Rung-3 *exact rung* (`source/r3_filter.py`): a 1-D drifting scalar run through the FDRS
cover-filter (exact rational) against a textbook Kalman filter (float, classical baseline).
True translational drift *as a prefix-map* needs the FDRS `⊕` arithmetic layer (Phase 1,
1-Lipschitz) ported to the scalar convention — **deferred**, flagged honestly; the Lean rung
proves the filter *structure*, the screen exercises real drift numerically.

**Hypotheses (pre-registered):**
- **H-R3a (Lean, structural):** the predict→update cycle preserves truth-in-cover; iterated,
  the belief cover contains the (moved) true state at every step, given a sound motion model and
  sound measurements. *Falsifier:* no proof / a cycle that drops the truth. (Risk = vacuity —
  the concrete predict must be non-trivial.)
- **H-R3b (empirical, clean regime):** with sensors respecting their bounds, the FDRS cover-filter
  contains the truth at **100%** of steps, and steady-state cover width stays **bounded** (does
  not inflate to the whole line) given one measurement round per step. *Falsifier:* containment
  < 100% (bug), or width → 1 (predict inflates faster than update deflates).
- **H-R3c (empirical, vs Kalman — the key claim):** under outlier contamination (fraction `q` of
  measurements grossly violate their bound), FDRS k-consensus truth-containment **≥** Kalman
  ±2σ containment, by a margin **growing with `q`**, at the cost of FDRS median interval width
  **≥** Kalman width. *Falsifier:* FDRS containment ≤ KF under outliers (no robustness edge —
  kills the value proposition), or FDRS width unboundedly larger (useless conservatism).
- **H-R3d (uncertainty tracking):** FDRS cover width **decreases on update, increases on predict**
  — it behaves like an uncertainty estimate. *Falsifier:* width unresponsive to predict/update.

**Pre-registered honest scope.** In the **clean Gaussian** regime the Kalman filter is optimal, so
FDRS is *expected* to be wider / less efficient there — that is **not** a loss and **not** the
claim. FDRS's claim is **robustness under bound-violation**, tested only in the outlier regime. An
FDRS advantage *in the clean regime* would indicate a confound, not a win. Kalman is cited as the
classical baseline; the FDRS contribution is the certified-conservative + outlier-robust filter,
not a new estimator that beats KF on KF's home turf.

## Rung 4 — async routing / the fusion control surface (pre-registered 2026-06-18, BEFORE execution)

Goal restated (per direction): **not** competing with Kalman / improving Gaussian handling — building
*our own* fusion control-surface abstraction from the FDRS philosophy that the control plane can be
engineered against. The routing layer is where the multi-timeline async structure becomes that
substrate: each sensor (IMU) is an independent timeline ticking at its own rate; a reading is *routed*
(injected) at a junction into the estimator's belief; fusion happens on injection. The defining
property that makes the surface well-defined: **async injection is confluent** — the fused belief
depends only on *which* readings arrived, not the order/interleaving in which they did.

**Exactness-ladder placement.** Rung-4 *proof rung* (Lean): the confluence theorems + the routed
predict/fuse step (the control-surface API) + the multi-rate sensor abstraction. Rung-4 *exact rung*
(`source/r4_routing.py`): a heterogeneous-rate network operating, with empirical confluence as a
proof sanity check. Deadlock-freedom + composite worst-case latency are **already proven in the main
corpus** (Phase 8 Thm 52/53, `FdrsFormal/Composition/`); our star topology (sensors → estimator) is
trivially acyclic, so we *cite* those, not re-prove them.

**Hypotheses (pre-registered):**
- **H-R4a (Lean, confluence):** the fused belief is invariant under permutation of the sensor
  injection order — both strict (`fuseAll`) and the consensus vote (`tally`). Async fusion is
  order-independent. *Falsifier:* a permutation that changes the belief / the tally.
- **H-R4b (Lean, routed soundness):** one routed step (predict the belief, then fuse the due round)
  preserves truth-in-cover when the predicted belief and every delivered cover are sound. *Falsifier:*
  a routed step that drops the truth despite sound inputs.
- **H-R4c (empirical, multi-rate + confluence sanity):** a heterogeneous-rate network (fast + slow
  sensors) keeps the truth in the belief while running; random injection orders within a round yield
  **identical** beliefs (empirical confluence). *Falsifier:* containment failure under sound sensors,
  or any order-dependent belief (would contradict the Lean theorem → a bug to fix).
- **H-R4d (latency / staleness):** a reading from a period-`p` sensor is incorporated within `p`
  global ticks — bounded staleness = the sensor's own period. *Falsifier:* unbounded incorporation delay.

**Pre-registered honest scope.** The deliverable is the *abstraction + its certified properties*, not a
performance claim. Confluence is the load-bearing property (it makes the surface well-defined); it is
proven, so the screen only sanity-checks it. Deadlock/timing are inherited from Phase 8, not novel
here. k-consensus robustness (F2) composes with routing but is not re-derived. The async model fuses
*within* a round order-independently; *across* ticks, predict interleaves (order matters there, by
design — that is the motion).

## Engineering integration — the embeddable control surface (2026-06-18)

Per the novelty audit (`NOVELTY.md`): the value here is **engineering utility, not research
novelty**. This rung makes the verified Lean control surface **runnable and embeddable** — a Rust
`#![no_std]` exact mirror (`source/rust/`, crates `fusion-core` + `fusion-demo`) that a control
plane consumes. It is the "exact mirror" rung of the exactness ladder for the *whole* surface; it
is **fidelity-tested against the Lean, not independently verified** (the Lean is the proof; the
Rust inherits the certified properties by fidelity to the mirror, tested via `#[test]`s). The
algorithm it mirrors is the one the audit identified as **Marzullo/Schweppe** — cite accordingly.

**Acceptance criteria (pre-registered):**
- **E1 (fidelity):** `fusion-core` reproduces the Lean fusion/consensus/refusal decisions on shared
  vectors, and the Lean theorems hold as runtime `#[test]`s — fused belief contains the truth;
  ≥k good sensors ⇒ truth in the k-consensus; **confluence** (shuffle the round ⇒ identical
  belief); conflicting sensors ⇒ refuse/fault. *Falsifier:* any disagreement or failed theorem-test.
- **E2 (embeddable):** the core is `#![no_std]`, **integer-only** (no float anywhere), **heap-free**
  (fixed-capacity buffers), **zero dependencies**. *Falsifier:* needs `std`/`alloc`/float to function.
- **E3 (actionable):** `estimate()` yields `(point, half_width bound, fault)` that a control loop
  consumes to make a decision; the demo runs a closed loop on it. *Falsifier:* output insufficient
  to drive control.

**Pre-registered honest scope.** Fidelity is *tested, not proven* — the certified guarantees live in
the Lean, the Rust is the exact mirror. Fixed-capacity buffers can overflow (handled by
saturate→fault, documented in `NEGATIVE.md`). This is the deployable artifact, positioned on
engineering value; it does not add a novelty claim.

## Probes — viability of ignored FDRS machinery for state estimation (pre-registered 2026-06-18)

Cheap exact screens (`source/probes.py`) testing whether Tier-1 corpus machinery we did **not**
use is worth pursuing for this estimator. **Experiments, not production** — a "not viable for us
now" verdict is a useful result (it tells us *not* to invest), not a failure.

- **P-A (designed/adaptive resolution — Phase 6/7):** a measurement-centered / interval-run
  representation gives cover overhead → 1 at 1 cell, vs the uniform fixed grid's coarse-straddle /
  fine-many-cells tradeoff — confirming Phase-6 designed-resolution is the right framing for F1.
  *Falsifier:* a fixed matched grid beats interval-runs with no per-reading machinery (then designed
  resolution is a free win to chase); or the straddle survives fineness.
- **P-B (graded disagreement — Phase 14 `netDist`):** a graded sensor-disagreement score (interval
  spread, netDist spirit) detects outlier contamination **earlier / with better separation** than the
  binary empty-fusion fault (which fires only when consensus fully collapses). *Falsifier:* the binary
  fault detects contamination as well as the graded score (then netDist adds nothing).
- **P-C (multi-resolution belief — Phase 2 MRA):** multi-resolution saves materially on memory only
  as **state dimension grows**; for the current 1-D scalar the belief is already tiny, so MRA is
  overkill *now*. *Falsifier:* MRA saves materially even at d=1 (pursue now), or never helps (drop it).
- **P-D (real routing — Phase 8 `Composition/`):** out-of-order arrival is already covered by proven
  confluence; the injection-queue / bounded-spawn / compile-time-timing substrate is viable only for
  **dynamic or networked** sensors, overkill for a fixed local array. *Falsifier:* a fixed local array
  needs the queue/spawn machinery near-term, or out-of-order breaks confluence (it cannot — proven).

**Honest scope:** these probes assess *whether to invest*, not performance; and using any of this
machinery would add capability, not novelty (MRA = wavelets/conditional-expectation, designed grids =
adaptive meshing, `netDist` = a disagreement metric — classical-where-proven, per `NOVELTY.md`).

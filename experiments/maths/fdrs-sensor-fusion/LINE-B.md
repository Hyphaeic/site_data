# Line B — Native Ultrametric Observer Fusion (the mixed-radix sensorimotor fork)

**Charter (G0/G1) pre-registered + FIRST EXACT SCREEN LANDED (G2, `runs/2026-06-30-lineb-screen/`).**
**Follows `ADR-007`; sibling track to the existing certified-interval work (now "Line A").**

- **Registry ID:** `experiment-fdrs-sensor-fusion` / Line B
- **Scientific status:** **`charter` → first exact screen PASS (6/6, tag `exact`)** — promotion to a
  `registered` Line-B status proposed, pending the protocol+results commit and review (G3 is
  human-in-loop for material claims). `results.md` ledger + `NEGATIVE.md` N-B1…N-B5 carry the verdict.
- **Risk class:** low (internal, exploratory)

> **Run pointer (G2).** `runs/2026-06-30-lineb-screen/` — `source/lineb_screen.py`, exact-integer Python
> stdlib (zero deps). All six pre-registered hypotheses (H-B1…H-B6) survive their falsifiers; headline
> is H-B3 (cleaner refusal vs Line A). Honest scope: H-B1 is content-free non-degeneracy, the
> branch-economy win (H-B2) is mostly generic lazy-vs-eager (only 2 branches pruned by embodiment), the
> refusal win is a 4-case mechanism demonstration not a rate, and there is no Lean rung yet
> (`NEGATIVE.md` N-B1…N-B5). The §3–§6 charter below is the (unchanged) pre-registration.
>
> **Run pointer (G2) — THE deliverable (H-B7 / §0.5).** `runs/2026-06-30-lineb-selection/` —
> `source/lineb_selection.sage` (SageMath exact, closes N-B5). The generalized `Selection` is formalized
> and all core properties verified exactly: **W** well-formed cover ∀t · **S** filtration-sound
> (conditioning only removes, `condition_le` echo) · **P** fibered π_B commutes with update (the forgetful
> voxel shadow's 31-voxel residual = Phase-6 Thm 42 payload, the reason the fibered object is needed) ·
> **R** refusal = empty selection · **F** faithful §0.5 example (arbitrary no-closed-form, live, temporal,
> cross-dimensionally-filtered voxel selection from ONE general rule). **H-B7 PASS; F-B7 does not fire.**
> Honest scope (`NEGATIVE.md` N-B7…N-B9): existence + faithfulness on one instance, **not** economy/
> capability. The scale run `runs/2026-06-30-lineb-scale/` is an archived secondary diagnostic (H-B2
> retired per §0.5).
>
> **Run pointer (G2/G4) — the Selection's Lean rung + Rust mirror.** `runs/2026-06-30-lineb-lean-rust/`.
> `lean/FdrsSelection.lean` (imports the Rung-5 toy, Mathlib-free, `v4.27.0-rc1`) **machine-checks the
> Selection W/S/P/R — 0 sorries, axiom-clean** (`select_wellformed`, `condition_le`/`condition_subset`,
> `projection_commute`, `refusal_empty`, all `[propext]`) plus `PlaceKind` well-formedness (obj 1), the
> mixed-radix codec round-trip (obj 2), and the lifted `force_sound` (obj 6). Embeddable Rust
> `source/rust/selection-core` (`no_std`, zero deps, additive per §7) mirrors them with **7/7 E1 fidelity
> tests**. This closes `NEGATIVE.md` N-B4 for the Selection (open: faithfulness-for-all-fields N-B7, and
> the `FdrsFormal/` corpus port). The §0–§6 charter below is the (unchanged) pre-registration.

---

## §0 The turn — and what it is *not*

Line A (Rungs 1–4, `tested`) proved a real thing: classical interval consensus can be made
**exact, conservative, embeddable, and digit-forcing** (`fuseU`/`kConsensus_sound`/`runFilter_sound`,
the `fusion-core` Rust mirror). Its lineage is honestly classical — Marzullo/Schweppe/Rushby
(`NOVELTY.md`). But its pipeline still begins in the **old ontology**:

```
Euclidean interval [lo,hi]  →  cylinder/cover  →  consensus  →  forced digit
```

The interval is *primary*; the cylinder is downstream. That is exactly why **F1 was the
make-or-break screen** — a connected Euclidean interval does not fit one ultrametric cylinder, and
the single-cylinder object failed near radix seams (`NEGATIVE.md` N1); the union-cover was the
repair. The shape of that failure is the tell: **we are projecting heterogeneous sensors into one
scalar Euclidean frame they do not share.**

**Line B's thesis (the buildable claim, stated soberly):** demote the Euclidean interval from
*belief* to *boundary adapter*, and make the native belief a **coupled ultrametric sheaf over
heterogeneous mixed-radix observer lines** — one line per sensor/modality, each with its own
context radix `Ω`, prefix, and cover. Fusion becomes the search for the **deepest compatible
(forced) common prefix** across the coupled lines; where no admissible coupling exists, it
**refuses** — the same discipline as the Rung-5 bridge, lifted off the scalar line.

```
sensorimotor event  →  per-observer mixed-radix line  →  stalk cover  →  coupling  →  forced common prefix
```

**No new mathematics is claimed** (standing verdict; `NOVELTY.md`). And — **goal corrected
2026-06-30** — Line B is **not** required to *outperform* a uniform tree, and "beats the octree" was
the wrong target (the first screen chased it; see §0.5). It does not need to do anything an octree
cannot. The goal is to **define, formalize, and make buildable** a *generalized selection / partition
mechanism* (§0.5). The contribution is the **formalized, parameterizable engineering framework + the
verified artifact** — that it *exists, is well-defined, sound, and faithfully represents selections no
smooth/closed-form rule can express* — not a benchmark win. Line A is **demoted, not deleted** — the
classical baseline and a valid local stalk adapter.

This is **not** "abolish all Euclidean representation," not a new capability, and not a
consciousness/embodiment metaphysics. It is one constructive question: *can the arbitrary, live,
cross-dimensionally-filtered selection a system actually needs be formalized as one general structure
— a union of mixed-radix cells over the coupled complex, projected onto the base space?*

## §0.5 The actual goal — formalize the generalized selection mechanism (owner correction, 2026-06-30)

The first screen, and my F-B7 "fix," chased the wrong target (*does mixed radix beat an octree*). The
real goal, restated by the owner: **the structure need not do anything a uniform tree cannot — it
needs to be *defined, existent, and formalized* as a general engineering framework.**

The motivating picture: a 3-D field of voxels; you want to **select / segment** a subset for which
there is **no smooth or closed-form boundary**. The selection is a **living fabric over incoming
sensor data** — live, updating in real time; **no simple rule** defines the partition; the selection
carries a **temporal pattern**; and it **couples to dimensions outside the 3-D space** that impose
**filtration constraints**, because the 3-D field is itself a **projection (implicate) of a
larger-dimensional structure**.

That object — *an arbitrary, live, temporally-patterned, cross-dimensionally-filtered selection over a
base space that is the projection of a higher-dimensional coupled complex* — is exactly a **union of
mixed-radix cells over the coupled observer lines, projected onto the base coordinate.** FDRS already
owns every piece:

| The need | The FDRS object |
|---|---|
| arbitrary selection, no closed form | a **union of cells** — `fuseU` / `cover` (not a shape; any sub-cover) |
| live / real-time update | the **Stok stack** / Rung-3 predict→update — a time-indexed sequence of selections |
| temporal pattern | recurring invariant cells in the sequence = "objects"/segments (Phase 14) |
| coupling to outside dimensions = filtration | the **`Coupling`** relation across observer lines (cuts the joint admissible set) |
| 3-D is *implicate* of a higher structure | the base = a **coordinate projection/restriction** of the coupled complex; Thm 91 (scalar-trace no-go) is exactly why it is *not* a global chart |

**Line B's deliverable = formalize this as one general, parameterizable structure** — the `Selection`
(§3, obj 7): a Lean object + soundness lemmas, and a Rust framework instantiable per system. The win
is **definability + faithfulness + generality**, not outperformance.

*Hardening (carried from §1):* "implicate from a larger-dimensional structure" is, formally, a
**coordinate projection / restriction** of the coupled complex onto the base sub-space — the
philosophical (Bohm-flavoured) framing is *motivation*; the substrate is the projection. No new math;
the contribution is the formalized framework + the artifact.

## §1 Substrate first — what is certified vs what is only a picture (the hardening)

The architectural discussion that motivated Line B carried grand framing ("hyperbolic continuum,"
"abolish floats," "space is the residue of coupling"). **The substrate must stay integer-first;
the pictures are optional.** This section is load-bearing and pre-committed:

| Concept | Status | Rule |
|---|---|---|
| Integer prefix ancestry, LCP, admissible transition, `netDist` | **SUBSTRATE (certified)** | the control state is always these |
| Poincaré disk / hyperbolic embedding | **OPTIONAL RENDERING** | a *view* of the prefix complex; **never** holds control authority; no float coordinate ever feeds planning |
| Sheaf Laplacian (stalk variance) | **inconsistency *energy*** | it **measures disagreement**, it does not "find truth"; truth is certified only where restrictions agree or the surviving cover forces a common prefix |
| Motion | **address rewrite** at the control layer | actuators stay continuous at the hardware boundary (PWM, voltages); they are quantized into certified integer transitions *before* affecting planning |
| Base 0 | **non-emitting substrate** (`PlaceKind::SubstrateZero`) | never an ordinary positional radix; kept out of division/modulo digit arithmetic (Phase-9 base-0 sea) |
| Octree / quadtree / voxel grid | **local adapter inside a stalk** | a permitted backend for one local spatial stalk; **never** the global ontology / world model |

The single anti-pattern Line B exists to avoid: *replacing `(x,y,z)` with a giant hyperbolic
octree and believing the epistemology changed.* It changed only if the **base object is the
coupled sensorimotor radix complex**, and spatial cells appear only as derived, local,
context-dependent stalks.

## §2 Existing FDRS items leaned on (the proven floor)

| FDRS item | Exact name / where | Used in Line B for |
|---|---|---|
| Context-dependent radix oracle | `Ω: Σ* × C → ℕ≥2`, `RadixLaw` (Phase 7, `docs/fdrs.md §7`; `Modes/VariableRadix/`, `Modes.lean` Mode II) | each **observer line's branching** is `b_k = Ω(prefix, context)` — radix gated by intention/body/sensor state |
| Mixed-radix space | `RadixSeq`, place values `Bₘ = ∏ bⱼ` (Core/Primitives/RadixSeq.lean) | heterogeneous per-line bases `[b₀,b₁,…]`; the suffix-product digit encoder |
| Cylinder / cover / LCP | `cover_of`, `commonPrefix`/`lcp`, `force_sound`, `fuseU`, `dissent` (Rung-5 toy `FdrsSensorFusion.lean`) | a line's **local stalk cover**; fusion-by-intersection; **forced common prefix** = certified readout |
| Observer-glued ultrametric | `netDist = sup_v δ_{G_v}` (Thm 92, `Modes/SyntheticPlace/NetworkGauge.lean`) | cross-line distance: "how much do the observer timelines disagree" — the fusion/refusal driver |
| Scalar-trace no-go | Thm 91 (`Modes/SyntheticPlace/TraceGeometry.lean`) | the **anti-global-chart prior**: a scalar metric cannot price concurrency ⇒ no single Euclidean frame |
| Synthetic place complex | Phase 14 (Defs 192–200) | an "object" = an **invariant node** in the sensorimotor sheaf, not a coordinate |
| Base-0 sea | `Modes/BaseZeroSea/` (wall/wire, occupancy, cyclic odometer) | the **non-emitting substrate** place type (`SubstrateZero`) — latent/transition states |
| Graded disagreement | `dissent`/`dissent_perm` (P-B, already ADOPTED) | the per-line health/disagreement score the coupling thresholds on |

**Honest scope of the floor:** `netDist` (Thm 92) and `Ω` (Phase 7) are proven *as corpus objects*;
their **application to heterogeneous sensor lines is new wiring, not a new theorem**. The Rung-5
`cover_of`/`lcp` live in the *toy*, not the corpus. Nothing here promotes a Line-B object to the
corpus before a confirmed screen (G4).

## §3 Core objects (formalize **only if** the screen survives)

Each an outline (intent · FDRS parent · informal · what Lean/Rust would assert · `proof_wanted`).
Per the family discipline: an object being *definable and sound now* is an **artifact control, not
a finding**.

1. **`PlaceKind`** — *intent:* keep base-0 out of digit arithmetic. *Parent:* base-0 sea.
   *Informal:* `enum PlaceKind { Radix(b≥2), SubstrateZero }`. *Assert:* `encode`/`cover_of` are
   defined only on `Radix` places; `SubstrateZero` is inert (no div/mod). *proof_wanted:* none (a
   data definition + a well-formedness lemma — provable now, artifact control).
2. **`ObserverLine`** — *intent:* one sensor/modality's address space. *Parent:* `RadixLaw`/`Ω`,
   `RadixSeq`. *Informal:* `{ places: [PlaceKind; W], Ω: (prefix,ctx)→PlaceKind, prefix, cover }`.
   *Assert:* `b_k = Ω(prefix,ctx)`; place values from suffix products `B_i = ∏_{j>i} b_j`.
   *proof_wanted:* `encode_mixed_digits` correctness (provable now).
3. **`Stalk`** — *intent:* sensor-specific evidence at a prefix. *Parent:* the cover/cell. *Informal:*
   local evidence (interval-runs, symbolic state, or event id) attached to a node. *proof_wanted:* none.
4. **`Coupling`** — *intent:* admissible cross-line relation. *Parent:* none direct (the new content).
   *Informal:* a relation saying which prefixes on different lines are jointly admissible (e.g.
   `forward ⊗ bump → blocked`). *Assert:* decidable; closed under prefix-restriction. *proof_wanted
   (empirical):* that the coupled belief refuses exactly where no admissible joint prefix exists.
5. **`SheafBelief` + `Fusion`** — *intent:* the native belief + its fusion. *Parent:* sheaf
   restriction; `netDist`; `fuseU`. *Informal:* a family of stalk assignments + compatibility
   constraints; fusion = common refinement / pullback over compatible prefixes. *Assert:* fusion is
   order-independent (confluent, cf. `fuseAll_confluent`) and sound (contains the true joint state).
   *proof_wanted (empirical):* the soundness/confluence lift to the coupled case.
6. **`ForcedReadout`** — *intent:* the certified location. *Parent:* `lcp`/`force_sound`. *Informal:*
   the deepest prefix forced jointly across all active lines; on disagreement, the multiline LCP
   (ascend); on no admissible coupling, refuse. *Assert:* `force_sound` lifted across lines.
   *proof_wanted:* the lifted forcing lemma.
7. **`Selection`** — *intent:* **THE deliverable** (§0.5) — the generalized selection / partition
   mechanism. *Parent:* `fuseU`/`cover` (union of cells) + `Coupling` (filtration) + base projection.
   *Informal:* a `Selection` is a **union of admissible joint cells** over the coupled complex — a
   sub-cover of `∏ lines` cut by the `Coupling` constraints — equipped with (i) a **live update** map
   `evidence-stream → time-indexed Selection_t` (the living fabric), and (ii) **base projections**
   `π_B : Selection → Cover_B` so the selection in a chosen sub-space (e.g. the 3-D voxel line) is the
   *shadow* of the joint selection (implicate→explicate). *Assert (the formalization):* `Selection_t`
   is a valid cover at every `t`; filtration only **removes** admissible cells (never invents —
   `condition_le` echo); `π_B` **commutes with update** (projecting then updating = updating then
   projecting); refusal = the empty selection. *proof_wanted:* the well-formedness + projection-commute
   + filtration-soundness lemmas — the heart of Line B's Lean rung. **Not required to be smaller or
   simpler than a uniform partition — required to be definable, live, projectable, and sound.**

> **Discipline:** objects 1, 2, 6, 7 contain lemmas **provable now** (encoder correctness, forcing
> soundness, `Selection` well-formedness) — these are the **deliverable**, not artifact controls to be
> beaten: per §0.5 the goal is the *formalized general structure existing and being faithful*, not an
> empirical out-performance. Objects 4, 5 (the coupling/fusion soundness) are the supporting properties.

## §4 Why mixed-radix *multi-line* coupling "starts to make sense" here

A flat interval map is one-dimensional and homogeneous: it assumes every sensor reports into the
same scalar coordinate. Real embodied fusion does not. Coupling becomes *necessary* exactly where a
single line cannot preserve the structure:

1. **Different rates** — fast IMU, slow sonar, event-based bump. One timeline either oversamples the
   slow sensor or drops fast events; separate lines keep each clock (this is the Rung-4 multi-rate
   result, lifted off the shared scalar).
2. **Different uncertainty geometries** — sonar branches by range band, vision by patch, bump by
   contact/no-contact. Not the same base `b`. Mixed radix is the only honest container.
3. **Different control relevance** — under `Explore` the gauge opens outward; under `Survive` it
   collapses toward known-safe parent prefixes. Same readings, different admissible branches — `Ω`
   gated by intention.
4. **Non-spatial objects** — a "wall" is not first a coordinate; it is a **stable coupling**
   (`forward motor-phase ⊗ bump-contact ⊗ no-optical-flow ⊗ halted-displacement`). The invariant
   *is* the object (Phase 14).
5. **Conflict** — camera "open" vs bump "blocked" is **not averaged**; the system ascends to a safer
   common prefix or refuses the transition.

The combinatorial explosion does **not** vanish; it is **controlled by embodiment** — `Ω` admits a
branch only if the body/intention/sensor stack can instantiate it, branches are lazily realized,
stalk disagreement prunes early, intention gates the radix, safety collapses the gauge upward. That
control is itself a falsifiable claim (F-B2), not an assumption.

## §5 Hypotheses + pre-registered falsifiers

- **H-B1 (non-degenerate representation).** The coupled observer-line belief preserves disjoint
  per-line / per-modality structure that a single Euclidean interval/cover **collapses** (e.g. two
  sensors agreeing on range but disagreeing on modality stay distinguishable). *F-B1:* the native
  belief degenerates to the same interval map — no structure the Line-A cover lacks. Then Line B is
  a re-skin; kill it.
- **H-B2 (embodiment economy — the octree is a *strawman*, not a yardstick).** The agent instantiates
  only `Ω`-admitted branches; the eager octree/uniform partition is the *wrong tool* (it pre-allocates
  the whole reachable volume **and** has no axis for the non-spatial intent/modality distinctions).
  *F-B2:* the `Ω`-tree instantiates ≥ the octree's cells. **Quantified caveat (run 2026-06-30, N-B1):
  generic laziness (materialize-on-visit, Phase 7 Thm 46 — which Line A could equally adopt) accounts
  for most of the "7 vs 96" gap; the *embodiment-specific* economy beyond a blind lazy octree was only
  2 branches on the toy. The "matched spatial resolution" comparison is RETIRED — it re-imports the
  octree as the frame (fraud gallery). **H-B2 is now a *secondary diagnostic* only — per the §0.5
  owner correction the line's deliverable is the formalized `Selection` (H-B7), not any economy or
  out-performance.**
- **H-B7 (the `Selection` is well-defined, sound, and faithful — THE deliverable; goal corrected
  2026-06-30).** The generalized selection mechanism (§3 obj 7) is **formalizable as one general
  structure** — a union of mixed-radix cells over the coupled complex, with a live update and a base
  projection — satisfying *well-formedness* (a valid cover at every `t`), *filtration-soundness* (the
  `Coupling` only removes admissible cells, never invents), and *projection-commute* (project-then-update
  = update-then-project). And it **faithfully represents the §0.5 example** — an arbitrary, no-closed-form,
  live, temporally-patterned, cross-dimensionally-filtered voxel selection — *without special-casing*.
  *F-B7 (re-posed):* the structure **cannot be defined cleanly** — it collapses to a trivial set, needs
  ad-hoc per-case rules (not general), the projection fails to commute, or the example needs structure
  the framework cannot express. Then the generalized selection mechanism does not exist as claimed.
  **F-B7 is NOT "a uniform base reproduces it" — the structure need not beat any uniform tree; it needs
  to EXIST, be sound, and be general** (the prior "octree in disguise" wording is retracted).
- **H-B3 (cleaner refusal).** Multiline coupling refuses **exactly** when no admissible joint prefix
  exists, and this boundary is cleaner (fewer false refusals at numeric seams, fewer false accepts of
  cross-modality conflict) than Line-A interval consensus. *F-B3:* no refusal/ambiguity improvement
  over Line A — no engineering win.
- **H-B4 (LCP keeps control resolution).** Ascending to the multiline LCP on disagreement still
  leaves an admissible transition to choose (the agent can act). *F-B4:* LCP coarsens to uselessness
  — over-aggressive refusal, the agent stalls.
- **H-B5 (`Ω` is concrete + cheap + deterministic).** The context oracle is a specified, cheap,
  deterministic exact-integer function (a table or closed form), not a hand-wave. *F-B5:* `Ω` cannot
  be specified deterministically/cheaply — the architecture rests on an unspecified magic function.
- **H-B6 (substrate-first invariant).** The control state is integer-prefix-first throughout; any
  hyperbolic rendering or actuator float is a boundary adapter with **no** planning authority. *F-B6:*
  a float/rendering value re-acquires control authority — the epistemology did not actually change,
  the §1 hardening failed.

The screen tests H-B1…H-B4 directly; H-B5 is discharged by *specifying* `Ω` as a concrete table in
the screen; H-B6 is a structural invariant audited in the artifact (no float on the control path).

## §6 First exact screen (pre-registered design; SageMath exact)

A toy embodied agent with four observer lines, exact/symbolic — no floats, no Burn (small):

```
intent_line   : Ω → [Explore, Survive]
motor_line    : Ω → [forward, turn_left, turn_right, halt]
contact_line  : Ω → [clear, bump]
range_line    : Ω → [open, blocked, unknown]   (or [near, mid, far])
```

Couplings (the concrete `Ω`/admissibility table — discharges H-B5):
`forward ⊗ bump → blocked` · `forward ⊗ clear ⊗ far → descend/explore` ·
`survive ⊗ bump → ascend/retreat` · `explore ⊗ open → branch outward`.

Pre-registered measurements, each tied to a hypothesis:
- **branch count** (active `Ω`-admitted prefixes over a scripted trajectory) **vs** an octree /
  uniform-interval partition at matched spatial resolution → H-B2 / F-B2.
- **refusal map**: where the coupled belief refuses vs where Line-A interval consensus refuses, on a
  cross-modality conflict battery (agree-on-range/disagree-on-contact, seam-straddle, etc.) →
  H-B3 / F-B3.
- **control resolution after LCP**: does an admissible transition survive the ascend on each
  disagreement case → H-B4 / F-B4.
- **degeneracy check**: is there a multi-sensor state the coupled belief distinguishes that the
  single interval cover cannot → H-B1 / F-B1.
- **substrate audit**: no float on the control path; rendering (if any) is read-only → H-B6 / F-B6.

A passing result is **not** new math; it is: *the coupled observer-line formulation represents the
ambiguity battery with fewer irrelevant branches and a cleaner refusal boundary than Euclidean
interval projection, with a concretely specified `Ω` and no float in the control loop.*

## §7 Honest scope & promotion

- **No new mathematics** (`NOVELTY.md` extends to Line B). The corpus objects (`Ω`, `netDist`,
  `cover_of`) are reused; the new content is the **coupling relation + the multiline forcing/fusion
  wiring** and **the verified artifact**. The "win," if any, is engineering economy + cleaner
  refusal, measured against Line A.
- **Line A is demoted, not deleted** — it is the classical baseline *and* a valid local stalk
  adapter. The comparison is the experiment; replacing it is not the goal.
- **Tooling:** SageMath for the exact screen (couplings + prefix search are exact/symbolic). The
  Rust `fusion-core` gains the new chart objects (`PlaceKind`, `ObserverLine`, `encode_mixed_digits`,
  `Coupling`) **as additive modules** — the existing `Cover` stays as the `Stalk` backend; nothing in
  the proven core is removed. Burn only if a later screen needs tensor/GPU scale (not the toy).
- **Promotion (G4, only on confirmation):** the artifact-control lemmas (`PlaceKind` well-formedness,
  `encode_mixed_digits`, the lifted `force_sound`) are clean facts depositable to `FdrsFormal/` /
  the toy independently; the empirical couplings (H-B1…H-B4) become `conjecture`-marked only after the
  screen. The two-repo boundary and pre-registration-before-results gate (`ADR-007`) hold throughout.

Falsifiers F-B1…F-B6 are pre-registered in `NEGATIVE.md`; the fraud gallery there names the traps
(hyperbolic-as-substrate, abolish-octrees overclaim, coupling-as-new-math, base-0-as-radix) before
any run. Nothing committed, nothing pushed.

---

## Rung B-2 — formalize the `Selection` + faithfully represent the hard example (re-posed 2026-06-30)

**Re-posed per the §0.5 owner correction.** The earlier Rung B-2 (does mixed radix *beat* a uniform
base — waste/loss accounting) is **retracted**: the structure need not outperform anything. The first
screen (`runs/2026-06-30-lineb-screen/`, 6/6) confirmed the *plumbing* (concrete `Ω`, substrate-first,
cleaner refusal on designed cases). Rung B-2 now does the real job: **define the `Selection` (§3 obj 7)
as one general structure, prove its well-formedness, and show it faithfully represents the §0.5
example** — committed before it runs.

**The deliverable (two parts):**
1. **The formal structure (the Lean rung — Line B's first proofs).** Define `Selection` =
   union-of-cells over the coupled complex + `Coupling` filtration + base projection `π_B`, and prove:
   *well-formedness* (valid cover ∀ `t`), *filtration-soundness* (`Coupling` only removes — the
   `condition_le` echo), *projection-commute* (`π_B ∘ update = update ∘ π_B`), and *refusal = ∅*. These
   are the `proof_wanted` of §3 obj 7 — provable now; they ARE the contribution, not artifact controls.
2. **The faithful-representation screen (SageMath exact).** Instantiate the §0.5 example and show the
   one `Selection` structure expresses it **without special-casing**:
   - **arbitrary / no closed form** — select a voxel set with a deliberately non-smooth, non-analytic
     boundary; represent it exactly as a union of mixed-radix cells (no shape primitive used).
   - **live** — drive it with a sensor stream; the `Selection_t` updates each tick; show the time
     sequence is a function of the stream, not a recomputed-from-scratch global.
   - **temporal pattern** — exhibit a recurring invariant cell across `t` (an "object"/segment) that the
     sequence makes explicit.
   - **cross-dimensional filtration** — a constraint on a line *outside* the 3-D base (e.g. an intent or
     a modality line) prunes admissible voxels; show the base selection changes although no spatial
     reading did — the filtration from outside the base space.
   - **implicate / projection** — define the base voxel field as `π_B` of the coupled complex; show the
     selection in 3-D is exactly the shadow of the joint admissible set, and `π_B` commutes with the
     live update (the explicate selection tracks the implicate one).

**Measurements (pre-registered) — definability/faithfulness, NOT competition:**
- the Lean lemmas (1) build, 0 sorries, axiom-clean (or honestly report which resist);
- the screen (2) reproduces each of the five properties on the example with **one** parameterization of
  `Selection` (no per-property special case) — record any property that needs structure outside the
  framework as an `F-B7` hit;
- the base multiset is genuinely heterogeneous *because the example demands it* (not as a target to
  beat a uniform base — heterogeneity is *used*, not *contested*).

**Tooling:** SageMath exact (cells, suffix-product place values, projection, the coupling filtration are
exact-integer — closes the N-B5 Sage→stdlib deviation). No floats on the control path (H-B6 carried).

**Honest stop condition (re-posed).** F-B7 now fires only if the `Selection` **cannot be defined
cleanly / generally** — it needs ad-hoc per-property rules, the projection does not commute, or the
example needs structure the framework cannot express. Then the generalized selection mechanism does not
exist as one structure, and that is the real negative. It does **not** fire merely because a uniform
tree could also represent the example — the deliverable is existence + faithfulness + generality, not
out-performance. Line A remains the proven track throughout.

# Theory track — fdrs-theory-expansion (Line A: Structured Information · Line B: The Emergent Group-Graded Complex)

**Posture (`ADR-008` / standing novelty verdict): no new mathematics is claimed.** FDRS supplies proven objects; the contribution would be a *connection* (information theory ↔ FDRS objects) and a *verified artifact*, never "FDRS-novel theory." The classical floor — Kolmogorov ε-entropy, Hartley information, functional ANOVA, Kraft — is named explicitly so the empirics must beat it, not re-skin it. **No Lean/Sage code here — outlines only.**

The whole line lives on one distinction, mirroring the existence/recurrence discipline of sibling families:

1. **Definability (existence).** Every candidate measure below is *soundly definable now* — `coverEntropy` is a valid certified-cover count, a row is a mass partition, the float denominator is 2-power. **Content-free as a finding; an artifact control.** (NEGATIVE.md.)
2. **Reach & extension (the empirical question).** Whether the measure *discriminates*, *means* its classical referent, *reaches* structure the variance face cannot, and *extends* rather than *renames*. Everything below serves reading 2; reading 1 is never a result.

---

## Part A — Existing FDRS items leaned on (the proven floor)

| FDRS item | Exact name / notation | Lean home | Used here for |
|---|---|---|---|
| Explained-variance ratio | `rSquared T f = explainedVar / totalVar` | `Analysis/DigitConditional/Complexity.lean` | the **captured-structure fraction** (variance face of `S_T`); H3 tree probe |
| ANOVA / Parseval decomposition | Thm 65: `f = μ + Σ g_v`, `‖f−μ‖² = Σ‖g_v‖²`; `orthogonalDecomposition_parseval` | `Analysis/DigitConditional/Decomposition.lean` | the **variance face of total correlation** (the "sum reading"); the orthogonal layers `g_v` = per-scale structure |
| Fourier/Vilenkin ceiling | Thm 66: no single mode captures `> α`; `FourierCeiling` | `Analysis/DigitConditional/FourierCeiling.lean` | the **character basis**; H3's parity-capture face |
| Representation gap | Thm 67: `Gap = b₀·lcm(rⱼ)/Σrⱼ`; `RepresentationGap` | `Analysis/DigitConditional/RepresentationGap.lean` | exact cell-count cost of heterogeneity (a coding/ε-entropy quantity) |
| Homogeneous collapse | Thm 69: tree-features → uniform Fourier; `SpecialCase` | `Analysis/DigitConditional/SpecialCase.lean` | the **degenerate baseline**: where non-stationary = stationary (H4 anchor) |
| Haar / wavelet-packet contrast basis | ONB, Parseval/completeness | `FunctionSpaces/Haar/ContrastBasis.lean`, `WaveletPacket.lean` | the orthonormal multiscale basis; the character side of H3 |
| Certified cover (ε-cover) | `cover_of`, `cover_of_interval_sound`; `lcp`, `force_sound` (Rung 5) | sensor-fusion toy `lean/FdrsSensorFusion.lean` | **`coverEntropy = log₂\|cover_of f d\|`** — the constructive metric-entropy candidate (H1/H2) |
| Four-corner emission trap | `emit_traps`; `BihTensor`; "emit a digit only when forced" | `Modes/VariableRadix/BihomographicSound.lean` | the **zero-error / certified** discipline (anti-fishing); the per-instance information floor |
| Place value / Kraft cost | `placeValue Bₖ = ∏ bⱼ`; `Σ 1/Bₖ < 2` (`tick_expected_complexity`); `touchComplexity` | `Integration/Complexity/Definition.lean` | the **coding-cost branch**; the non-stationary `log bₖ` budget (H4) |
| Mixed-radix space | `RadixSeq`, place values `Bₘ` (Def 1–4) | `Core/Primitives/RadixSeq.lean` | the **non-stationary, function-defined alphabet** — the setting (H4) |
| Network gauge / observer distance | `netDist = sup` over places of `gaugeDist` (Thm 92) | `Modes/SyntheticPlace/NetworkGauge.lean` | the **observer-relative gluing** of per-place information (H5) |
| Scalar-trace no-go | `scalar_trace_metric_no_go` | `Modes/SyntheticPlace/TraceGeometry.lean` | the "no global chart" prior — entropy is a derived, observer-relative read |

**Honest scope of the floor:** `digitConditionalComplexity := N` is a *placeholder* (its own docstring flags `sInf`-over-trees as formalization debt); `minUniformCells` likewise. They are cited as prose, never as formalized measures. `cover_of` lives in the sensor-fusion *toy*, not the corpus; promoting `coverEntropy` to the corpus is a G4 step, not an assumption.

---

## Part B — Candidate new definitions (formalize **only if** empirics survive)

Each an outline: intent · FDRS parent · informal · what a Lean formalization would assert · the `proof_wanted` it seeds. None enters the corpus before a confirmed empirical claim (G4, `ADR-007`).

1. **`coverEntropy`** — *intent:* constructive metric ε-entropy. *Parent:* `cover_of`, `cover_of_interval_sound`. *Informal:* `coverEntropy f d := log₂ |cover_of f d|`. *Formalize:* the **soundness lemma** — the true value lies in one of the counted cells, so `coverEntropy` bits are *certifiably* resolved (an upper bound on distinguishable information). *proof_wanted:* `coverEntropy_sound` — **provable now; an artifact control, not a finding.** The *finding* is H1 (discrimination) + H2 (it equals metric entropy).

2. **`metricEntropyScaling`** — *intent:* the calibration object. *Parent:* `coverEntropy` + a function class. *Informal:* slope of `log coverEntropy` vs `log(1/ε)`. *Formalize:* on a Lipschitz/Hölder model, the slope is `1/α`. *proof_wanted (empirical):* H2 as a `conjecture`-marked scaling, only after the Sage screen.

3. **`nonStationaryEntropy`** — *intent:* entropy over a function-defined alphabet. *Parent:* `RadixSeq`, `placeValue`. *Informal:* `Hₙₛ(f) = Σₖ Hₖ(f \| prefix)`, max per place `= log bₖ` (position-dependent). *Formalize:* additivity over places; the Kraft bound `Σ 1/Bₖ < 2` as the cost dual (already proven as `tick_expected_complexity`). *proof_wanted (empirical):* H4 — that `Hₙₛ ≠` any fixed-base `H`.

4. **`treeStructuredInformation`** — *intent:* the variance face of `S_T`. *Parent:* `rSquared`, `orthogonalDecomposition_parseval`. *Informal:* `Sᵥₐᵣ(f, T) = explainedVar(T) = Σ_{v∈T} ‖g_v‖²`. *Formalize:* monotone in tree refinement; `= ‖f−μ‖²` at full depth (this is Thm 65). *proof_wanted:* the monotonicity lemma is *provable now*; the **correspondence to total correlation** is the connection, not a theorem.

5. **`characterSynergy`** — *intent:* the higher-order extension the variance face can't see. *Parent:* `FourierCeiling`, the Haar–Vilenkin contrast basis. *Informal:* energy in characters absent from every lower interaction order (parity = one Walsh coefficient, zero tree variance). *Formalize:* the interaction-order grading of the Vilenkin basis; synergy = top-order energy. *proof_wanted (empirical):* H3 — the genuine native extension, **only if** the parity screen confirms the character route.

6. **`observerEntropy`** — *intent:* observer-relative information. *Parent:* `netDist`, `scalar_trace_metric_no_go`. *Informal:* per-place `Hₚ`, glued `Hₒᵦₛ = sup_p Hₚ` (or the `netDist`-weighted form). *Formalize:* the **data-processing inequality** under coarsening; non-domination. *proof_wanted (empirical):* H5 — `observerEntropy` is an entropy (obeys DPI), only after the toy screen.

> **Discipline:** definitions 1 and 4 contain lemmas **provable now** (cover soundness; ANOVA monotonicity) that are **artifact controls, not findings**. Stating them in Lean *first* makes the empirical conjectures (2, 3, 5, 6) honest — each must beat exactly the structure the provable lemmas already account for.

---

## Part C — A sharp prior FDRS already implies (a prediction, not a hope)

The corpus already proves the boundary that decides Line A's scope. Thm 65 (`orthogonalDecomposition_parseval`) is a **second-order** decomposition: it apportions *variance*. Thm 66 (`FourierCeiling`) is about *single-mode* energy capture. Composed, they imply:

> **A signal whose information is pure top-order synergy (parity / a Walsh function) carries zero variance at every tree level** — the ANOVA layers `g_v` are all zero — **yet is a single character.** So the tree/cell information measures (`rSquared`, `treeStructuredInformation`) *must* report ≈ 0 on parity, while the Vilenkin/Haar basis reports it exactly.

This is H3 stated as a prediction FDRS makes about itself. Its consequence is structural, not incidental: **the variance branch is the Gaussian shadow of information theory; the genuine higher-order extension is not a new term on the tree but a switch to the character basis — machinery the corpus already owns (`FourierCeiling`, `WaveletPacket`, `ContrastBasis`).** If the parity screen instead found a *tree* capturing parity, that would contradict FDRS itself and demand the artifact controls before any excitement.

This gives the line a built-in skeptic: any claim that the tree-cell measures capture synergy is, by FDRS's own theorems, suspect.

---

## Part D — Promotion path (`ADR-007` §4)

- Confirmed claims become `proof_wanted` / `conjecture`-marked declarations under `projects/fdrs-formal/FdrsFormal/Conjectures/` (does not yet exist; created only when the first claim is ready — never pre-emptively).
- The provable artifact-control lemmas (defs 1, 4) can be contributed to `fdrs-formal` independent of any empirical result — they are clean facts that harden the corpus regardless of what the screens find. `coverEntropy_sound` is the natural first deposit.
- Two-repo boundary applies: family in HiR repo, conjecture layer in `fdrs-formal`; a promotion PR references the run transcript by stable path.

---

## Part E — The Senchal crossover (Observer Theory ↔ FDRS, located)

S. A. Senchal's *Operationalising Observer Theory* (Wolfram Inst., 2026 draft) hardens Observer Theory by writing a **compute budget `T` into an information measure** (epiplexity), yielding `S_T` (captured structure) and a falsifiable `Q_T ≠ Φ` against IIT. It is an **information-decomposition** programme (PID [Williams–Beer], total correlation [Watanabe], connected information [Schneidman], synergy). FDRS holds the **variance/certified mirror** of that apparatus:

| Senchal (information / bits) | FDRS (variance / certified) | FDRS Lean object |
|---|---|---|
| `S_T` — captured structure at budget `T` | `rSquared` / `treeStructuredInformation` — captured-variance fraction | `Complexity.lean`, Thm 65 |
| GC1: `S_int(t) → ceiling` without overshoot | `rSquared → 1` as the tree refines (the DCC `R² ≥ 1−ε`) | `Complexity.lean` |
| total correlation `I(F_O) = Σφ` (the sum reading) | Parseval `‖f−μ‖² = Σ‖g_v‖²` | `orthogonalDecomposition_parseval` |
| domains / partition the decomposition is over | the radix tree cells; the observer's individuated parts | `Tree.lean`, `RadixSeq` |
| compute budget `T` | tree **depth** (+ `touchComplexity` for the cost side) | `Definition.lean` |
| synergy `Q_T` = structure no partition reconstructs | top-order character energy (deep contrasts) | `FourierCeiling`, `ContrastBasis` |
| observer-relative `S_T` (vs IIT's objective Φ) | `netDist`-glued, no global chart | `NetworkGauge.lean`, `TraceGeometry.lean` |

**The sharp boundary (and the line's whole point):** FDRS's variance face captures everything Senchal's `Σφ` total-correlation does **except** pure higher-order synergy — and `Q_T` (parity, the `Q_T ≠ Φ` result) is his entire novel content. So FDRS already holds the **L² skeleton** of his information theory, proven in Lean; the missing layer is exactly the character-basis synergy of **H3 / Part C**. The crossover is filed as motivation and an independent convergent framing — **never** as an FDRS result, and not a claim about consciousness (`Q_T = experienced qualia` has no FDRS counterpart and is out of scope).

---

# Line B — The Emergent Group-Graded Complex

**Posture (`ADR-008`): no new mathematics.** Line B is unusual for this family in that **its floor is not prose-adjacent theory but running Lean**: nearly every object is already machine-checked in `FdrsFormal/`, as *leaf* modules nothing yet composes. The classical floor — **Zaslavsky gain-graph balance**, flat connections / holonomy on graphs, SE(2) synchronization / pose-graph SLAM, Mazurkiewicz trace monoids, Zappa–Szép products — is named so the empirics beat it, not re-skin it. **No Lean/Sage code here — outlines only.** The single distinction (mirroring Line A): **definability** of the coupled group-graded complex is *provable-now* (an artifact control, content-free); the **finding** is observer-relativity (HB2) — a complex that is neither globally abelian nor globally non-abelian, but both, by what is observed.

## Part A (Line B) — Existing FDRS items leaned on (the proven floor — reused, not rebuilt)

| FDRS item | Exact name / notation | Lean home | Used here for |
|---|---|---|---|
| Group grading / holonomy dichotomy | `GroupGraph`, `Gradable`, `walkFactor`; `group_gradable_iff_trivial_holonomy` | `Modes/SyntheticPlace/GroupGrading.lean` | **the whole object**: a coupled complex is a `GroupGraph`; a global measure exists iff trivial holonomy (HB1/HB2/HB3) |
| Abelian (ℚ) grading + witnesses | `CouplingGraph`, `chainGraph_gradable`, `frustratedTriangle_not_gradable` | `Modes/SyntheticPlace/Grading.lean` | the abelian control (chains gradable) + the ℚ frustration witness |
| Non-abelian frustration witness | `frustratedSE2`, `frustratedSE2_not_gradable` | `Modes/SyntheticPlace/SE2Pose.lean` | a genuine non-abelian (SE(2)) non-gradable loop — order survives, measure dies |
| Non-abelian certified set-membership line | `PoseRegion`, `update`, `predict_sound`, `run_sound`; `bbox_sound`, `bilinear_ge`, `runPose_sound`; `tightTractable_run_sound` | `SE2Pose.lean`, `SE2Engine.lean`, `SE2Tight.lean` | the certified `Selection` **already lifted** to a non-abelian manifold (HB5); "soundness through non-commutativity is free" |
| Emergence-of-digit (manifestation) | `ManifestSpace`, `tickDigit` (`∅→0`) | `Integration/ThreeLineMediator/CoupledSystem.lean` | a digit born when carry first reaches it, **inside a coupling** (HB4) |
| Emergence-of-digit (sustainment) | `emergentEffectiveBase = observedStates.card`; wall/wire/digit | `Modes/BaseZeroSea/Modules.lean` | base earned against decay (`R = In−Out ≥ 0`) — the trichotomy (HB4) |
| Base-0/base-1 arithmetic | `ExtendedDigit.zero/.one`, `extendedEncode_wire`, `extendedBijection` | `Modes/ExtendedBase/Definition.lean` | the inert `SubstrateZero`/wire ↔ identity ratio wiring (HB4) |
| Observer-glued distance (scalar) | `netDist = sup_v gaugeDist_v` (Thm 92) | `Modes/SyntheticPlace/NetworkGauge.lean` | the gluing pattern the group grading must lift from scalar to group-valued |
| Scalar-trace no-go | `scalar_trace_metric_no_go` (Thm 91) | `Modes/SyntheticPlace/TraceGeometry.lean` | the "no global chart" prior — the schedule analogue of HB3 (order not measure) |
| Certified emission | `AdmissibilityTrap` (Thm 86); `emit_traps` (Thm 82) | `Modes/SyntheticPlace/AdmissibilityTrap.lean`, `Modes/VariableRadix/BihomographicSound.lean` | emit only when forced; refusal = safe hold (HB5) |
| Guarded execution | `guardedInstruction Instr(g,a) = M_g·T_a` | `Integration/RuntimeAlgebra/Definition.lean` | the command-step skeleton (single-line, abelian) to lift to the complex (HB5) |
| Abelian certified selection | `select_wellformed`/`condition_le`/`projection_commute`/`refusal_empty`/`force_sound` | sensor-fusion `lean/FdrsSelection.lean` | the abelian belief line the complex interweaves with the SE(2) line (HB5) |

**Honest scope of the floor:** `GroupGrading`, `SE2Pose/Engine/Tight` are **leaf** modules (nothing imports them); **no** module imports both `BaseZeroSea` (emergence) and `SyntheticPlace` (grading). So the stones are proven, the arch is not — the delta Line B builds is the *composition*, not any stone.

## Part B (Line B) — Candidate new objects (formalize **only if** the screen survives; each provable-now = artifact control)

1. **`CoupledComplex`** — a single `GroupGraph` over the disjoint union of per-place lines with cross-place coupling edges (group-valued ratios), heterogeneous places under one def (HB1). *proof_wanted:* well-formedness (a `GroupGraph`) — provable now.
2. **`observerRelativeGrading`** — **the crown (horizon-quantified per Amendment B1):** the ring family `ringGraph N r` + induced-ball restriction, with the **horizon law**: every radius-`k` ball is gradable iff `2k+1 < N` (sub-cycle balls = paths, the `chainPotential` pattern) while the whole is non-gradable (`walkFactor = r^N ≠ 1`); detection threshold = the ball first containing the unbalanced cycle. The grading analogue of the Thm 87 zoom-out ("the gauge prices observability" → *the holonomy prices non-abelianness*). *proof_wanted:* the **parametric horizon law** — the promotion crown. *(The un-quantified "local gradable / global not" is already witnessed by `frustratedTriangle` — an artifact control, not this object; see NEGATIVE FB2 re-pose.)*
3. **`emergentGrading`** — the wiring `manifest/sustain ↦ ratio`, `SubstrateZero/∅ ↦ 1`, with gradability preserved under manifestation (HB4). *proof_wanted:* preservation lemma — provable now if it composes.
4. **`certifiedCoupledStep`** — `Instr(g,a)` over the complex, gated by `AdmissibilityTrap`, emitting only when forced (HB5). *proof_wanted:* the lifted emission-soundness lemma.

## Part C (Line B) — The sharp prior FDRS already implies (sharpened by Amendment B1)

`group_gradable_iff_trivial_holonomy` + subgraph restriction **forces** the observer-relative reading: holonomy is a *cycle* property, so any acyclic view is gradable — which is exactly why the *un-quantified* "local abelian / global non-abelian" is a near-tautology (the triangle already witnesses it) and had to be re-posed. The **quantified** prior is the interesting one: an observer of horizon `k` can only see cycles of length `≤` its ball; the shortest unbalanced cycle has some length `L`; therefore *the abelian illusion persists exactly while `k` is too small to contain `L`* — the horizon law. On the ring family this is exact and provable (`gradable ⟺ 2k+1 < N`); the general-graph version ("detection horizon = shortest-unbalanced-cycle radius") is the promotion target. The screen's job is the machine-checked ring law + the two-way observer-relativity witnesses (same `k`, different `N`; same `N`, different `k`), and to check the re-posed FB2 cannot fire.

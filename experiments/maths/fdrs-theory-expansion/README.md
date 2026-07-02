# Experiment: FDRS Theory Expansion — extending proven FDRS objects into adjacent mathematics

**Charter stage (G0/G1): hypotheses, method, pre-registered falsifiers recorded. No runs yet.**
**Follows the FDRS experiments workflow (`ADR-007`); same shape as `fdrs-digit-conditional-activation` (the calibration family).**

- **Registry ID:** `experiment-fdrs-theory-expansion`
- **Upstream project:** `project-fdrs-formal`
- **Program:** `program-variable-representation`
- **Workspace:** `workspace-math-proof-env` (Lean + **SageMath** for exact/symbolic Python work; **Burn** for any tensor / GPU / kernel work)
- **Owner:** `volition-billy`
- **Scientific status:** **`charter`** (G0/G1; pre-registration before any execution)
- **Risk class:** low (internal, no external commitment, no IP disclosure)

---

## What this family is

An umbrella for investigations that **extend FDRS into adjacent mathematical territory** — taking objects already proven in the corpus and asking whether they host, or sharpen, a neighbouring theory. It is deliberately general: each pursuit is a numbered **investigation line** with its own hypotheses, falsifiers, and runs, sharing one workflow and one grounding discipline.

**Posture (inherited, `ADR-008` / the standing novelty verdict): no new mathematics is claimed.** FDRS supplies a vocabulary and a set of machine-checked facts; the contribution of any line is a **connection** (an outside theory ↔ FDRS objects) and a **verified artifact**, never "FDRS-novel theory." Each line must beat exactly the structure the *provable-now* facts already account for; anything that merely re-expresses a classical quantity is recorded as such, not as a win.

### Investigation lines

| Line | Title | Status |
|---|---|---|
| **A** | **Structured Information** — does FDRS's certified/variance machinery host (and extend) information theory? | **chartered + run (H1/H3/H6; §Line A)** |
| **B** | **The Emergent Group-Graded Complex** — is the coupled radix complex definable as *one* structure where abelian/non-abelian is **observer-relative** (a holonomy property), where digits **emerge into their grading**, and where certified **reactive commands** ride on top? | **chartered (this document, G0/G1; no runs; §Line B)** |

The charter below covers **Line A** (§ Line A) and **Line B** (§ Line B). Future lines are added by amendment, each pre-registered before execution.

---

## Line A — Structured Information

### Motivation (grounded in what is already proven)

A re-read of the corpus (2026-06-30) found that FDRS already carries the **two classical branches of information theory plus a cost measure**, machine-checked — see `THEORY.md` Part A for the exact Lean homes:

- **Combinatorial / zero-error branch (Hartley → Kolmogorov ε-entropy):** the certified-cover machinery (`cover_of` / `cover_of_interval_sound` in the sensor-fusion Lean toy; the corpus four-corner trap `emit_traps`) constructs an ε-cover into a finite number of *certifiably distinguished* cells. `log₂(cell count)` is a metric-entropy quantity, and FDRS produces it **constructively and per-instance** (a forced digit is a proof you can distinguish).
- **Statistical / second-order branch (Shannon's Gaussian face):** `rSquared` (captured-variance fraction) and the ANOVA/Parseval orthogonal decomposition `‖f − μ‖² = Σ‖g_v‖²` (`orthogonalDecomposition_parseval`, Thm 65) are the variance face of mutual information and total correlation.
- **Cost / coding branch:** `touchComplexity` + the amortised `Σ 1/Bₖ < 2` bound (`tick_expected_complexity`) — a Kraft/place-value description cost.

All three live over a **non-stationary, function-defined alphabet** (`RadixSeq`, base `bₖ` varying per position) and admit an **observer-relative gluing** (`netDist = sup` over places). An independent, convergent framing — Senchal's *Operationalising Observer Theory* (Wolfram Inst., 2026 draft) — builds an entire programme on information decomposition (PID, total correlation, connected information, a budget-`T` "structured information `S_T`"); the FDRS objects above are the variance/certified mirror of exactly that apparatus. `THEORY.md` Part E maps the crossover.

**The question Line A asks is not "can we define an information measure in FDRS" — soundness of the candidate measures is *provable now* and is an artifact control, not a finding. The question is whether those measures (a) discriminate, (b) mean what classical theory means, (c) reach the structure FDRS's variance face cannot, and (d) genuinely *extend* rather than merely *rename*.** Those are empirical and decide the novelty honestly.

### Hypotheses

Each is pre-registered with its mechanism, the proven FDRS object it leans on, and its falsifier. Soundness of every candidate is settled in Lean; these test *value and reach*, not correctness.

1. **H1 (Discrimination — the non-vacuity screen).** `coverEntropy f d := log₂|cover_of f d|` **separates structured from unstructured signals**: monotone non-decreasing in depth `d`, small for low-information signals (constant, periodic) and large for high-information ones (generic, i.i.d.), across the canonical battery. *Mechanism:* a certified cover of a structured value collapses to few cells (shared prefix forced); an unstructured one does not. *Leans on:* `cover_of_interval_sound`.

2. **H2 (Calibration — "is it really ε-entropy?").** On function classes with a *known* Kolmogorov–Tikhomirov ε-entropy in closed form (Lipschitz / Hölder-α balls, ε-entropy `~ ε^{-1/α}`), `coverEntropy` **recovers the known scaling** (slope of `log coverEntropy` vs `log(1/ε)` matches `1/α` within tolerance). *Mechanism:* the certified cover *is* an ε-cover; its log-cardinality should track metric entropy. *Leans on:* the cover construction + the Hölder calibration targets.

3. **H3 (Reachability — the decisive scope screen).** Pure higher-order synergy (parity / a Walsh function) is **invisible to the radix-tree variance decomposition** (`rSquared → 0` at every reasonable depth) but **captured by the Vilenkin/character basis** (a single Walsh coefficient). *Mechanism:* ANOVA is second-order; parity has zero variance at every tree level but is one character. *Leans on:* `orthogonalDecomposition_parseval` (the tree face) vs `FourierCeiling`/the Haar–Vilenkin contrast basis (the character face). **This hypothesis sets the scope of the whole line and may redirect the synergy design to machinery the corpus already owns.**

4. **H4 (Non-tautology — does non-stationarity buy anything?).** A position-dependent (variable-base) entropy `Hₙₛ(f) = Σₖ Hₖ(f)` over a `RadixSeq` with non-constant `bₖ` **separates from every fixed-base entropy** on a genuinely position-dependent source. *Mechanism:* if some single effective base reproduces it, non-stationarity is cosmetic. *Leans on:* `RadixSeq`, `placeValue`. *(Mirrors the digit-conditional H1 dose–response and the gpu-numerics "which-partition-is-data-dependent" falsifier.)*

5. **H5 (Axioms — is the observer-glued quantity an entropy?).** A `netDist`-glued, per-place information `Hₒᵦₛ` on a small multi-place toy **obeys data-processing / monotonicity-under-coarsening** (information cannot increase when a place blurs) and is **not trivially dominated by one place**. *Mechanism:* an entropy must satisfy DPI; a sup-gluing that violates it is not one. *Leans on:* `netDist` (Thm 92).

### Method

#### Exactness ladder (per `ADR-007` §3) — toolchain split

```
Lean theorem (proven)   →   exact mirror              →   tensor/scale experiment
                            SageMath (exact/symbolic;      Burn (GPU/kernels;
                            theorem statements as          candidate-rank only,
                            exact-equality tests)          only if a screen needs scale)
```

- **Rung 1 — Lean (proven):** the objects in `THEORY.md` Part A (Thm 65 Parseval, `rSquared`, `cover_of_interval_sound`, `tick_expected_complexity`, `FourierCeiling`, `netDist`). *Honest scope:* `digitConditionalComplexity` is a `:= N` placeholder (formalization debt) — used only as prose, never cited as formalized.
- **Rung 2 — exact mirror (`source/`, SageMath):** transcribe each candidate measure 1:1 from the Lean object; the proven theorems become exact-equality `assert`s (Parseval as an identity, `cover_of` soundness as a containment check, no epsilon). Result tag `exact`. **This is the load-bearing rung for Line A** — the screens are number-theoretic / variance / cover computations, natural in Sage.
- **Rung 3 — Burn (only if a screen needs it):** reserved for any test that must run at tensor/GPU scale or against captured model tensors (e.g. a synergy screen over real attention rows). Result tag `float` → `candidate` rank; never advances past `registered` without an exact recheck. Most of Line A is expected to stay at Rung 2.

#### The canonical signal battery

One fixed family, generated exactly (Sage, `num`-rational / symbolic), screened by all five hypotheses where applicable:

`constant` · `periodic-p` · `digit-conditional` (the Phase-11 `(α, Gap)` targets, reused from `fdrs-digit-conditional-activation`) · `golden-mean / finite-order Markov` (known entropy rate) · `parity / Walsh` (pure synergy) · `i.i.d. random` (the structureless control).

#### Variables (Tuning-Playbook discipline)

- **Scientific variable:** the measure / basis under test (cover vs variance vs character; stationary vs non-stationary base; per-place vs glued).
- **Nuisance:** depth `d`, ε grid, base sequence — swept, not fit.
- **Fixed:** the battery, the seed set (≥3 seeds where stochastic), the exact-mirror reference.
- Pre-registered prediction curves recorded **before** each sweep; protocol-before-results is the hard gate (anti-HARKing).

### Expected Evidence (H1–H5 discrimination)

| Observation | Supports |
|---|---|
| `coverEntropy` rises with depth and separates battery tiers (constant ≪ generic) | H1 |
| `coverEntropy` exact mirror passes the `cover_of` soundness assertions | H1 / artifact control |
| `log coverEntropy` vs `log(1/ε)` slope matches `1/α` on Hölder-α targets | H2 |
| `rSquared(parity, T) ≈ 0` for all trees; one Walsh/Vilenkin coefficient = parity | H3 |
| `Hₙₛ` on a position-dependent source ≠ any fixed-base `H` (beyond seed variance) | H4 |
| `Hₒᵦₛ` non-increasing under coarsening; no single place dominates trivially | H5 |

### Falsification Criteria

- **H1 fails if** `coverEntropy` is flat across the battery (independent of signal structure) — then it is base-counting, not an information measure, and the candidate dies (recorded as the headline negative). *This is the `digitConditionalComplexity := N` trap made falsifiable.*
- **H2 fails if** the slope does not track `1/α` — then `coverEntropy` is *some* count but **not** metric entropy, and must not be named one. Bounded-completeness negative.
- **H3 outcomes set scope:** if no tree captures parity *and* the character basis does → the synergy extension lives in the (already-built) Vilenkin/Haar machinery, not the tree (the positive direction). If a tree *does* capture parity → the second-order-only framing was wrong (re-scope). If *neither* captures it → higher-order synergy is out of reach in this framework (hard limitation, documented).
- **H4 fails if** a single effective base reproduces `Hₙₛ` everywhere — non-stationarity is cosmetic; drop it. The "extension" collapses to "classical IT in a verified wrapper" (still a fine artifact, not new ground — stated plainly).
- **H5 fails if** `Hₒᵦₛ` violates data-processing on the toy — the gluing is not an entropy; fix the construction or abandon the observer-relative object.

Any falsified hypothesis is a scientific result. The line passes regardless of outcome provided the screens complete, the exact-mirror theorem-tests are green, and runs are reproducible from committed manifests.

### Promotion path (per `ADR-007` §4)

- If a measure **discriminates + calibrates** (H1+H2): `coverEntropy`'s soundness lemma (it is a valid certified ε-cover count) is a `proof_wanted` target under `FdrsFormal/Conjectures/` — a clean number-system fact, promotable independent of any empirical claim.
- If **H3 confirms the character route**: the synergy/connected-information object on the Vilenkin basis becomes the priority `conjecture`-marked target — the genuine native extension.
- If **H4/H5 confirm**: the non-stationary entropy and the `netDist`-glued entropy become `proof_wanted` candidates (data-processing inequality as the lemma).
- A confirmed claim is stated in Lean under an explicit unproven marker **before** it is cited as established; the scanner counts it as empirical debt.

### Protocol Amendment 1 — next screens (pre-registered 2026-06-30, BEFORE execution)

The decisive pair (H1 + H3, `runs/2026-06-30-h1-h3-decisive-pair/`) and its honest-broker review (`results.md`) resolved the scope: H3 located the synergy extension in the **character basis** (forced confirmation — `rSquared(parity, cylinder-tree) = 0` is a theorem, "parity = one Walsh character" is definitional); H1 bounded `coverEntropy` to the **combinatorial / range** branch (it reads value-set diversity, blind to *all* arrangement — parity ≈ constant). Amendment 1 registers the follow-on screens that follow from those two facts. Committed-to-paper before any of them execute; anything not stated here is exploratory and will be labelled so.

#### H6 (the genuine native extension — `characterSynergy`) — priority
Grade the exact Walsh/Vilenkin spectrum by **interaction order** (the popcount of the character index `S`); define `synergy_{>m}(f) = ` energy fraction in characters of order `> m`. Prediction: on a battery of known structure —
- **pure low-order** (additive / single-bit / digit-conditional ≤ order-`m`): `synergy_{>m} = 0` **exactly**;
- **pure top-order** (parity-`k`): `synergy_{>k−1} = 1` (all energy at the maximal order);
- **mixed gates** (AND, OR): a strictly-between value, validated **FDRS-natively** against the test functions' *by-construction* synergy (parity = pure top-order by design, COPY = redundant, additive = low-order), with a **neutral classical cross-check** — plain interaction-information / co-information (basis-independent, predates FDRS and Senchal: XOR `+1.0`, COPY `−1.0`, UNIQUE `0`, AND `+0.189`). **Senchal's `Q_T` minimum-partition is a neighbour, NOT the yardstick** — compared only after the FDRS-native result stands, and incorporated only if the order-decomposition's own logic produces a minimum-partition. (Crossover stays motivation, not evidence — THEORY Part E / fraud gallery.)
- **Inference criteria (decided in advance):** (a) `synergy_{>m} = 0` exactly on every pure-≤`m`-order target (exact QQ); (b) order-grading separates parity-`k` from a same-range random control (energy at order `k` is `1` vs `≈ uniform`); (c) on mixed gates, the order-graded energy is monotone in the **by-construction** synergy rank (parity > AND > COPY) **and** agrees in sign/ordering with classical interaction-information — the FDRS-native structural ranking is the arbiter, interaction-information the neutral sanity check; Senchal's `Q_T` is not a criterion.
- **Falsifier (F6):** the order-graded character energy does **not** separate synergy from redundancy/low-order — i.e. a redundant (COPY) or additive function carries top-order energy, or parity does not. Then "synergy = top-order character energy" is wrong and the extension fails (recorded in `NEGATIVE.md`).
- **Scope guard:** uses the corpus character basis (`FourierCeiling` / `ContrastBasis` / `WaveletPacket`) — **no new basis**; the contribution is the order-grading + the PID/connected-information connection. Formalize (`characterSynergy` under `Conjectures/`) **only if** the screen separates synergy from redundancy.

#### H2 re-specified (H2a / H2b) — forced by the H1 finding
Original H2 ("slope `= 1/α` on Hölder-α") implicitly assumed `coverEntropy` measures *function-class* ε-entropy; H1 showed it measures the *range* covering number. Split:
- **H2a (range entropy):** on a single Hölder-α target, `log coverEntropy` vs `log(1/ε)` has slope **≈ 1** (1-D range cover), **α-independent** — confirming `coverEntropy` is range metric entropy, *not* class entropy. *Falsifier:* slope tracks `1/α` on a single signal (would mean it sees more than the range — investigate).
- **H2b (class entropy):** `coverEntropy` of an *ensemble* sampled from a Hölder-α ball (the covering number of the function *class*) scales as `ε^{−1/α}`. *Falsifier:* no `1/α` dependence over the ensemble → `coverEntropy` cannot be lifted to class metric entropy even in aggregate; it is range-only, full stop.
- Either outcome is a characterization, not a failure; both are pre-committed so neither is retro-fit.

#### H4 elevated (the sequential / source-information route)
The decisive pair touched no **entropy rate** (golden-mean `log₂φ`, the Markov structure are invisible to `coverEntropy` and to the second-order tree). The source/sequential-information content lives wholly in **H4 (non-stationary entropy)** plus the variance/character decomposition. H4's priority is raised from "deferred" to "the next structural screen after H6"; its falsifier (F4) is unchanged.

#### Order of execution
H6 first (the genuine extension, and it reuses the H3 Walsh mirror), then H4 (sequential structure), then H2a/H2b (calibrating the now-bounded `coverEntropy`). H5 stays deferred until a multi-place toy is motivated.

### Run Configuration (planned, written at G2)

`run.sh` will: (1) run the Sage exact-mirror theorem-tests (gate — must be green before any screen is trusted); (2) generate the battery into `runs/<date>/transcript/`; (3) run H1–H5 screens; (4) emit per-run `manifest.yaml` (config, seed, `git describe --dirty`, Sage + Lean toolchain, result tag) + CSV; (5) reduce to `results.md` against the pre-registered curves.

### Scientific Attribution & Provenance

- **Formal basis:** `FdrsFormal/Analysis/DigitConditional/` (Thm 65/66/67/69, `rSquared`), `FdrsFormal/Integration/Complexity/Definition.lean` (`touchComplexity`, `tick_expected_complexity`, `placeValue`), `FdrsFormal/FunctionSpaces/Haar/` (contrast / wavelet-packet basis), `FdrsFormal/Modes/VariableRadix/BihomographicSound.lean` (`emit_traps`), `FdrsFormal/Modes/SyntheticPlace/NetworkGauge.lean` (`netDist`), `FdrsFormal/Core/Primitives/RadixSeq.lean`; plus the sensor-fusion Lean toy (`cover_of`, `cover_of_interval_sound`, `force_sound`). Module status reviewed 2026-06-30; see `THEORY.md` Part A.
- **Classical baselines (what the line must not merely rename):** Kolmogorov–Tikhomirov ε-entropy / metric entropy; Hartley combinatorial information; functional ANOVA / Hoeffding decomposition; Kraft–McMillan. These are the named classical objects the FDRS measures map onto.
- **External convergent framing (motivation, not basis):** S. A. Senchal, *Operationalising Observer Theory* (Wolfram Inst. / Open Research Inst., 2026 draft) — PID, total correlation, connected information, budget-`T` structured information. Mapped in `THEORY.md` Part E. Cited as a neighbouring programme, never as FDRS result.
- **Workflow:** `ADR-007`. Tooling per owner directive (2026-06-30): **SageMath for all Python/exact/symbolic work; Burn for any GPU/tensor/matrix-kernel/operator-complex work.**

### Directory Contents (planned)

```
fdrs-theory-expansion/
├── README.md            ← this charter (G0/G1) — general family + Line A
├── THEORY.md            ← grounding: FDRS items leaned on, candidate defs, the Senchal crossover
├── NEGATIVE.md          ← pre-registered falsifiers + fraud gallery
├── results.md           ← G3 verdict (pending; no results before protocol)
├── run.sh               ← reproducible runner (written at G2)
├── source/              ← SageMath exact mirror (+ Burn only if a screen needs scale)
└── runs/<date>-slug/    ← manifest.yaml · transcript/ · notes.md
```

### Status

- [x] Charter written — Line A (G0/G1)
- [x] Grounding table + crossover map (`THEORY.md`)
- [x] Pre-registered falsifiers + fraud gallery (`NEGATIVE.md`)
- [x] Sage exact mirror + theorem-tests green — G2 rung 2 (the gate) — **10/10 GREEN** (`source/`, `runs/2026-06-30-h1-h3-decisive-pair/transcript/gate.txt`)
- [x] H1 discrimination + H3 reachability screens (the decisive pair) — G2 — **H1 PASS, H3 F3(a)** (`runs/2026-06-30-h1-h3-decisive-pair/`)
- [x] H6 characterSynergy (Amendment 1) — **PASS, F6 not triggered** (`runs/2026-06-30-h6-character-synergy/`); the order grading is a synergy measure (exact-0 on low-order/redundant; AND/OR rank with classical interaction-information)
- [ ] H4 (next), then H2a/H2b screens — Amendment 1 (unblocked: H6 PASS; deferred this run)
- [~] `results.md` vs pre-registered curves — G3 — **H1/H3/H6 reduced; H4/H2a/H2b/H5 pending**
- [ ] (G4, `propose`-gated) `proof_wanted` debt staged in `FdrsFormal/Conjectures/` (candidates: `coverEntropy_sound`, **`characterSynergy` — now warranted by H6**, with scope)

---

## Line B — The Emergent Group-Graded Complex (abelian/non-abelian by holonomy)

**Charter stage (G0/G1): pre-registered object, hypotheses, falsifiers, first exact screen. No runs yet.**
**Follows `ADR-007` (pre-registration; negatives first-class; exact-arithmetic gate) and `ADR-008` (FDRS = connection + curation + verified artifact; NEVER "FDRS-novel"; no performance claim).**

### Motivation (grounded in what is already proven — a corpus re-read, 2026-06-30)

A deep read of `FdrsFormal/` found that **nearly every stone of the coupled non-abelian radix complex is already machine-checked — but only in isolation (leaf modules; nothing wires them together).** The stones:

- **The grading dichotomy** — `Modes/SyntheticPlace/Grading.lean` (ℚ cocycle) and `GroupGrading.lean` (a general `[Group G]` cocycle): size/measure is *not* a node property but a **cocycle on the coupling graph**; `group_gradable_iff_trivial_holonomy` — a global potential (a *measure*) exists **iff** every closed walk's holonomy is `1`. Witnesses: `frustratedTriangle_not_gradable` (ℚ, loop factor 8) and the **non-abelian** `frustratedSE2_not_gradable` — "*order survives, measure dies*", machine-checked.
- **The non-abelian certified line** — `SE2Pose.lean`/`SE2Engine.lean`/`SE2Tight.lean`: a certified **set-membership** pose region on the real `SE(2)=Circle⋉ℂ` (`PoseRegion := Set SE2`, `update = ∩`, `run_sound`), tight and exact (`bbox_sound`, `bilinear_ge`, `runPose_sound`, `tightTractable_run_sound`) — *soundness through non-commutative composition is FREE; the obligation is only the BCH/curvature over-approximation, discharged tightly.*
- **Emergence-of-digit, formalized twice** — `Integration/ThreeLineMediator/CoupledSystem.lean` **manifest-on-overflow** (`ManifestSpace`, `tickDigit`: `∅ → 0` = "*the first act of creation*", a digit born when carry first reaches it, inside a coupling); and `BaseZeroSea/Modules.lean` **`emergentEffectiveBase`** (`= observedStates.card`; base from sustainment `R = In − Out ≥ 0`; wall/wire/digit trichotomy).
- **The gluing + certificates** — `NetworkGauge.lean` `netDist = sup_v gaugeDist_v` (observer-glued, but **scalar**); `AdmissibilityTrap.lean` (Thm 86 — certified emission, "emit only when forced"); `RuntimeAlgebra.lean` `guardedInstruction Instr(g,a)=M_g·T_a` (but **single-line, abelian, non-reactive**); plus our sensor-fusion `FdrsSelection.lean` (the *abelian* certified selection: `select_wellformed`/`condition_le`/`projection_commute`/`refusal_empty`).

**The gap is the arch, not the stones.** No object couples a non-abelian (group-graded) line to an abelian one; `netDist` glues *scalar* gauges, not group-valued gradings; `GroupGrading`/`SE2Pose` are leaves nothing builds on; the two emergence formalizations are neither unified nor wired to the grading; and the command algebra is single-line and non-reactive.

**The question Line B asks is not "can the group-graded complex be defined" — its soundness is provable-now (a `GroupGraph` over a union is one line of Lean) and is an artifact control, not a finding.** The findings are: (a) is it **one general structure**, no per-place-type special-casing; (b) is abelian/non-abelian genuinely **observer-relative** (a complex *locally* gradable everywhere yet *globally* not — reducible to neither); (c) does **emergence compose with grading** (a digit earning its place earns its ratio); (d) does it host a **certified reactive command** step. Everything else — the SE(2) region, the frustration witnesses, the emergence, the traps — is reused, not rebuilt.

**Honest posture (`ADR-008`): NO new mathematics.** The grading theorem is **Zaslavsky (1989) gain-graph balance** (generalizing Harary's 1953 signed-graph balance) = a flat connection with trivial holonomy on a graph; the networked/observer-relative lift is subgraph-vs-whole holonomy; SE(2)/BCH and trace monoids (Mazurkiewicz) are classical. The contribution is the **connection** (these ↔ the emergent coupled radix substrate) and the **verified artifact** — never "FDRS-novel", never a performance claim.

### Hypotheses (each: mechanism · proven object it leans on · falsifier). Soundness is settled/provable in Lean; these test definability, reach, and observer-relativity.

1. **HB1 (definability — one general structure, no special-casing).** The emergent group-graded coupled complex is definable as a single `GroupGraph` over the disjoint union of per-place radix lines with cross-place coupling edges carrying group-valued ratios, where a place may be abelian (trivial/`ℤ`/ℚ grading) or non-abelian (`DihedralGroup`, `SE(2)`) **under one definition**, and `Gradable` is the global-holonomy property. *Mechanism:* `GroupGrading.GroupGraph` already ranges over `[Group G]`; the complex is a `GroupGraph` on the union. *Leans on:* `GroupGraph`, `Gradable`, `walkFactor`. *Falsifier* **FB1**: the object needs a separate rule for abelian vs non-abelian places (a case split) — then it is a case analysis, not one structure.
2. **HB2 (observer-relative abelian/non-abelian — the decisive finding; HORIZON-QUANTIFIED per Amendment B1, 2026-06-30, pre-run).** For **every observation horizon `k`** there is a coupled complex whose **every radius-`k` ball is gradable** (trivial holonomy ⇒ a local measure exists ⇒ every bounded-horizon observer reads *abelian*) while the **whole is non-gradable** (*non-abelian*) — witness family: the **ring** of `N` places at constant ratio `r ≠ 1` with `2k+1 < N` (every radius-`k` ball is an acyclic path; total holonomy `r^N ≠ 1`; `frustratedTriangle` = the `N=3` member). And on that family the **detection threshold is exact**: a radius-`k` observer sees the frustration **iff** its ball contains the unbalanced cycle (`2k+1 ≥ N`) — *the abelian illusion persists exactly up to the length of the shortest unbalanced cycle*. *Mechanism:* holonomy is a cycle property; a ball containing no unbalanced cycle is gradable. *Leans on:* `gradable_holonomy`, the `chainPotential` pattern, `frustratedTriangle`. *Falsifier* **FB2 (re-posed):** the horizon law fails on the ring family — a ball with `2k+1 < N` is non-gradable, or the full-cycle ball (`2k+1 ≥ N`) is gradable, or the law cannot be stated without per-`k` case-splits. **Vacuity guard (what Amendment B1 fixes):** un-quantified, "locally gradable everywhere yet globally non-gradable" was *already witnessed* by `frustratedTriangle` (radius-1 balls of a triangle are acyclic paths) — an artifact control, not a finding; the finding is the **quantified horizon law**. **The crown reading: "the same complex is abelian or non-abelian by the horizon it is observed at," machine-checked.**
3. **HB3 (order without measure).** On a non-gradable complex the ordered `walkFactor` (the carry/composition) is well-defined and order-faithful at every step, while **no** global scalar potential/measure is consistent — the arithmetic analogue of the trace no-go (Thm 91), lifted from the *schedule* to the *group-graded carry*. *Mechanism:* `walkFactor` is always an ordered product; `Gradable` (a potential) fails iff non-trivial holonomy. *Leans on:* `walkFactor`, `gradable_holonomy` (contrapositive), Thm 91. *Falsifier* **FB3**: a consistent global measure exists on a non-gradable complex → "order not measure" is false (it would be abelian-reducible). *(Largely a corollary of `gradable_holonomy`; the screen makes it concrete on the emergent complex.)*
4. **HB4 (emergence → grading — a digit earns its grading by earning its place).** The two emergence formalizations wire to the grading: a place that **manifests** (`∅→0`) / **sustains** (`emergentEffectiveBase ≥ 2`) acquires a well-defined edge ratio (its grading); an un-earned place (base-0 `SubstrateZero` / unmanifested `∅`) carries the **identity** ratio (inert, no grading) — so the group grading *emerges with the digits*, and gradability is preserved under manifestation. *Mechanism:* base-0 ↔ identity/absent edge; base ≥ 2 ↔ a non-trivial ratio; manifestation only *adds* an identity-graded node. *Leans on:* `emergentEffectiveBase`, `ManifestSpace`/`tickDigit`, `PlaceKind.SubstrateZero`, `Gradable`. *Falsifier* **FB4**: the ratio must be fixed *before* manifestation (assigning it at birth breaks gradability/soundness) — emergence and grading do not compose; "emergent grading" is not definable.
5. **HB5 (certified reactive command).** A guarded step `Instr(g,a)` over the coupled complex — gated by the coupling `AdmissibilityTrap` and emitting a group-valued command only when the joint state **forces** it (refusal = safe hold when no admissible joint transition exists) — is definable and **sound**, lifting the single-line `guardedInstruction`, the Line-B `Selection`/`force_sound`, and `SE2Pose.run_sound` to the group-graded complex. *Mechanism:* the admissibility/four-corner trap certifies emission; `Instr(g,a)` composes. *Leans on:* `AdmissibilityTrap` (Thm 86), `guardedInstruction`, `FdrsSelection.force_sound`, `SE2Pose.run_sound`. *Falsifier* **FB5**: an unforced (hallucinated) command emits, or refusal fires where an admissible joint transition exists → the command layer is not certified.

**HB1/HB4/HB5 are definability/soundness screens (artifact controls, provable-now); HB2 is the decisive *finding* (the observer-relativity horizon law); HB3 is a near-corollary made concrete.**

> **Charter Amendment B1 (2026-06-30, pre-run — the vacuity repair).** The session assessment (2026-06-30) found the original HB2/FB2 near-unfalsifiable: with "local" = incident-edge neighbourhoods, the existing `frustratedTriangle` *already* satisfies "locally gradable everywhere, globally non-gradable" (its radius-1 balls are acyclic paths), so FB2 could never fire. HB2/FB2 are re-posed above in the **horizon-quantified** form (ring family, exact detection threshold) *before any Line-B run*. Honest scope: even the quantified law is classical (restricted gain-graph balance); the contribution is the machine-checked **horizon law + its observer reading**, per `ADR-008`.

> **Deliberately unchartered (named so the line cannot "complete" around them).** (i) **The async/multi-rate axis** — Phase-8 routing/confluence/staleness and the Phase-13.6 homographic/`SL₂` streams as *non-abelian generated lines* over the graded complex — is the vision's flow layer and is **not** covered by HB1–HB5; it becomes an HB6 amendment (pre-registered before any of its work) once HB2/HB4/HB5 land. (ii) **The engineering rung** — the Lean → exact → `no_std` Rust → demo arc proven out in `fdrs-sensor-fusion` Line B — follows HB4/HB5 as the command-layer artifact (a `graded-core` mirror with E1 fidelity tests), scaffolded only after its Lean anchors exist.

### Method

- **Exactness ladder — Lean-first this line** (unlike Line A's Sage-first: the object *is* a Lean object). **Rung 1 (Lean, proven):** the HB2 witness is `decide`-checkable over finite groups (`DihedralGroup n`, `Fin n`), reusing `frustrated*`; HB1/HB3 are the general `GroupGraph`-on-a-union definition + `walkFactor`/holonomy facts. **Rung 2 (SageMath, exact):** the exact mirror — holonomy products over larger finite groups and exact-rational `SE(2)` (the `(3,4,5)` rotation), theorem statements as exact-equality tests; result tag `exact`. **Rung 3 (Burn):** reserved — only if a control-loop scale test needs tensors (not expected early).
- **The canonical complex battery** (fixed, exact): `chain` (tree ⇒ gradable, the abelian control) · `frustrated-ℚ-triangle` (loop factor 8, non-gradable) · `frustrated-Dihedral-3` (non-abelian, non-gradable) · **`local-abelian-global-nonabelian`** (the HB2 witness) · `frustratedSE2` (the pose loop) · `emergent-complex` (places manifest over `t`; the HB4 witness).
- **Variables (Tuning-Playbook discipline).** *Scientific:* the coupling structure (which places abelian/non-abelian; the graph topology/holonomy). *Nuisance:* group size, graph size, depth. *Fixed:* the battery, the exact-mirror reference, the seed set where any sampling enters. Pre-registered prediction (which complexes are gradable, which not, which locally-vs-globally) recorded **before** each screen — protocol-before-results is the hard gate.

### Expected Evidence

| Observation | Supports |
|---|---|
| the complex is one `GroupGraph`-on-a-union; abelian & non-abelian places under one def (no case split) | HB1 |
| ring family: every radius-`k` ball gradable for `2k+1 < N`; whole non-gradable; full-cycle ball (`2k+1 ≥ N`) non-gradable — the exact threshold | **HB2 (horizon law)** |
| `walkFactor` defined & order-faithful on a non-gradable complex; no potential `w` exists | HB3 |
| a place manifests/sustains ⇒ acquires a ratio; base-0/∅ ⇒ identity; gradability preserved under manifestation | HB4 |
| a guarded step emits only when the joint state forces it; refusal = safe hold; soundness holds | HB5 |

### Falsification Criteria

- **HB1 fails (FB1)** if the definition case-splits on place type → not one structure. **HB2 fails (FB2, re-posed per Amendment B1)** if the horizon law fails on the ring family — a sub-cycle ball (`2k+1 < N`) non-gradable, a full-cycle ball gradable, or no uniform (non-case-split) statement — then "abelian = bounded-horizon reading" is wrong (the headline negative). **HB3 fails (FB3)** if a global measure survives on a non-gradable complex. **HB4 fails (FB4)** if emergence and grading cannot compose without pre-fixing ratios. **HB5 fails (FB5)** on any unsound emission or spurious refusal. Any falsified hypothesis is a scientific result; the line passes provided the screens complete, the exact-mirror theorem-tests are green, and runs are reproducible from committed manifests.

### Promotion path (per `ADR-007` §4)

- **HB2 is the promotion crown:** the *networked / observer-relative grading* theorem (local gradability ≠ global gradability) is a clean `proof_wanted` → theorem under `FdrsFormal/Modes/SyntheticPlace/` — the subgraph-holonomy lift of `group_gradable_iff_trivial_holonomy`, promotable independent of any empirical claim.
- HB1 (the `GroupGraph`-on-a-union structure), HB3 (order-not-measure corollary), HB4 (`emergentGrading` well-formedness + gradability-under-manifestation), HB5 (the certified `Instr(g,a)` step) each become `conjecture`/`proof_wanted` candidates under `Conjectures/` **before** citation; the scanner counts them as empirical debt.

### First exact screen (pre-registered design, amended B1 — the HB2 horizon law + HB3 control)

A single Lean screen (exact, no floats), built **against the corpus environment** (`lake env lean`; the corpus is imported read-only, never modified; the canonical source lives in this family's `lean/`): **(i)** define the **ring family** `ringGraph N r` (vertices `Fin N`, edges `i → i+1`, constant ratio; `frustratedTriangle` = `N=3, r=2`) and the **induced-ball restriction** (a screen-local `restrict`, not a corpus edit); **(ii)** machine-check the **horizon law**: every radius-`k` ball with `2k+1 < N` is `Gradable` (the path potential, `chainPotential` pattern) AND the whole ring is `¬ Gradable` (loop `walkFactor = r^N ≠ 1` + `gradable_holonomy`) AND the full-cycle ball (`2k+1 ≥ N`) is `¬ Gradable` — parametric where smooth, concrete `decide`/`norm_num` witnesses (`N ∈ {5,6,7}`, `k ∈ {1,2,3}`) where parametric proofs would balloon (concrete witnesses satisfy the pre-registration; the parametric law is then the `proof_wanted` promotion target); **(iii)** on the ring, `walkFactor` is defined and order-faithful while no potential exists (HB3). The observer-relativity payoff, machine-checked twice over: *same radius `k=2` reads abelian on `N=7` and non-abelian on `N=5`; same complex `N=7` reads abelian at `k=2` and non-abelian at `k=3`.* HB1 (the heterogeneous union `GroupGraph`) rides along as a definitional control. Emergence (HB4) and the command step (HB5) are the second/third screens.

### Scientific Attribution & Provenance

- **Formal basis (reused, not rebuilt):** `Modes/SyntheticPlace/{Grading,GroupGrading,SE2Pose,SE2Engine,SE2Tight,NetworkGauge,AdmissibilityTrap}.lean`, `Modes/BaseZeroSea/Modules.lean`, `Integration/ThreeLineMediator/CoupledSystem.lean`, `Integration/RuntimeAlgebra/Definition.lean`, `Modes/ExtendedBase/Definition.lean`; plus the sensor-fusion `lean/FdrsSelection.lean` (`select_wellformed`/`condition_le`/`projection_commute`/`refusal_empty`/`force_sound`). Reviewed 2026-06-30; homes in `THEORY.md` (Line B).
- **Classical baselines (what the line must not merely rename):** Zaslavsky (1989) **gain-graph balance**; Harary (1953) signed-graph balance; flat connections / trivial holonomy on graphs (Gao–Brodzki–Mukherjee 2021); SE(2) synchronization & pose-graph SLAM (Lu–Milios 1997; guaranteed 2-D SLAM, Jaulin / Song et al. 2025); Mazurkiewicz **trace monoids**; Zappa–Szép products (the classical "non-abelian carry" of two monoids).
- **Workflow:** `ADR-007`. **Tooling:** Lean-first (the object is Lean); SageMath for the exact mirror; Burn only if a screen needs scale.

### Status (Line B)

- [x] Charter written — Line B (G0/G1)
- [x] Grounding table (`THEORY.md` Line B)
- [x] Pre-registered falsifiers + fraud gallery (`NEGATIVE.md` Line B)
- [x] **Amendment B1 (2026-06-30, pre-run):** HB2/FB2 horizon-quantified (vacuity repair); async axis + engineering rung explicitly deferred (named)
- [x] **First exact screen — the HB2 horizon law: PASS, FB2 does not fire** (`runs/2026-06-30-lineb-ring-horizon/`, tag `proven`): parametric `ringGraph_not_gradable`; concrete ball witnesses (5,1)/(7,1)/(7,2) gradable vs (5,2)/(7,3) non-gradable; **`hb2_same_complex_different_horizon` + `hb2_same_horizon_different_complex`** — the observer-relativity crown, machine-checked; HB3 + HB1 rider PASS (artifact controls). Charter+Amendment committed BEFORE the run (anti-HARKing by commit ordering). Lean 0 sorries, axiom-clean.
- [x] **HB4 + HB5: PASS (artifact controls discharged)** (`runs/2026-06-30-lineb-emergent-command/`): `manifestLeaf_gradable`/`gradable_of_manifestLeaf` (manifestation is measure-neutral, ratio assigned at birth — FB4 refuted), `emergentRatio` trichotomy (wall/wire inert), `certifiedCommand_sound`/`certifiedCommand_none_iff` (commands ride Thm-86-certified emissions; refusal = safe hold — FB5 refuted); golden-mean demos. Lean 0 sorries, axiom-clean.
- [x] **Rust arc, first stone: `source/rust/graded-core`** — `no_std`, zero deps: exact `Ratio`, `CouplingGraph`, ordered `walk_factor`, `gradable()` solver, ring/ball/manifest mirrors; **8/8 E1 fidelity tests**.
- [ ] (G4, `propose`-gated) `proof_wanted` staged in `FdrsFormal/Conjectures/` (crown: the parametric horizon law)

# Negative results & boundaries — fdrs-theory-expansion (Lines A & B)

Per `ADR-007` §5: negatives are recorded as bounded-completeness statements ("searched X up to bound N with exact method M, result; transcript at P") plus a **fraud gallery** of things that will look like wins but are not. Archive-never-delete.

**This file is opened at charter stage: the falsifiers and the fraud gallery are PRE-REGISTERED before any run, the anti-HARKing instrument. The bounded-completeness entries are templates the G2 screens fill in; the fraud gallery names the traps in advance so a tempting result is checked against them, not after them.**

---

## Pre-registered falsifiers (kill conditions, committed before data)

Each becomes a bounded-completeness negative if hit. Format to be filled at G3: *method · exact bound / battery · result · transcript path.*

### F1 — `coverEntropy` discrimination (kills H1)
**Kill condition:** `coverEntropy f d` is flat across the canonical battery — its value is explained by `(d, base)` alone, independent of signal structure (constant and i.i.d. land within the same envelope at matched depth). **Then it is base-counting, not an information measure**, and the candidate dies. This is the `digitConditionalComplexity := N` trap (a measure that returns the ambient cell count and looks meaningful) made falsifiable — the first thing to rule out.

> **G2 status (2026-06-30, `runs/2026-06-30-h1-h3-decisive-pair/`): NOT triggered.**
> *Method:* exact integer cell-counts over the canonical battery, bases `b∈{2,3}`, widths
> `D∈{8,5}`, depths `d=0..D`, ≥3 seeds on stochastic members; transcript
> `transcript/screen_h1.txt`. *Result:* at matched `(d=4,b=2)` coverEntropy takes **4 distinct
> values** (constant 1 cell → i.i.d. 16 cells = the `2^d` envelope) — not flat. H1 survives.
> *Deviation logged (not a falsification):* the per-signal prediction P-H1a/b mis-stated the
> resolution **depth** for metrically-adjacent value-sets `{0,1}` (predicted `d≥1`, observed
> `d=8`); cause = `cover_of` is MSB-first, so coverEntropy is the *metric* covering number of
> the range. This **sharpens** the scope bound P-H1c (range-only, temporally blind); see
> `results.md` and the run `notes.md`.

### F2 — metric-entropy calibration (kills H2)
**Kill condition:** the `log coverEntropy` vs `log(1/ε)` slope does not track `1/α` on Hölder-α / Lipschitz targets (deviation beyond a pre-set tolerance over the ε-grid). **Then `coverEntropy` is *some* count but NOT Kolmogorov ε-entropy**, and naming it metric entropy is forbidden. The measure may still be useful — but as a different object, relabeled honestly.

### F3 — parity reachability (re-scopes the whole line; H3)
Three pre-registered outcomes, all informative:
- **(a)** No tree captures parity AND the character basis does → the synergy extension is the character route (the positive direction). *Confirms Part C.*
- **(b)** A tree *does* capture parity (`rSquared > 0` at reasonable depth) → FDRS's own Thm 65/66 prior is violated in the screen → **suspect a generator/encoding artifact** (parity mis-encoded so it correlates with a coarse cell); escalate to a method check, do not claim.
- **(c)** Neither tree nor character captures it → higher-order synergy is **out of reach in this framework**; the line is bounded to second-order IT (hard limitation, recorded, not a failure).

> **G2 status (2026-06-30, `runs/2026-06-30-h1-h3-decisive-pair/`): outcome (a).**
> *Method:* exact `QQ` rSquared of parity `(-1)^popcount` over homogeneous binary trees
> truncated at depth `k=0..n` (`n=3,4,5,6`) + assorted heterogeneous/unbalanced trees; exact
> full Walsh spectrum; transcript `transcript/screen_h3.txt`. *Result:* `rSquared(parity,T_k)=0`
> **exactly** ∀ `k<n` (and for every tree whose leaves all have size ≥2), `=1` only at `k=n`
> (singleton leaves = memorization); the general law `rSquared = (#singletons)/N` was asserted
> to match at every `(n,k)`. The Walsh spectrum has **exactly one** nonzero coefficient at
> `S=2^n−1` carrying 100% of the energy. Controls (`top-bit`, `digit-cond-2bit`) are captured
> by the tree at depths 1 and 2 — so the `0` on parity is genuine, not a dead screen. **Not
> outcome (b):** no tree with leaves ≥2 ever reported `rSquared>0`, so no encoding artifact.
> Confirms Part C: the synergy extension is the character route the corpus already owns.

### F4 — non-stationarity non-tautology (kills H4)
**Kill condition:** some single effective base `b*` reproduces `nonStationaryEntropy` everywhere on the position-dependent source (within seed variance). **Then non-stationarity is cosmetic** — Line A's "extension" collapses to "classical IT in a verified wrapper." Recorded plainly: a verified artifact, not new ground.

### F5 — observer-entropy axioms (kills H5)
**Kill condition:** `observerEntropy` increases under a coarsening on the toy (data-processing violation), or is trivially pinned by one dominating place. **Then the `netDist`-gluing is not an entropy**; fix the construction or abandon the observer-relative object.

### F6 — character-synergy separation (kills H6; Amendment 1)
**Kill condition:** the interaction-order grading of the Walsh/Vilenkin energy does **not** separate synergy from redundancy/low-order — a redundant (COPY) or purely additive function carries top-order character energy, or parity-`k` does **not** concentrate at order `k`, or the mixed gates do not rank monotonically with their **by-construction structural synergy** (parity > AND > COPY) and the neutral classical interaction-information cross-check. **Then "synergy = top-order character energy" is false**, and the genuine native extension H3 pointed to does not exist as stated — record as the headline negative for Amendment 1, do not promote `characterSynergy`.

> **Amendment-1 status (2026-06-30, `runs/2026-06-30-h6-character-synergy/`): NOT triggered.**
> *Method:* exact (QQ) interaction-order grading `synergy_{>m}(f) = (Σ_{popcount(S)>m}
> energy_S)/(Σ_{popcount(S)≥1} energy_S)` over k = 2..5 boolean batteries; exact-symbolic
> classical interaction-information on the k = 2 gates; transcript `transcript/screen_h6.txt`.
> *Result:* no redundant/low-order function carried top-order energy — `synergy_{>1} = 0`
> **exactly** for single-bit, additive, copy(native); parity-k has `synergy_{>k-1} = 1`,
> `synergy_{>k} = 0` exactly; mixed gates AND-2/OR-2 = `1/3`, **strictly between** parity (1) and
> redundancy (0), monotone and sign/order-agreeing with classical interaction-information
> (`XOR +1 > AND/OR +0.189 > UNIQUE 0 ≥ COPY −1`). **H6 PASS**; `characterSynergy` warranted (with
> scope: nonnegative synergy fraction, redundancy/uniqueness → 0 — *not* a full PID lattice).
> *Deviation logged (not an F6 trigger):* pre-registered criterion (b) at k = 2 fails — a random
> ±1 function on the 4-point hypercube is spectrally degenerate (often a pure character; 8-seed
> mean top-frac 1/2, not 1/3). (b) holds for k ≥ 3; the k ≥ 3 restriction is post-hoc and
> attributed to the **control**, not the measure (F6's kill conditions did not occur, and
> non-vacuity at k = 2 is independently established by the deterministic battery: additive 0 <
> AND/OR 1/3 < parity 1). See `results.md` and the run `notes.md`.

---

## Fraud gallery (apparent wins that are NOT claims — named in advance)

- **"A sound information measure exists in FDRS" is content-free.** `coverEntropy`, `treeStructuredInformation`, `observerEntropy` are all *definable and sound now* — that is an artifact control (Part B defs 1, 4), **not** a finding. The findings are discrimination (F1), calibration (F2), reach (F3), non-tautology (F4). Do not cite definability as a result.

- **"`coverEntropy` varies with the signal" is not yet discrimination.** It will trivially vary with depth and base. The win requires it to separate *structure tiers at matched `(d, base)`* — constant ≪ generic — beyond the base-counting envelope. A monotone-in-depth curve alone is the null model, not the signal.

- **"It matches the ε-entropy scaling" can be a fit, not a measurement.** If the Hölder exponent `α` is itself tuned to the data, the slope match is circular. `α` is fixed by the *generator* (pre-registered), and the slope is read, not fit. A post-hoc `α` that makes the slope work is fraud #2's shape (Borwein–Bailey: agreement engineered after the fact).

- **The variance face "covers information theory" only at second order.** `rSquared`/Parseval reproduce total correlation on Gaussian/second-order structure — and FDRS *predicts* (Part C) they report ≈ 0 on parity. Citing the ANOVA decomposition as a general information decomposition is exactly the over-read the corpus's own theorems forbid. The synergy gap is structural, not a missing term.

- **The Senchal crossover is motivation, not evidence.** The `S_T ↔ rSquared`, `Σφ ↔ Parseval` table (THEORY Part E) is an independent convergent framing. It does **not** make any FDRS measure "the same as" his information measures, does not import his `Q_T = qualia` claim (out of scope), and is never cited as an FDRS result. A neighbouring programme agreeing in shape is a prior to test, not a confirmation.

- **"Non-stationary entropy differs from fixed-base entropy" may be a generator artifact.** If the position-dependent source is built with a structure that *no* fixed base could match by construction, the separation is tautological (we engineered it). The source must admit a genuine best-fixed-base competitor; the separation is a win only against that competitor, beyond seed variance — the digit-conditional H1/H2 discipline transplanted.

- **A Burn/float screen that "confirms" an exact result is downstream, not independent.** Per the exactness ladder, any tensor/GPU screen is `candidate` rank; if it agrees with the Sage exact mirror that is a regression guard, and if it *disagrees* it is a bug in the float path, never a finding. The arbiter is the exact mirror and the Lean kernel — a float that "passes" by exploiting a loose check means the check is redesigned upstream (Tao's non-exploitable-verifier rule), not the candidate kept.

- **`coverEntropy` from the sensor-fusion toy is not a corpus measure.** `cover_of` lives in the experiment's Lean toy, not `FdrsFormal/`. Until `coverEntropy_sound` is deposited under `Conjectures/` (a G4 step), "FDRS has a certified ε-entropy" is a candidate, not an established corpus fact. Say "the toy's `cover_of`", not "the corpus's."

- **"`coverEntropy` discriminates structure" is the trap H1 already caught (review 2026-06-30).** It separated battery tiers — but the tiers are **value-set / range diversity**, not structure: parity (maximally structured) reads ≈ `constant`, and would read identically to a *random* `{0,1}` string. `coverEntropy` is a metric ε-entropy of the **range**, blind to arrangement. Never cite "H1 PASS" as "FDRS measures structured information"; cite it as "a non-vacuous range covering-number." Structure lives in the decomposition (variance/character), not the cover.

- **H3's "parity = one character" is definitional, not a discovery (review 2026-06-30).** `parity ≡ W_{all-ones}` by definition, and `rSquared(parity, cylinder-tree) = 0` is *forced* (aligned cells of size ≥2 are popcount-balanced). H3 is a **forced confirmation of FDRS self-consistency**; F3(b) could only have surfaced as an implementation bug. Cite H3 as "the synergy extension is *located* in the character basis," never as "we discovered parity is synergistic."

- **H6's "parity has all its energy at top order" is also definitional — the win is the MIXED cases.** Parity concentrating at order `k` is the same definitional fact as H3. `characterSynergy` is a *finding* only if the order-grading (a) reads `0` on pure low-order/redundant functions AND (b) ranks the *mixed* gates (AND/OR) monotonically with their **by-construction synergy** — neutral cross-check is classical interaction-information, **not** Senchal's `Q_T` (a neighbour, never the yardstick; adopt only if the FDRS extension itself motivates a minimum-partition). A pass on parity alone is the null model, not the signal.

---

## Line B — pre-registered falsifiers (FB1–FB5, committed before data)

Each becomes a bounded-completeness negative if hit (*method · exact battery · result · transcript path*, filled at G3). **Soundness of every Line-B object is provable-now (an artifact control); FB2 is the only decisive *finding* falsifier.**

### FB1 — the structure needs a case split (kills HB1)
If the emergent group-graded complex cannot be defined as ONE `GroupGraph`-over-a-union — if abelian and non-abelian places require separate rules, or the coupling can't range over `[Group G]` uniformly — it is a case analysis, not one general structure. *Bound:* the union construction over ≥1 abelian + ≥1 non-abelian (`DihedralGroup`) place, under a single definition, `#eval`/`decide`.

### FB2 — the horizon law fails (THE decisive kill; kills HB2) — RE-POSED by Amendment B1 (2026-06-30, pre-run)
**Original form (RETIRED as unfalsifiable, recorded here per archive-never-delete):** "no coupled complex is locally gradable everywhere yet globally non-gradable." The session assessment (2026-06-30) found this could never fire: `frustratedTriangle` *already* satisfies it (its radius-1 balls are acyclic paths ⇒ gradable; the whole is proven non-gradable) — so the un-quantified HB2 was an artifact control wearing a finding's label, exactly the "definability is not a finding" trap below.
**Re-posed (falsifiable) form:** FB2 fires iff the **horizon law fails on the ring family** `ringGraph N r` (`r ≠ 1`): (a) some radius-`k` ball with `2k+1 < N` is **non**-gradable, or (b) the full-cycle ball (`2k+1 ≥ N`) **is** gradable, or (c) the law admits no uniform statement (needs per-`k`/per-`N` case-splits — a definability failure). *Bound:* parametric Lean proof where smooth; concrete exact witnesses `N ∈ {5,6,7} × k ∈ {1,2,3}` otherwise; transcript = the `lake env lean` output + axiom audit.

### FB3 — a global measure survives on a non-gradable complex (kills HB3)
If some non-gradable complex nevertheless admits a consistent global scalar potential/measure, the "carry preserves order, not measure" split is false — the complex was abelian-reducible. *Bound:* `gradable_holonomy` contrapositive checked on every non-gradable battery member. *(Near-corollary; a failure would indicate a definitional error, not a discovery.)*

### FB4 — emergence and grading do not compose (kills HB4)
If a place's edge ratio must be fixed *before* it manifests/sustains — if assigning the grading at manifestation (`∅→0` / `emergentEffectiveBase` crossing 2) breaks gradability or soundness — then "emergent grading" is not definable and the two emergence formalizations stay disconnected from the grading. *Bound:* manifest a place into a gradable complex with an identity ratio; require gradability preserved and the ratio well-defined at birth.

### FB5 — the reactive command is unsound (kills HB5)
If the guarded `Instr(g,a)` over the complex emits an **unforced** (hallucinated) command, or **refuses** where an admissible joint transition exists, the command layer is not certified. *Bound:* the `AdmissibilityTrap` soundness lifted to the coupled step, checked on a conflict battery (analogue of the sensor-fusion refusal map).

## Line B — fraud gallery (apparent wins that are NOT claims — named in advance)

- **"The group grading is new FDRS mathematics" — it is Zaslavsky (1989) gain-graph balance.** `GroupGrading.lean`'s own banner says so: `group_gradable_iff_trivial_holonomy` = a flat connection with trivial holonomy on a graph, classical. Line B reuses it; the contribution is the **connection** (grading ↔ the emergent coupled radix substrate) + the **verified artifact**, never the theorem.
- **"The SE(2) certified pose region is our contribution" — it is ALREADY BUILT and classical.** `SE2Pose`/`SE2Engine`/`SE2Tight` exist (`run_sound`, tight, exact) before Line B; the pose-region soundness is the SLAM/synchronization literature (Jaulin; Song 2025). Line B **reuses** SE(2) as a non-abelian *instance*; its object is the *coupled, observer-relative* lift, not the pose region. Never cite SE(2) soundness as a Line-B result.
- **The octree/scalar-measure yardstick returns (the Line-A/ sensor-fusion trap, transplanted).** Benchmarking the non-abelian complex against a global scalar measure re-imports the abelian frame. The win is that **no global measure exists** (non-gradability), not "a better measure." Do not score a non-gradable complex by any single potential — that is measuring the thing by the very object its existence denies.
- **Definability is not a finding.** HB1/HB4/HB5 are provable-now (one `GroupGraph`, an emergence wiring, a guarded step) — artifact controls. The only *finding* is HB2 (observer-relativity). Do not cite "the structure exists" or "the command step is sound" as a win.
- **"Local-abelian / global-non-abelian is a discovery" — it is subgraph-vs-whole holonomy (classical).** The witness is a spanning-tree / cycle-space fact about gain graphs. The contribution is the **machine-checked artifact** and its reading as "the same line is abelian or non-abelian by what is observed," never the graph-theory fact.
- **"A digit *creates* its own grading" overclaims emergence.** `∅→0 ↦ identity ratio`, `base≥2 ↦ a non-trivial ratio` is a **bookkeeping wiring** (base-0 is inert, `SubstrateZero`), not a genesis-of-mathematics claim. Emergence-of-digit is Phase-10 sustainment; wiring it to a ratio is curation.
- **"The reactive command layer controls a complex system."** HB5 is a certified-**emission-soundness** screen on a toy — refusal = safe-hold is a *discipline*, not a controller and not a performance claim. No deployment, no benchmark, no "beats a classical controller."
- **"Non-abelian is load-bearing" only if the abelianization genuinely ties it (F-B7, transplanted from sensor-fusion).** A complex whose non-abelian structure *abelianizes* (trivial holonomy after all, or a scalar re-grading reproduces it) bought nothing from the group. The win requires genuine non-trivial holonomy that **no** abelian re-grading reproduces — measured, not assumed.

### Bounded-completeness (FILLED — run `2026-06-30-lineb-ring-horizon`, proven/Lean)

**FB2 (re-posed) did NOT fire.** Method: Lean machine-check against the corpus env (`lake env
lean`; 0 errors, 0 sorries, axiom-clean). Battery: ring family — parametric whole-ring
non-gradability (`∀ N, 1 < r`); concrete balls `N ∈ {5,7} × k ∈ {1,2,3}` at centre `v = 0`.
Result: the horizon law held at every point tested — sub-cycle balls gradable (`5,1`/`7,1`/`7,2`,
including the wrap-edge path), full-cycle balls non-gradable (`5,2`/`7,3`), whole non-gradable
(parametric). Transcript: `runs/2026-06-30-lineb-ring-horizon/transcript/output.txt`.

- **NB-1 (scope of the concrete rung).** Ball gradability is proven at `v = 0` and small `(N,k)`
  only; the **parametric** ball law (`gradable ⟺ 2k+1 < N`, all `N, k, v`) is NOT proven here —
  it is the `proof_wanted` promotion crown. Citing "the horizon law" beyond the tested points is
  over-claim until that lands.
- **NB-2 (import seam).** The corpus's `Grading.lean` and `GroupGrading.lean` cannot be imported
  together (both declare `frustratedTriangle*`); the HB1 rider lives in a separate file. A corpus
  port must resolve the namespace collision first — logged as friction for G4.
- **NB-3 (what HB1/HB3 are).** Definability/corollary artifact controls, recorded as PASS but
  never citable as findings (fraud gallery stands). The finding is HB2's observer reading only.

### Bounded-completeness (FILLED — run `2026-06-30-lineb-emergent-command`, proven/Lean + exact/Rust)

**FB4 and FB5 did NOT fire.** Lean (`lean/FdrsEmergentGrading.lean`, vs the corpus env, 0 errors,
0 sorries, axiom-clean) + Rust mirror (`source/rust/graded-core`, 8/8). Transcript:
`runs/2026-06-30-lineb-emergent-command/transcript/output.txt`.

- **NB-4 (HB4 scope: leaf-only).** Manifestation is proven measure-neutral for the LEAF (`∅→0`)
  birth shape — a leaf cannot create a cycle. **Manifestation that CLOSES a cycle (a join of two
  existing places) is not covered**, and the ring screen shows that is precisely where measures die.
  "Emergence never breaks the measure" may only be cited with the leaf qualifier.
- **NB-5 (HB5 is a thin lift, by design).** `certifiedCommand` is `Option.map` over the corpus
  `emitNow` — the theorems compose Thm 86 with a grading table. The composition is the artifact;
  there is NO new trap theory, and none may be implied.
- **NB-6 (kernel-reduction seam).** `Finset.sort` does not kernel-reduce, so `decide` cannot
  evaluate `emitNow` end-to-end; the executable demos route through `simp` + decidable gates.
  Logged as Lean-engineering friction for the corpus port.
- **NB-7 (Rust is fidelity-tested, not verified).** `graded-core`'s `gradable()` is the classical
  spanning-tree/holonomy algorithm; a transcription bug could pass tests. Guarantees live in Lean.

# Results — fdrs-theory-expansion / Line A (Structured Information)

**Status: G2 decisive pair COMPLETE (H1 + H3). Amendment 1 H6 COMPLETE (PASS).
H4 + H2a/H2b deferred (run after H6, per Amendment 1). H5 deferred.**

Runs: `runs/2026-06-30-h1-h3-decisive-pair/`, `runs/2026-06-30-h6-character-synergy/`
(manifests + transcripts committed).
Toolchain: SageMath 10.9 exact mirror, arbiter = Lean `v4.27.0-rc1` corpus. Decoration
tag **`exact`** — every verdict rests on exact integers / `QQ` / `QQ(ζ_b)`, no floats.

Pre-registration boundary (fixed at G0/G1, honoured here):
- Hypotheses H1–H5 + falsifiers F1–F5 + fraud gallery: pre-committed (`README.md`,
  `NEGATIVE.md`).
- Prediction curves `source/predictions/h{1,3}_prediction.md`: written to disk **before**
  the screens ran; not edited after. Deviations are reported below, not retro-fitted.

## Gate (Rung-2 exact mirror — the artifact control, must precede any screen)

**GREEN: 10/10 exact theorem-tests** (`transcript/gate.txt`). The Sage mirror reproduces
the machine-checked corpus exactly: Thm 65 Parseval/ANOVA (`total = Σ‖g_v‖² + residual`,
`explained = Σ‖g_v‖²`, one-level cross-term `= 0`); Def 174 rSquared (constant→1,
singleton-leaf tree→1, range `[0,1]`); `cover_of_interval_sound` (3235 containment cases);
Thm 69 homogeneous collapse (`leafCount = ∏ branching`, leaves = base-`b` cylinders, α=1);
Lemma 3 Vilenkin/Walsh identities (mean-zero, orthonormal `b·δ`, complete `b·δ−1`); the
Kraft bound `Σ 1/B_k < 2` and `sum_max_digits = B_{k+1}−1`. **Per the fraud gallery this is
content-free as a finding** — it certifies faithfulness, nothing more.

## Verdict ledger (one row per screen)

| Screen | Run | Tag | Pre-registered prediction | Outcome | Status |
|---|---|---|---|---|---|
| **H1** discrimination | 2026-06-30 | `exact` | coverEntropy separates battery tiers at matched `(d,b)`, not flat | **≥4 tiers; F1 does NOT fire; constant pinned at 0, i.i.d. at envelope** | **PASS** (scope bound + 1 logged deviation) |
| **H3** reachability | 2026-06-30 | `exact` | tree `rSquared = 0` on parity at all `k<n`; one Walsh coeff captures it | **rSquared = 0 ∀ k<n (exact), = 1 only at k=n; exactly one Walsh coeff, 100% energy** | **PASS — F3(a)** |
| **H6** characterSynergy | 2026-06-30 | `exact` | order grading reads 0 on low-order/redundant, ranks mixed gates with by-construction + classical synergy | **(a) exact-0 on additive/single-bit/copy; (c) AND/OR = 1/3 between parity (1) & copy (0), agrees with classical II; (b) parity≠random for k≥3** | **PASS — F6 not triggered** |
| H2a/H2b calibration | — | — | range-cover slope ≈ 1 (α-indep) / class-cover ~ ε^{−1/α} | pending | deferred (after H6) |
| H4 non-tautology | — | — | `Hₙₛ` ≠ any fixed-base `H` on a position-dependent source | pending | next (Amendment 1) |
| H5 axioms | — | — | `observerEntropy` obeys data-processing; no place dominates | pending | deferred |

## H3 — headline result (the decisive scope screen)

**F3 outcome (a), confirmed exactly.** Parity `(-1)^popcount` is invisible to the radix-tree
variance face and is exactly one Vilenkin/Walsh character:

- `rSquared(parity, T_k) = 0` **exactly** for every depth `k < n` (`n = 3,4,5,6`); `= 1`
  only at `k = n`, where leaves are singletons (memorization, `leafCount = N`, not structure).
  General law verified at every `(n,k)`: `rSquared(parity, T) = (#singleton-leaf points)/N`.
  Any tree with all leaves size ≥ 2 (incl. heterogeneous/unbalanced) → `0`.
- Walsh spectrum: **exactly one** nonzero coefficient at `S = 2^n − 1` (the top-order
  character), carrying **100%** of `‖f‖²`; all other coefficients `= 0`.
- Controls alive: `top-bit` captured at depth 1, `digit-cond-2bit` at depth 2 — confirming
  the tree *does* capture root-/low-order structure, so the `0` on parity is real.

This is **THEORY.md Part C observed**: FDRS's variance branch is the L²/Gaussian shadow of
information theory; pure top-order synergy carries zero tree variance at every level but is a
single character. **The synergy extension is the character route — machinery the corpus
already owns (`FourierCeiling`, `ContrastBasis`, `WaveletPacket`) — not a new tree term.** A
tree capturing parity would have contradicted Thm 65/66 (F3(b)); none did.

**Honest reading of the two halves.** "Parity = one Walsh character" is *definitional*
(parity ≡ `W_{all-ones}`), so the character-capture half is not a discovery — it is the
statement of *which* corpus object reads it. The **falsifiable, non-trivial half is the
tree's exact-zero blindness**: an independent, pre-specified corpus decomposition (the
ANOVA/cylinder tree) explains *nothing* of parity at any non-degenerate depth, and this could
have failed (F3(b)) but did not. The finding is therefore the *location*: synergy is reachable
in the corpus, but only in the character basis, never the tree — exactly the scope claim Part
C makes about FDRS itself.

## H1 — discrimination confirmed; an honest deviation; a sharpened scope

**PASS.** coverEntropy `= log2 |distinct depth-d value-cells|` is **not** base-counting (F1
does not fire): at matched `(d=4, b=2)` it takes 4 distinct values — constant (1 cell) <
spread-2-level (2) < digit-cond-2 (4) < i.i.d. (16 = the `2^d` envelope). It is the exact
metric covering number (Kolmogorov ε-entropy) of the signal's **value-range**.

**Deviation from pre-registration (P-H1a/b), logged in full:** the per-signal table predicted
the metrically-*adjacent* `{0,1}`-valued sources (parity, golden-mean, markov) would read 2
cells at `d ≥ 1`; observed they read **1 cell until `d = 8`**, separating only at the finest
depth. Cause (verified, `transcript/screen_h1.txt` + run notes): `cover_of` is **MSB-first**,
so coverEntropy is a *metric* covering number — `{0,1}` differ by `2^0` (resolved last),
`{0,128}` by `2^7` (resolved first). The PASS verdict (P-H1b: ≥3 tiers, not flat, constant
lowest, i.i.d. at envelope) holds exactly; the deviation **sharpens** the pre-registered scope
bound P-H1c rather than threatening it.

**Scope bound (P-H1c, reported as characterization, not failure):** coverEntropy is blind to
temporal/sequential structure — parity (deterministic), golden-mean (rate `log2 φ ≈ 0.694`),
and markov are **indistinguishable** to it (identical curves) — and indifferent to value
multiplicity among metrically-clustered values. It reads the **metric spread of the range**
only. So "H1 passes" means *coverEntropy is a non-vacuous range ε-entropy*, **not** "it
captures all structure." Whether its scaling equals metric entropy quantitatively is **H2**.

## H6 — characterSynergy (Amendment 1): the order grading IS a synergy measure

**PASS — F6 not triggered** (`runs/2026-06-30-h6-character-synergy/`). Grading the exact Walsh
energy by interaction order `order(S) = popcount(S)` yields a synergy measure
`synergy_{>m}(f) = (Σ_{order>m} energy_S)/(Σ_{order≥1} energy_S)`. The finding rests on the
**exact (a)** and the **cross-validated (c)** — parity at top order is the **definitional null
(= H3)**, explicitly not the finding (NEGATIVE.md / the H6 definitional-trap line).

- **(a) exact zeros.** `synergy_{>1} = 0` **exactly (QQ)** for single-bit, additive, copy(native)
  at every k = 2..5; `synergy_{>k}=0`, `synergy_{>k-1}=1` for parity-k. The grading assigns
  additive/low-order structure exactly zero synergy — no high-order leakage.
- **(c) mixed gates — the non-definitional content.** AND-2 / OR-2 (genuinely mixed) read
  `synergy_{>1} = 1/3` (`o1:2/3, o2:1/3`), **strictly between** parity (1) and additive/copy (0),
  and this **agrees in sign and rank** with the independent neutral classical
  interaction-information: `II(XOR)=+1 > II(AND)=II(OR)=+0.189 (=(3/4)log₂3−1) > II(UNIQUE)=0 ≥
  II(COPY)=−1` (all exact). Two independently-defined quantities rank the AND gate identically;
  AND/OR symmetry preserved by both. Agreement is **ordinal**, not quantitative (`1/3 ≠ 0.189` —
  different units).
- **(b) parity vs random.** `synergy_{>k-1}(parity)=1` (exact) vs random ensemble mean →
  `1/(2^k−1)` (exact white-spectrum expectation), `≪ 1`, **for k ≥ 3**.

**Scope (pre-registered P-H6-scope, confirmed).** `synergy_{>m}` is **nonnegative**: COPY (II=−1)
and UNIQUE (II=0) both read `synergy_{>1}=0`. It is a **synergy measure** (the positive PID atom),
agreeing with classical-II on the synergy side; it does **not** resolve redundancy as a negative
quantity. The full PID lattice is out of scope. `characterSynergy` must carry this scope into the
Lean (a nonnegative top-order-energy synergy fraction, redundancy/uniqueness → 0).

**Deviation logged (honest; parallels H1).** Pre-registered (b) covered k = 2..5; **at k = 2 it
fails** — a random ±1 function on the 4-point hypercube is spectrally degenerate (only 3
non-constant characters; a draw is often a pure character; 8-seed mean 1/2, not the predicted
1/3). The k ≥ 3 restriction is **post-hoc** and attributed to the **control, not the measure**.
It is **not** an F6 falsification because: F6's kill conditions (a redundant/additive function
carrying top-order energy, or parity not concentrating, or gates mis-ranking) **did not occur**;
"random" is low-synergy only in expectation (a random function *can* equal parity, and high
synergy on it is the measure being correct); and **non-vacuity at every k incl. k = 2 is
independently established by the deterministic battery** (additive 0 < AND/OR 1/3 < parity 1,
exact). The random control is a supplementary check; its k = 2 degeneracy is a small-sample
artifact.

## Promotion staging (per ADR-007 §4 — proposed, not yet deposited)

Both decisive screens say **go**. Unblocked candidates (a G4 step; nothing deposited here):
- `coverEntropy_sound` — provable-now artifact control (the certified-cover count is a sound
  ε-cover cardinality); first natural deposit to `FdrsFormal/Conjectures/`, independent of any
  screen. **Note the honest scope:** it is the *metric range* ε-entropy, blind to temporal
  structure — the soundness lemma should be stated as such.
- `characterSynergy` on the Vilenkin basis — the genuine native extension. **H6 PASS now
  warrants it** as a `conjecture` target: `synergy_{>m}(f) = ` top-order character energy fraction,
  a **nonnegative synergy measure** that reads 0 on additive/low-order/redundant functions and
  ranks mixed gates in agreement with classical interaction-information. **The Lean statement must
  encode the scope** — nonnegative top-order-energy fraction, redundancy/uniqueness both → 0 (it is
  *not* a full PID lattice). The empirical `proof_wanted`: that `synergy_{>m}` ranks gates monotone
  with classical interaction-information (the cross-validated correspondence).
- H2a/H2b, H4, H5 remain `proof_wanted` candidates only on their own confirmation.

_No claim here is `registered` or higher beyond what its committed transcript + green
exact-mirror gate support. H3 is `exact`-tagged and reproducible; H1 likewise, with its
deviation recorded. Nothing committed to git, nothing pushed (per charter discipline)._

---

## Honest-broker review (appended 2026-06-30, post-hoc — sharpens, does not retro-fit)

Independent verification pass against the artifacts (transcripts ↔ this file line-for-line;
pre-registration confirmed by mtime — predictions 13:44, screens 13:48; mirror spot-checked
faithful: `cover_of` = MSB-first cell quantizer, `r_squared` = explainedVar/totalVar, exact
Walsh spectrum). The run is sound and was honestly reported. Two readings are **sharpened**.

### H3 is a *forced confirmation*, not a contingent discovery
Both halves are essentially theorems, not empirical bets: "parity ≡ one Walsh character" is
**definitional** (`parity = W_{all-ones}`), and `rSquared(parity, cylinder-tree) = 0` is
**forced** — any aligned cell of size ≥ 2 is popcount-balanced, so its parity-mean is 0. So
F3(b) (a tree capturing parity) was never a live empirical risk; it could only have surfaced as
an *implementation bug*. "Could have failed but didn't" should read as "the screen was not
buggy." The genuine, valuable output of H3 is the **location/redirect** (synergy is reachable in
the corpus, only in the character basis), confirming FDRS's self-consistency — **not** a discovery.

### H1's kicker — `coverEntropy` is range entropy, blind to *all* arrangement (not just temporal)
The transcript shows **parity reads `[1,1,1,1,1,1,1,1,2]` — nearly identical to `constant`.**
`coverEntropy` is the covering number of the **output value-set**; it is blind to arrangement
entirely, so a maximally-structured deterministic parity, a constant, and a *random* `{0,1}`
string are interchangeable to it. The H1 tiers (constant < periodic < digit-cond < iid) are tiers
of **value-multiplicity / range spread**, not structure. Therefore:

> **`coverEntropy` is a non-vacuous metric ε-entropy of the value *range* — NOT a
> "structured-information" measure.** It correctly occupies the combinatorial / Hartley branch
> (set covering number); structure lives in the *arrangement*, i.e. the variance/character
> **decomposition** (the H3 axis), not the cover. Naming it structured information would conflate
> "how many distinct values" with "how structured."

"H1 PASS" stands (non-vacuous, F1 does not fire) but its scope is narrower than the framing first
implied — it bounds `coverEntropy` to the combinatorial branch.

### Consequences (carried into Amendment 1, pre-registered in README)
- **`characterSynergy` is the genuine native extension** and is promoted to the next screen (H6).
- **`coverEntropy_sound` deposit must state the bound in the Lean** ("metric entropy of the value
  range, arrangement-blind"), not just in prose — else it will be cited as more than it is.
- **H2 is reshaped by H1.** Since `coverEntropy` covers a 1-D range, on a Hölder-α target expect
  slope ≈ 1 (range cover), **not** `1/α`. As originally written H2 would likely show
  `coverEntropy ≠ function-class metric entropy`. Re-specified as H2a/H2b in Amendment 1 so the
  outcome is read as a characterization, not a failure.
- **The actual source/sequential-information question (entropy *rate* — golden-mean's `log₂φ`,
  the Markov structure) is untouched by both screens** and lives wholly in H4 + the decomposition
  branches. Its priority is elevated.

Net: the decisive pair did its job — it says **go**, but redirects the investment toward
`characterSynergy` and the sequential/decomposition branches; `coverEntropy` is a clean,
correctly-bounded combinatorial object, not the line's center.

---

# Line B — The Emergent Group-Graded Complex (G3 verdicts)

## First exact screen — the HB2 horizon law (`runs/2026-06-30-lineb-ring-horizon/`, tag `proven`)

**Anti-HARKing note:** the charter + Amendment B1 were **committed (`df9fd8a`) before this screen
was written or run** — Line B's pre-registration precedes execution by commit ordering.

Build: `lake env lean` against the corpus env (read-only; corpus untouched). Both files 0 errors,
0 sorries; every theorem within the FDRS clean set `[propext, Classical.choice, Quot.sound]`.

| Screen | Run | Tag | Pre-registered prediction (Amendment B1) | Outcome | Status |
|---|---|---|---|---|---|
| HB2 horizon law | `2026-06-30-lineb-ring-horizon` | proven (Lean) | ring family: every radius-`k` ball with `2k+1 < N` gradable; whole non-gradable (`1<r`); full-cycle ball (`2k+1 ≥ N`) non-gradable | **parametric** whole-ring `ringGraph_not_gradable` (loop `walkFactor = r^N ≠ 1` + corpus `gradable_holonomy`); **concrete** ball witnesses `ball_5_1/7_1/7_2_gradable` (incl. the wrap edge `6→0` in the `7,2` ball — the path potential crosses the seam) and `ball_5_2/7_3_not_gradable` (via `restrict_total_gradable`) | **HB2 PASS — FB2 does not fire** |
| observer-relativity (the crown) | same | proven | same complex flips by horizon; same horizon flips by complex | `hb2_same_complex_different_horizon` (N=7: abelian at k=2, NON-abelian at k=3) · `hb2_same_horizon_different_complex` (k=2: abelian on N=7, NON-abelian on N=5) | **machine-checked, twice** |
| HB3 order-without-measure | same | proven | ordered `walkFactor` defined while no potential exists | `hb3_order_without_measure`: `IsWalk 0 loop 0 ∧ walkFactor = 32 ∧ ¬Gradable` (ring 5, r=2) | **HB3 PASS** (artifact control) |
| HB1 one-structure rider | same | proven | heterogeneous places under ONE definition, no case split | `unionWith : GroupGraph V G → GroupGraph W G → cross → GroupGraph (V ⊕ W) G`; `heteroComplex` = abelian line ⊕ `DihedralGroup 3` line (product group), cross-coupled (`heteroComplex_cross_couples`) | **HB1 PASS** (artifact control) |

**Honest read.** The finding is the **horizon law's observer reading** — *abelian is the
bounded-horizon reading; the illusion persists exactly until the observer's ball contains the
unbalanced cycle* — now a theorem-pair, not prose. Everything classical stays classical
(Zaslavsky balance; the corpus proved the dichotomy; this screen composed it with an observer).
Ball gradability is concrete (`v = 0`, `N ∈ {5,7}`, `k ∈ {1,2}`); **the parametric ball law
(`gradable ⟺ 2k+1 < N`, all `N,k,v`) is the `proof_wanted` promotion crown, not claimed.**
HB4 (emergence→grading) and HB5 (certified command step) are the next screens.

## Second screen — HB4 emergence→grading + HB5 certified command (`runs/2026-06-30-lineb-emergent-command/`, tag `proven` + `exact`)

| Screen | Run | Tag | Pre-registered prediction | Outcome | Status |
|---|---|---|---|---|---|
| HB4 emergence→grading | `2026-06-30-lineb-emergent-command` | proven (Lean) | a place manifesting/sustaining acquires its ratio AT BIRTH; un-earned (wall/wire) ⇒ identity; gradability preserved | `manifestLeaf_gradable` (any positive birth ratio preserves the measure) + `gradable_of_manifestLeaf` (and cannot fake one — measure-neutral) + `emergentRatio` trichotomy (`SubstrateZero`/wire inert) + `manifest_at_emergent_ratio_gradable` (composition) — all axiom-clean | **HB4 PASS — FB4 does not fire** (artifact control) |
| HB5 certified reactive command | same | proven (Lean) | emit only when the joint state forces it; refusal = safe hold | `certifiedCommand := Option.map over emitNow` (the corpus Thm 86 trap); `certifiedCommand_sound` (an emitted command is FORCED over every admissible tail + carries the declared grading — no hallucination) + `certifiedCommand_none_iff` (refusal = exactly the trap's — no spurious refusal); golden-mean demos (emit after `1`, refuse from `{0}`) | **HB5 PASS — FB5 does not fire** (artifact control) |
| Rust arc (first stone) | same | exact (mirror) | `graded-core` mirrors the screens embeddably | `no_std`, zero deps, fixed-capacity: `Ratio`/`CouplingGraph`/`walk_factor` (order)/`gradable()` (spanning-tree + holonomy check)/`ring`/`ring_ball`/`manifest_leaf`; **8/8 E1 fidelity tests**, each re-checking a Lean theorem (incl. both HB2 observer-relativity witnesses and HB3) | **LANDED** — fidelity-tested, not verified; guarantees live in the Lean |

**Honest read.** HB4/HB5 are what the charter said they are — **artifact controls** (provable-now
definability + soundness), now discharged; the finding of Line B remains HB2's horizon law. The
HB4 scope is the **leaf** (∅→0) birth — a leaf cannot create a cycle; manifestation into a JOIN
(closing a cycle) is uncovered future work, and the ring screen says exactly that is where measures
die. HB5 is a thin honest lift (commands ride certified emissions); the composition is the content.
Next: the parametric horizon law (`proof_wanted`, the promotion crown) and the async axis (HB6, by
amendment) — per the charter's deferral note.

# Novelty audit — FDRS sensor fusion control surface

**Adversarial prior-art audit, 2026-06-18.** Method: deep-research harness (103 agents, 5
search angles, 21 sources fetched, 100 claims extracted, 25 adversarially verified by 3-vote,
23 confirmed). Run: `wf_3a315742-401`. Framing: *try to refute novelty.* This is the
honest-broker record; treat it as the binding constraint on any external claim.

## Bottom line (read this first)

**The algorithmic content is NOT novel — every component is classical, much of it decades old.
Even the "machine-checked" angle is partially occupied.** The only genuinely unoccupied
territory is the *specific composed combination* (interval-consensus + recursive invariant +
async confluence + certified-refusal + exact-integer, axiom-clean in **Lean 4**, for an embedded
target). Novelty = **connection + curation + verified artifact**, exactly the project's standing
verdict — *not* new math, not a new algorithm, not a new theorem.

**Single strongest threat — cite it front-and-centre, never claim around it:**
> **Rushby, "Formal Verification of Marzullo's Sensor Fusion Interval," SRI CSL Tech. Report,
> Jan 2002** (`csl.sri.com/~rushby/papers/sensors.pdf`). Already **machine-checked, in PVS**, the
> soundness of exactly this interval fusion — "it always contains the correct value," in the
> `card(intersect) ≥ n−f` form, *including a fault-detection corollary* (`card < n−f ⇒ faulty`).
> Our k-of-n consensus soundness (`kConsensus_sound`) and even our refusal semantics are, at the
> static-fusion level, **a Lean re-expression of a 2002 PVS result.**

## Per-component novelty map

| Our component | Closest prior art | Verdict |
|---|---|---|
| #1 Interval/cylinder-cover belief (set, not distribution) | Schweppe 1968 (set-not-distribution); Jaulin–Walter SIVIA 1993 (subpavings = unions of cells) | **classical** |
| #2 Fusion = interval **intersection**; refuse on inconsistency | Marzullo 1990: "the f=0 operator **is** the intersection of all readings"; refusal ≈ Rushby's detection corollary | **classical / re-expression** |
| #3 **k-of-n majority consensus** over intervals | **Marzullo 1984/1990** ("smallest interval consistent with ≥ n−f sensors" = k=n−f majority); **Brooks–Iyengar 1996** (keep regions with overlap ≥ n−τ); Ao et al. 2016 (precision bounds) | **re-expression (verbatim)** |
| #4 Recursive predict/update, truth-stays-in-set invariant | Schweppe 1968 / Bertsekas–Rhodes 1971; Kieffer–Jaulin–Walter 2002 ("closely parallels Kalman filtering, alternating prediction and correction, recursively, real-time"); interval observers Raïssi–Efimov–Zolghadri 2012, Mazenc–Bernard 2011; Combastel 2015 (zonotopic) | **classical re-expression** |
| #5 Async confluence (order-independent fusion) | Intersection commutativity/associativity (semilattice fold); Kahn Process Networks 1974 (dataflow determinacy) | **trivial — must NOT claim as a theorem** |
| #6 Exact-integer / embedded | Integer/fixed-point interval arithmetic; CoqInterval (certified interval *numerics*, not an estimator) | **engineering choice, not a result** |
| "machine-checked / certified" (the distinguishing angle) | **Rushby 2002 (PVS, static interval-fusion soundness + fault detection)**; Tekriwal et al. 2024 (Coq, scalar W-MSR consensus) | **partially occupied** |

## What IS (narrowly) unoccupied

No source establishes the **exact composition**: an axiom-clean **Lean 4** mechanization of the
*whole stack* — interval-consensus **+** recursive cross-cycle invariant **+** asynchronous
multi-rate confluence **+** certified-refusal semantics **+** exact-integer arithmetic for an
embedded/RTOS target — as one artifact. Prior verified work covers *parts*: Rushby = static +
PVS (not recursive/async/refusal/exact-int); Tekriwal = Coq + scalar averaging (not
interval/set); Kieffer/Combastel = recursive but unverified; CoqInterval = numerics tactic, not
an estimator. **No prior Lean (vs PVS/Coq) verified set-membership / interval-consensus estimator
was found.** That gap is the *only* defensible novelty bid, and it is curation, not mathematics.

## Must NOT be claimed as novel

Interval/set belief · intersection fusion · k-of-n interval consensus · truth-stays-in-set
invariant · the unknown-but-bounded (UBB) noise model · the set-vs-probability distinction ·
order-independence/confluence of intersection fusion · the dyadic/ultrametric cylinder
representation (multiresolution dyadic grids and p-adic/ultrametric models are classical) · "first
machine-checked interval-fusion soundness" (Rushby 2002 has it).

## Must-cite threats (the binding prior art)

- **Rushby 2002** (SRI, PVS) — *the* threat: machine-checked Marzullo-fusion soundness + fault detection.
- **Marzullo 1990** (ACM TOCS 8(4):284–304; orig. 1984 Stanford PhD) — the interval consensus itself.
- **Brooks & Iyengar 1996** (IEEE Computer 29(6):53–60); **Ao, Wang, Yu, Brooks & Iyengar 2016** (ACM CSUR 49(1) Art.5, precision bounds).
- **Schweppe 1968** (IEEE TAC AC-13(1):22–28); **Bertsekas & Rhodes 1971** (IEEE TAC 16(2):117–128) — set-membership estimation.
- **Kieffer, Jaulin & Walter 2002** (IJACSP 16(3):193–218); **Jaulin, Kieffer, Didrit & Walter, "Applied Interval Analysis," Springer 2001** — guaranteed recursive interval estimation.
- **Raïssi, Efimov & Zolghadri 2012** (IEEE TAC 57(1):260–265); **Combastel 2015** (Automatica 55:265–273) — interval observers / zonotopic filtering.
- **Tekriwal et al. 2024** (TACAS, arXiv:2202.13833) — first Coq proof of fault-tolerant (scalar) consensus; **LeBlanc et al. 2013** (W-MSR).
- **Kahn 1974** — process-network determinacy (the honest home of "confluence").

## How to frame the contribution honestly (engineering ≠ research novelty)

- **Do say:** a verified, exact-integer, axiom-clean **Lean** re-expression of classical
  interval-consensus filtering (Marzullo/Schweppe lineage), *composed* into one certified
  predict→fuse→route surface — a reusable, embeddable artifact to engineer against. The value is
  **engineering utility + a clean verified composition**, and the FDRS-corpus connection.
- **Do NOT say:** a new fusion algorithm, a new robustness result, the first verified interval
  fusion, or that confluence is a theorem.
- The honest one-liner: *"We did not invent the math — Marzullo and Schweppe did, and Rushby
  machine-checked the core in 2002. We re-expressed and composed it, axiom-clean in Lean, as an
  exact-integer embeddable control surface."*

## Caveats on this audit (honesty about the audit itself)

- **Artifact-existence false negative (corrected):** the audit's verifiers grepped the *main*
  `FdrsFormal/` repo + `docs/fdrs.md` and concluded the fusion code "does not exist." It **does** —
  in *this* experiments family (`lean/FdrsSensorFusion.lean`, 40 theorems, builds green,
  axiom-clean), kept deliberately *outside* fdrs-formal. The agents searched the wrong tree; the
  artifact is real and verified. (This does not change any prior-art verdict.)
- **Citation hygiene (do not affect verdicts):** the auto-extracted DOI `10.1145/128733.128735`
  is Marzullo 1990, *not* Rushby — Rushby's source is the SRI PDF. Some Schweppe/Bertsekas–Rhodes
  DOI conflation (same UBB lineage). One interval-observer ResearchGate URL pointed at
  Cacace–Germani–Manes vs the cited Raïssi/Mazenc (both genuine). Verify each DOI before any writeup.
- **Open / time-sensitive:** (a) the "no prior Lean recursive set-membership estimator" negative
  is the only time-sensitive claim — a 2024–2026 paper could falsify it; re-check before publishing.
  (b) Rushby's fault-detection corollary may *partially* occupy even the certified-refusal niche —
  treat refusal as "refinement of," not "new." (c) confluence (#5) had no surviving prior-art
  citation beyond intersection commutativity / KPN — frame as trivial. (d) p-adic/ultrametric
  signal-processing prior art (Khrennikov; dyadic wavelets) was not fully resolved but is treated
  as classical here, consistent with the FDRS corpus's own novelty verdict.

## Consequence

This **confirms and sharpens** the project's standing `fdrs-novelty-verdict`: no new math; the
contribution is connection + curation + the verified artifact. Proceed on **engineering value**
(a certified reusable fusion surface), not research-novelty claims, and cite Rushby/Marzullo/
Schweppe wherever the work is described.

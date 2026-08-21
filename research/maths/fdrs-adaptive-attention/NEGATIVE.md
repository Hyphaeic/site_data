# Negative results & fraud gallery — fdrs-adaptive-attention

ADR-007 bounded-completeness: refuted sub-hypotheses are reported at full weight, and the tempting-but-wrong
spins are written down so they cannot be quietly used.

---

## NEG-1 — F2 budget direction REFUTED: the advantage does NOT grow as the budget shrinks

**Pre-registered (charter, F2):** "the adaptive advantage … **grows as the budget B shrinks** (sparser ⇒
selection matters more)."

**Result (`runs/2026-06-19-rung1-screen/`):** the opposite, within the tested range. At SNR=8 the advantage
(fixed_err / adaptive_err) is **5.1× at B=1 → 9.2× at B=2 → 11.3× at B=4** — it grows *with* budget, not
against it. Since at B = n_blocks (dense) all rules equal dense (advantage → 1), the advantage is
**non-monotone in B**: it rises from B=1, peaks at intermediate budget, and falls back to 1× at full budget.

**Why the intuition was wrong.** "Sparser ⇒ selection matters more" is about the *absolute stakes* of a
single choice, but the metric is a *ratio*. At B=1 both fixed and adaptive pick one block; adaptive's hit is
imperfect (91% at SNR=8) and a single miss is unrecoverable, capping the ratio. With a little slack (B≥2)
adaptive reliably includes the target *plus* the next-best blocks, while fixed wastes its budget on a local
window — so the ratio widens. The honest statement is **F2-SNR holds; F2-budget is non-monotone and the
pre-registered direction is refuted.**

---

## NEG-2 — Rung 2: the FROZEN content gate fails to help (A1 refuted) — but the plan, not the gate, is exonerated

**Pre-registered (Rung 2, A1):** content-adaptive val-accuracy ≥ fixed-local + 0.15 in ≥ 4/5 seeds.

**Result (`runs/2026-06-19-rung2-train/`):** refuted, 0/5. Structured val-accuracy (5-seed mean): adaptive
**0.154 is BELOW fixed-local 0.186** (and far below oracle 0.559). A3 also refuted (gap fraction −0.086).

**Why it is the GATE, not the plan.** The decomposition is unambiguous:
- **The plan/routing has large value:** `oracle` (correct routing at budget B=2) = **0.559 ≫ fixed 0.186**, and
  *above* `dense` 0.319 — focused correct low-budget routing beats both fixed sparsity and full attention.
- **The frozen gate routes below chance:** the content-adaptive gate hits the planted target only **10%** of
  the time, *below* the 25% expected by chance at budget 2. The pooled-Q·pooled-K rule on the model's *learned*
  Q/K is dominated by **self-similarity** (a block scores highest against itself), so it burns its budget on
  self + a neighbour and rarely routes to the content-matched remote block — and with no gradient through the
  frozen selection, the model can't bootstrap a fix.

**Why Rung 1 didn't transfer.** Rung 1's content gate worked because the inputs were *constructed* with Q
pre-aligned to the target's K. Rung 2 *learns* Q/K, and the frozen pooled-dot rule has neither the form nor
the incentive to align with the token-level content match the task requires. A fidelity screen passing
(necessary) did not make the trained-model claim hold (sufficient) — exactly the gap Rung 1 flagged.

**Control (A2) holds:** the no-structure condition is at chance (~0.13) for every variant, so the oracle's win
is genuinely structural, not a shortcut. **Conclusion:** the FDRS content-adaptive *plan* has real model-level
value; the *frozen* gate cannot realize it on learned representations ⇒ a **learned router** is required (the
pre-registered next rung). This is the pre-registered ¬A1 outcome, localizing the failure to the gate.

## What Rung 1 DID confirm (so the negative isn't over-read)

F1 is confirmed: at high SNR the FDRS content gate beats fixed by 5–11× and closes 89–95% of the
fixed→oracle gap, with a clean SNR=0 floor. The refutation is specific to the *budget-direction* sub-claim.

Rung 2 confirms the **plan/routing has model-level value** (oracle 0.559 ≫ fixed 0.186, > dense 0.319) and
that the controls are clean (A2 null). The negative (NEG-2) is specific to the **frozen gate**, not the plan.

Rung 3 then **confirms the plan value is learnable**: a learned router (auxiliary routing supervision)
recovers 76% of the oracle gap, target-hit 0.70, B1–B5 all pass, controls clean. The standing caveats (#11–13)
are the supervision qualifier and the 70%/76% residual — not a deployable method, not unsupervised.

## Fraud gallery — spins this experiment must NOT be used to support

1. **"FDRS gives a new sparse-attention method."** FALSE. Content-adaptive block-sparse attention is mature
   prior art (Routing Transformer, BigBird, Reformer/LSH, NSA). This tests FDRS's plan algebra as a
   *substrate* on the verified M3 kernel — connection + curation, not a new method.
2. **"Adaptive attention works (rung 1 proved it)."** Overclaim. Rung 1 is a **training-free fidelity
   screen**: it shows the content gate *approximates dense better than fixed at budget B* — a **necessary,
   not sufficient** precondition. The model-level claim needs the (deferred) training rung.
3. **"Adaptive ≈ oracle."** No — adaptive is ~2× the oracle's *absolute* error; it closes ~89–95% of the
   *gap to* the oracle. The cheap gate captures most, not all, of the achievable selection benefit.
4. **"The advantage proves the FDRS structure helps."** The advantage is the **classical content-based
   selection** effect (top-B by a relevance score), expressed over the FDRS `AttentionPlan`. The win is
   selection-by-content, which is not FDRS-novel; FDRS supplies the plan substrate.
5. **"Big advantage numbers (11×!)."** Those are at the planted-signal high-SNR end of a *synthetic* sweep
   designed to *have* exploitable structure; at SNR=0 the advantage is ~1×. Always read the full SNR curve,
   never the high-SNR cell alone — that is the point of the sweep (and of the SNR=0 floor).
6. **"`gap_closed` at low SNR."** Meaningless there: when fixed ≈ oracle there is no gap, so the ratio is
   unstable/undefined (null/noise in the table). Only interpret `gap_closed` where fixed > oracle.
7. **"It's fast / efficient."** No timing, no FLOP accounting beyond the active-block budget. No speed claim.
8. **"FDRS content-adaptive attention helps a model (rung 2)."** FALSE for the *frozen* gate (NEG-2): adaptive
   (0.154) is *worse* than fixed-local (0.186), gate routes below chance. The honest claim is the
   decomposition — the *plan/routing* is valuable (oracle ≫ fixed), the *frozen pooled-dot gate* fails to
   realize it. Do not cite rung 2 as "adaptive attention works"; it shows the frozen gate does **not**.
9. **"The oracle result is the FDRS win."** The oracle is a *ceiling*, not the method: it is handed the
   ground-truth target. It proves the *plan* could help if routing were correct; it is not an achievable
   FDRS result. The achievable frozen-gate result is the negative (adaptive < fixed).
10. **"Rung 1 passing means rung 2 should pass."** It didn't — fidelity-at-budget (rung 1, pre-aligned inputs)
    is necessary, not sufficient, for trained-model benefit (rung 2, learned Q/K). The frozen gate's pooled-dot
    rule is self-similarity-dominated on learned representations; this is why a *learned router* is the next rung.
11. **"Rung 3 shows the router can be learned (the plan works end-to-end)."** Half-true, and the half matters:
    the rung-3 router is trained by an **auxiliary loss that uses the known target**. It shows the plan value is
    learnable **with routing supervision** — NOT that a router learns from task loss alone (straight-through /
    Gumbel top-k / RL), which is explicitly deferred. Do not drop the "with supervision" qualifier.
12. **"The learned router matches the oracle."** No — it routes correctly **70%** of the time (not 100%) and
    closes **76%** of the fixed→oracle gap (not 100%). A real residual remains; the oracle is still a ceiling.
13. **"Rung 3's big jump proves FDRS-adaptive attention."** It proves *routing quality was the bottleneck and
    is learnable here*, on a synthetic position-free retrieval task, at one budget, with supervision. Controls
    (no-structure null, permutation-invariant) rule out shortcuts — but this is a mechanism result, not a
    deployable method or a general sparse>dense claim.

# Negatives & falsifiers — fdrs-chart-coupled-attention

Negatives are first-class (ADR-007). This file lists, **before any run**, the ways a coupling could *look*
compiled-and-faithful while being an artifact, plus the falsifier table that says when to declare a null. The
sibling proved the discipline pays (it caught NEG-1 `QQ(float)` and NEG-2 sharpness); the same paranoia applies to
the constructive direction, where the seductive failure is **"accuracy matched, therefore compiled."**

## §1 — Fraud gallery (patterns that would fabricate a "compilability" result)

1. **Trivial-task match.** If the task is easy enough that near-uniform attention already solves it, *any* coupling
   (even the wrong one) "matches" the head. → **Control:** only non-degenerate tasks (aggregation required;
   max-weight ≈ 1/B; mask-all-but-one crashes the original). The Rung-13/14 modular task is pre-checked
   non-degenerate; re-verify per task.

2. **Normalization / coupling answer-leak.** The integer normalization `(1/|Cᵢ|)Σvⱼ`, or a coupling whose classes
   align too well with the label, can *encode the target* independent of any learned computation. → **Control:**
   the **wrong-coupling** must fail (`C₄` on a mod-3 head), and **shuffled-V** must destroy the match. If the
   wrong coupling also "works," the operator is reading the answer, not the mechanism.

3. **Gate over-capacity.** A learned gate `g_r` with enough capacity can recover the full task *regardless* of how
   good the coupling library is — stealing credit the couplings didn't earn. → **Control:** bound and ablate gate
   capacity; a positive B4 must survive a near-trivial gate, and must collapse when the library is replaced with
   wrong couplings.

4. **Accuracy ≠ function (aggregate-score illusion).** Two operators can hit the same task accuracy while computing
   different functions. Declaring a head "compiled" on accuracy alone is the central trap. → **Control:** require
   **per-input output agreement** on held-out inputs (B1/B2 primary metric), not just aggregate score. Until that
   agreement clears the pre-registered strict threshold (≥ 0.98), a head is at most **`candidate-compilable`**;
   **"losslessly compilable" is reserved** for outcome 1 (pure-average `(b)`) at threshold. A `(c)` match (exact
   class + learned intra-weights) is reported as the partial/intra-weighted outcome, never as "lossless."

5. **Cherry-picked head.** Scanning all heads and reporting only the ones whose coupling happened to match is
   HARKing. → **Control:** heads are pre-identified as positional by the sibling's Rung-13/14 battery (match by
   *recovered chart*, not head ID), *before* compiling; report the full head set incl. the failures.

6. **Compiling from a fished chart.** If the source chart was gauge-fished (which the sibling forbids via the
   penalized RadixScore), the coupling inherits a fabricated structure and any "match" is circular. → **Control:**
   compile only from charts that survived the sibling's penalized search + controls.

7. **"Exact" theater.** Claiming an exactness-tag upgrade while float values silently re-enter (un-quantized V, a
   float gate counted as exact). → **Control:** the decoration tag composes weakest-tag; integer V is required for
   the `exact`/`enclosure` claim, and the float gate keeps its branch `float`.

8. **Content head reproduced (the FDRS red flag).** If an exact chart coupling reproduces a *content/semantic*
   head, that contradicts the commutant prior (THEORY Part C: couplings express only the cylinder-measurable
   part). Treat it as a leak (trap #2), not a triumph — investigate before believing.

## §2 — Falsifier table (when to declare a null / a tension)

| Observation | Reading |
|---|---|
| Exact `C_P` ≠ chart-masked head (B1) even for a clearly positional head | the chart was **not** the head's mechanism → **tension with the sibling's Rung-14 causal result**; record, do not bury |
| Exact coupling < learned head by a pre-set margin (B2) | not **losslessly** compilable; report as partial/null (the structure is positional-ish but more than a clean coupling) |
| Couplings match **everywhere**, including content/diffuse heads (B3 fails) | task trivial or metric leaks (traps #1/#2) → **whole result void** until the control passes |
| Wrong-coupling / shuffled-V also "match" | answer-leak (trap #2) → void |
| Only a high-capacity gate makes B4 work | couplings aren't carrying the computation (trap #3) → gate is doing it |
| Match on accuracy but not per-input (B1/B2) | aggregate-score illusion (trap #4) → not a function match |

## §3 — Recorded negatives

*(none yet — experiment unstarted. NEG entries are added here as runs surface them, mirroring the sibling's
NEG-1/NEG-2.)*

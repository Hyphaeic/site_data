# Negative results & fraud gallery — fdrs-mcf-threefolds

Seeded **before M0** (ADR-007: negatives first-class; the traps written down before any
scoping, so they cannot be quietly walked into). This experiment is scoping-gated; the most
likely first-class outcome is a *designed negative* (M0.4) or an honest "scoped and parked."

---

## Fraud gallery — spins this experiment must NOT be used to support (seeded pre-M0)

1. **"Algorithm X is the canonical multidimensional continued fraction."** FALSE — there is
   none. The existence of a canonical MCF (with the periodicity that characterizes cubic
   irrationals) is the **Hermite problem**, open since the 19th century. Jacobi–Perron, Brun,
   Selmer, Klein/sails, Mönkemeyer are all inequivalent, each with failure modes. Any
   "the canonical one" claim is `F-3-canon` and is the field's classic trap. (The whole point
   of the algorithm-space framing is that there is a SPACE, not a distinguished point.)
2. **"Jacobi–Perron (or any MCF) is periodic for cubic irrationals."** Not a stated fact —
   this is exactly the open/negative territory (JP periodicity for cubics is unproven in
   general and known to fail for many). No periodicity guarantee may be asserted in `SCOPING.md`
   without a source; unsourced periodicity claims are the M0.1 fraud.
3. **"The economic (Danilov) resolution is THE minimal resolution."** FALSE in dim 3 —
   minimal resolutions of 3-folds do not exist in general. Economic resolutions are a
   *distinguished construction*, not a minimal object; and terminal singularities have no
   crepant divisors at all. Calling any dim-3 toric resolution "minimal" is `F-3-canon`'s cousin.
4. **"Gauge = |det| = r, same as dim 2."** Premature. The surface lesson (the abelianization
   correction the naive HJ-analog law needed) says expect the crude `r` to be the *coarse*
   datum and the discrepancy/age vector to be the rich one. Asserting the naive `|det|=r` law
   without checking against the economic resolution is the M0.2 trap.
5. **"FDRS captures the resolution of a terminal 3-fold quotient with one law."** The M0.4
   walls (flops; Hermite non-periodicity) are pre-registered reasons a **single deterministic
   Phase-7 law provably cannot** capture the full picture. A single-law success claim that
   ignores the flop-equivalence class or the non-periodic cubic case is fraud; the honest
   result is the *boundary* (what one law cannot do).
6. **"This says something about general 3-fold singularities."** FALSE — `F-3-scope`: cyclic
   quotients only, terminal-first. No general-singularity claim.
7. **"We ran the anchor."** Not until (a) the M0.2 battery is fixed and (b) an **independent**
   dim-3 toric oracle (Sage / Normaliz / polymake / Magma) is identified and shown adequate.
   Running before the oracle exists is `F-3-anchor` and voids the exactness ladder.
8. **"New MCF / new resolution theory."** `F-novel`: MCF, terminal classification, economic
   resolutions, Klein sails are classical (Reid, Danilov, Mori, Klein, Karpenkov). The
   contribution — if any — is the algorithm-space *encoding* + verified artifact.
9. **"Discrepancy is the conserved quantity across subdivision laws" (naive form).** Refuted
   in advance: the essential discrepancies `{1/r,…,(r−1)/r}` occur in *every* resolution (they
   are intrinsic to the singularity — Bouvier–González-Sprinberg), so "conserved across laws
   resolving the *same* singularity" is **true by definition of *essential* and says nothing
   about any transport** — the exact shape of P5's `F5-tautology`. A real test needs a
   law-morphism that *changes* the singularity (a Wahl-analog on `(r,a)`) or an analysis of
   *non-essential* divisors. This is `F-3-essential-tautology`.

---

## Guard table (statuses updated after M0 scoping — 2026-07-07)

| ID | Fires when | Kills | Status |
|---|---|---|---|
| **F-3-canon** | any one MCF algorithm presented as "the" canonical generalization | the algorithm-space thesis | **well-founded** — Hermite open; Karpenkov sin² reaches only totally-real cubics (arXiv:2101.12707). No "the canonical MCF." |
| **F-3-anchor** | running before the M0.2 battery + independent dim-3 oracle are fixed | the exactness ladder | **satisfiable** — oracle identified + smoke-tested adequate (Sage verify-mode + elementary age; `oracle_probe{,2}.sage`). Battery fixed in `M1-draft.md`, unregistered. |
| **F-3-scope** | any claim about general (non-cyclic-quotient / non-terminal) 3-folds | the honest-scope contract | **held** — anchor is cyclic-quotient, terminal-first; general "ladder for all terminals" was REFUTED (see below), reinforcing the line. |
| **F-novel** | any "new MCF / new resolution theory" claim | the honest-broker line | **honored** — every M0.2 fact is Reid/Danilov/Sato–Sato/White; contribution is the encoding. |
| **F-3-essential-tautology** *(new, M0.3)* | "discrepancy conserved" claim reducing to "essential divisors are intrinsic" | the experiment-level (M4) conjecture | **seeded** — must be dodged before M4 runs (analog of P5 `F5-tautology`). |

---

## Recorded negatives & refuted over-claims

**M0 outcome:** gate **CLEARED** (not parked) — see `SCOPING.md` verdict. The designed
negatives (M0.4) are the two boundary theorems (Hermite non-periodicity; toric-flip
non-uniqueness), stated but not yet run (M2/M3).

**Refuted during M0 literature verification (honest bookkeeping — over-claims the research
would NOT let stand):**
- **"Every 3-fold terminal singularity is resolved by a minimal-discrepancy weighted-blow-up
  ladder."** REFUTED 0–3 (against arXiv:1310.6445): the general existence over-reached; only
  the **cyclic-quotient** economic resolution stands. → the anchor is solid *only* inside
  `F-3-scope`. Load-bearing: do not let M1's success leak into a general-terminal claim.
- **"Every 3-fold terminal = cyclic quotient or cDV" (the structural dichotomy).** Recorded
  0–3, but *because the paywalled source did not expose the list*, not because it is false
  (it is a real theorem, Reid–Mori). Flagged so we neither cite it as verified nor treat it
  as refuted — it is simply *unverified this pass*.
- **"AJPA solved cubic periodicity generally."** REFUTED (1–2): it is enumerated families
  only (Lee arXiv:1810.11676). Reinforces `F-3-canon`.

*(No experiment-run negatives yet — M0 is report-only. Any "scoped and parked" or M1/M2/M3
negative will be recorded here with its errata.)*

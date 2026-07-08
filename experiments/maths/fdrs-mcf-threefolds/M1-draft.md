# M1-draft.md — protocol for the first runnable phase

**STATUS: WRITTEN, NOT REGISTERED.** This is a pre-registration draft. It does not become
the registered M1 protocol until the human review of `SCOPING.md` clears the M0 gate
(ADR-007). No code is run against it until then. If the gate says "scoped and parked,"
this file is archived, not executed.

---

## M1 — The dim-3 anchor: the economic resolution of terminal `¹⁄ᵣ(1,a,r−a)` as an exact Phase-7 radix law

**One-line goal.** Establish, on the exactness ladder (Sage verify-oracle + elementary age
oracle + Rust `no_std` mirror), that the economic (Danilov–Barlow / Ashikaga–Fujiki–Oka)
resolution of the terminal anchor family **is** an exact FDRS Phase-7 context-dependent
radix law — the dim-3 analog of P1 (HJ = radix law), with the loss of dim-2 canonicity made
explicit and *not* papered over.

**Why this is the right M1 (not a later phase).** M0 confirmed the anchor is decidable, the
resolution is a named algorithm (Ashikaga CF), and the oracle is adequate and correctly
shaped (law generates, Sage verifies). This is exactly the clean, canonical-enough corner P1
occupied in dim 2. The *non-canonical* content (the walls) is deliberately deferred to
M2/M3 so M1 stays a clean anchor.

### The law (the object under test)

A Phase-7 `(state, Ω, Γ)` triple over the toric lattice `ℤ³`:

- **State `s`:** the active singular cone — carried as `(r, a)` plus the `3×3` integer ray
  matrix of the active chart (multiplicity `|det|=r` is the gauge).
- **Digit `Ω(s)`:** the next economic subdivision ray. Two equivalent generators to be shown
  to coincide: (a) the explicit economic ray `v_k=(1/r)(k, ak mod r, (r−a)k mod r)`; (b)
  **Ashikaga's continued-fraction digit** (round-down polynomial + remainder) as in
  Sato–Sato (arXiv:2108.02402). `Ω` is *context-dependent* — the admissible digit depends on
  the current cone, precisely the Phase-7 shape.
- **Update `Γ`:** star-subdivision of the active cone along `Ω(s)` (a weighted blow-up =
  subdivision along a primitive ray; Chen arXiv:1310.6445), yielding the successor
  cone(s). **Terminal (Base-0 Wall):** the cone is smooth, `|det|=1`.

### Hypotheses and pre-registered falsifiers

| ID | Hypothesis | Falsifier (pre-registered) |
|---|---|---|
| **H-M1a** (exactness) | For every anchor in the battery, the law's full subdivision is certified **smooth** by the independent Sage oracle. | **F-M1-smooth** — any battery anchor where Sage reports the law's output fan is *not* smooth. |
| **H-M1b** (gauge) | The coarse gauge `|det(σ)| = r = |μᵣ|` holds (P1 analog), **and** the ordered discrepancy vector of the law's exceptional rays equals `(1/r,…,(r−1)/r)` by *both* the elementary age formula and the toric support-function computation. | **F-M1-gauge** — any anchor where the two discrepancy computations disagree, or either differs from `{k/r}`. |
| **H-M1c** (Ashikaga ≡ economic) | The Ashikaga-CF digit sequence reproduces *exactly* the economic ray set `{v_k}` (generator (a) ≡ generator (b)). | **F-M1-ashikaga** — any anchor where the Ashikaga digits and the economic rays diverge. |
| **H-M1d** (ladder parity) | A `no_std` Rust mirror of the law reproduces the Sage oracle's smoothness verdict and the discrepancy vector for the whole battery, bit-for-bit. | **F-M1-parity** — any anchor where Rust and Sage disagree. |
| **H-M1e** (canonicity) | The economic resolution is the **unique** smooth toric resolution on the essential ray set across the battery (extending the 5-anchor M0.4 finding — the anchor's target is canonical, so the algorithm-space content is *paths not destinations*). | **F-M1-canon** — any battery anchor admitting ≥2 smooth resolutions on its essential rays. |

### Battery

All terminal anchors `¹⁄ᵣ(1,a,r−a)` with `2 ≤ r ≤ R_max`, `1 ≤ a < r`, `gcd(a,r)=1`
(one representative per generator-symmetry class). `R_max` fixed at registration (candidate:
`R_max = 60`, giving `Σφ(r)`-many cases, comfortably exact-arithmetic-sized). Plus the four
hand/Sage-worked anchors from M0 (`r∈{5,7,11,13}`) as smoke tests, and `¹⁄5(1,2,3)` as the
worked headline.

### Oracle (established in M0, promoted to `source/` under M1 provenance)

- **Elementary age oracle** (discrepancy, terminality) — integer arithmetic, self-verifying
  against `{k/r}`. Owned in-house (Sage + Rust).
- **Sage toric verify-oracle** — `Fan.is_smooth()` on the law's supplied subdivision.
- **Rust `no_std` mirror** — the P1–P7 ladder pattern.
- **Normaliz** (optional second check) — cone Hilbert basis = essential divisors.

### Verdicts (pre-declared)

- **PASS:** H-M1a–d all hold across the battery; `¹⁄5(1,2,3)` headline reproduces
  discrepancies `1/5,2/5,3/5,4/5`, smooth, gauge `r=5`.
- **PARTIAL:** exactness (H-M1a/b) holds but Ashikaga≡economic (H-M1c) fails or is only
  verified on a sub-family (the encoding works but the *named* CF is not the generator) —
  recorded honestly; the law still stands, the literature-bridge is narrower than claimed.
- **NEGATIVE:** F-M1-smooth or F-M1-gauge fires — the economic recipe as transcribed is
  wrong; errata + first-class negative (this would be a real, publishable correction).

### Pre-seeded fraud gallery for M1 (before its code)

- "We resolved a **general** 3-fold singularity." — `F-3-scope`. M1 is cyclic-quotient,
  terminal-first, full stop.
- "The economic resolution is **THE minimal** resolution." — `F-3-canon`. It is a
  distinguished *construction*; no minimal object exists in dim 3.
- "Gauge `= r` captures the singularity." — refuted in advance by H-M1b: the informative
  invariant is the **discrepancy vector**, not the scalar `r`.
- "Ashikaga's CF is **the** canonical MCF." — `F-3-canon`. It is *one* algorithm that
  happens to generate this resolution; the algorithm space is the point.

---

## The phase ladder beyond M1 (sketched, not registered — sequence subject to M1's outcome)

- **M2 — the non-terminal extension (where Wall 2 *actually* lives).** M0.4 showed the
  *terminal* anchor's economic resolution is canonically **unique**, so the flip/non-uniqueness
  wall is **not** at the anchor. It lives in the **canonical (non-terminal)** cyclic quotients
  `¹⁄ᵣ(1,a,b)` with an age exactly `1` — which *have* crepant (discrepancy-0) divisors and thus
  genuine minimal-model non-uniqueness / **flops**. M2 sites the designed negative there:
  exhibit a canonical quotient with ≥2 crepant resolutions, flip-connected, that a single `Ω`
  provably cannot hold — the honest home of the reviewer's original "Y". Oracle: Sage
  triangulation count (`wall2_multi.sage` pattern) + crepant/age check. *This is the phase the
  designed no-go is owed to.*
- **M3 — arithmetic MCF as subdivision (the S→T question; likely-negative).** M0.1 established
  the arithmetic MCFs (JPA/Brun/Selmer/Mönkemeyer) are sense-**(S)** simplex-splitting
  (Lagarias), and that **no** classical MCF has a sense-**(T)** resolution reading. M3 tests
  directly: does JPA's (or Brun's) step satisfy M0.3 (1)–(4) as a *resolution* of the anchor?
  Expected honest outcome **NEGATIVE** ("sense-S ≠ sense-T for arithmetic MCF X") — the finding
  being that the resolution bridge runs through Ashikaga/Klein only, not the arithmetic zoo.
  Touches Wall 1's Hermite frontier at cubic directions.
- **M4 — the conserved-discrepancy transport (the P5 analog, *sharpened*).** Only after
  `F-3-essential-tautology` is dodged: define a **Wahl-analog move on `(r,a)`** (a law-morphism
  that *changes* the singularity), and test whether a discrepancy datum transports across it
  (the true "value dies, invariant survives" test), **or** analyze the non-essential divisors a
  law adds. The experiment-level conjecture; *not* M1, and forbidden in the tautological
  same-singularity form.

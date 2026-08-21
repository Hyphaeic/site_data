# Future directions — fdrs-attention-mixed-radix

> **Status: scaffold only. Nothing here is started, nothing here has code, nothing here is merged into the frozen
> Rungs 0–14 result** (see `SUMMARY.md`). These are scoped *proposals* branching off the frozen synthetic
> milestone. Each would get its own pre-registration before any run, per ADR-007.

The frozen milestone established (synthetic, controlled): the **value** lens is null; the **positional** mixed-radix
lens recovers the task's coordinate charts, and chart-aligned interventions show those charts are **causal**. Two
*orthogonal* directions follow. They are not competitors — one extends **scope**, the other extends **method**.

---

## Track A — pretrained-model candidate charts (extends SCOPE; observational)

The existing "Rung 15." Point the same positional battery at a **real pretrained model**; report control-surviving
candidate charts. **Strictly descriptive unless** the Rung-14 intervention protocol is actually run on the
pretrained model. Set-level reading; match-by-chart; value-null frozen; not merged into the synthetic result. This
fits *this* family's charter (observational study of existing attention). No code in this package.

---

## Track B — exact integer coupling operators (extends METHOD; constructive) → PROMOTED

> **Promoted to its own sibling experiment (2026-06-26): `../fdrs-chart-coupled-attention/`** (charter + THEORY +
> NEGATIVE + registry draft; unstarted, no code). The sketch below is retained as the rationale; the live spec is
> in that experiment's `README.md`.

**Thesis.** Turn the lens around: from *recovering* the chart a float attention head learned, to *compiling* that
chart into an **exact integer coupling operator** that **replaces** the head — and testing whether behavior is
preserved. If it is, the model was using a structure that can be **compiled out of floating-point attention**.
That promotes the finding from *descriptive + causal* to **compilable**.

```
  float attention  →  recover chart (Rungs 7–14)  →  compile to exact integer coupling  →  replace head  →  test
```

**Why this is the stronger immediate next step (stronger than Track A):**
- It builds on the **positive** lens (positional charts), **not** the frozen-null value lens. It does **not**
  reopen the value-arithmetic null.
- It is **FDRS-native**: cylinders, partitions, digit-conditioned membership, integer-normalized aggregation are
  the home objects (Part A / Part E). The "coupling" is just cylinder co-membership.
- It **reuses existing infrastructure**: the Rung-13/14 modular transformer (`capture_transformer.rs`,
  `capture_intervene.rs`) is already trained, with recovered mod-3/4/5 charts in hand. The first experiment needs
  **no new model and no new data**.
- It stays **synthetic / controlled** — no scope inflation. And it can carry a **stronger decoration tag**: the
  coupling operator itself is *exact* (integer), so a successful result is `enclosure`/`exact` on the operator
  side, with only the "matches the float model" comparison float-tagged. That is an epistemic upgrade over the
  fully float-tagged Rungs 0–14.

### The atlas (a body of positional templates)

Collect the recovered structures from Rungs 7–14 as exact templates rather than ad-hoc examples:

```
  A = { (b, ι, M, C, T) }
     b = radix gauge          ι = embedding / chart        M = occupancy mask
     C = coupling law over positions      T = task / transformation the chart supports
```

Each coupling `Cᵣ ⊆ [N]×[N]` is defined by an exact **digit condition**, not a learned scalar similarity:

```
  C_same-block(i,j)      = [ block(i) = block(j) ]
  C_same-role(i,j)       = [ role(i)  = role(j)  ]
  C_period-p(i,j)        = [ i ≡ j  (mod p) ]
  C_strided(i,j)         = [ digit_k(ι(i)) = digit_k(ι(j)) ]
  C_cylinder-prefix(i,j) = [ π_{≤L}(ι(i)) = π_{≤L}(ι(j)) ]      # = same cylinder U(s); the FDRS bridge
```

Output is exact, integer-normalized (exact/bounded-rational if values are fixed-point):

```
  y_i = (1/|C_i|) · Σ_{j : C(i,j)} v_j           # "attention" with similarity replaced by chart membership
```

Optionally a small (eventually integer/fixed-point) **learned gate** selects among couplings — a hybrid of exact
positional coupling + learned routing, i.e. a **content stream** (token semantics) alongside a **chart stream**
(exact positional/coupling structure):

```
  y_i = Σ_r g_r(x_i) · Σ_{j : C_r(i,j)} v_j
```

### The key experiment (contained, on existing infra)

On the Rung-13/14 modular task where heads learned mod 3 / 4 / 5, replace those heads with exact couplings
`C₃, C₄, C₅` and compare four conditions:

1. learned softmax head (baseline);
2. recovered chart-**masked** head (Rung-14 style);
3. **exact integer coupling** head;
4. exact coupling **+ learned gate**.

If (3) matches or beats (1) on the head's task, the structure compiled out of float attention losslessly — the
headline result. The verdict is per-head and per-task, matched **by recovered chart, not head ID** (the frozen
seed-instability rule still holds).

### Honest caveats (the discipline travels)

- **Not every head is positional.** Content / semantic / token-identity heads are **out of scope** — the exact
  coupling layer replaces only the heads whose behavior is dominantly positional/chart-based. The honest framing
  is "for heads well-explained by positional charts," never "attention = couplings."
- Exactness is contingent on **value quantization** (integer/fixed-point V); with float V the operator is exact
  but the comparison stays bounded-rational.
- This is a **different claim** from the frozen synthetic result (constructive/compilable vs descriptive/causal).
  It does **not** upgrade or borrow the confidence of Rungs 0–14, and is reported separately.

### Candidate theory objects (would seed a Part F or a new experiment's THEORY.md)

`ExactCoupling Cᵣ ⊆ [N]×[N]` (digit-condition relation = cylinder co-membership), `ChartCouplingOperator`
(`y = integer-normalized aggregate over C`), `ChartCompile : recovered-chart → operator` (the compiler), and the
`proof_wanted` that an exact coupling reproduces the masked-head behavior up to the value-quantization bound. FDRS
parents: cylinder sets `U(s)`, partition law `setMass_partition`, interface balance (exact normalization).

### Placement — DECIDED (2026-06-26)

Track B is **constructive**, so it does not fit this family's *observational* charter. It has been **promoted to a
new sibling experiment, `experiment-fdrs-chart-coupled-attention`** (`../fdrs-chart-coupled-attention/`), with this
milestone as its input — not "Rung 16" here. That keeps the frozen observational result clean and gives the
constructive work its own pre-registration (rungs B0–B5) and exactness ledger. Charter, THEORY, NEGATIVE, and the
registry draft are written; it is unstarted (no code), and the registry entity is the user's human-gated step.

---

## On the robotics bridge (analogy, not equivalence)

The cross-project resonance — a **sparse observed system embedded into a larger admissible coordinate space**
(physical local-map with un-mapped/blocked cells ≈ attention chart with cover holes / unused volume, Part E
regimes 2–3) — is real and useful, but it is **shared formal vocabulary and method, not a proven universal law**.
State it as: *the same kind of object (signal over a partially occupied coordinate chart) appears in both places.*
Not: *the two stacks are governed by the same topological laws.* Any robotics tie-in is a separate program with
its own evidence; nothing in this family is evidence about a robot.

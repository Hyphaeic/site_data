# READING.md — sources for M0 (grouped by item; verified in the M0 research pass)

Quality tags from the research harness (23 fetched, 22/25 claims survived 3-vote adversarial
verification). "primary" = the actual paper/book; "not verified this pass" = used but not
run through verification (honest flag).

## Dim-2 template (the proven anchor the experiment generalizes)
- **Cox–Little–Schenck, *Toric Varieties*, GSM 124, §10.1–10.2** — cyclic quotient
  `¹⁄d(1,k)`, HJ resolution, Hilbert-basis = convex-hull-edge identity (Thm 10.2.8, "Klein").
  https://www.ams.org/bookstore/pspdf/gsm-124-prev.pdf *(preview; Ch.10 verified vs full copy)*
- **Popescu–Pampu, arXiv:math/0506432**, Prop 6.2 — minimal resolution, `Eₖ²=−bₖ`, dual
  graph a segment. *(primary)*
- Reid, "Surface cyclic quotient singularities and HJ resolutions" — corroborating.

## M0.1 — MCF landscape, the (S)/(T) distinction, the Hermite problem
- **Lagarias, *Monatsh. Math.* 115 (1993) 299–328** — coins **"simplex-splitting"** (sense
  **(S)**); JPA/Brun the prime examples, but the frame covers Selmer/Mönkemeyer equally. *The
  source that corrects the "JPA/Brun are special" prior.*
- **Berthé–Steiner–Thuswaldner, arXiv:2005.13038 (JEMS 2023)** + **arXiv:1910.09386** —
  simplex Markov partitions / Rauzy-fractal subdivisions; groups Selmer *with* Brun/JPA.
- **Dasaratha–Flapan–Garrity et al., TRIP maps, arXiv:1206.7077 (IJNT 2014), arXiv:1208.4244**
  — literal triangle-subdivision family (Brun a member; "for none can the converse be shown").
- **Panti, arXiv:0705.0584** — Mönkemeyer map + its simplex subdivision (the canonical base).
- **Fougeron, arXiv:2001.01367** — non-degenerate vs degenerate simplicial systems (why
  fully-subtractive is dynamically degenerate: Rauzy gasket).
- **Labbé, arXiv:1511.08399** / **Mercat, arXiv:2311.10046** — verbatim step rules for all five
  arithmetic MCFs (used in place of Schweiger, unfetched).
- **Karpenkov, arXiv:2101.12707 (Acta Arith. 2022)** + **arXiv:2101.12627 (Monatsh. Math.
  2024)** — sin²- / modified-JPA proven periodic on **totally-real cubics only**, *new
  non-classical* algorithms; complex case OPEN. **Karpenkov–van Son, arXiv:2410.13091** — the
  one *proven*-aperiodic cubic, for a JPA **variant** (Farey-summation), Example 2.51.
- **Murru, arXiv:1305.3285 (IJNT 2015)** + **Řada–Starosta–Kala, arXiv:2307.00898** — Hermite
  open both ways; "no algorithm proved periodic on cubic irrationals in general." *(the
  no-proven-non-periodic-cubic anchor)*
- **Kraaikamp–Meester (1995)** — fully-subtractive diverges a.e. for `d≥3`. *(result
  high-confidence; not verbatim — do not quote)*
- Dubois–Paysant-Le-Roux (1975), Bernstein (LNM 207, 1971) — JPA proven-periodic cubic families.
- **Karpenkov, *Geometry of Continued Fractions* (Springer, 2013)** + habilitation — Klein
  sails = sense-**(T)**; Korkina/Lachaud periodicity; German–Lakshtanov (arXiv:math/0607084)
  corrects the converse. Tsuchihashi (Tohoku 35, 1983) — periodic MCF ↔ cusps.
- **Schweiger, *Multidimensional Continued Fractions*, OUP (2000)** — the standard step-rule
  reference; **NOT fetched (paywalled)**; step rules taken from Labbé/BST/Mercat/Panti instead.

## M0.2 — terminal classification + economic resolution (the anchor)
- **Reid, *Young Person's Guide to Canonical Singularities*, PSPUM 46 (1987)** — Thm 5.2
  (terminal lemma: terminal ⟺ `¹⁄ᵣ(1,a,r−a)`, `gcd(a,r)=1`); Thm 4.11 (Reid–Tai age); economic
  resolution (Danilov §4, with R. Barlow: discrepancies `1/r,…,(r−1)/r`). *(primary; theorem
  labels are image-scans, content verified; "semicrepant" = Reid's coinage, std term
  "essential")* Scan: github.com/lfantini/…/Reid 1987.pdf
- **Sato–Sato, arXiv:2108.02402** ("Hilbert desingularizations for 3-dim **canonical** cyclic
  quotient singularities" — *canonical*, terminal is sub-case (ii)-α) — terminal lemma (Thm
  1.1); Ashikaga CF → Fujiki–Oka; "economic resolution coincides with the Fujiki–Oka
  resolution" for `¹⁄ᵣ(1,a,r−a)" (§3); rays `vᵢ` (§2). *(primary — the M1 anchor algorithm)*
- **Sato–Sato, arXiv:2004.03522** ("Crepant property of Fujiki–Oka resolutions…") — the **only**
  source defining the **round-down map** `Zᵢ` (Def 2.10(ii)); remainder map `Rᵢ`, Oka center +
  star subdivision (Lemma 2.16). Both maps self-verified against Ex 2.11 / `¹⁄11(1,2,8)`.
- **Ashikaga, Kyoto J. Math. 59(4) (2019) 993–1039**, Defs 3.1/3.2 — the original CF.
  **Paywalled — reaches us only via Sato–Sato's cited reproduction.**
- **Y. Sato, *Tokyo J. Math.* 45(1) (2022)** ("…via binary trees") — abstract confirms
  `¹⁄ᵣ(1,a,r−a) ↦` economic; **full text paywalled** (likely home of a worked terminal ladder).
- **Morrison–Stevens, Proc. AMS 90 (1984)** — terminal quotient classification, dims 3 & 4.
- **White, arXiv:1004.3411** — empty-lattice-simplex / lattice-width-1 normal form (the
  geometric core of the terminal lemma). *(primary)*
- **Chen, arXiv:1310.6445** — weighted blow-up = subdivision along `v`; minimal discrepancy
  `1/r`. *(primary; note: its **general** "weighted-blow-up ladder for all 3-fold terminals"
  was REFUTED 0–3 in verification — the cyclic-quotient economic resolution is the only part
  that stands.)*
- Bouvier–González-Sprinberg — essential toric divisors = Hilbert-basis elements (why the
  `k/r` spectrum is resolution-invariant).

## Part C — oracle software
- SageMath toric geometry (in-workspace, the P1–P7 environment) — `Cone`, `Fan`,
  `Fan.is_smooth()`, `Fan.subdivide(new_rays=…)`. **Verify-oracle; does not auto-generate
  resolutions.** Novoseltsev thesis (2011, Sage toric) for background.
- Normaliz — cone Hilbert bases (= essential divisors); natural second independent check.
- polymake / Magma — not needed for the anchor, not assessed this pass.

## FDRS corpus (read-only)
- Phase 7 law families (the admissible-`Ω` space). Phase 5.3 recharts (`F5-transport`).
  Phase 8 multi-timeline routing. `fdrs-hj-singularities` Amendment 2 (P5 transport finding:
  "value dies, `d` survives" — the precedent for M0.3 / M4).

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

## M0.1 — MCF landscape, Klein sails, the Hermite problem
- **Karpenkov, *Geometry of Continued Fractions*, Springer ACM 26 (2013)** — sails as
  convex-hull boundaries; "lattice geometry coincides with toric geometry"; Korkina/Lachaud
  Lagrange-type periodicity (totally-real). *(primary)* + habilitation:
  http://pcwww.liv.ac.uk/~karpenk/hab/habilitation.pdf
- **Karpenkov, arXiv:2101.12707** ("On Hermite's problem, Jacobi–Perron type algorithms, and
  Dirichlet groups", Acta Arith. 203, 2022) — **first** JPA-type algorithm proven periodic on
  cubics, **totally-real only; complex-conjugate case OPEN**. *(primary — the Hermite front)*
- **Lee, arXiv:1810.11676** — AJPA (Tamura–Yasutomi) periodicity = enumerated families only,
  no cubic Lagrange theorem. *(primary)*
- **German–Lakshtanov, arXiv:math/0607084** — corrects the *converse* Lagrange direction /
  operator hypotheses (so Klein periodicity ≠ Hermite's converse). *(primary)*
- **Schweiger, *Multidimensional Continued Fractions*, OUP (2000)** — THE reference for the
  precise step rules of JPA, Brun, Selmer, Mönkemeyer, fully-subtractive. **NOT independently
  verified this pass** — read before M0.1-addendum or M3.
- Tsuchihashi (Tohoku Math. J. 35, 1983) — periodic MCF ↔ cusp singularities. Moussafir (FAA
  34, 2000) / German (Proc. Steklov 239, 2002) — sails ↔ Hilbert bases.

## M0.2 — terminal classification + economic resolution (the anchor)
- **Reid, *Young Person's Guide to Canonical Singularities*, PSPUM 46 (1987)** — Thm 5.2
  (terminal lemma: terminal ⟺ `¹⁄ᵣ(1,a,r−a)`, `gcd(a,r)=1`); Thm 4.11 (Reid–Tai age); economic
  resolution (Danilov §4, with R. Barlow: discrepancies `1/r,…,(r−1)/r`). *(primary; theorem
  labels are image-scans, content verified; "semicrepant" = Reid's coinage, std term
  "essential")* Scan: github.com/lfantini/…/Reid 1987.pdf
- **Sato–Sato, arXiv:2108.02402** ("Hilbert Desingularizations for 3-dim toric terminal
  quotient singularities") — restates the terminal lemma (Thm 1.1); **Fujiki–Oka resolution
  built algorithmically from Ashikaga's continued fraction; economic resolution of
  `¹⁄ᵣ(1,a,r−a)` explicitly**. *(primary — the M1 anchor algorithm)*
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

# Distribution Contract

`site_data` is the static content distribution substrate for Hyphaeic-facing
surfaces. It is intentionally small: Markdown content plus `manifest.json`.
Frontends and other consumers should treat the manifest as the routing and
navigation contract: **the OS filesystem is this tree**.

Bundled DocWindows are not distributed from this repository. They are compiled
into the shell. POSITION is currently the only such document.

## Role In The Topology

- Corporate state remains canonical in `corp/registry/`.
- Research source material remains canonical in `branches/hir/`.
- Durable records remain canonical in `corp/records/` or `shared/records/`.
- `site_data` distributes selected public or presentation-ready projections of
  those sources.

This repository should not become the source of truth for legal obligations,
project lifecycle, research validity, or ownership. It is a publishing layer.

## Integration Rules

1. Every distributed document must be listed in `manifest.json`.
2. Manifest `id` values are stable route identifiers. Rename titles freely;
   avoid changing ids after publication.
3. Paths are relative to this repository root.
4. Content promoted from another Hyphaeic source should keep enough context to
   trace back to the originating registry entity, branch document, or record.
5. Do not store secrets, credentials, private records, generated build output,
   or heavyweight binary artifacts here.
6. If a document becomes authoritative for governance, obligations, or claims,
   create or update the corresponding registry entity first.
7. Do not duplicate bundled DocWindow sources here. An empty root key is the
   correct CMS shape for a folder whose index document lives in the OS.

## Intended Distribution Domains

The frozen public IA (see `README.md`) uses these roots:

- `start/` - orientation surface. What is Hyphaeic and why should I care.
- `problems/` - local-to-global coherence failures across real systems, stated
  in ordinary language before formal terms.
- `technology/` - FDRS, HyphaFabric, Modulus, STOK-CORE, Abzu, HyphaKernel,
  HyphOS, HyphaeicOS (Web, Hyphax), and systems such as HyphaChat / ChessBender.
- `research/` - formal programme, papers, Lean, hypotheses, open problems;
  curated maps plus an automated experiment stream.
- `repositories/` - proof-by-inspection: the repository index. Show me the code.
- `company/` - SPC, governance, purpose, the firm as a system, machine
  stewardship, institutional surface.
- `foundations/` - the deeper worldview: Position, The Gambit, Representation,
  Coherence & Viability, Freedom, Metaphysics, A Romance of Systems.

The former reserved root `position/` is no longer a top-level distribution
domain; the POSITION document now lives under `foundations/position.md`. The
former `demos/` root is dissolved: a system's public execution state is carried
as `state` metadata on its technology entry, not as a separate folder. The
former `freedom/` and `the_gambit/` roots are folded under `foundations/`.

Distribution is organised around reader questions, not internal ontology
(progressive disclosure). A document exists once and projects outward: canonical
deep documents live in `foundations/` (and `problems/` for the explanatory
corpus), and other sections project the same idea at different resolutions
rather than duplicating it.

## Phase Plan

- P0: Standalone repository placed at `shared/site_data/` with parent registry
  coverage.
- P1: Define export mappings from registry entities and branch documents into
  manifest entries.
- P2: Add validation in the consuming frontend or a lightweight CI check:
  unique ids, existing paths, file entries with required fields.
- P3: Use the repository as the public/static distribution layer for selected
  Hyphaeic topology slices.

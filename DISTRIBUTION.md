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
7. Do not duplicate bundled DocWindow sources here. The reserved `_root`
   manifest key is the only place for files shown directly at the OS filesystem
   root.
8. A manifest entry marked `"internal": true` is an internal-only projection,
   not part of the public surface. This tag is protected: distribution must
   preserve it, and `sync-manifest.sh` never overwrites or removes it.

## Intended Distribution Domains

The public IA (see `README.md`) uses these surfaces:

- `_root/START.md` - orientation surface. What is Hyphaeic and why should I care.
- `company/` - Hyphaeic, Team, Position, and Contact.
- `technology/products/` - HyphaeicOS, HyphaFabric, Phax, Modulus,
  Chessbender, and Hyphacom.
- `technology/technologies/` - FDRS, STOK-CORE, and Abzu.
- `research/` - formal programme, papers, Lean, hypotheses, open problems;
  curated maps plus an automated experiment stream.
- `philosophy/problems/` - local-to-global coherence failures across real
  systems, stated in ordinary language before formal terms.
- `philosophy/foundations/` - the deeper worldview: The Gambit,
  Representation, Coherence & Viability, Freedom, Metaphysics, and A Romance
  of Systems.
- `repositories/` - proof-by-inspection: the repository index. Show me the code.

Distribution is organised around reader questions, not internal ontology
(progressive disclosure). A document exists once and projects outward: canonical
documents live at one physical path, and links project the same idea at
different resolutions rather than duplicating it. Withdrawn public pages remain
under unlisted `archive/` paths.

## Phase Plan

- P0: Standalone repository placed at `shared/site_data/` with parent registry
  coverage.
- P1: Define export mappings from registry entities and branch documents into
  manifest entries.
- P2: Add validation in the consuming frontend or a lightweight CI check:
  unique ids, existing paths, file entries with required fields.
- P3: Use the repository as the public/static distribution layer for selected
  Hyphaeic topology slices.

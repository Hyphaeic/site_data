# Distribution Contract

`site_data` is the static content distribution substrate for Hyphaeic-facing
surfaces. It is intentionally small: Markdown content plus `manifest.json`.
Frontends and other consumers should treat the manifest as the routing and
navigation contract.

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

## Intended Distribution Domains

- `org/` - public organizational descriptions and corporate topology.
- `axioms/` - mission, thesis, and theory primers.
- `r_and_d/` - selected research/project summaries and paper-style exports.
- Future folders may represent product, branch, library, or artifact surfaces
  once a consumer exists.

## Phase Plan

- P0: Standalone repository placed at `shared/site_data/` with parent registry
  coverage.
- P1: Define export mappings from registry entities and branch documents into
  manifest entries.
- P2: Add validation in the consuming frontend or a lightweight CI check:
  unique ids, existing paths, file entries with required fields.
- P3: Use the repository as the public/static distribution layer for selected
  Hyphaeic topology slices.

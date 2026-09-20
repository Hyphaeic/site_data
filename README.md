# site_data

The static content layer for Hyphaeic OS. This repository holds the prose, the
routing manifest, and one helper script. The OS fetches `manifest.json` at boot
and **builds the filesystem from it**. The reserved `_root` key contains files
shown directly at the filesystem root; every other public top-level key is a
root folder.

Bundled DocWindows (currently only POSITION) may be compiled into the OS shell;
the public POSITION projection lives under `COMPANY`.

For Hyphaeic topology integration rules, see [`DISTRIBUTION.md`](DISTRIBUTION.md).

## Public Information Architecture

The public surface is organised around the questions a new reader has — not the
internal ontology.

| Key | Surface | Job |
|-----|--------|----------------------------------|
| `_root` | START file | Introduce Hyphaeic and route into the public tree. |
| `company` | COMPANY | Hyphaeic, Team, Position, and Contact. |
| `technology` | TECHNOLOGY | Products and foundational technologies. |
| `research` | RESEARCH | What are you investigating, what remains unresolved, what has been established? |
| `philosophy` | PHILOSOPHY | Problems and Foundations in one domain. |
| `repositories` | REPOSITORIES | Can I inspect the actual work? (proof-by-inspection) |

`archive/` preserves withdrawn public pages but is intentionally absent from
the manifest.

## Rules of the IA

1. **A document exists once, then projects outward.** Write the canonical deep
   document in one place; links and navigation project it without copying it.
2. **There is no `DEMOS` root.** Live demonstrations are *properties*, not
   folders. A technology entry carries its own execution state in `state`.
3. **Epistemic status is standardised.** Every curated document carries a
   `status` (cardinality: one or more). A visitor must be able to tell at a
   glance “Hyphaeic believes this” from “Hyphaeic proved this in Lean” from
   “we demonstrated this experimentally.”
4. Research under `RESEARCH` is a *living record*: three curated maps
   (Programmes, Open Problems, Results) plus an automated stream publishing from
   the research repository. The automated stream is not manually maintained.

## Root structure

`manifest.json` keys, in display order:

- `_root` — `START.md`
- `company/` — Hyphaeic, Team, Position, Contact.
- `technology/products/` — HyphaeicOS, HyphaFabric, Phax, Modulus,
  Chessbender, Hyphacom.
- `technology/technologies/` — FDRS, STOK-CORE, ABZU.
- `research/` — `overview.md`, `programmes.md`, `open-problems.md`,
  `results.md`, the curated maps; `maths/` is the automated experiment stream.
- `philosophy/problems/` — the problem corpus and applications.
- `philosophy/foundations/` — the deeper worldview and The Gambit.
- `repositories/` — the repository index (evidence / proof-by-inspection).

An empty public array still creates a folder. A file outside `archive/` that is
not in the manifest is invisible to the OS. A missing manifest path 404s.

## How It Works

1. **Markdown / assets** live under the matching root folder.
2. **`manifest.json`** is the single source of truth for navigation, routing,
   and metadata.
3. The frontend fetches `manifest.json`, walks its tree, then overlays a few
   local objects the CMS cannot serve (live GitHub repos under TECHNOLOGY, any
   OS-bundled DocWindows).

Add a file, add an entry to the manifest, and the OS picks it up. Or use
`./sync-manifest.sh` to reconcile new files.

## The Manifest Format

`manifest.json` is an object whose values are arrays of entries. `_root` is
reserved for root-level files; every other top-level key names a folder.

### A file entry

```json
{ "id": "fdrs", "title": "FDRS", "path": "technology/technologies/fdrs.md",
  "type": "SYSTEM", "status": ["FORMAL RESULT", "IMPLEMENTED"] }
```

| Field | Purpose |
|--------|---------|
| `id` | Unique identifier for this node. Used for routing. Keep it short, lowercase, snake_case. Do not reuse the parent folder's id (reserved for a bundled DocWindow if one exists). |
| `title` | The display name shown in the OS UI. |
| `path` | Relative path from the repo root, **or** an absolute `http(s)` URL. |
| `type` | A category tag the frontend uses for styling/routing. |
| `status` | *Optional.* Epistemic status array — one or more of the standardised tags (below). |
| `state` | *Optional.* Execution/liveness flags for a technology `SYSTEM` entry (below). |
| `internal` | *Optional boolean.* Marks the document internal-only. **Protected** — the sync script never overwrites or removes this tag. |

### A directory entry

```json
{
  "id": "core",
  "title": "CORE",
  "type": "DIR",
  "children": [
    { "id": "fdrs", "title": "FDRS", "path": "technology/technologies/fdrs.md", "type": "SYSTEM" }
  ]
}
```

### Available types

`TEXT`, `SYSTEM`, `THEORY`, `PAPER`, `INFO`, `RESULT`, `ARTIFACT`, `GRAPH`,
`IMAGE`, `PDF`, `DIR`.

`INTERNAL` is not a manifest type. Those documents are bundled in the OS
(`DocWindow`) and overlaid after the manifest tree is built.

`REPO` is created from the Hyphaeic GitHub organization. `PROGRAM` rows are
overlaid into folder catalogs from the OS catalog.

### Epistemic status (`status`)

`POSITION`, `HYPOTHESIS`, `OPEN PROBLEM`, `FORMAL RESULT`, `EXPERIMENTAL RESULT`,
`DEMONSTRATED`, `IMPLEMENTED`, `PROTOTYPE`, `LIVE`, `HISTORICAL`.

Documents and technologies may carry more than one where appropriate. This is
how the site distinguishes “Hyphaeic believes this” from “Hyphaeic proved this
in Lean” from “we demonstrated this experimentally.”

### Execution state (`state`, technology entries only)

`ACTIVE`, `LIVE`, `INTERACTIVE`, `SOURCE`, `PROTOTYPE`, `RESEARCH`.

Replaces the former `DEMOS` root: the public execution state of a system is
metadata on its technology entry, not a folder.

### Internal tag (`internal`)

A file entry may carry `"internal": true` to mark it internal-only (not part of
the public surface). It is a boolean **tag**, not a category, so the entry keeps
its ordinary `type` (e.g. `THEORY`). This tag is **protected**: `sync-manifest.sh`
never overwrites or removes it during reconciliation.

### Rules

- Every file entry **must** have `id`, `title`, `path`, and `type`.
- Every directory entry **must** have `id`, `title`, `type: "DIR"`, and `children`.
- `_root` is the only top-level key that does not require a matching directory.
- `id` values must be unique across the entire manifest.
- `path` values must match the actual file location on disk.

## Using the sync script

```bash
./sync-manifest.sh          # dry-run
./sync-manifest.sh --apply  # update manifest.json (interactive)
./sync-manifest.sh --stamp-modified  # refresh modified timestamps from git
```
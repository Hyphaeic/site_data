# site_data

The static content layer for Hyphaeic OS. This repository holds the prose, the
routing manifest, and one helper script. The OS fetches `manifest.json` at boot
and **builds the filesystem from it**. Top-level keys are the root folders.

Bundled DocWindows (currently only POSITION) may be compiled into the OS shell;
a root key that is empty or absent means that folder's index is provided
externally. Under the current frozen IA, POSITION lives as a document under
`FOUNDATIONS` rather than as a reserved root.

For Hyphaeic topology integration rules, see [`DISTRIBUTION.md`](DISTRIBUTION.md).

## Public Information Architecture (frozen)

The public surface is organised around the questions a new reader has — not the
internal ontology. **Progressive disclosure**: what is this → what problem →
what has been built → what does the research say → show me the work → what kind
of institution → why do you believe this.

| Key | Folder | Job — which question it answers |
|-----|--------|----------------------------------|
| `start` | START | What is Hyphaeic, and why should I care? |
| `problems` | PROBLEMS | What fundamental problems are you attacking? |
| `technology` | TECHNOLOGY | What have you actually built to attack them? |
| `research` | RESEARCH | What are you investigating, what remains unresolved, what has been established? |
| `repositories` | REPOSITORIES | Can I inspect the actual work? (proof-by-inspection) |
| `company` | COMPANY | What is Hyphaeic SPC as an institution, and why is it structured this way? |
| `foundations` | FOUNDATIONS | What deeper worldview causes you to approach these problems differently? |

These sections have different jobs. If a page starts answering three of them at
once, it probably needs splitting.

## Rules of the frozen IA

1. **A document exists once, then projects outward.** Write the canonical deep
   document in one place (e.g. `FOUNDATIONS/Representation`); every other
   section that touches the idea is a different projection of it at a different
   resolution — one line in `START`, engineering consequences in `PROBLEMS`,
   a response in `TECHNOLOGY`, the formal investigation in `RESEARCH`. That is
   not duplication; it is projection.
2. **There is no `DEMOS` root.** Live demonstrations are *properties*, not
   folders. A technology entry carries its own execution state in `state`.
3. **Epistemic status is standardised.** Every curated document carries a
   `status` (cardinality: one or more). A visitor must be able to tell at a
   glance “Hyphaeic believes this” from “Hyphaeic proved this in Lean” from
   “we demonstrated this experimentally.”
4. Research under `RESEARCH` is a *living record*: three curated maps
   (Programmes, Open Problems, Results) plus an automated stream publishing from
   the research repository. The automated stream is not manually maintained.

## Root folders

`manifest.json` keys, in display order:

- `start/` — `what-is-hyphaeic.md`
- `problems/` — Overview, coordination, representation, control, time, planning,
  embodiment, alignment, and `applications/` for how each appears in a domain.
- `technology/` — `overview.md`; `core/` (FDRS, HyphaFabric, Modulus, STOK-CORE,
  Abzu, HyphaKernel, HyphOS); `hyphaeicos/` (Overview, Web, Hyphax);
  `live-applications/` (HyphaChat, ChessBender, Magnon, SIGIL).
- `research/` — `overview.md`, `programmes.md`, `open-problems.md`,
  `results.md`, the curated maps; `maths/` is the automated experiment stream.
- `repositories/` — the repository index (evidence / proof-by-inspection).
- `company/` — Hyphaeic SPC, Why an SPC, Social Purpose, Firm as a System,
  Governance, Machine Stewardship, Social Purpose Reports, Team, and the
  corporate-cybernetics / marine-corp documents.
- `foundations/` — Position, The Gambit, Representation, Coherence & Viability,
  Freedom, Metaphysics, A Romance of Systems.

An empty array still creates the folder. A file on disk that is not in the
manifest is invisible to the OS. A manifest path that is missing on disk 404s.

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

`manifest.json` is a flat object where each **top-level key** is a folder name.
Each value is an **array of entries**.

### A file entry

```json
{ "id": "fdrs", "title": "FDRS", "path": "technology/core/fdrs.md",
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

### A directory entry

```json
{
  "id": "core",
  "title": "CORE",
  "type": "DIR",
  "children": [
    { "id": "fdrs", "title": "FDRS", "path": "technology/core/fdrs.md", "type": "SYSTEM" }
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

### Rules

- Every file entry **must** have `id`, `title`, `path`, and `type`.
- Every directory entry **must** have `id`, `title`, `type: "DIR"`, and `children`.
- `id` values must be unique across the entire manifest.
- `path` values must match the actual file location on disk.

## Using the sync script

```bash
./sync-manifest.sh          # dry-run
./sync-manifest.sh --apply  # update manifest.json (interactive)
./sync-manifest.sh --stamp-modified  # refresh modified timestamps from git
```
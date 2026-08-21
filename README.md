# site_data

The static content layer for Hyphaeic OS. This repository holds the prose, the
routing manifest, and one helper script. The OS fetches `manifest.json` at boot
and **builds the filesystem from it**. Top-level keys are the root folders.

Bundled DocWindows (currently only POSITION) live in the OS shell, not here.

For Hyphaeic topology integration rules, see [`DISTRIBUTION.md`](DISTRIBUTION.md).

## Root folders

`manifest.json` keys, in display order:

| Key | Folder | Contents |
|-----|--------|----------|
| `position` | POSITION | Why the current paradigm fails. Empty here — the DocWindow is bundled in the OS. |
| `problems` | PROBLEMS | Where local-to-global coherence breaks across real systems. |
| `technology` | TECHNOLOGY | FDRS / HyphaFabric / Modulus / STOK / Abzu / HyphaeicOS. |
| `research` | RESEARCH | Formal programme, papers, Lean, hypotheses, open problems. Math experiments live here. |
| `demos` | DEMOS | Empty here — the OS overlays running programs (minus chat). |
| `company` | COMPANY | SPC, governance, purpose, machine-operable institution. |
| `freedom` | FREEDOM | AI must be free / nobody should own the future. |
| `the_gambit` | THE GAMBIT | The founding work. |
| `metaphysics` | METAPHYSICS | The deeper worldview and its religious/philosophical ancestry. |

An empty array still creates the folder. A file on disk that is not in the
manifest is invisible to the OS. A manifest path that is missing on disk 404s.

## How It Works

1. **Markdown / assets** live under the matching root folder.
2. **`manifest.json`** is the single source of truth for navigation, routing, and metadata.
3. The frontend fetches `manifest.json`, walks its tree, then overlays a few
   local objects the CMS cannot serve (the POSITION DocWindow, the DEMOS
   program catalog, live GitHub repos under TECHNOLOGY).

Add a file, add an entry to the manifest, and the OS picks it up. Or use
`./sync-manifest.sh` to reconcile new files.

## The Manifest Format

`manifest.json` is a flat object where each **top-level key** is a folder name.
Each value is an **array of entries**.

### A file entry

```json
{ "id": "team", "title": "TEAM", "path": "company/team.md", "type": "INFO" }
```

| Field | Purpose |
|--------|---------|
| `id` | Unique identifier for this node. Used for routing. Keep it short, lowercase, snake_case. Do not reuse the parent folder's id (reserved for a bundled DocWindow if one exists). |
| `title` | The display name shown in the OS UI. |
| `path` | Relative path from the repo root, **or** an absolute `http(s)` URL. |
| `type` | A category tag the frontend uses for styling/routing. |

### A directory entry

```json
{
  "id": "hyphaeicos",
  "title": "HYPHAEICOS",
  "type": "DIR",
  "children": [
    { "id": "hyphaeicos_rhizonet", "title": "RhizoNET", "path": "technology/hyphaeicos/RhizoNET.md", "type": "SYSTEM" }
  ]
}
```

### Available types

`TEXT`, `SYSTEM`, `THEORY`, `PAPER`, `INFO`, `RESULT`, `ARTIFACT`, `GRAPH`, `IMAGE`, `PDF`, `DIR`.

`INTERNAL` is not a manifest type. Those documents are bundled in the OS (`DocWindow`) and overlaid after the manifest tree is built.

`REPO` is created from the Hyphaeic GitHub organization. `PROGRAM` rows are overlaid into `demos/` from the OS catalog.

### Rules

- Every file entry **must** have `id`, `title`, `path`, and `type`.
- Every directory entry **must** have `id`, `title`, `type: "DIR"`, and `children`.
- `id` values must be unique across the entire manifest.
- `path` values must match the actual file location on disk.

## Using the sync script

```bash
./sync-manifest.sh          # dry-run
./sync-manifest.sh --apply  # update manifest.json
```

# site_data

The static content layer for Hyphaeic OS. This repository holds the prose, the routing manifest, and one helper script. The frontend reads this repo at boot and builds its navigation from the manifest.

For Hyphaeic topology integration rules, see [`DISTRIBUTION.md`](DISTRIBUTION.md).

## How It Works

The system is simple:

1. **Markdown files** live in folders under the repo root (`org/`, `axioms`, `r_and_d/`, etc.).
2. **`manifest.json`** at the root describes every file and folder the OS should know about. It is the single source of truth for navigation, routing, and metadata.
3. The frontend fetches `manifest.json`, walks its tree, and builds the file system / directory UI from it. If a file exists on disk but is not in the manifest, the OS won't see it. If the manifest references a file that doesn't exist, the OS will get a 404.

That's it. Add a markdown file, add an entry to the manifest, and the OS picks it up. Or use the sync script to automate the manifest updates.

## The Manifest Format

`manifest.json` is a flat object where each **top-level key** is a folder name. Each value is an **array of entries**.

### A file entry

```json
{ "id": "team", "title": "TEAM", "path": "org/team.md", "type": "TEXT" }
```

| Field  | Purpose |
|--------|---------|
| `id`   | Unique identifier for this node. Used for routing and internal references. Keep it short, lowercase, snake_case. |
| `title` | The display name shown in the OS UI. |
| `path` | Relative path from the repo root to the markdown file. |
| `type` | A category tag the frontend uses for styling/routing. See the full list below. |

### A directory entry (nested folder)

When a folder contains subfolders, use `"type": "DIR"` with a `"children"` array instead of a `"path"`:

```json
{
  "id": "fdrs",
  "title": "FDRS",
  "type": "DIR",
  "children": [
    { "id": "fdrs_p1", "title": "Formal Verification", "path": "r_and_d/fdrs/p1_formal_verification.md", "type": "PAPER" },
    { "id": "fdrs_p2", "title": "Positional Algebra", "path": "r_and_d/fdrs/p2_positional_algebra.md", "type": "PAPER" }
  ]
}
```

The `children` array follows the same format — each child is either a file entry or another `DIR` entry. This nesting can go as deep as you need.

### Available types

These are the valid values for the `type` field in manifest entries:

| Type | Viewer | File format | Notes |
|------|--------|-------------|-------|
| `TEXT` | TextWindow | `.md` | Prose essays. Routed as THEORY internally. |
| `SYSTEM` | TextWindow | `.md` | System docs and architecture. |
| `THEORY` | TextWindow | `.md` | Theoretical work. |
| `PAPER` | TextWindow | `.md` | Research papers. |
| `INFO` | TextWindow | `.md` | Reference and informational docs. |
| `RESULT` | TextWindow | `.md` | Experiment results and findings. |
| `ARTIFACT` | TextWindow | `.md` | Experiment records, generated outputs, and derived artifacts. |
| `GRAPH` | GraphWindow | `.svg` | SVG diagrams, rendered inline. |
| `IMAGE` | ImageWindow | `.png`, `.jpg`, `.jpeg` | Raster images. |
| `DIR` | — | — | Directory container (uses `children`, not `path`). |

`COMPONENT` and `LEGAL` are reserved category names in the frontend but have no corresponding manifest type today. They exist for tag palette completeness.

`REPO` is a special category the frontend creates automatically from the Hyphaeic GitHub organization — it does not come from the manifest.

Use `ARTIFACT` for Markdown files that belong to an experiment process, including charters, summaries, result reports, negative controls, glossaries, instrumentation notes, predictions, and run notes.

### Rules

- Every file entry **must** have `id`, `title`, `path`, and `type`.
- Every directory entry **must** have `id`, `title`, `type: "DIR"`, and `children`.
- Directory entries do **not** have a `path` — they are containers, not content.
- `id` values must be unique across the entire manifest.
- `path` values must match the actual file location on disk.

## How to Add Things

### Add a new file to an existing folder

1. Create the markdown file in the folder. Use an H1 header and whatever content you need:

   ```markdown
   # My New Document

   Content goes here.
   ```

2. Add an entry to the folder's array in `manifest.json`:

   ```json
   { "id": "my_new_doc", "title": "MY NEW DOCUMENT", "path": "org/my_new_doc.md", "type": "TEXT" }
   ```

### Add a new top-level folder

1. Create the directory at the repo root:

   ```
   mkdir docs
   ```

2. Add your markdown files inside it.

3. Add a new top-level key in `manifest.json`:

   ```json
   "docs": [
     { "id": "overview", "title": "OVERVIEW", "path": "docs/overview.md", "type": "TEXT" }
   ]
   ```

   Top-level keys can appear in any order, but keep them alphabetically sorted for readability.

### Add a subfolder (nested directory)

1. Create the subfolder and its files:

   ```
   mkdir r_and_d/my_project
   touch r_and_d/my_project/spec.md
   ```

2. In the parent folder's array in `manifest.json`, replace what would be a file entry with a `DIR` entry:

   ```json
   {
     "id": "my_project",
     "title": "MY PROJECT",
     "type": "DIR",
     "children": [
       { "id": "my_project_spec", "title": "Spec", "path": "r_and_d/my_project/spec.md", "type": "PAPER" }
     ]
   }
   ```

3. To nest deeper, put another `DIR` entry inside `children`. There is no depth limit.

### Quick reference

| What you're adding          | What to do                                                                 |
|-----------------------------|---------------------------------------------------------------------------|
| File in existing folder     | Create the `.md` file, add an entry to the folder's array in the manifest |
| New top-level folder        | `mkdir`, create files, add a new top-level key to the manifest            |
| Subfolder inside a folder   | Create the dir + files, use a `DIR` entry with `children` in the manifest |
| Sub-subfolder (deeper)      | Same as above — nest another `DIR` inside `children`                      |

### Using the sync script

Instead of manually editing `manifest.json`, run `./sync-manifest.sh` after adding files to the repository. The script scans for new files and walks you through adding each one.

**Basic usage:**

```bash
./sync-manifest.sh          # dry-run (shows what would be added, no changes)
./sync-manifest.sh --apply  # actually update manifest.json
```

**What it does:**

1. Scans all top-level directories for `.md`, `.svg`, `.png`, `.jpg`, and `.jpeg` files
2. Compares against `manifest.json` to find new files and drift (manifest entries pointing to missing files)
3. For each new file, prompts for:
   - `id` — unique identifier (auto-generated from path, e.g., `org/my_doc.md` → `my_doc`)
   - `title` — display name (auto-generated from filename, e.g., `my_doc.md` → `My Doc`)
   - `type` — category (suggested based on extension: `.svg` → GRAPH, `.png` → IMAGE, `.md` → TEXT)
4. Shows the proposed JSON entry and asks for confirmation before adding
5. Splices the entry into the correct location in `manifest.json`

**Scope and limitations:**

- Scans only files inside top-level directories (ignores root-level files like `README.md`, `DISTRIBUTION.md`)
- Ignores `.sage` files (no valid manifest type)
- Does not handle `DIR` entries for new subdirectories — those must be added manually or the script will add files to the parent folder's array
- Does not auto-fix drift — it reports missing files but doesn't remove stale manifest entries

**Example:**

```bash
$ echo "# New Essay" > org/new_essay.md
$ ./sync-manifest.sh --apply

Scanning for new files...
Found 1 new file:
  - org/new_essay.md

Processing org/new_essay.md:
  id [new_essay]: 
  title [New Essay]: 
  type [TEXT]: PAPER
  Add this entry? [y/N]: y

Updated manifest.json (1 entry added)
```

The script is interactive and asks before each change. Press Enter to accept the suggested values, or type alternatives.

## Markdown File Convention

Every markdown file should start with an H1 heading that matches the `title` in the manifest, followed by placeholder or real content:

```markdown
# TITLE

Content goes here.
```

Keep files focused. One topic per file. The manifest handles the structure — the files just need to hold the words.

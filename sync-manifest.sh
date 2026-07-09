#!/usr/bin/env bash
# sync-manifest.sh — reconcile manifest.json with files on disk
#
# Scans top-level directories, detects new files and drift (manifest references
# to missing files), prompts for metadata on new entries, and writes the updated
# manifest.
#
# Flow: for each new file, prompt for metadata → show proposed entry → confirm →
# splice immediately → next file.
#
# Usage:
#   ./sync-manifest.sh [--apply]
#   ./sync-manifest.sh --stamp-modified
#
# Default is dry-run (exit 0, no writes). Pass --apply to write changes.
# Pass --stamp-modified to only refresh `modified` metadata from git history.

set -euo pipefail

# -------- args --------
APPLY=0
STAMP_MODIFIED=0
for arg in "$@"; do
    case "$arg" in
        --apply) APPLY=1 ;;
        --stamp-modified) STAMP_MODIFIED=1 ;;
        -h|--help) sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "Unknown arg: $arg" >&2; exit 2 ;;
    esac
done

# -------- preflight --------
command -v jq >/dev/null || { echo "jq required" >&2; exit 2; }
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
MANIFEST="manifest.json"
[[ -f "$MANIFEST" ]] || { echo "manifest.json not found" >&2; exit 2; }

# -------- scan disk --------
# Collect all file paths under top-level dirs (skip .git, root files, .sage)
declare -A ON_DISK
while IFS= read -r -d '' f; do
    case "$f" in
        */.git/*) continue ;;
        ./.git*) continue ;;
    esac
    rel="${f#./}"
    # Skip root-level files
    [[ "$rel" == */* ]] || continue
    ext="${rel##*.}"
    ext_lower="${ext,,}"
    [[ "$ext_lower" == "sage" ]] && continue
    case "$ext_lower" in
        md|svg|png|jpg|jpeg|pdf) ON_DISK["$rel"]=1 ;;
    esac
done < <(find . -type f -print0)

# Collect all manifest paths
mapfile -t MANIFEST_PATHS < <(jq -r '.. | objects | select(has("path")) | .path' "$MANIFEST" | sort -u)

# Scan top-level directories on disk
declare -a DISK_TOP_DIRS=()
while IFS= read -r -d '' d; do
    dir="${d#./}"
    [[ -z "$dir" || "$dir" == ".git" ]] && continue
    DISK_TOP_DIRS+=("$dir")
done < <(find . -maxdepth 1 -mindepth 1 -type d -print0 | sort -z)

# -------- compute diff sets --------
declare -a NEW_FILES=()
declare -a DRIFT_PATHS=()

for rel in "${!ON_DISK[@]}"; do
    found=0
    for mp in "${MANIFEST_PATHS[@]}"; do
        [[ "$mp" == "$rel" ]] && { found=1; break; }
    done
    [[ $found -eq 0 ]] && NEW_FILES+=("$rel")
done

for mp in "${MANIFEST_PATHS[@]}"; do
    [[ "$mp" =~ ^https?:// ]] && continue
    [[ -z "${ON_DISK[$mp]:-}" ]] && DRIFT_PATHS+=("$mp")
done

IFS=$'\n' NEW_FILES=($(printf '%s\n' "${NEW_FILES[@]:-}" | sort)); unset IFS
IFS=$'\n' DRIFT_PATHS=($(printf '%s\n' "${DRIFT_PATHS[@]:-}" | sort)); unset IFS

# Check for structural issues
declare -a EMPTY_TOPS=()
declare -a ORPHANED_KEYS=()
declare -a EMPTY_DIRS=()

# Check for empty top-level arrays
mapfile -t EMPTY_TOPS < <(jq -r 'to_entries[] | select(.value == []) | .key' "$MANIFEST" 2>/dev/null || true)

# Check for orphaned top-level keys (keys without corresponding directories)
mapfile -t manifest_keys < <(jq -r 'keys[]' "$MANIFEST" 2>/dev/null || true)
for key in "${manifest_keys[@]}"; do
    if [[ ! -d "$key" ]]; then
        ORPHANED_KEYS+=("$key")
    fi
done

# Check for empty DIR entries (DIRs with no children)
mapfile -t EMPTY_DIRS < <(jq -r '
    def check_empty:
        . as $in
        | if type == "array" then
            .[] | check_empty
        elif type == "object" then
            if .type == "DIR" and (.children // [] | length == 0) then
                .id
            elif has("children") then
                .children[] | check_empty
            else empty
            end
        else empty
        end;
    .[] | check_empty
' "$MANIFEST" 2>/dev/null || true)

# Determine if we have structural issues
HAS_STRUCTURAL_ISSUES=false
if [[ ${#EMPTY_TOPS[@]} -gt 0 || ${#ORPHANED_KEYS[@]} -gt 0 || ${#EMPTY_DIRS[@]} -gt 0 ]]; then
    HAS_STRUCTURAL_ISSUES=true
fi

# -------- modified metadata helpers --------
# Stamp each local manifest file entry with its latest git commit date. External
# URLs intentionally do not get a modified field; Git cannot know their history.
build_modified_map() {
    local manifest_file="$1"
    local map_file="$2"
    command -v git >/dev/null || { echo "git required for modified dates" >&2; return 2; }
    jq -n '{}' > "$map_file"

    local path modified next_file
    mapfile -t paths_to_stamp < <(jq -r '.. | objects | select(has("path")) | .path' "$manifest_file" | sort -u)
    for path in "${paths_to_stamp[@]}"; do
        [[ "$path" =~ ^https?:// ]] && continue
        modified="$(git log -1 --format=%cI -- "$path" 2>/dev/null || true)"
        [[ -z "$modified" ]] && continue
        next_file="${map_file}.next"
        jq --arg path "$path" --arg modified "$modified" \
            '. + {($path): $modified}' \
            "$map_file" > "$next_file" && mv "$next_file" "$map_file"
    done
}

stamp_modified_dates() {
    local input_file="$1"
    local output_file="$2"
    local map_file
    map_file="$(mktemp)"
    build_modified_map "$input_file" "$map_file"

    jq --slurpfile modified "$map_file" '
        ($modified[0]) as $m
        | def stamp:
            if type == "array" then
                map(stamp)
            elif type == "object" then
                (
                    if has("path") then
                        if (.path | test("^https?://"; "i")) then
                            del(.modified)
                        elif ($m[.path] // null) then
                            .modified = $m[.path]
                        else
                            del(.modified)
                        end
                    else
                        .
                    end
                )
                | if has("children") then .children |= stamp else . end
            else
                .
            end;
        with_entries(.value |= stamp)
    ' "$input_file" > "$output_file"

    rm -f "$map_file"
}

MODIFIED_DRIFT=0
MODIFIED_CHECK="$(mktemp)"
stamp_modified_dates "$MANIFEST" "$MODIFIED_CHECK"
if ! cmp -s "$MANIFEST" "$MODIFIED_CHECK"; then
    MODIFIED_DRIFT=1
fi
rm -f "$MODIFIED_CHECK"

if [[ $STAMP_MODIFIED -eq 1 ]]; then
    if [[ $MODIFIED_DRIFT -eq 0 ]]; then
        echo "modified metadata already in sync."
        exit 0
    fi
    TMP_STAMP="$(mktemp)"
    stamp_modified_dates "$MANIFEST" "$TMP_STAMP"
    mv "$TMP_STAMP" "$MANIFEST"
    echo "modified metadata refreshed."
    exit 0
fi

# -------- report --------
echo "=== manifest sync ==="
echo "apply: $([ $APPLY -eq 1 ] && echo yes || echo no '(dry-run)')"
echo

if [[ ${#NEW_FILES[@]} -eq 0 && ${#DRIFT_PATHS[@]} -eq 0 && "$HAS_STRUCTURAL_ISSUES" == "false" && $MODIFIED_DRIFT -eq 0 ]]; then
    echo "manifest and disk are in sync."
    exit 0
fi

[[ ${#DRIFT_PATHS[@]} -gt 0 ]] && {
    echo "drift (manifest references missing files):"
    printf '  - %s\n' "${DRIFT_PATHS[@]}"
    echo
}

if [[ ${#NEW_FILES[@]} -eq 0 && ${#DRIFT_PATHS[@]} -eq 0 && "$HAS_STRUCTURAL_ISSUES" == "false" && $MODIFIED_DRIFT -eq 0 ]]; then
    echo "no changes needed."
    exit 0
fi

[[ ${#NEW_FILES[@]} -gt 0 ]] && {
    echo "new files (not in manifest):"
    printf '  + %s\n' "${NEW_FILES[@]}"
    echo
}

# -------- helpers --------
derive_id() {
    local rel="$1"
    local base="${rel%.*}"
    base="${base//\//_}"
    base="${base//[^a-zA-Z0-9_]/_}"
    base="$(printf '%s' "$base" | tr -s '_')"
    base="${base#_}"
    base="${base%_}"
    printf '%s' "${base,,}"
}

prompt() {
    local var="$1" msg="$2" default="${3:-}"
    local reply
    read -r -p "$msg [$default]: " reply
    reply="${reply:-$default}"
    printf -v "$var" '%s' "$reply"
}

id_exists() {
    local id="$1"
    local manifest_file="$2"
    local count
    count="$(jq -r --arg id "$id" '[.. | objects | .id // empty | select(. == $id)] | length' "$manifest_file" 2>/dev/null || echo 0)"
    [[ "$count" -gt 0 ]]
}

unique_id() {
    local base="$1"
    local manifest_file="$2"
    local candidate="$base"
    local n=2
    while id_exists "$candidate" "$manifest_file"; do
        candidate="${base}_${n}"
        n=$((n+1))
    done
    printf '%s' "$candidate"
}

title_case() {
    printf '%s' "$1" | awk '{
        for (i=1; i<=NF; i++) {
            t=toupper(substr($i,1,1)) substr($i,2)
            printf "%s%s", (i>1?" ":""), t
        }
    }'
}

# Auto-derive defaults for a file without prompting
auto_defaults() {
    local rel="$1"
    local manifest_file="$2"

    # id
    local prop_id
    prop_id="$(unique_id "$(derive_id "$rel")" "$manifest_file")"
    printf -v AUTO_ID '%s' "$prop_id"

    # title
    local base="${rel##*/}"
    base="${base%.*}"
    if [[ "$rel" == */* ]]; then
        printf -v AUTO_TITLE '%s' "$(title_case "${base//[_-]/ }")"
    else
        printf -v AUTO_TITLE '%s' "$(printf '%s' "$base" | tr '_-' '  ' | tr '[:lower:]' '[:upper:]')"
    fi

    # type
    local ext="${rel##*.}"
    local ext_lower="${ext,,}"
    case "$ext_lower" in
        svg) printf -v AUTO_TYPE '%s' "GRAPH" ;;
        png|jpg|jpeg) printf -v AUTO_TYPE '%s' "IMAGE" ;;
        pdf) printf -v AUTO_TYPE '%s' "PDF" ;;
        md) printf -v AUTO_TYPE '%s' "TEXT" ;;
        *) printf -v AUTO_TYPE '%s' "" ;;
    esac
}

# -------- dry-run: just show what would happen --------
if [[ $APPLY -eq 0 ]]; then
    echo "dry-run: showing proposed changes (no changes will be made)"
    echo "pass --apply to interactively update manifest.json"
    echo

    if [[ ${#NEW_FILES[@]} -gt 0 ]]; then
        echo "Entries to add:"
        echo "---------------"
        for rel in "${NEW_FILES[@]}"; do
            auto_defaults "$rel" "$MANIFEST"
            parent="$(dirname "$rel")"
            top="${parent%%/*}"

            echo "  $rel"
            echo "    id:    $AUTO_ID"
            echo "    title: $AUTO_TITLE"
            echo "    type:  $AUTO_TYPE"
            if [[ "$parent" == "$top" ]]; then
                echo "    target: top-level array \"$top\""
            else
                echo "    target: nested DIR under $parent"
            fi
            echo
        done
    fi

    if [[ ${#DRIFT_PATHS[@]} -gt 0 ]]; then
        echo "Entries to remove (files no longer exist):"
        echo "--------------------------------------------"
        for path in "${DRIFT_PATHS[@]}"; do
            # Extract entry details from manifest
            entry_json=$(jq -c --arg p "$path" '
                def find_entry:
                    . as $in
                    | if type == "array" then
                        .[] | select(.path == $p)
                    elif type == "object" then
                        if .path == $p then .
                        elif .children then .children[] | find_entry
                        else empty
                        end
                    else empty
                    end;
                first(.[] | find_entry)
            ' "$MANIFEST")

            if [[ -n "$entry_json" ]]; then
                id=$(echo "$entry_json" | jq -r '.id')
                title=$(echo "$entry_json" | jq -r '.title')
                type=$(echo "$entry_json" | jq -r '.type')
                echo "  $path"
                echo "    id:    $id"
                echo "    title: $title"
                echo "    type:  $type"
                echo
            fi
        done
    fi

    # Check for orphaned top-level keys (no matching disk directory)
    echo
    echo "Orphaned sections (top-level keys without disk directories):"
    echo "-------------------------------------------------------------"
    mapfile -t manifest_keys < <(jq -r 'keys[]' "$MANIFEST")
    orphan_count=0
    for key in "${manifest_keys[@]}"; do
        if [[ ! -d "$key" ]]; then
            echo "  $key"
            orphan_count=$((orphan_count + 1))
        fi
    done
    [[ $orphan_count -eq 0 ]] && echo "  (none)"
    echo

    # Check for empty containers
    echo "Empty containers:"
    echo "-----------------"
    
    # Empty top-level arrays
    empty_tops=$(jq -r 'to_entries[] | select(.value == []) | .key' "$MANIFEST" 2>/dev/null || true)
    empty_count=0
    if [[ -n "$empty_tops" ]]; then
        while IFS= read -r top_key; do
            [[ -z "$top_key" ]] && continue
            echo "  $top_key (empty array)"
            empty_count=$((empty_count + 1))
        done <<< "$empty_tops"
    fi
    
    # Empty DIR entries
    empty_dirs=$(jq -r '
        def check_empty:
            . as $in
            | if type == "array" then
                .[] | check_empty
            elif type == "object" then
                if .type == "DIR" and (.children // [] | length == 0) then
                    .id
                elif has("children") then
                    .children[] | check_empty
                else empty
                end
            else empty
            end;
        .[] | check_empty
    ' "$MANIFEST" 2>/dev/null || true)
    
    if [[ -n "$empty_dirs" ]]; then
        while IFS= read -r dir_id; do
            [[ -z "$dir_id" ]] && continue
            echo "  DIR: $dir_id (empty children)"
            empty_count=$((empty_count + 1))
        done <<< "$empty_dirs"
    fi
    
    [[ $empty_count -eq 0 ]] && echo "  (none)"
    echo

    if [[ $MODIFIED_DRIFT -eq 1 ]]; then
        echo "Modified metadata:"
        echo "------------------"
        echo "  modified fields need refresh"
        echo
    fi

    echo "=== summary ==="
    echo "${#NEW_FILES[@]} file(s) to add, ${#DRIFT_PATHS[@]} file(s) to remove."
    [[ $orphan_count -gt 0 ]] && echo "$orphan_count orphaned section(s) to remove."
    [[ $empty_count -gt 0 ]] && echo "$empty_count empty container(s) to remove."
    [[ $MODIFIED_DRIFT -eq 1 ]] && echo "modified metadata to refresh."
    exit 0
fi

# -------- interactive apply flow --------
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

file_count=0
added_count=0

echo "Interactive manifest update"
echo "==========================="
echo
echo "For each new file, you'll be prompted for three fields:"
echo
echo "  id    — unique routing identifier (short, lowercase, snake_case)"
echo "          becomes the path-chain key in the store (e.g., org/team)"
echo "          must be unique across the entire manifest"
echo
echo "  title — display name shown in the OS UI"
echo "          appears in the TITLE column cell (with ▸ prefix for directories)"
echo
echo "  type  — category tag that determines UI styling and viewer routing"
echo "          maps to a colored badge in the CATEGORY column"
echo "          TEXT → THEORY bucket, PAPER → research papers, ARTIFACT → experiment records"
echo

for rel in "${NEW_FILES[@]}"; do
    file_count=$((file_count + 1))
    echo "[$file_count/${#NEW_FILES[@]}] $rel"

    auto_defaults "$rel" "$MANIFEST"

    # Compute parent and top early for explanations
    parent="$(dirname "$rel")"
    top="${parent%%/*}"

    # id
    echo "  [id] routing identifier — must be unique, lowercase, snake_case"
    echo "       becomes ${top}/${AUTO_ID} in the store's path-chain"
    prompt final_id "  id" "$AUTO_ID"
    if id_exists "$final_id" "$MANIFEST"; then
        final_id="$(unique_id "$final_id" "$MANIFEST")"
        echo "  (uniquified to $final_id)"
    fi

    # title
    echo "  [title] display name — shown in the OS file browser TITLE cell"
    prompt final_title "  title" "$AUTO_TITLE"

    # type
    echo "  [type] category tag — determines viewer routing and colored badge"
    echo "         TEXT: prose essays (renders as THEORY)"
    echo "         SYSTEM: architecture/system docs"
    echo "         THEORY: theoretical work"
    echo "         PAPER: research papers"
    echo "         INFO: reference/informational docs"
    echo "         RESULT: experiment results"
    echo "         ARTIFACT: experiment records (charters, summaries, negatives, glossaries)"
    echo "         GRAPH: SVG diagrams (auto-detected for .svg)"
    echo "         IMAGE: raster images (auto-detected for .png/.jpg/.jpeg)"
    echo "         PDF:   PDF documents (auto-detected for .pdf; path may be absolute URL)"
    valid_types=(TEXT SYSTEM THEORY PAPER INFO RESULT ARTIFACT GRAPH IMAGE PDF)
    prompt final_type "  type" "$AUTO_TYPE"
    final_type="${final_type^^}"

    while true; do
        for vt in "${valid_types[@]}"; do
            [[ "$final_type" == "$vt" ]] && break 2
        done
        echo "  invalid type '$final_type'"
        prompt final_type "  type" "$AUTO_TYPE"
        final_type="${final_type^^}"
    done

    # Build the proposed entry
    entry="$(jq -nc --arg id "$final_id" --arg title "$final_title" --arg path "$rel" --arg type "$final_type" '{id:$id, title:$title, path:$path, type:$type}')"

    # Show proposed entry
    echo
    echo "  proposed entry:"
    jq . <<< "$entry" | sed 's/^/    /'
    echo

    if [[ "$parent" == "$top" ]]; then
        echo "  will be added to top-level array: $top"
    else
        echo "  will be added to nested DIR under: $parent"
    fi

    # Confirm before write
    read -r -p "  add this entry? [y/N] " confirm
    if [[ "${confirm,,}" != "y" ]]; then
        echo "  skipped."
        echo
        continue
    fi

    # Splice into manifest
    before_count=$(jq -r --arg p "$rel" '[.. | objects | select(.path == $p)] | length' "$MANIFEST")
    
    if [[ "$parent" == "$top" ]]; then
        jq --arg key "$top" --arg id "$final_id" --arg title "$final_title" --arg path "$rel" --arg type "$final_type" '
            .[$key] += [{id:$id, title:$title, path:$path, type:$type}]
        ' "$MANIFEST" > "$TMP/tmp.json" && mv "$TMP/tmp.json" "$MANIFEST"
    else
        # For nested paths, split parent into segments and build DIR chain
        # E.g., parent="philosophy/axioms" -> top="philosophy", rest="axioms"
        IFS='/' read -ra parts <<< "$parent"
        top="${parts[0]}"
        rest=""
        for ((i=1; i<${#parts[@]}; i++)); do
            [[ -n "$rest" ]] && rest="$rest/"
            rest="$rest${parts[$i]}"
        done
        
        jq --arg top "$top" --arg rest "$rest" \
           --arg id "$final_id" --arg title "$final_title" --arg path "$rel" --arg type "$final_type" '
            # Recursive: given an array, walk $rest segments to place the entry
            def place(segments):
                if segments == "" then
                    # Done — add the file entry here
                    . + [{id:$id, title:$title, path:$path, type:$type}]
                else
                    (segments | split("/")[0]) as $dir |
                    (segments | split("/")[1:] | join("/")) as $next |
                    if any(.[]; .id == $dir and .type == "DIR") then
                        # DIR exists, recurse into its children
                        map(if .id == $dir and .type == "DIR"
                           then .children |= place($next)
                           else . end)
                    else
                        # DIR does not exist, create it
                        . + [{
                            id: $dir,
                            title: ($dir | gsub("_"; " ")),
                            type: "DIR",
                            children: ([] | place($next))
                        }]
                    end
                end;
            # Ensure top-level key exists, then apply
            if has($top) then . else .[$top] = [] end
            | .[$top] |= place($rest)
        ' "$MANIFEST" > "$TMP/tmp.json" && mv "$TMP/tmp.json" "$MANIFEST"
    fi
    
    after_count=$(jq -r --arg p "$rel" '[.. | objects | select(.path == $p)] | length' "$MANIFEST")
    if [[ "$after_count" -gt "$before_count" ]]; then
        added_count=$((added_count + 1))
        echo "  ✓ added to manifest"
    else
        echo "  ✗ FAILED to add (manifest unchanged)"
    fi
    echo
done

# -------- removal phase --------
removed_count=0

if [[ ${#DRIFT_PATHS[@]} -gt 0 ]]; then
    echo
    echo "Removal phase: ${#DRIFT_PATHS[@]} stale file entries detected"
    echo "=============================================================="
    echo
    echo "These manifest entries reference files that no longer exist on disk."
    echo "For each entry, confirm removal to clean up the manifest."
    echo

    for path in "${DRIFT_PATHS[@]}"; do
        echo "Stale entry: $path"

        # Extract entry details from manifest
        entry_json=$(jq -c --arg p "$path" '
            def find_entry:
                . as $in
                | if type == "array" then
                    .[] | select(.path == $p)
                elif type == "object" then
                    if .path == $p then .
                    elif .children then .children[] | find_entry
                    else empty
                    end
                else empty
                end;
            first(.[] | find_entry)
        ' "$MANIFEST")

        if [[ -z "$entry_json" ]]; then
            echo "  [warn] could not locate entry in manifest"
            echo
            continue
        fi

        id=$(echo "$entry_json" | jq -r '.id')
        title=$(echo "$entry_json" | jq -r '.title')
        type=$(echo "$entry_json" | jq -r '.type')

        echo "  id:    $id"
        echo "  title: $title"
        echo "  type:  $type"
        echo

        read -r -p "  remove this stale entry? [y/N] " confirm
        if [[ "${confirm,,}" != "y" ]]; then
            echo "  kept (manifest still references missing file)"
            echo
            continue
        fi

        # Remove from manifest
        # Determine if this is a top-level or nested entry
        parent="$(dirname "$path")"
        top="${parent%%/*}"

        if [[ "$parent" == "$top" ]]; then
            # Top-level entry: remove from top-level array
            jq --arg key "$top" --arg p "$path" '
                .[$key] |= map(select(.path != $p))
            ' "$MANIFEST" > "$TMP/tmp.json" && mv "$TMP/tmp.json" "$MANIFEST"
        else
            # Nested entry: remove from children array
            jq --arg p "$path" '
                def remove_entry:
                    . as $in
                    | if type == "object" then
                        if .children then
                            .children |= map(select(.path != $p) | remove_entry)
                        else .
                        end
                    elif type == "array" then
                        map(select(.path != $p) | remove_entry)
                    else .
                    end;
                . | with_entries(.value |= remove_entry)
            ' "$MANIFEST" > "$TMP/tmp.json" && mv "$TMP/tmp.json" "$MANIFEST"
        fi

        removed_count=$((removed_count + 1))
        echo "  ✓ removed from manifest"
        echo
    done
fi

# -------- cleanup phase (always runs) --------
echo
echo "Cleanup phase: checking for empty containers"
echo "============================================="
echo

# Remove DIR entries with empty children
echo "Checking for empty DIR entries..."
empty_dirs=$(jq -r '
    def check_empty:
        . as $in
        | if type == "array" then
            .[] | check_empty
        elif type == "object" then
            if .type == "DIR" and (.children // [] | length == 0) then
                .id
            elif has("children") then
                .children[] | check_empty
            else empty
            end
        else empty
        end;
    .[] | check_empty
' "$MANIFEST" 2>/dev/null || true)

if [[ -n "$empty_dirs" ]]; then
    while IFS= read -r dir_id; do
        [[ -z "$dir_id" ]] && continue
        echo "  Empty DIR: $dir_id"
        read -r -p "  remove this empty directory? [y/N] " confirm
        if [[ "${confirm,,}" == "y" ]]; then
            jq --arg id "$dir_id" '
                def remove_dir:
                    . as $in
                    | if type == "array" then
                        map(select(.id != $id) | remove_dir)
                    elif type == "object" then
                        if has("children") then
                            .children |= map(select(.id != $id) | remove_dir)
                        else .
                        end
                    else .
                    end;
                . | with_entries(.value |= remove_dir)
            ' "$MANIFEST" > "$TMP/tmp.json" && mv "$TMP/tmp.json" "$MANIFEST"
            removed_count=$((removed_count + 1))
            echo "  ✓ removed from manifest"
        else
            echo "  kept"
        fi
        echo
    done <<< "$empty_dirs"
else
    echo "  No empty DIR entries found."
fi

# Remove top-level keys with empty arrays
echo
echo "Checking for empty top-level sections..."
empty_tops=$(jq -r 'to_entries[] | select(.value == []) | .key' "$MANIFEST" 2>/dev/null || true)

if [[ -n "$empty_tops" ]]; then
    while IFS= read -r top_key; do
        [[ -z "$top_key" ]] && continue
        echo "  Empty section: $top_key"
        read -r -p "  remove this empty section? [y/N] " confirm
        if [[ "${confirm,,}" == "y" ]]; then
            jq --arg key "$top_key" 'del(.[$key])' "$MANIFEST" > "$TMP/tmp.json" && mv "$TMP/tmp.json" "$MANIFEST"
            removed_count=$((removed_count + 1))
            echo "  ✓ removed from manifest"
        else
            echo "  kept"
        fi
        echo
    done <<< "$empty_tops"
else
    echo "  No empty top-level sections found."
fi

# Remove top-level keys for directories that don't exist on disk
echo
echo "Checking for top-level keys without disk directories..."
mapfile -t manifest_keys < <(jq -r 'keys[]' "$MANIFEST")
for key in "${manifest_keys[@]}"; do
    if [[ ! -d "$key" ]]; then
        echo "  Orphaned section: $key (directory does not exist)"
        read -r -p "  remove this orphaned section? [y/N] " confirm
        if [[ "${confirm,,}" == "y" ]]; then
            jq --arg key "$key" 'del(.[$key])' "$MANIFEST" > "$TMP/tmp.json" && mv "$TMP/tmp.json" "$MANIFEST"
            removed_count=$((removed_count + 1))
            echo "  ✓ removed from manifest"
        else
            echo "  kept"
        fi
        echo
    fi
done

metadata_updated=0
TMP_MODIFIED="$TMP/modified.json"
stamp_modified_dates "$MANIFEST" "$TMP_MODIFIED"
if ! cmp -s "$MANIFEST" "$TMP_MODIFIED"; then
    mv "$TMP_MODIFIED" "$MANIFEST"
    metadata_updated=1
    echo
    echo "✓ refreshed modified metadata"
else
    rm -f "$TMP_MODIFIED"
fi

echo "=== summary ==="
echo "processed: $file_count files"
echo "added: $added_count entries"
echo "removed: $removed_count stale entries"
if [[ $added_count -gt 0 || $removed_count -gt 0 || $metadata_updated -eq 1 ]]; then
    echo "manifest.json updated."
else
    echo "no changes made."
fi

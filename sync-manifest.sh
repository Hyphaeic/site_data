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
#
# Default is dry-run (exit 0, no writes). Pass --apply to write changes.

set -euo pipefail

# -------- args --------
APPLY=0
for arg in "$@"; do
    case "$arg" in
        --apply) APPLY=1 ;;
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
        md|svg|png|jpg|jpeg) ON_DISK["$rel"]=1 ;;
    esac
done < <(find . -type f -print0)

# Collect all manifest paths
mapfile -t MANIFEST_PATHS < <(jq -r '.. | objects | select(has("path")) | .path' "$MANIFEST" | sort -u)

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
    [[ -z "${ON_DISK[$mp]:-}" ]] && DRIFT_PATHS+=("$mp")
done

IFS=$'\n' NEW_FILES=($(printf '%s\n' "${NEW_FILES[@]:-}" | sort)); unset IFS
IFS=$'\n' DRIFT_PATHS=($(printf '%s\n' "${DRIFT_PATHS[@]:-}" | sort)); unset IFS

# -------- report --------
echo "=== manifest sync ==="
echo "apply: $([ $APPLY -eq 1 ] && echo yes || echo no '(dry-run)')"
echo

if [[ ${#NEW_FILES[@]} -eq 0 && ${#DRIFT_PATHS[@]} -eq 0 ]]; then
    echo "manifest and disk are in sync."
    exit 0
fi

[[ ${#DRIFT_PATHS[@]} -gt 0 ]] && {
    echo "drift (manifest references missing files):"
    printf '  - %s\n' "${DRIFT_PATHS[@]}"
    echo
}

if [[ ${#NEW_FILES[@]} -eq 0 ]]; then
    echo "no new files to process."
    exit 0
fi

echo "new files (not in manifest):"
printf '  + %s\n' "${NEW_FILES[@]}"
echo

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
        md) printf -v AUTO_TYPE '%s' "TEXT" ;;
        *) printf -v AUTO_TYPE '%s' "" ;;
    esac
}

# -------- dry-run: just show what would happen --------
if [[ $APPLY -eq 0 ]]; then
    echo "dry-run: showing proposed entries (no changes will be made)"
    echo "pass --apply to interactively add entries to manifest.json"
    echo

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

    echo "=== summary ==="
    echo "${#NEW_FILES[@]} new file(s) found. run with --apply to add them."
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
    valid_types=(TEXT SYSTEM THEORY PAPER INFO RESULT ARTIFACT GRAPH IMAGE)
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
    if [[ "$parent" == "$top" ]]; then
        jq --arg key "$top" --arg id "$final_id" --arg title "$final_title" --arg path "$rel" --arg type "$final_type" '
            .[$key] += [{id:$id, title:$title, path:$path, type:$type}]
        ' "$MANIFEST" > "$TMP/tmp.json" && mv "$TMP/tmp.json" "$MANIFEST"
    else
        jq --arg parent "$parent" --arg id "$final_id" --arg title "$final_title" --arg path "$rel" --arg type "$final_type" '
            def splice_in:
                . as $in
                | if type == "object" then
                    if .type == "DIR" then
                        if (.children // []) | any(.path // "" | split("/")[:-1] | join("/") == $parent) then
                            .children += [{id:$id, title:$title, path:$path, type:$type}]
                        else
                            .children |= map(splice_in)
                        end
                    else
                        with_entries(.value |= splice_in)
                    end
                  elif type == "array" then
                    map(splice_in)
                  else .
                  end;
            splice_in
        ' "$MANIFEST" > "$TMP/tmp.json" && mv "$TMP/tmp.json" "$MANIFEST"
    fi

    added_count=$((added_count + 1))
    echo "  ✓ added to manifest"
    echo
done

echo "=== summary ==="
echo "processed: $file_count files"
echo "added: $added_count entries"
if [[ $added_count -gt 0 ]]; then
    echo "manifest.json updated."
else
    echo "no changes made."
fi

#!/usr/bin/env bash
set -euo pipefail

# Run from the existing repository root after extracting this package elsewhere.
# Usage: ./merge-additively.sh /path/to/azure-landing-zone-enterprise-extension
SRC="${1:?Usage: $0 /path/to/extension-package}"
DEST="$(pwd)"

if [[ ! -d "$DEST/.git" ]]; then
  echo "ERROR: Run this script from the root of the existing Git repository." >&2
  exit 1
fi
if [[ ! -d "$SRC/terraform/vending" || ! -d "$SRC/terraform/subscription-foundation" ]]; then
  echo "ERROR: Extension source directory does not contain expected Terraform roots." >&2
  exit 1
fi

# Refuse to overwrite any existing path; this protects existing code and backups.
while IFS= read -r -d '' srcfile; do
  rel="${srcfile#"$SRC"/}"
  if [[ -e "$DEST/$rel" ]]; then
    echo "CONFLICT: $rel already exists. Review/merge this file manually; nothing copied." >&2
    exit 2
  fi
done < <(find "$SRC" -type f ! -name 'merge-additively.sh' ! -name '.gitignore.append' -print0)

while IFS= read -r -d '' srcfile; do
  rel="${srcfile#"$SRC"/}"
  mkdir -p "$(dirname "$DEST/$rel")"
  cp -n "$srcfile" "$DEST/$rel"
done < <(find "$SRC" -type f ! -name 'merge-additively.sh' ! -name '.gitignore.append' -print0)

if [[ -f "$SRC/.gitignore.append" ]]; then
  echo "NOTE: Append the non-comment rules from $SRC/.gitignore.append to your existing .gitignore manually." 
fi

echo "Additive files copied. No existing paths were overwritten. Review git status and run validation before committing."

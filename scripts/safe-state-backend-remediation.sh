#!/usr/bin/env bash
set -Eeuo pipefail
umask 077

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

BACKEND="terraform/bootstrap/state-backend"
STAMP="$(date +%Y%m%d-%H%M%S)"
BRANCH="chore/state-backend-remediation-${STAMP}"
BACKUP_DIR="$HOME/alz-remediation-backups/$STAMP"
REPORT_DIR="$ROOT/.local-remediation/$STAMP"

mkdir -p "$BACKUP_DIR" "$REPORT_DIR"
chmod 700 "$BACKUP_DIR" "$REPORT_DIR"

echo "=================================================="
echo "Azure Landing Zone: safe backend remediation"
echo "=================================================="
echo "Repository: $ROOT"
echo "Branch:     $BRANCH"
echo "Backup:     $BACKUP_DIR"
echo "Report:     $REPORT_DIR"
echo
echo "Safety: no Azure deployment, no terraform apply,"
echo "no workflow_dispatch and no automatic push."
echo

# Do not overwrite or accidentally commit unrelated work.
if [[ "$(git branch --show-current)" != "main" ]]; then
  echo "ERROR: Start from main so the remediation branch is predictable."
  exit 1
fi

# Permit only the four known, previously reported backup files.
while IFS= read -r entry; do
  [[ -z "$entry" ]] && continue
  case "$entry" in
    "?? .github/workflows/terraform-deploy.yml.before-corp-online-20261016-155854" |     "?? .gitignore.before-cleanup" |     "?? scripts/validate-network-cidrs.py.backup-20261016-160643" |     "?? scripts/validate-network-cidrs.py.backup-20261016-160726")
      ;;
    *)
      echo "ERROR: Unexpected working-tree change:"
      echo "$entry"
      echo "Review or safely preserve it before continuing."
      exit 1
      ;;
  esac
done < <(git status --short)

# Preserve the existing backend configuration before any edits.
for file in   "$BACKEND/main.tf"   "$BACKEND/variables.tf"   "$BACKEND/versions.tf"   "$BACKEND/outputs.tf"   "$BACKEND/terraform.tfvars.example"   "terraform/environments/networking/main.tf"   "terraform/environments/networking/variables.tf"   ".github/workflows/repository-checks.yml"   ".github/workflows/terraform-deploy.yml"
do
  if [[ -f "$file" ]]; then
    mkdir -p "$BACKUP_DIR/$(dirname "$file")"
    cp -p "$file" "$BACKUP_DIR/$file"
  fi
done

# This script itself is expected to be uncommitted when first run.
git switch -c "$BRANCH"

# Record the architecture decision and unresolved prerequisites.
mkdir -p docs/architecture
cat > docs/architecture/state-backend-remediation-status.md <<'DOC'
# Terraform State Backend Remediation Status

## Approved direction

- Terraform backend security is the target.
- Customer-managed key (CMK) is the encryption target.
- GitHub Actions runner is GitHub-hosted 

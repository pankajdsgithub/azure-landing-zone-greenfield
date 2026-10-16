#!/usr/bin/env bash
set -u

ROOT="$HOME/workspace/azure-landing-zone-greenfield"
cd "$ROOT" || exit 1

PASS=0
FAIL=0
WARN=0

ok()   { echo "PASS: $*"; PASS=$((PASS+1)); }
fail() { echo "FAIL: $*"; FAIL=$((FAIL+1)); }
warn() { echo "WARN: $*"; WARN=$((WARN+1)); }

echo "========================================"
echo " Azure Landing Zone - Verification"
echo "========================================"
echo "Repository: $ROOT"
echo "Branch: $(git branch --show-current)"
echo

# 1. Format Terraform files safely
echo "== 1. Terraform formatting =="
if terraform fmt -check -recursive; then
  if terraform fmt -check -recursive; then
    ok "Terraform formatting"
  else
    fail "Terraform formatting check"
  fi
else
  fail "Terraform fmt command"
fi

# 2. Check whitespace errors
echo
echo "== 2. Git diff whitespace check =="
if git diff --check; then
  ok "git diff --check"
else
  fail "Whitespace errors in Git diff"
fi

# 3. Required repository files
echo
echo "== 3. Required files =="
required_files=(
  README.md
  docs/architecture.md
  docs/design-decisions.md
  docs/deployment-guide.md
  docs/rbac-security-review.md
  architecture/landing-zone-flow.mmd
  terraform/bootstrap/README.md
  terraform/modules/management-groups/README.md
  terraform/environments/README.md
  policies/README.md
  examples/README.md
  terraform/environments/management-groups/main.tf
  terraform/environments/management-groups/variables.tf
  terraform/environments/management-groups/outputs.tf
  terraform/environments/management-groups/providers.tf
  terraform/environments/management-groups/versions.tf
  terraform/environments/governance/terraform.tfvars.example
  .github/workflows/repository-checks.yml
)

for f in "${required_files[@]}"; do
  if [[ -s "$f" ]]; then
    ok "$f"
  else
    fail "Missing or empty: $f"
  fi
done

# 4. Terraform init/validate without configuring Azure backend
echo
echo "== 4. Terraform validation (no deployment) =="

roots=(
  terraform/environments/management-groups
  terraform/environments/platform
  terraform/environments/identity
  terraform/environments/networking
  terraform/environments/governance
  terraform/bootstrap/state-backend
)

for d in "${roots[@]}"; do
  echo "--- $d ---"

  if terraform -chdir="$d" init \
      -backend=false -input=false -no-color; then
    if terraform -chdir="$d" validate -no-color; then
      ok "Terraform validate: $d"
    else
      fail "Terraform validate: $d"
    fi
  else
    fail "Terraform init -backend=false: $d"
  fi
done

# 5. Verify workflow includes the intended checks
echo
echo "== 5. GitHub Actions workflow =="

workflow=".github/workflows/repository-checks.yml"

for pattern in \
  'management-groups' \
  'terraform fmt -check -recursive' \
  'Checkov' \
  'soft_fail: true' \
  'pull_request:' \
  'workflow_dispatch:'
do
  if grep -Fq "$pattern" "$workflow"; then
    ok "Workflow contains: $pattern"
  else
    fail "Workflow missing: $pattern"
  fi
done

if grep -Eq 'Lint management-groups environment|tflint --chdir=terraform/environments/management-groups' "$workflow"; then
  ok "Management Groups TFLint check"
else
  fail "Management Groups TFLint check"
fi

# 6. Check workflow YAML syntax if a parser is available
echo
echo "== 6. Workflow syntax =="

if command -v actionlint >/dev/null 2>&1; then
  if actionlint "$workflow"; then
    ok "actionlint"
  else
    fail "actionlint"
  fi
elif python3 -c 'import yaml' >/dev/null 2>&1; then
  if python3 - "$workflow" <<'PY'
import sys, yaml
with open(sys.argv[1], encoding="utf-8") as f:
    doc = yaml.safe_load(f)
if not isinstance(doc, dict) or not isinstance(doc.get("jobs"), dict):
    raise SystemExit("Workflow must contain a jobs mapping")
print("YAML parsed; jobs:", ", ".join(doc["jobs"].keys()))
PY
  then
    ok "Workflow YAML parses"
  else
    fail "Workflow YAML parsing"
  fi
else
  warn "No actionlint/PyYAML installed; workflow syntax not independently parsed"
fi

# 7. TFLint if installed; Checkov remains in CI as requested
echo
echo "== 7. TFLint =="

if command -v tflint >/dev/null 2>&1; then
  for d in "${roots[@]}"; do
    if tflint --chdir="$d"; then
      ok "TFLint: $d"
    else
      fail "TFLint: $d"
    fi
  done
else
  warn "TFLint is not installed locally; CI workflow retains its TFLint checks"
fi

echo
echo "== 8. Tracked Terraform state/plan files =="

if git ls-files | grep -E '(^|/)(terraform\.tfstate|[^/]*\.tfstate(\..*)?|[^/]*\.tfplan)$'; then
  fail "Review the tracked state/plan paths printed above"
else
  ok "No tracked Terraform state/plan files found"
fi

echo
echo "== Final Git status =="
git status --short

echo
echo "========================================"
echo "PASS=$PASS  FAIL=$FAIL  WARN=$WARN"
echo "========================================"
echo "Checkov has NOT been run locally; it remains in GitHub Actions."
echo "No Terraform apply, commit, or push was performed."

if (( FAIL > 0 )); then
  exit 1
fi

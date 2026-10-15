# Terraform Azure Remote State Backend

## 1. Objective

This document explains how the Azure Landing Zone Terraform stacks
were migrated from local state files to Azure Blob Storage.

The migration changes where Terraform stores its state. It does not
deploy, recreate, or delete Azure resources.

## 2. Why Remote State?

| Local state | Azure remote state |
|---|---|
| Stored on a developer machine | Stored centrally in Azure Blob Storage |
| Difficult to share safely | Accessible through Azure RBAC |
| Local backup and recovery required | Blob versioning and retention can help recovery |
| Collaboration is difficult | Supports team workflows and state locking |

Remote state must be protected because it can contain sensitive
infrastructure information.

## 3. Backend Details

| Setting | Value |
|---|---|
| Azure subscription | `8de31583-5018-4d87-9fa1-2a74a001bb25` |
| Resource Group | `rg-tfstate-railconnect-ci` |
| Storage Account | `sttfstatepankaj2026ci` |
| Blob Container | `tfstate` |
| Region | Central India |
| Authentication | Azure CLI |
| Terraform provider | AzureRM `~> 4.0` |

### State files

| Stack | Blob key |
|---|---|
| Platform | `platform.tfstate` |
| Governance | `governance.tfstate` |
| Bootstrap | `bootstrap.tfstate` |

Each stack has its own state file.

## 4. Backend Configuration

Terraform backend blocks do not support normal input variables.
Therefore, the backend block is declared in the Terraform configuration,
while backend values are passed during `terraform init`.

Add the following inside the existing top-level `terraform` block:

```hcl
backend "azurerm" {}
```

Do not create a second top-level `terraform` block.

The provider configuration remains separate:

```hcl
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
```

## 5. Prerequisites

1. Azure CLI is installed and authenticated.
2. The correct Azure subscription is selected.
3. The user has permission to read and write blobs in the state container.
4. The destination state key does not contain another stack's state.
5. Local state backups have been created and protected.

Check the active account:

```bash
az account show \
  --query "{subscription:id, tenant:tenantId, user:user.name}" \
  --output table
```

Check Blob access:

```bash
az storage blob list \
  --account-name sttfstatepankaj2026ci \
  --container-name tfstate \
  --auth-mode login \
  --query "[].name" \
  --output table
```

## 6. State Migration Command

Run the command from the relevant stack directory.

### Platform

```bash
cd ~/workspace/azure-landing-zone-greenfield/terraform/environments/platform

terraform init -migrate-state \
  -backend-config="resource_group_name=rg-tfstate-railconnect-ci" \
  -backend-config="storage_account_name=sttfstatepankaj2026ci" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=platform.tfstate" \
  -backend-config="use_cli=true"
```

### Governance

```bash
cd ~/workspace/azure-landing-zone-greenfield/terraform/environments/governance

terraform init -migrate-state \
  -backend-config="resource_group_name=rg-tfstate-railconnect-ci" \
  -backend-config="storage_account_name=sttfstatepankaj2026ci" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=governance.tfstate" \
  -backend-config="use_cli=true"
```

### Bootstrap

```bash
cd ~/workspace/azure-landing-zone-greenfield/terraform/bootstrap/state-backend

terraform init -migrate-state \
  -backend-config="resource_group_name=rg-tfstate-railconnect-ci" \
  -backend-config="storage_account_name=sttfstatepankaj2026ci" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=bootstrap.tfstate" \
  -backend-config="use_cli=true"
```

When Terraform asks whether to copy the existing local state to the
new backend, review the prompt and enter `yes` only after verifying
the destination key is correct.

Do not use `-reconfigure` as a substitute for migration when the
existing local state must be copied.

## 7. Verification

Run these commands from each stack directory after migration:

```bash
terraform state list
terraform plan -var-file=terraform.tfvars
```

Expected results:

- The expected resources appear in `terraform state list`.
- The plan reports `No changes` when configuration and Azure resources
  are already in sync.

Verify the state blobs:

```bash
az storage blob list \
  --account-name sttfstatepankaj2026ci \
  --container-name tfstate \
  --auth-mode login \
  --query "[].name" \
  --output tsv
```

Expected blob keys:

```text
platform.tfstate
governance.tfstate
bootstrap.tfstate
```

A successful `terraform init` alone is not sufficient verification.
Check both the remote blob and the Terraform plan.

## 8. What Migration Does and Does Not Do

- `backend "azurerm" {}` declares the backend type.
- `-backend-config` supplies the remote storage settings.
- `terraform init -migrate-state` initializes the backend and offers
  to copy existing state into it.
- `terraform state list` displays resources tracked in the current state.
- `terraform plan` compares configuration with the refreshed state.

State migration is not infrastructure deployment. Do not run `terraform
apply` merely because the backend has changed. Apply only when a reviewed
plan contains intended infrastructure changes.

## 9. Safety and Recovery

- Keep protected local state backups until remote state is verified.
- Never commit `.tfstate`, state backups, credentials, or sensitive
  `.tfvars` files to Git.
- Do not delete or recreate the state Storage Account or container
  during migration.
- Do not migrate two stacks into the same state key.
- Stop if Terraform proposes unexpected resource creation, replacement,
  or deletion.
- If migration fails, preserve the local state and error output. Inspect
  the backend configuration and remote blobs before retrying.
- Restrict access to the state container using least-privilege RBAC.
- Review network restrictions, encryption, blob versioning, retention,
  and recovery procedures as part of the platform security review.

## 10. Current Migration Status

The following results were observed during the migration session:

| Stack | State verification | Plan result |
|---|---|---|
| Platform | Three expected resources; `platform.tfstate` present | No changes |
| Governance | Three expected resources | No changes |
| Bootstrap | Three expected resources | No changes |

The Bootstrap plan confirmed the Resource Group, Storage Account, and
Blob Container were in sync with the Terraform configuration.

Re-run the verification commands if the backend, configuration, or
Azure resources change.

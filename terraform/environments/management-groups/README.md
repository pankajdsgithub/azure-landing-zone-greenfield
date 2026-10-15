# Enterprise Management Group Hierarchy

## Target hierarchy

- Existing Tenant Root Management Group (not created here)
- Platform
  - Identity
  - Connectivity
  - Management
  - Security
- Landing Zones
  - Corp
  - Online
- Sandbox (optional)

## Prerequisites

- An existing Azure tenant and subscription.
- The verified tenant-root Management Group resource ID.
- Appropriate permissions to create Management Groups.
- AzureRM provider authentication configured for the operator.

## Configuration

Copy `terraform.tfvars.example` to `terraform.tfvars` and replace
all placeholders with verified values. Enable Sandbox only if approved.

Do not commit `terraform.tfvars`, state files, or plan files.

## Validation

Run `terraform init -backend=false` and `terraform validate` in this
directory. Validation does not deploy resources.

# Azure Landing Zone — Deployment Guide

## 1. Purpose

This guide describes the phased implementation of an enterprise Azure Landing Zone using Terraform. The objective is to establish a secure, governed, scalable, and repeatable Azure platform.

## 2. Target Architecture

The Azure tenant will use the following Management Group hierarchy:

```text
Tenant Root Management Group
│
├── Platform
│   ├── Identity
│   ├── Connectivity
│   └── Management
│
├── Landing Zones
│   ├── Corp
│   └── Online
│
└── Sandbox (Optional)
```

Management Groups organize subscriptions and provide a scope for Azure Policy and role assignments.

## 3. Prerequisites

Before starting, ensure that you have:

- An Azure tenant and an active subscription.
- Azure CLI installed and authenticated.
- Terraform installed at a supported version.
- Git installed and access to the project repository.
- Appropriate permissions to create Management Groups and role assignments.
- Approval to configure Azure Storage for Terraform remote state.

Verify the tools:

```bash
az version
terraform version
git --version
```

Authenticate to Azure:

```bash
az login
az account show
```

Select the intended subscription:

```bash
az account set --subscription "<SUBSCRIPTION_ID>"
```

Verify the selected subscription before making changes.

## 4. Implementation Phases

### Phase 1 — Azure Access and Readiness

1. Confirm tenant ID and subscription ID.
2. Verify permissions for Management Groups, subscriptions, and role assignments.
3. Identify the platform, security, and workload owners.
4. Review existing Management Groups and Azure Policy assignments.
5. Confirm naming conventions and regional requirements.

**Outcome:** Azure access and implementation prerequisites are validated.

### Phase 2 — Terraform Bootstrap

1. Create a dedicated state resource group.
2. Create an Azure Storage Account for Terraform state.
3. Create a private Blob container for state files.
4. Configure Microsoft Entra ID-based authentication.
5. Grant only the required data-plane permissions.
6. Configure Terraform's AzureRM backend.
7. Enable appropriate storage security, versioning, and recovery controls.

**Important:** Bootstrap resources must be created before configuring the remote backend that depends on them. Use a separate bootstrap state or a controlled state migration process.

**Outcome:** Terraform state is stored remotely with controlled access.

### Phase 3 — Management Group Hierarchy

1. Confirm the intended parent Management Group.
2. Create the Platform Management Group.
3. Create the Landing Zones Management Group.
4. Create Identity, Connectivity, and Management children under Platform.
5. Create Corp and Online children under Landing Zones.
6. Add Sandbox only if required.
7. Validate the resulting hierarchy.

**Outcome:** The target Management Group structure is established.

### Phase 4 — Governance and Access

1. Define Azure Policy requirements.
2. Assign policies at the appropriate Management Group or subscription scope.
3. Configure least-privilege Azure RBAC.
4. Separate platform administration from workload administration.
5. Review policy exemptions and role assignments.
6. Validate governance through Azure Policy compliance.

**Outcome:** Governance and access controls are applied at the intended scopes.

### Phase 5 — Platform Services

Implement platform services in controlled increments:

- Identity and privileged access.
- Hub networking, DNS, and connectivity.
- Central logging, monitoring, and security integrations.

The actual services depend on the organization's requirements and existing Azure estate.

**Outcome:** Shared platform capabilities are ready for workload onboarding.

### Phase 6 — Landing Zone Subscriptions

1. Identify workload and environment requirements.
2. Place subscriptions in the appropriate Management Groups.
3. Apply inherited and subscription-specific governance.
4. Configure network connectivity and private access.
5. Establish monitoring, security, and cost-management controls.
6. Validate the subscription before onboarding applications.

**Outcome:** Governed subscriptions are ready for application workloads.

## 5. Terraform Execution Workflow

For each Terraform configuration, review the execution plan before applying changes:

```bash
terraform fmt -check -recursive
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

Run commands from the relevant Terraform root module.

Review the plan carefully before applying it. Do not commit state files, plan files, credentials, or secrets to Git.

For production, execute Terraform through an approved CI/CD pipeline with protected environments, controlled approvals, and workload identity or another approved non-interactive authentication method.

## 6. Validation Checklist

- [ ] Correct Azure tenant and subscription selected.
- [ ] Remote state backend initialized successfully.
- [ ] State storage access is restricted.
- [ ] Management Group hierarchy matches the approved design.
- [ ] Azure Policy assignments are present at the intended scopes.
- [ ] RBAC follows least-privilege principles.
- [ ] Platform and workload responsibilities are separated.
- [ ] Connectivity and DNS are validated.
- [ ] Logging and security monitoring are operational.
- [ ] Terraform plan has been reviewed and approved.
- [ ] No secrets or Terraform state files are committed to Git.

## 7. Operational Guidelines

- Use pull requests for Terraform changes.
- Separate development, test, and production configuration.
- Avoid manual configuration drift.
- Review policy compliance and privileged access regularly.
- Document exceptions and architecture changes.
- Test recovery procedures for Terraform state.
- Follow organizational change-management and approval processes.

## 8. Important Notes

This guide describes the intended implementation sequence. The exact Terraform commands, module inputs, Azure Policy definitions, networking configuration, and role assignments must match the actual repository implementation and available Azure permissions.

Do not apply production changes until the configuration, execution plan, access model, and rollback or recovery approach have been reviewed.

## Production deployment guardrails

The recommended production path is the separate GitHub Actions workflow
`.github/workflows/terraform-deploy.yml`. It is manually dispatched from `main`,
creates a saved Terraform plan, uploads that plan as an artifact, and requires
the `production` GitHub Environment before the apply job can run.

Before enabling it, configure:
- A GitHub Environment named `production` with required reviewers.
- Azure workload identity federation for GitHub OIDC. Configure federated
  credentials for both the `main` branch plan job and the `production`
  environment apply job, matching your repository and environment names.
- Repository or environment variables for `AZURE_CLIENT_ID`,
  `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`, `TF_STATE_RESOURCE_GROUP`,
  `TF_STATE_STORAGE_ACCOUNT`, and `TF_STATE_CONTAINER`.
- Any root-specific `TF_VAR_*` values needed by the selected Terraform root.
- Azure RBAC for the federated identity, limited to the scopes it needs.

The deployment workflow intentionally excludes the state-bootstrap root. Do not
treat a state-bootstrap root as an ordinary workload deployment: it creates the
backend on which other roots depend. Choose and document a separate initial-state
and migration procedure before changing its backend configuration.

The workflow is a deployment mechanism, not a guarantee that a plan is safe.
Review the plan and its artifact, confirm the selected subscription and state key,
and ensure the protected environment's reviewers are correctly configured.
Do not store state files, plan files, credentials, or real `.tfvars` files in Git.

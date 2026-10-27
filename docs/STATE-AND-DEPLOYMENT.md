# State and deployment model

## Required state separation

Use distinct backend keys/containers or state accounts with least-privilege access. Suggested logical keys (adapt to the existing backend convention):

- `vending/<customer-code>/<environment>.tfstate`
- `subscription-foundation/<customer-code>/<environment>.tfstate`
- existing `management-groups`, `governance`, `identity`, `platform`, `networking`, `corp`, `online` keys remain independently owned.

Do not configure a new backend by copying a sample storage account name. Reuse the organization's approved backend only after verifying the storage account, container, private network path, identity permissions, locking and recovery requirements. Do not migrate or rename existing state without a reviewed state-migration plan.

## CI/CD

- PR: `terraform fmt -check`, `init -backend=false`, `validate`, TFLint, Checkov, CIDR/IPAM validation and diff review.
- Apply: protected environment, OIDC/federated identity, plan artifact, human approval, exact plan apply, audit evidence.
- GitHub-hosted runners cannot reach a private-only backend unless a supported private connectivity design exists. Use an appropriately networked self-hosted runner or a carefully controlled backend access design.
- Keep billing-scope vending permissions separate from subscription resource deployment permissions where feasible.

## Safe adoption of existing Azure resources

Before adding any existing resource to a Terraform root, verify its resource ID, current configuration, ownership, existing state owner and blast radius. Import it into exactly one state or leave it data-source-managed. Never create a duplicate resource group, workspace, VNet, state account or Management Group just because a module expects one.

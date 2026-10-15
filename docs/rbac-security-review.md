# Azure RBAC Security Review

- Review date: 2026-10-15
- Subscription: Azure subscription 1
- Review type: Read-only RBAC inspection
- Status: Initial review completed; follow-up checks pending

## 1. Resource Group Assignments

| Resource Group | Principal | Role | Review |
|---|---|---|---|
| rg-railconnect-compute-prod-ci | grp-rc-app-devs | Contributor | Validate least privilege |
| rg-railconnect-data-prod-ci | grp-rc-dba | SQL DB Contributor | Verify database data-plane access separately |
| rg-railconnect-security-prod-ci | grp-rc-secops | Key Vault Administrator | Review privileged vault access |

The three assignments were observed at their expected resource-group scopes
and matched the current Terraform configuration.

## 2. Privileged Management Scopes

Direct Owner assignments were observed for the administrative account at:

- Subscription scope
- mg-railconnect
- mg-prod
- mg-landing-zones

These are high-privilege assignments. Their business justification and
ongoing necessity must be confirmed before any change is considered.

No permissions were changed during this review.

## 3. Other Observed Assignments

At mg-railconnect, the following assignments were observed:

- grp-rc-readers: Reader
- grp-rc-secops: Security Reader

## 4. Findings and Follow-up Actions

1. Confirm whether the Owner assignments are intentional and required.
2. Review inherited and effective access for relevant users and groups.
3. Assess whether app developers require Contributor at the full compute RG scope.
4. Verify SQL database authentication and data-plane permissions separately.
5. Review Key Vault RBAC mode, access requirements, and privileged-role membership.
6. Review Privileged Identity Management (PIM), where available.
7. Re-run the review after approved permission changes.

## 5. Limitations

This is an initial RBAC review based on Azure CLI role-assignment listings.
It is not a complete effective-access assessment. It does not independently
verify PIM activation history, all group memberships, Key Vault data access,
or database permissions.

## 6. Change Control

Do not remove or downgrade roles solely on the basis of this document.
Confirm the business requirement, assess impact, obtain approval, and prepare
a rollback plan before making access changes.

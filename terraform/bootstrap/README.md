# Terraform Bootstrap

## Purpose

Manage the dedicated Azure resources used to store Terraform remote state. Bootstrap is a separate Terraform root so that backend infrastructure can be managed independently from the platform and governance environments.

## Managed Resources

The bootstrap configuration defines:

- A dedicated resource group for Terraform state.
- An Azure Storage Account with HTTPS-only access, TLS 1.2 minimum, blob versioning, and deletion retention.
- A private blob container for Terraform state.
- Storage network rules with a deny-by-default policy and approved client IP rules.
- Resource lifecycle protections using `prevent_destroy`.

## Authentication and Network Security

- Prefer Microsoft Entra ID authentication for Terraform backend access.
- Backend configurations use `use_azuread_auth = true`.
- Shared Key authorization remains enabled in the current Storage Account configuration; do not disable it until the Entra ID/RBAC access path has been verified and the change has been reviewed.
- Public network access is currently enabled, while the Storage Account firewall defaults to deny and allows explicitly configured client IP rules.
- Private Endpoint, private DNS, diagnostic logging, replication strategy, and customer-managed encryption keys require separate design and validation before adoption.

## State Management

Bootstrap state is maintained separately from the platform and governance state files. Keep backend configuration files, local variable files, state files, and saved plan files out of version control.

Use the remote-state backend runbook for initialization, state verification, plan review, recovery, and any controlled state migration.

## Operational Safeguards

- Review Terraform plans before any apply.
- Keep state access restricted to authorized operators and automation.
- Use protected CI/CD environments and approved workload identity or non-interactive authentication.
- Document security exceptions with justification, owner, and review date.
- Never commit credentials, secrets, state files, or saved plan files.

## Implementation Status

Terraform bootstrap resources are defined in `state-backend/main.tf`. The configuration has previously been initialized against the remote backend and its plan reviewed. This repository documentation does not imply that every recommended production hardening control has already been implemented.

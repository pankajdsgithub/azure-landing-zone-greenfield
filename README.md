# Azure Landing Zone — Greenfield Enterprise Platform

[![Repository Checks](https://github.com/pankajdsgithub/azure-landing-zone-greenfield/actions/workflows/repository-checks.yml/badge.svg)](https://github.com/pankajdsgithub/azure-landing-zone-greenfield/actions/workflows/repository-checks.yml)

A Terraform-based blueprint for building a secure, governed and scalable
Azure enterprise platform using Azure Landing Zone principles.

> **Project status:** Terraform configurations and reusable modules cover
> management groups, RBAC and Azure Policy governance. Hub-Spoke networking
> remains a planned extension. This repository update does not deploy Azure
> resources.

## Objectives

- Organize platform and landing-zone management groups.
- Separate governance, platform configuration and bootstrap responsibilities.
- Reuse Terraform modules for management groups and Azure Policy.
- Apply RBAC using configurable assignments.
- Run automated formatting, validation and security checks.
- Document architecture, state management and implementation decisions.

## Target Architecture

```text
Microsoft Entra ID Tenant
└── Tenant Root Management Group
    ├── Platform
    │   ├── Identity
    │   ├── Connectivity
    │   └── Management
    └── Landing Zones
        ├── Corp
        ├── Online
        └── Sandbox (optional)
```

This is the target design, not a claim that every component is implemented.
Final hierarchy and subscription placement must be confirmed for each tenant.

## Repository Structure

```text
.
├── .github/workflows/
│   └── repository-checks.yml
├── architecture/
│   └── landing-zone-flow.mmd
├── docs/
│   ├── architecture.md
│   ├── design-decisions.md
│   ├── deployment-guide.md
│   ├── governance/
│   │   └── tag-audit.md
│   ├── rbac-security-review.md
│   └── terraform-remote-state-backend.md
├── examples/
│   └── README.md
├── policies/
│   └── README.md
└── terraform/
    ├── bootstrap/
    │   └── state-backend/
    ├── environments/
    │   ├── governance/
    │   └── platform/
    └── modules/
        ├── management-groups/
        ├── policy-assignment/
        ├── policy-initiative/
        └── policy-tag-audit/
```

## Architecture and Documentation

| Document | Purpose |
|---|---|
| [Architecture](docs/architecture.md) | Target hierarchy and platform boundaries |
| [Design Decisions](docs/design-decisions.md) | Design principles and trade-offs |
| [Deployment Guide](docs/deployment-guide.md) | Implementation sequence and precautions |
| [Architecture Diagram](architecture/landing-zone-flow.mmd) | Mermaid diagram source |
| [Terraform Bootstrap](terraform/bootstrap/README.md) | State-backend bootstrap guidance |
| [Environments](terraform/environments/README.md) | Environment configuration layout |
| [Management Groups Module](terraform/modules/management-groups/README.md) | Reusable management-group module |
| [Policy Framework](policies/README.md) | Governance documentation |
| [Tag Audit](docs/governance/tag-audit.md) | Environment-tag audit policy |
| [RBAC Security Review](docs/rbac-security-review.md) | Role assignment review |
| [Remote State](docs/terraform-remote-state-backend.md) | State-backend design |
| [Examples](examples/README.md) | Example usage guidance |

## Validation and CI

The repository workflow is designed to check:

- Terraform formatting.
- Terraform initialization and validation.
- TFLint static analysis.
- Checkov security and configuration checks.
- Required documentation and accidental Terraform state tracking.

Passing static checks does not guarantee that a configuration is correct
for every Azure tenant. Review provider versions, permissions, policy scopes
and the proposed Terraform plan before any approved deployment.

## Planned Implementation Phases

1. Review management-group hierarchy and governance requirements.
2. Verify bootstrap prerequisites and remote-state configuration.
3. Review management-group and subscription configuration.
4. Improve reusable identity, connectivity and management foundations.
5. Review policy definitions, initiatives, assignments and RBAC.
6. Validate code through local checks and GitHub Actions.
7. Document review findings and deployment prerequisites.

## Engineering Principles

- Least privilege and separation of duties.
- Reusable Infrastructure as Code.
- Explicit environment-specific configuration.
- Secure handling of state, credentials and configuration.
- Reviewed changes and traceable validation.
- No Azure deployment without explicit approval.

## Scope and Limitations

**Implemented in the repository:** management-group, policy-definition,
policy-initiative, policy-assignment and RBAC Terraform configurations.

**Future enhancement:** Hub-Spoke networking and additional platform services.

Actual resource availability, permissions, policy effects and state alignment
must be verified in the target environment. Do not commit state files, plan
files, credentials, real environment-specific `.tfvars` or backend settings.

## License

See [LICENSE](LICENSE).

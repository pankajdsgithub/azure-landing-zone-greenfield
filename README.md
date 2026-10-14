# Azure Landing Zone — Greenfield Enterprise Platform

[![Repository Checks](https://github.com/pankajdsgithub/azure-landing-zone-greenfield/actions/workflows/repository-checks.yml/badge.svg)](https://github.com/pankajdsgithub/azure-landing-zone-greenfield/actions/workflows/repository-checks.yml)

A documentation-first blueprint for designing a secure, governed, scalable
Azure enterprise platform using Azure Landing Zone principles and Terraform.

> **Current status:** Repository foundation and architecture documentation.
> Azure resources have not been deployed by this project setup.

## Objectives

- Establish a clear management-group and subscription hierarchy.
- Separate platform services from application landing zones.
- Standardize identity, connectivity, management and governance.
- Prepare a modular Terraform structure for future implementation.
- Introduce repeatable repository checks before infrastructure deployment.

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

The exact hierarchy, subscription placement and policy assignments will be
validated against organizational requirements before implementation.

## Repository Structure

```text
.
├── README.md
├── LICENSE
├── .gitignore
├── .github/
│   └── workflows/
│       └── repository-checks.yml
├── architecture/
│   └── landing-zone-flow.mmd
├── docs/
│   ├── architecture.md
│   ├── design-decisions.md
│   └── deployment-guide.md
├── examples/
│   └── README.md
├── policies/
│   └── README.md
└── terraform/
    ├── bootstrap/
    │   └── README.md
    ├── environments/
    │   └── README.md
    └── modules/
        └── management-groups/
            └── README.md
```

## Architecture and Design

| Document | Purpose |
|---|---|
| [Architecture](docs/architecture.md) | Target hierarchy and platform boundaries |
| [Design Decisions](docs/design-decisions.md) | Design principles and trade-offs |
| [Deployment Guide](docs/deployment-guide.md) | Planned implementation sequence |
| [Architecture Diagram](architecture/landing-zone-flow.mmd) | Diagram source in Mermaid format |
| [Terraform Bootstrap](terraform/bootstrap/README.md) | State and bootstrap design |
| [Management Groups Module](terraform/modules/management-groups/README.md) | Planned module responsibilities |
| [Environments](terraform/environments/README.md) | Future environment layout |
| [Policy Framework](policies/README.md) | Governance design |
| [Examples](examples/README.md) | Future examples and usage guidance |

## Planned Implementation Phases

1. Confirm tenant hierarchy, naming standards and governance requirements.
2. Review Terraform state, identity and bootstrap prerequisites.
3. Design management-group and subscription provisioning.
4. Define platform foundations for identity, connectivity and management.
5. Introduce policy assignments, RBAC and security guardrails.
6. Add environment-specific infrastructure and CI/CD workflows.
7. Validate, review and document changes before any deployment.

## Engineering Principles

- Least privilege and separation of duties.
- Infrastructure as Code and reusable modules.
- Explicit environment configuration.
- Secure state management and secret handling.
- Change review, validation and traceability.
- No deployment without an approved plan and appropriate permissions.

## Current Scope

This repository is being prepared in documentation-first mode. The folder
structure and design documents do not imply that Terraform modules are
implemented or that Azure resources exist.

## Contributions

Changes should be reviewed for security, naming consistency, documentation
quality and Terraform validation requirements before implementation.

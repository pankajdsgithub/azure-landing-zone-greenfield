# Management Groups Module

## Purpose

Document the planned Terraform module for the Azure management-group hierarchy.
No Azure management groups are created by this document.

## Target Hierarchy

```text
Tenant Root Management Group
├── Platform
│   ├── Identity
│   ├── Connectivity
│   └── Management
└── Landing Zones
    ├── Corp
    ├── Online
    └── Sandbox (optional)
```

## Planned Module Responsibilities

- Accept explicit parent and child management-group configuration.
- Use stable, predictable identifiers.
- Avoid hard-coded tenant-specific IDs.
- Keep management-group creation separate from policy assignments where practical.
- Document inputs, outputs, permissions and dependencies.
- Validate configuration before any deployment.

## Future Validation

- Review the hierarchy against organizational requirements.
- Validate Terraform configuration and provider compatibility.
- Review access permissions and policy inheritance.
- Inspect the Terraform plan before approval.

## Status

Documentation scaffold only. Terraform resources and tests will be added in
a later implementation phase.

# Terraform Environments

This directory will hold environment-specific root configurations when
implementation begins.

## Planned Layout

```text
terraform/environments/
├── platform/
├── corp/
├── online/
└── sandbox/   # Optional
```

The final layout will depend on subscription boundaries, deployment ownership
and state isolation requirements.

## Standards

- Keep environment configuration separate from reusable modules.
- Do not commit secrets or Terraform state.
- Pin provider and module versions appropriately.
- Require review and plan validation before deployment.
- Document dependencies and required permissions.

No environment is deployed by this scaffold.

# Azure Landing Zone — Architecture Design Decisions

## 1. Purpose

This document records the key architecture and implementation decisions for the Enterprise Azure Landing Zone.

The objective is to establish a secure, scalable, governed, and reusable Azure platform using Terraform Infrastructure as Code (IaC).

These decisions provide a consistent foundation for platform engineering, workload onboarding, security, and operational governance.

## 2. Management Group Hierarchy

### Decision

Use the Tenant Root Management Group as the parent scope for the enterprise Management Group hierarchy.

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

### Rationale

- Establish a clear separation between shared platform services and application workloads.
- Apply governance consistently through Management Group scopes.
- Organize subscriptions according to workload requirements.
- Support future growth without redesigning the entire hierarchy.

### Implementation Considerations

- Use the existing Tenant Root Management Group rather than creating a duplicate root.
- Create child Management Groups through reusable Terraform configuration.
- Create Sandbox only when required by organizational policy.
- Apply policies and role assignments at the appropriate scope.

## 3. Platform and Landing Zones Separation

### Decision

Maintain separate `Platform` and `Landing Zones` Management Groups.

### Rationale

The Platform Management Group contains subscriptions responsible for shared enterprise capabilities, while Landing Zones contains subscriptions hosting business applications.

**Platform responsibilities:**

- Identity and access services.
- Shared networking and connectivity.
- Centralized monitoring and management.

**Landing Zones responsibilities:**

- Business application subscriptions.
- Workload-specific infrastructure.
- Application environments and workload governance.

This separation improves operational ownership, access control, and governance.

## 4. Corp and Online Workload Separation

### Decision

Create separate `Corp` and `Online` Management Groups under Landing Zones.

### Rationale

- Corp supports internal or enterprise-connected workloads.
- Online supports internet-facing workloads requiring appropriate perimeter security.
- Different workload types may require different network controls and policy assignments.

### Implementation Considerations

The separation does not automatically provide network isolation. Effective isolation must be implemented through networking, identity, Azure Policy, and access controls.

## 5. Azure Policy and Governance

### Decision

Use Azure Policy assignments at suitable Management Group and subscription scopes.

### Rationale

- Enforce organizational standards consistently.
- Improve compliance visibility.
- Reduce configuration drift.
- Apply common controls without duplicating every assignment across subscriptions.

### Governance Principles

- Begin with audit policies where assessment is required.
- Introduce deny or deploy-effect policies after validating their impact.
- Use exemptions only through an approved and documented process.
- Review inherited assignments and conflicts before deployment.

## 6. Identity and Azure RBAC

### Decision

Use Microsoft Entra ID and Azure RBAC to manage access through least-privilege principles.

### Rationale

- Separate platform administration from workload administration.
- Reduce unnecessary privileged access.
- Assign roles at the narrowest practical scope.
- Use approved workload identities for automation where supported.

### Implementation Considerations

- Prefer Microsoft Entra ID-based authentication over long-lived credentials.
- Avoid hardcoded secrets in Terraform files and pipeline variables.
- Use privileged roles only when required and authorized.
- Review role assignments periodically.

## 7. Terraform Infrastructure as Code

### Decision

Use Terraform to provision and manage Management Groups and associated Azure platform configuration.

### Rationale

- Provide repeatable and reviewable deployments.
- Standardize naming, inputs, and resource configuration.
- Support version control and pull-request reviews.
- Reduce manual configuration and configuration drift.

### Implementation Principles

- Keep reusable resources in dedicated Terraform modules.
- Separate root configurations from reusable modules.
- Use input variables for environment-specific values.
- Use `for_each` where resources are driven by stable maps or sets.
- Define and validate required variables.
- Pin provider versions and commit the dependency lock file.
- Review execution plans before applying changes.

## 8. Terraform Remote State

### Decision

Store Terraform state in a dedicated Azure Storage Account using the AzureRM backend.

### Rationale

- Support team collaboration.
- Enable controlled state access.
- Support backend state locking.
- Reduce the risk of concurrent state modifications.

### Security Considerations

- Restrict access using Microsoft Entra ID and appropriate data-plane RBAC.
- Enable HTTPS and secure storage configuration.
- Restrict network access according to organizational requirements.
- Configure recovery protections such as blob versioning and soft delete where appropriate.
- Never commit state files, credentials, or sensitive plan files to Git.

### Bootstrap Dependency

Create the backend resources before initializing the main Terraform configuration that uses them. Keep bootstrap state separate or migrate state through a controlled procedure.

## 9. Naming and Tagging Standards

### Decision

Adopt documented naming and tagging conventions for resources, subscriptions, and platform components.

### Rationale

- Improve resource identification and ownership.
- Support cost allocation and operational reporting.
- Simplify automation and inventory management.

### Suggested Common Tags

- `Environment`
- `Owner`
- `CostCenter`
- `Application`
- `ManagedBy`

Actual tag requirements and resource naming rules must follow organizational standards and Azure service-specific naming constraints.

## 10. Security and Network Connectivity

### Decision

Design connectivity and security controls according to workload classification and enterprise requirements.

### Rationale

- Reduce unnecessary public exposure.
- Provide controlled communication between workloads and shared services.
- Support centralized DNS, inspection, and monitoring where required.

### Implementation Considerations

- Use private endpoints for supported services where required.
- Configure Private DNS and validate name resolution.
- Use approved hub-and-spoke or other enterprise network patterns.
- Restrict inbound administrative access.
- Apply Network Security Groups and other relevant controls.
- Validate routing, firewall requirements, and connectivity before workload onboarding.

The Management Group hierarchy alone does not create network connectivity or isolation.

## 11. Environment Separation

### Decision

Separate development, test, and production environments according to security, operational, and compliance requirements.

### Rationale

- Reduce the risk of unintended production changes.
- Support independent release and approval processes.
- Apply appropriate availability and security controls.

The implementation may use separate subscriptions, distinct Terraform root configurations, or approved combinations based on organizational requirements.

## 12. CI/CD and Change Management

### Decision

Manage Terraform changes through a controlled CI/CD workflow.

### Rationale

- Ensure consistent validation and execution.
- Provide traceability and approval history.
- Reduce unreviewed infrastructure changes.

### Proposed Workflow

1. Create a feature branch.
2. Run formatting and validation checks.
3. Execute security and policy checks.
4. Generate a Terraform plan.
5. Review the plan through a pull request.
6. Obtain required approvals.
7. Apply the approved configuration through the authorized pipeline.
8. Verify deployment and record any exceptions.

Production approval requirements must follow organizational change-management policies.

## 13. Architectural Assumptions and Constraints

- An existing Azure tenant is available.
- Required permissions will be approved before deployment.
- Management Group creation and policy assignments may require elevated permissions.
- The Terraform execution identity will receive only the permissions required for its responsibilities.
- Azure Policy definitions and assignments will be validated against actual workloads.
- Connectivity, regional availability, quotas, and compliance requirements will be confirmed during implementation.

## 14. Review and Evolution

This document represents the initial design baseline for the Enterprise Azure Landing Zone.

Architecture decisions may be updated when implementation findings, security requirements, operational needs, or organizational standards change.

All significant changes should be documented and reviewed through version control.


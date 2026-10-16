# Terraform Environment Roots

This directory contains Terraform root configurations. A root is an independently
planned state boundary; it is not automatically the same thing as a management group.

## Current roots

| Root | Purpose | Current scope |
|---|---|---|
| `management-groups` | Creates the Platform and Landing Zones hierarchy and child management groups | Management groups |
| `platform` | Platform-scoped RBAC assignments | Resource-group scopes |
| `identity` | Explicit, input-driven Azure role assignments | Supplied scopes |
| `governance` | Custom Environment-tag audit policy, initiative, and assignment | Management groups |
| `networking` | Basic hub/spoke virtual networks, subnets, NSGs, and VNet peering | One subscription |
| `corp` | Initial Corp workload network baseline | One existing workload subscription |
| `online` | Initial Online workload network baseline | One existing workload subscription |

## Target management-group hierarchy

- Tenant Root
  - Platform
    - Management
    - Identity & Access
    - Connectivity
    - Security
  - Landing Zones
    - Corp
    - Online
    - Sandbox (optional)

`Corp` and `Online` are represented by separate Terraform roots for initial
workload network baselines. Creating these roots does not create subscriptions
or automatically place subscriptions into their management groups. `Sandbox`
remains an optional management group.

## Important implementation limits

The networking root currently provides basic hub/spoke VNet peering. It does not
by itself implement Azure Firewall, VPN Gateway, ExpressRoute, Bastion, UDRs,
Private DNS, or Private Endpoints.

The repository does not yet provide a complete dedicated Security root,
centralized Log Analytics/diagnostic-settings deployment, subscription vending,
or a complete enterprise policy catalogue. Treat these as planned work until
their Terraform resources and validation are present.

Review each root's README, variables, and example configuration before planning.
Do not apply example placeholder IDs or sample RBAC assignments to a real tenant.

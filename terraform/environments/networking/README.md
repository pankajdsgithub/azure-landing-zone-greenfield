# Phase 2 - Hub-Spoke Networking

This root defines a basic hub-spoke network foundation:
- Dedicated networking resource group
- Hub and spoke virtual networks
- One subnet and NSG per VNet
- Bidirectional VNet peering

## Before deployment
1. Verify address spaces do not overlap with existing VNets or on-premises routes.
2. Confirm subscription and resource-group permissions.
3. Review NSG, routing, DNS, and egress requirements.
4. Run `terraform plan` and obtain approval before any apply.

This baseline does not deploy Azure Firewall, Bastion, VPN/ExpressRoute,
private endpoints, private DNS zones, route tables, or a centralized egress path.
Default NSG rules are not a complete production security policy.

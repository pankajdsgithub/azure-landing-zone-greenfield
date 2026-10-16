# Corp Workload Environment

Purpose: Internal enterprise workloads.

## Resources in this initial baseline

- Dedicated resource group
- Dedicated virtual network and workload subnet
- Network security group with an explicit inbound Internet deny rule
- Terraform-managed subnet/NSG association

## Before deployment

1. Use the intended existing subscription ID.
2. Verify the CIDR ranges against all Azure VNets, peered networks, VPN/ExpressRoute ranges, and on-premises networks.
3. Configure the remote Azure Storage backend and a unique state key for this root.
4. Verify identity permissions and the GitHub Actions environment protection rules.
5. Review the Terraform plan before any apply.

The example subscription ID is a placeholder and must not be used for deployment.

## Scope limitations

This is an initial workload network baseline, not a complete enterprise landing zone.
It does not create management-group placement, subscriptions, Azure Firewall,
route tables/UDRs, private endpoints, Private DNS, Bastion, DDoS protection,
central diagnostics, or application resources. The NSG rule does not provide
centralized egress control; Azure NSGs retain their default outbound rules.

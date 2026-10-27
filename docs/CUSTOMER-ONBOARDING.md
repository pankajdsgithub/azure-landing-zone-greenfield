# New customer launch runbook

This is the standard launch path for a new customer/project. It is deliberately split into two Terraform roots so subscription creation and resources inside that subscription have independent state and approvals.

## Intake checklist

- [ ] Obtain approved customer/project code, legal/customer display name, owner, cost centre, data classification, environment and target region.
- [ ] Decide destination MG: existing Corp/Online/Nonprod/Sandbox MG based on workload classification and connectivity/security needs. Do not create a new MG for every customer unless governance design requires it.
- [ ] Confirm billing scope and billing-role authorization for subscription creation.
- [ ] Confirm subscription quota, allowed regions, service quotas, policy requirements and naming availability.
- [ ] Select CIDR from the central IPAM plan; never guess or reuse a VNet range. Record hub/spoke peering and DNS requirements.
- [ ] Confirm budget amount, notification recipients, retention, RTO/RPO, connectivity and workload pattern.

## Step 1 — Vending

```bash
cd terraform/vending
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with the approved billing scope, existing MG ID, tags and subscription name.
terraform init
terraform fmt -check
terraform validate
terraform plan -out=vending.tfplan
terraform show vending.tfplan
```

Review the plan with the billing/platform owner. Only after explicit approval:

```bash
terraform apply vending.tfplan
terraform output -raw subscription_id
```

Save the output securely in the change record. Do not put populated tfvars or plan files in Git.

## Step 2 — Foundation inside the new subscription

Use the subscription ID output from Step 1. Configure the root's remote backend to a **different state key** from vending and from every other root. Authenticate to Azure and ensure the operator/service principal has appropriate rights in the new subscription.

```bash
cd ../subscription-foundation
cp terraform.tfvars.example terraform.tfvars
# Set subscription_id, names, budget, contact list and tags.
terraform init
terraform fmt -check
terraform validate
terraform plan -out=foundation.tfplan
terraform show foundation.tfplan
```

Review and approve the plan before running `terraform apply foundation.tfplan`.

## Step 3 — Connect to shared platform

- Register/validate required resource providers and apply baseline policies/RBAC through the existing governance root.
- Allocate a non-overlapping CIDR from IPAM and configure spoke VNet, subnet, NSGs/ASGs, UDRs and peering using the existing networking root/modules.
- Confirm hub firewall/egress, Private DNS links, private endpoint resolution, routing and on-premises connectivity where required.
- Deploy workload resources via existing Corp/Online roots; don't recreate shared hub, identity, or management services in every customer subscription.
- Configure diagnostic settings for each supported resource type to the approved central/local workspace and storage/SIEM destinations.
- Add ACR/AKS, Key Vault, storage, databases and app resources only when the approved customer pattern requires them.

## Step 4 — Go-live evidence

- [ ] Subscription is under the correct MG and inherited policies are compliant.
- [ ] Budget notifications and activity/resource diagnostic settings are configured and tested.
- [ ] RBAC is least privilege; no broad permanent Owner grants for delivery identities.
- [ ] Network tests prove expected private DNS, routes, egress and ingress.
- [ ] Security scan, Terraform plan, approvals, deployment IDs and ownership are attached to the change record.
- [ ] Customer-specific state key, repository/environment, tags, cost centre, runbooks and support ownership are recorded.

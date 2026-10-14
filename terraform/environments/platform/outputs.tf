output "management_group_ids" {
  description = "Resource IDs of the platform child Management Groups."

  value = {
    identity     = module.identity.id
    connectivity = module.connectivity.id
    management   = module.management.id
  }
}

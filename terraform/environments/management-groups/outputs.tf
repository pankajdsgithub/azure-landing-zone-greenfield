output "management_group_ids" {
  description = "Resource IDs of the configured Management Groups."

  value = {
    platform      = module.platform.id
    landing_zones = module.landing_zones.id
    identity      = module.identity.id
    connectivity  = module.connectivity.id
    management    = module.management.id
    security      = module.security.id
    corp          = module.corp.id
    online        = module.online.id
    sandbox       = try(module.sandbox[0].id, null)
  }
}

output "management_group_names" {
  description = "Names of the configured Management Groups."

  value = {
    platform      = module.platform.name
    landing_zones = module.landing_zones.name
    identity      = module.identity.name
    connectivity  = module.connectivity.name
    management    = module.management.name
    security      = module.security.name
    corp          = module.corp.name
    online        = module.online.name
    sandbox       = try(module.sandbox[0].name, null)
  }
}

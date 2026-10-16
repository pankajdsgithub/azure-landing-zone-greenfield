module "platform" {
  source = "../../modules/management-groups"

  name                       = "mg-platform"
  display_name               = "Platform"
  parent_management_group_id = var.tenant_root_management_group_id
}

module "landing_zones" {
  source = "../../modules/management-groups"

  name                       = "mg-landing-zones"
  display_name               = "Landing Zones"
  parent_management_group_id = var.tenant_root_management_group_id
}

module "sandbox" {
  count  = var.create_sandbox ? 1 : 0
  source = "../../modules/management-groups"

  name                       = "mg-sandbox"
  display_name               = "Sandbox"
  parent_management_group_id = module.landing_zones.id
}

module "identity" {
  source = "../../modules/management-groups"

  name                       = "mg-identity"
  display_name               = "Identity & Access"
  parent_management_group_id = module.platform.id
}

module "connectivity" {
  source = "../../modules/management-groups"

  name                       = "mg-connectivity"
  display_name               = "Connectivity"
  parent_management_group_id = module.platform.id
}

module "management" {
  source = "../../modules/management-groups"

  name                       = "mg-management"
  display_name               = "Management"
  parent_management_group_id = module.platform.id
}

module "security" {
  source = "../../modules/management-groups"

  name                       = "mg-security"
  display_name               = "Security"
  parent_management_group_id = module.platform.id
}

module "corp" {
  source = "../../modules/management-groups"

  name                       = "mg-corp"
  display_name               = "Corp"
  parent_management_group_id = module.landing_zones.id
}

module "online" {
  source = "../../modules/management-groups"

  name                       = "mg-online"
  display_name               = "Online"
  parent_management_group_id = module.landing_zones.id
}

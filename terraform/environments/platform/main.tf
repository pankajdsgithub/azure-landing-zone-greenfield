module "identity" {
  source = "../../modules/management-groups"

  name                       = "identity"
  display_name               = "Identity"
  parent_management_group_id = "/providers/Microsoft.Management/managementGroups/mg-platform"
}

module "connectivity" {
  source = "../../modules/management-groups"

  name                       = "connectivity"
  display_name               = "Connectivity"
  parent_management_group_id = "/providers/Microsoft.Management/managementGroups/mg-platform"
}

module "management" {
  source = "../../modules/management-groups"

  name                       = "management"
  display_name               = "Management"
  parent_management_group_id = "/providers/Microsoft.Management/managementGroups/mg-platform"
}

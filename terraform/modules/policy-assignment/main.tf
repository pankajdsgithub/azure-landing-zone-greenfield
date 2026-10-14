resource "azurerm_management_group_policy_assignment" "this" {
  name                 = var.assignment_name
  display_name         = var.display_name
  management_group_id  = var.management_group_id
  policy_definition_id = var.policy_definition_id
  description          = var.description
}

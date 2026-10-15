resource "azurerm_management_group_policy_set_definition" "policy_initiative" {
  name                = var.initiative_name
  policy_type         = "Custom"
  display_name        = var.display_name
  management_group_id = var.management_group_id
  description         = var.description

  metadata = jsonencode({
    category = "Governance"
  })

  policy_definition_reference {
    policy_definition_id = var.policy_definition_id
    reference_id         = "environment-tag-audit"
  }
}

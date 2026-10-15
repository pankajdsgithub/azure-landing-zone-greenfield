
resource "azurerm_policy_definition" "require_environment_tag" {
  name                = var.policy_name
  policy_type         = "Custom"
  mode                = "Indexed"
  management_group_id = var.management_group_id
  display_name        = var.display_name

  description = "Audits Azure resources that do not have the required ${var.tag_name} tag."

  metadata = jsonencode({
    category = "Tags"
  })

  policy_rule = jsonencode({
    "if" = {
      field  = "tags['${var.tag_name}']"
      exists = "false"
    }

    "then" = {
      effect = "Audit"
    }
  })
}

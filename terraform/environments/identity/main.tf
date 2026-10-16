# Intentionally creates no role assignments until the caller supplies
# reviewed entries in a local terraform.tfvars file.
resource "azurerm_role_assignment" "approved" {
  for_each = var.role_assignments

  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}

moved {
  from = azurerm_role_assignment.app_devs_compute_contributor
  to   = azurerm_role_assignment.rbac["app_devs_compute_contributor"]
}

moved {
  from = azurerm_role_assignment.dba_sql_db_contributor
  to   = azurerm_role_assignment.rbac["dba_sql_db_contributor"]
}

moved {
  from = azurerm_role_assignment.secops_key_vault_admin
  to   = azurerm_role_assignment.rbac["secops_key_vault_admin"]
}

resource "azurerm_role_assignment" "rbac" {
  for_each = var.rbac_assignments

  scope = "/subscriptions/${var.subscription_id}/resourceGroups/${each.value.resource_group_name}"

  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
  principal_type       = each.value.principal_type
}

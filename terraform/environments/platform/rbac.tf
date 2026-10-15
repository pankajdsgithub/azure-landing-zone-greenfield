resource "azurerm_role_assignment" "app_devs_compute_contributor" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/rg-railconnect-compute-prod-ci"
  role_definition_name = "Contributor"
  principal_id         = "1776d1b5-daae-40de-b64e-2f1bcd4a5e6a"
  principal_type       = "Group"
}

resource "azurerm_role_assignment" "dba_sql_db_contributor" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/rg-railconnect-data-prod-ci"
  role_definition_name = "SQL DB Contributor"
  principal_id         = "3196eaeb-57b3-40dd-ac83-89246b35eede"
  principal_type       = "Group"
}

resource "azurerm_role_assignment" "secops_key_vault_admin" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/rg-railconnect-security-prod-ci"
  role_definition_name = "Key Vault Administrator"
  principal_id         = "cd27d0be-3749-441f-9305-3246ba2acfd5"
  principal_type       = "Group"
}

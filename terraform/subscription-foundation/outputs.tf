output "resource_group_ids" {
  description = "Resource group IDs keyed by logical purpose."
  value       = { for key, rg in module.resource_groups : key => rg.id }
}

output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.this.id
  description = "Workspace resource ID for downstream diagnostic settings."
}

output "log_analytics_customer_id" {
  value       = azurerm_log_analytics_workspace.this.workspace_id
  description = "Workspace ID used by compatible monitoring integrations."
}

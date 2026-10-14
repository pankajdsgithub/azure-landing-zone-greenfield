output "initiative_id" {
  description = "Resource ID of the Azure Policy initiative"
  value       = azurerm_management_group_policy_set_definition.this.id
}

output "initiative_name" {
  description = "Name of the Azure Policy initiative"
  value       = azurerm_management_group_policy_set_definition.this.name
}

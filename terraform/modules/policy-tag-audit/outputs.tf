output "policy_definition_id" {
  description = "Resource ID of the custom Azure Policy definition."
  value       = azurerm_policy_definition.require_environment_tag.id
}

output "policy_definition_name" {
  description = "Name of the custom Azure Policy definition."
  value       = azurerm_policy_definition.require_environment_tag.name
}

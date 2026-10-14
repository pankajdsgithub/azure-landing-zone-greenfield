output "policy_assignment_id" {
  description = "Resource ID of the policy assignment."
  value       = azurerm_management_group_policy_assignment.this.id
}

output "policy_assignment_name" {
  description = "Name of the policy assignment."
  value       = azurerm_management_group_policy_assignment.this.name
}

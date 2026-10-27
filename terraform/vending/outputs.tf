output "subscription_id" {
  description = "ID of the vended Azure subscription."
  value       = azurerm_subscription.customer.subscription_id
}

output "subscription_name" {
  description = "Display name of the vended subscription."
  value       = azurerm_subscription.customer.subscription_name
}

output "management_group_id" {
  description = "Management Group receiving the subscription."
  value       = azurerm_management_group_subscription_association.customer.management_group_id
}

output "id" {
  description = "Resource ID of the Management Group."
  value       = azurerm_management_group.m_group.id
}

output "name" {
  description = "Name of the Management Group."
  value       = azurerm_management_group.m_group.name
}

output "display_name" {
  description = "Display name of the Management Group."
  value       = azurerm_management_group.m_group.display_name
}

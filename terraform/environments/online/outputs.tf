output "resource_group_id" {
  description = "Workload resource group resource ID."
  value       = azurerm_resource_group.workload.id
}

output "vnet_id" {
  description = "Workload virtual network resource ID."
  value       = azurerm_virtual_network.workload.id
}

output "subnet_id" {
  description = "Workload subnet resource ID."
  value       = azurerm_subnet.workload.id
}

output "network_security_group_id" {
  description = "Workload NSG resource ID."
  value       = azurerm_network_security_group.workload.id
}

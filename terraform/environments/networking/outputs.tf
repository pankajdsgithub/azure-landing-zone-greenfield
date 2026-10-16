output "resource_group_id" {
  value = azurerm_resource_group.network.id
}

output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "hub_subnet_id" {
  value = azurerm_subnet.hub.id
}

output "spoke_vnet_id" {
  value = azurerm_virtual_network.spoke.id
}

output "spoke_subnet_id" {
  value = azurerm_subnet.spoke.id
}

output "hub_to_spoke_peering_state" {
  value = azurerm_virtual_network_peering.hub_to_spoke.id
}

output "spoke_to_hub_peering_state" {
  value = azurerm_virtual_network_peering.spoke_to_hub.id
}

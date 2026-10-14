resource "azurerm_management_group" "m_group" {
  name                       = var.name
  display_name               = var.display_name
  parent_management_group_id = var.parent_management_group_id
}

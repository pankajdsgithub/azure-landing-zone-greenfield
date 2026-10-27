resource "azurerm_subscription" "customer" {
  subscription_name = var.subscription_name
  billing_scope_id  = var.billing_scope_id
  workload          = var.workload
  tags              = var.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_management_group_subscription_association" "customer" {
  management_group_id = var.management_group_id
  subscription_id     = azurerm_subscription.customer.subscription_id
}

locals {
  common_tags = merge(var.tags, {
    customer    = var.customer_code
    environment = var.environment
    managed_by  = "terraform"
  })
}

module "resource_groups" {
  source   = "../modules/resource-group"
  for_each = var.resource_groups

  name     = each.value
  location = var.location
  tags     = merge(local.common_tags, { purpose = each.key })
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = module.resource_groups["management"].name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_analytics_retention_days
  tags                = merge(local.common_tags, { purpose = "central-monitoring" })

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_consumption_budget_subscription" "monthly" {
  name            = "budget-${var.customer_code}-${var.environment}"
  subscription_id = "/subscriptions/${var.subscription_id}"
  amount          = var.monthly_budget_amount
  time_grain      = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01'T'00:00:00'Z'", timestamp())
  }

  dynamic "notification" {
    for_each = length(var.budget_contact_emails) > 0 ? ["actual"] : []
    content {
      enabled        = true
      threshold      = 80
      operator       = "GreaterThan"
      threshold_type = "Actual"
      contact_emails = var.budget_contact_emails
    }
  }

  dynamic "notification" {
    for_each = length(var.budget_contact_emails) > 0 ? ["forecast"] : []
    content {
      enabled        = true
      threshold      = 100
      operator       = "GreaterThan"
      threshold_type = "Forecasted"
      contact_emails = var.budget_contact_emails
    }
  }
}

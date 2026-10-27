variable "subscription_id" {
  description = "Target subscription ID output by the vending root."
  type        = string
  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.subscription_id))
    error_message = "subscription_id must be a GUID."
  }
}

variable "location" {
  description = "Azure region for regional foundation resources."
  type        = string
  default     = "centralindia"
}

variable "customer_code" {
  description = "Short customer/project code used in names and tags."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]{2,12}$", var.customer_code))
    error_message = "customer_code must be 2-12 lowercase letters or digits."
  }
}

variable "environment" {
  type    = string
  default = "prod"
  validation {
    condition     = contains(["prod", "nonprod", "dev", "test", "sandbox"], var.environment)
    error_message = "environment must be prod, nonprod, dev, test or sandbox."
  }
}

variable "resource_groups" {
  description = "Map of logical resource group keys to names. Keep names unique in the subscription."
  type        = map(string)
  default = {
    management = "rg-customer-management"
    network    = "rg-customer-network"
    security   = "rg-customer-security"
    workload   = "rg-customer-workload"
  }
}

variable "log_analytics_workspace_name" {
  description = "Globally unique within the subscription/resource group."
  type        = string
}

variable "log_analytics_retention_days" {
  type    = number
  default = 90
  validation {
    condition     = var.log_analytics_retention_days >= 30 && var.log_analytics_retention_days <= 730
    error_message = "Retention must be between 30 and 730 days."
  }
}

variable "monthly_budget_amount" {
  description = "Monthly budget amount in the subscription billing currency. Set to a realistic positive value before apply."
  type        = number
  default     = 1000
  validation {
    condition     = var.monthly_budget_amount > 0
    error_message = "monthly_budget_amount must be greater than zero."
  }
}

variable "budget_contact_emails" {
  description = "Distribution list or responsible budget contacts."
  type        = list(string)
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

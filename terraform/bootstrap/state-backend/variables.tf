
variable "subscription_id" {
  description = "Subscription that will host Terraform remote state."
  type        = string
}

variable "location" {
  description = "Azure region for the backend resources."
  type        = string
  default     = "Central India"
}

variable "resource_group_name" {
  description = "Dedicated resource group for Terraform state."
  type        = string
  default     = "rg-tfstate-example-ci"
}

variable "storage_account_name" {
  description = "Globally unique lowercase Azure Storage Account name."
  type        = string

  validation {
    condition = (
      length(var.storage_account_name) >= 3 &&
      length(var.storage_account_name) <= 24 &&
      can(regex("^[a-z0-9]+$", var.storage_account_name))
    )
    error_message = "Storage Account name must be 3-24 lowercase letters or digits."
  }
}

variable "approved_client_ip_rules" {
  description = "Approved public IPv4 addresses or CIDRs allowed to access storage."
  type        = list(string)

  validation {
    condition     = length(var.approved_client_ip_rules) > 0
    error_message = "Provide at least one approved client IP rule to avoid an accidental open network policy."
  }
}

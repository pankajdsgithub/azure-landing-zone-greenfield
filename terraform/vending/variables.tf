variable "subscription_name" {
  description = "Globally meaningful subscription display name for the new customer/workload."
  type        = string
  validation {
    condition     = length(trimspace(var.subscription_name)) >= 3
    error_message = "subscription_name must contain at least 3 non-whitespace characters."
  }
}

variable "billing_scope_id" {
  description = "EA enrollment/billing account scope or MCA billing profile/invoice section scope accepted by azurerm_subscription."
  type        = string
  sensitive   = false
  validation {
    condition     = startswith(var.billing_scope_id, "/")
    error_message = "billing_scope_id must be a full Azure billing scope resource ID."
  }
}

variable "workload" {
  description = "Azure subscription workload classification."
  type        = string
  default     = "Production"
  validation {
    condition     = contains(["Production", "DevTest"], var.workload)
    error_message = "workload must be Production or DevTest."
  }
}

variable "management_group_id" {
  description = "Existing destination Management Group ID (not its display name)."
  type        = string
  validation {
    condition     = length(trimspace(var.management_group_id)) > 0
    error_message = "management_group_id must identify an existing Management Group."
  }
}

variable "tags" {
  description = "Required ownership and chargeback metadata for the subscription."
  type        = map(string)
  default     = {}
}

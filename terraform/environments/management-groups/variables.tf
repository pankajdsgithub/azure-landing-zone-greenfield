variable "subscription_id" {
  description = "Existing Azure subscription UUID used by the provider."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.subscription_id))
    error_message = "Provide a valid Azure subscription UUID."
  }
}

variable "tenant_root_management_group_id" {
  description = "Resource ID of the existing tenant root Management Group."
  type        = string

  validation {
    condition = can(regex(
      "^/providers/Microsoft.Management/managementGroups/[^/]+$",
      var.tenant_root_management_group_id
    ))
    error_message = "Provide a valid existing Management Group resource ID."
  }
}

variable "create_sandbox" {
  description = "Whether to create the optional Sandbox Management Group."
  type        = bool
  default     = false
}

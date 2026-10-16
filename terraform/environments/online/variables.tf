variable "subscription_id" {
  description = "Existing Azure subscription ID for this workload environment."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", trimspace(var.subscription_id)))
    error_message = "subscription_id must be a valid GUID."
  }
}

variable "location" {
  description = "Azure deployment region."
  type        = string
  default     = "centralindia"
}

variable "resource_group_name" {
  description = "Workload environment resource group name."
  type        = string
}

variable "vnet_name" {
  description = "Workload virtual network name."
  type        = string
}

variable "address_space" {
  description = "VNet CIDR ranges. Check for overlap with every connected network."
  type        = list(string)

  validation {
    condition     = length(var.address_space) > 0 && alltrue([for cidr in var.address_space : can(cidrhost(cidr, 0))])
    error_message = "address_space must contain valid CIDR prefixes."
  }
}

variable "subnet_prefixes" {
  description = "CIDR ranges for the workload subnet."
  type        = list(string)

  validation {
    condition     = length(var.subnet_prefixes) > 0 && alltrue([for cidr in var.subnet_prefixes : can(cidrhost(cidr, 0))])
    error_message = "subnet_prefixes must contain valid CIDR prefixes."
  }
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}

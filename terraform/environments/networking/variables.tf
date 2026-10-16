variable "subscription_id" {
  description = "Azure subscription ID for this networking environment."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", trimspace(var.subscription_id)))
    error_message = "subscription_id must be a valid GUID."
  }
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "centralindia"
}

variable "resource_group_name" {
  description = "Resource group for hub and spoke networks."
  type        = string
  default     = "rg-alz-networking"
}

variable "hub_vnet_name" {
  type    = string
  default = "vnet-alz-hub"
}

variable "hub_address_space" {
  description = "Hub CIDRs; check for overlap with every connected network."
  type        = list(string)
  default     = ["10.40.0.0/16"]

  validation {
    condition     = length(var.hub_address_space) > 0 && alltrue([for cidr in var.hub_address_space : can(cidrhost(cidr, 0))])
    error_message = "hub_address_space must contain valid CIDR prefixes."
  }
}

variable "hub_subnet_prefixes" {
  description = "CIDR prefixes for the shared hub subnet."
  type        = list(string)
  default     = ["10.40.1.0/24"]

  validation {
    condition     = length(var.hub_subnet_prefixes) > 0 && alltrue([for cidr in var.hub_subnet_prefixes : can(cidrhost(cidr, 0))])
    error_message = "hub_subnet_prefixes must contain valid CIDR prefixes."
  }
}

variable "spoke_vnet_name" {
  type    = string
  default = "vnet-alz-spoke-corp"
}

variable "spoke_address_space" {
  description = "Spoke CIDRs; must not overlap the hub or connected networks."
  type        = list(string)
  default     = ["10.41.0.0/16"]

  validation {
    condition     = length(var.spoke_address_space) > 0 && alltrue([for cidr in var.spoke_address_space : can(cidrhost(cidr, 0))])
    error_message = "spoke_address_space must contain valid CIDR prefixes."
  }
}

variable "spoke_subnet_prefixes" {
  description = "CIDR prefixes for the spoke workload subnet."
  type        = list(string)
  default     = ["10.41.1.0/24"]

  validation {
    condition     = length(var.spoke_subnet_prefixes) > 0 && alltrue([for cidr in var.spoke_subnet_prefixes : can(cidrhost(cidr, 0))])
    error_message = "spoke_subnet_prefixes must contain valid CIDR prefixes."
  }
}

variable "tags" {
  type = map(string)
  default = {
    managed_by  = "terraform"
    environment = "nonprod"
    project     = "enterprise-azure-landing-zone"
  }
}

variable "subscription_id" {
  description = "Azure subscription ID for this networking environment."
  type        = string
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
  description = "Must not overlap with existing networks."
  type        = list(string)
  default     = ["10.40.0.0/16"]
}

variable "hub_subnet_prefixes" {
  type    = list(string)
  default = ["10.40.1.0/24"]
}

variable "spoke_vnet_name" {
  type    = string
  default = "vnet-alz-spoke-corp"
}

variable "spoke_address_space" {
  description = "Must not overlap with existing networks."
  type        = list(string)
  default     = ["10.41.0.0/16"]
}

variable "spoke_subnet_prefixes" {
  type    = list(string)
  default = ["10.41.1.0/24"]
}

variable "tags" {
  type = map(string)
  default = {
    managed_by  = "terraform"
    environment = "nonprod"
    project     = "enterprise-azure-landing-zone"
  }
}

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
  description = "Hub CIDRs; must not overlap the spoke or connected networks."
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

variable "nsg_rules" {
  description = "Approved security rules applied to both hub and spoke NSGs."
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))

  # Custom rules only. The mandatory Internet inbound deny is defined in main.tf.
  default = []

  validation {
    condition = (
      length(distinct([for rule in var.nsg_rules : rule.name])) == length(var.nsg_rules) &&
      length(distinct([for rule in var.nsg_rules : rule.priority])) == length(var.nsg_rules) &&
      alltrue([
        for rule in var.nsg_rules :
        length(rule.name) > 0 &&
        rule.name != "Deny-Internet-Inbound" &&
        rule.priority >= 100 && rule.priority <= 4096 &&
        rule.priority != 4000 &&
        floor(rule.priority) == rule.priority &&
        contains(["Inbound", "Outbound"], rule.direction) &&
        contains(["Allow", "Deny"], rule.access) &&
        contains(["*", "Tcp", "Udp", "Icmp", "Esp", "Ah"], rule.protocol) &&
        length(rule.source_port_range) > 0 &&
        length(rule.destination_port_range) > 0 &&
        length(rule.source_address_prefix) > 0 &&
        length(rule.destination_address_prefix) > 0
      ])
    )
    error_message = "NSG rules must have unique names/priorities, priorities 100-4096, supported direction/access/protocol values, and non-empty port/address fields."
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

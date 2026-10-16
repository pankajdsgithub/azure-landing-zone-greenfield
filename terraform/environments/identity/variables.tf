variable "subscription_id" {
  description = "Subscription used by the AzureRM provider."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", trimspace(var.subscription_id)))
    error_message = "subscription_id must be a valid GUID."
  }
}

variable "role_assignments" {
  description = "Explicitly approved Azure RBAC assignments keyed by a unique name."
  type = map(object({
    scope                = string
    role_definition_name = string
    principal_id         = string
  }))
  default = {}

  validation {
    condition = alltrue([
      for assignment in values(var.role_assignments) : contains([
        "Reader",
        "Monitoring Reader",
        "Network Contributor",
        "Security Reader"
      ], assignment.role_definition_name)
    ])
    error_message = "Only the allowlisted least-privilege roles are accepted by this starter root."
  }

  validation {
    condition = alltrue([
      for assignment in values(var.role_assignments) :
      can(regex("^(/subscriptions/[^/]+(/resourceGroups/[^/]+(/providers/[^/]+/.+)?)?|/providers/Microsoft[.]Management/managementGroups/[^/]+)$", trimspace(assignment.scope)))
    ])
    error_message = "Each scope must use a supported subscription, resource group, resource, or management group resource ID format."
  }

  validation {
    condition = alltrue([
      for assignment in values(var.role_assignments) :
      can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", trimspace(assignment.principal_id)))
    ])
    error_message = "Each principal_id must be a valid GUID representing an Entra object ID."
  }
}

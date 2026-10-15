variable "subscription_id" {
  description = "Azure subscription ID used by the AzureRM provider."
  type        = string
}

variable "rbac_assignments" {
  description = "Resource-group RBAC assignments keyed by stable logical name."

  type = map(object({
    resource_group_name  = string
    role_definition_name = string
    principal_id         = string
    principal_type       = string
  }))
}

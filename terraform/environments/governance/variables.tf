variable "subscription_id" {
  description = "Azure subscription ID used by the AzureRM provider."
  type        = string
}

variable "definition_management_group_id" {
  description = "Management Group ID where the custom policy definition is created."
  type        = string
}

variable "assignment_management_group_id" {
  description = "Management Group ID where the policy assignment is created."
  type        = string
}

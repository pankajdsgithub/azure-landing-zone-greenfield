variable "subscription_id" {
  description = "Existing Azure subscription UUID used by the AzureRM provider."
  type        = string
}

variable "definition_management_group_id" {
  description = "Full Azure resource ID of the Management Group where the custom policy definition and initiative are created."
  type        = string
}

variable "assignment_management_group_id" {
  description = "Full Azure resource ID of the Management Group where the policy initiative is assigned."
  type        = string
}

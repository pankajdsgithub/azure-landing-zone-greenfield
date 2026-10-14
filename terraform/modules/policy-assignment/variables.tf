variable "assignment_name" {
  description = "Unique name of the policy assignment."
  type        = string
}

variable "display_name" {
  description = "Display name of the policy assignment."
  type        = string
}

variable "management_group_id" {
  description = "Management Group scope where the policy is assigned."
  type        = string
}

variable "policy_definition_id" {
  description = "Resource ID of the policy definition to assign."
  type        = string
}

variable "description" {
  description = "Purpose of the policy assignment."
  type        = string
}

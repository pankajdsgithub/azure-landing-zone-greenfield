variable "initiative_name" {
  description = "Unique name of the Azure Policy initiative"
  type        = string
}

variable "display_name" {
  description = "Display name of the Azure Policy initiative"
  type        = string
}

variable "management_group_id" {
  description = "Management group ID where the initiative is defined"
  type        = string
}

variable "description" {
  description = "Purpose of the Azure Policy initiative"
  type        = string
}

variable "policy_definition_id" {
  description = "Resource ID of the existing Azure Policy definition"
  type        = string
}

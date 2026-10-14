variable "policy_name" {
  description = "Name of the custom Azure Policy definition."
  type        = string
  default     = "require-environment-tag-audit"
}

variable "display_name" {
  description = "Display name of the custom Azure Policy definition."
  type        = string
  default     = "Audit resources missing the Environment tag"
}

variable "tag_name" {
  description = "Required resource tag to audit."
  type        = string
  default     = "Environment"
}
variable "management_group_id" {
  description = "Management Group ID where the custom policy definition will be created."
  type        = string
}




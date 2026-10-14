variable "name" {
  description = "Unique name of the Azure Management Group."
  type        = string
}

variable "display_name" {
  description = "Human-readable display name of the Management Group."
  type        = string
}

variable "parent_management_group_id" {
  description = "Optional resource ID of the parent Management Group."
  type        = string
  default     = null
}

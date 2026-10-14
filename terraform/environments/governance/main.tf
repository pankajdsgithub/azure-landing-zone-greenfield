module "environment_tag_policy" {
  source = "../../modules/policy-tag-audit"

  policy_name         = "require-environment-tag-audit"
  display_name        = "Audit resources missing the Environment tag"
  tag_name            = "Environment"
  management_group_id = var.definition_management_group_id
}

module "environment_tag_assignment" {
  source = "../../modules/policy-assignment"

  assignment_name      = "audit-environment-tag"
  display_name         = "Audit missing Environment tag"
  description          = "Audits resources that do not have the Environment tag."
  management_group_id  = var.assignment_management_group_id
  policy_definition_id = module.environment_tag_policy.policy_definition_id
}

module "environment_tag_initiative" {
  source = "../../modules/policy-initiative"

  initiative_name     = "environment-tag-governance"
  display_name        = "Environment Tag Governance"
  description         = "Groups policies for auditing required environment tags."
  management_group_id = var.definition_management_group_id

  policy_definition_id = module.environment_tag_policy.policy_definition_id
}

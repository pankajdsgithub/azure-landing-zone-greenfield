output "policy_definition_id" {
  description = "ID of the custom Environment tag policy."
  value       = module.environment_tag_policy.policy_definition_id
}

output "policy_assignment_id" {
  description = "ID of the Environment tag policy assignment."
  value       = module.environment_tag_assignment.policy_assignment_id
}

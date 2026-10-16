output "role_assignment_ids" {
  description = "IDs of configured role assignments."
  value = {
    for name, assignment in azurerm_role_assignment.approved :
    name => assignment.id
  }
}

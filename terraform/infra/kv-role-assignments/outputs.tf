output "assigned_roles" {
  value = {
    secrets_user = azurerm_role_assignment.secrets_user.id
    kv_reader    = azurerm_role_assignment.kv_reader.id
  }
}

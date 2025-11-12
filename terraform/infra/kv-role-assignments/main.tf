# Look up built-in role definitions at Key Vault scope
data "azurerm_role_definition" "kv_secrets_user" {
  name  = "Key Vault Secrets User"
  scope = var.key_vault_id
}

data "azurerm_role_definition" "kv_reader" {
  name  = "Key Vault Reader"
  scope = var.key_vault_id
}

# Role assignment: allow the UAMI to GET/LIST secrets (no key operations)
resource "azurerm_role_assignment" "secrets_user" {
  scope                = var.key_vault_id
  role_definition_id   = data.azurerm_role_definition.kv_secrets_user.role_definition_id
  principal_id         = var.principal_object_id
  skip_service_principal_aad_check = true
}

# Optional: Reader on the vault for metadata (some scenarios require it)
resource "azurerm_role_assignment" "kv_reader" {
  scope                = var.key_vault_id
  role_definition_id   = data.azurerm_role_definition.kv_reader.role_definition_id
  principal_id         = var.principal_object_id
  skip_service_principal_aad_check = true
}

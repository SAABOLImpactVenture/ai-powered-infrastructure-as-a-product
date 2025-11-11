package terraform.security
deny[msg] {
  some i
  r := input.resource_changes[i]
  r.type == "azurerm_storage_account"
  r.change.after_properties.allowBlobPublicAccess == true
  msg := sprintf("Public blob access is not allowed for %s", [r.name])
}

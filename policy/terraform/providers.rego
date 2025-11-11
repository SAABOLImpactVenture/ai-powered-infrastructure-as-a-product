package terraform.providers
deny[msg] {
  input.provider.name == "azurerm"
  not input.provider.version
  msg := "Provider version pinning is required for azurerm"
}

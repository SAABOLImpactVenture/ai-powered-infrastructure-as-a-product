resource "azurerm_resource_group" "rg" {
  provider = azurerm.workload
  name     = "rg-aiap-example"
  location = "eastus"
}

resource "azurerm_log_analytics_workspace" "la" {
  name                = "platform-la"
  location            = "eastus"
  resource_group_name = "platform-rg"
  sku                 = "PerGB2018"
  retention_in_days   = 90
}

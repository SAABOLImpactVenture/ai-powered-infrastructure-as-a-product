# Log Analytics workspace (optional create)
resource "azurerm_log_analytics_workspace" "law" {
  count               = var.log_analytics_workspace_id == null ? 1 : 0
  name                = "${var.name_prefix}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

locals {
  law_id = var.log_analytics_workspace_id != null ? var.log_analytics_workspace_id : one(azurerm_log_analytics_workspace.law[*].id)
}

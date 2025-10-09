terraform {
  required_providers { azurerm = { source="hashicorp/azurerm", version=">= 3.115.0" } }
}
provider "azurerm" { features {} }
variable "rg_name" { type=string }
variable "workspace_name" { type=string }
variable "retention_days" { type=number, default=365 }
resource "azurerm_log_analytics_workspace" "la" {
  name = var.workspace_name
  resource_group_name = var.rg_name
  location = "eastus"
  retention_in_days = var.retention_days
  daily_quota_gb = -1
}
output "workspace_id" { value = azurerm_log_analytics_workspace.la.workspace_id }

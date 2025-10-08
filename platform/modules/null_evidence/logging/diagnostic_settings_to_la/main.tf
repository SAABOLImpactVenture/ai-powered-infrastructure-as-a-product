terraform {
  required_version = ">= 1.4.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}
provider "azurerm" { features {} }

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "iaap-diag"
  target_resource_id         = var.target_resource_id
  log_analytics_workspace_id = var.workspace_resource_id
  # Example categories; uncomment and adjust for your resource type
  # enabled_log {
  #   category = "Administrative"
  # }
}

output "id" { value = azurerm_monitor_diagnostic_setting.this.id }

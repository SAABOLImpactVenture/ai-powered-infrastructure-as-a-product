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

resource "azurerm_log_analytics_workspace" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_days
  features {
    enable_log_access_using_only_resource_permissions = true
  }
}

output "workspace_id"         { value = azurerm_log_analytics_workspace.this.workspace_id }
output "workspace_resource_id" { value = azurerm_log_analytics_workspace.this.id }

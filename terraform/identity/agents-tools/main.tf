terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.114.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.50.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.31.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Service principal per tool (Jira example)
resource "azuread_application" "tool_jira" {
  display_name = "mcp-tool-jira"
}

resource "azuread_service_principal" "tool_jira" {
  client_id = azuread_application.tool_jira.client_id
}

resource "azuread_service_principal_password" "tool_jira" {
  service_principal_id = azuread_service_principal.tool_jira.id
  end_date_relative    = "1h"
}

resource "azurerm_role_assignment" "jira_reader" {
  scope                = var.scope_resource_id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.tool_jira.id
}

resource "kubernetes_secret" "tool_jira_sp" {
  metadata {
    name      = "tool-jira-sp"
    namespace = "agents-tools"
  }
  data = {
    CLIENT_ID = azuread_application.tool_jira.client_id
    SECRET    = azuread_service_principal_password.tool_jira.value
  }
  type = "Opaque"
}

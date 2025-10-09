terraform {
  required_providers {
    azuread = { source = "hashicorp/azuread", version = ">= 2.49.0" }
    azurerm = { source = "hashicorp/azurerm", version = ">= 3.115.0" }
  }
}
provider "azuread" {}
provider "azurerm" { features {} }

variable "repo" { description = "owner/repo for GitHub OIDC" type = string }
variable "client_name" { type = string }
variable "tenant_id" { type = string }

resource "azuread_application" "gha" {
  display_name = var.client_name
}

resource "azuread_service_principal" "gha" {
  client_id = azuread_application.gha.client_id
}

# Federated credential for GitHub Actions OIDC (repo environment)
resource "azuread_application_federated_identity_credential" "gha_env" {
  application_object_id = azuread_application.gha.id
  display_name          = "github-oidc-env"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = "https://token.actions.githubusercontent.com"
  subject               = "repo:${var.repo}:environment:prod"
}

# Conditional Access: Require MFA for Azure AD roles (admins)
resource "azuread_conditional_access_policy" "mfa_admins" {
  display_name = "Require MFA for Admins"
  state        = "enabled"
  conditions {
    users {
      include_roles = [
        "62e90394-69f5-4237-9190-012177145e10" # Global Administrator
      ]
    }
    sign_in_risk_levels = ["high","medium","low"]
    client_app_types    = ["all"]
  }
  grant_controls {
    operator          = "AND"
    built_in_controls = ["mfa"]
  }
}

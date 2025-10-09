terraform {
  required_providers { azuread = { source="hashicorp/azuread", version=">= 2.49.0" } }
}
provider "azuread" {}

variable "repo" { type = string }    # org/repo
variable "app_name" { type = string }
variable "envs" { type = list(string) }

resource "azuread_application" "gha" { display_name = var.app_name }
resource "azuread_service_principal" "gha" { client_id = azuread_application.gha.client_id }

resource "azuread_application_federated_identity_credential" "env" {
  for_each = toset(var.envs)
  application_object_id = azuread_application.gha.id
  display_name          = "gh-${each.value}"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = "https://token.actions.githubusercontent.com"
  subject               = "repo:${var.repo}:environment:${each.value}"
}
output "client_id" { value = azuread_application.gha.client_id }
output "object_id" { value = azuread_application.gha.id }

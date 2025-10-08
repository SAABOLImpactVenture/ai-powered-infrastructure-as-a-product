terraform {
  required_version = ">= 1.4.0"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53"
    }
  }
}
provider "azuread" {}

resource "azuread_application" "this" {
  display_name = var.display_name
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id
}

output "application_id" { value = azuread_application.this.client_id }
output "service_principal_id" { value = azuread_service_principal.this.id }

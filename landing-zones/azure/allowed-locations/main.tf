terraform {
  required_providers { azurerm = { source = "hashicorp/azurerm", version = ">= 3.115.0" } }
}
provider "azurerm" { features {} }
variable "scope" { type = string }
variable "allowed_locations" { type = list(string) }

data "azurerm_policy_definition" "allowed" {
  display_name = "Allowed locations"
}

resource "azurerm_policy_assignment" "regions" {
  name                 = "allowed-locations"
  scope                = var.scope
  policy_definition_id = data.azurerm_policy_definition.allowed.id
  parameters           = jsonencode({ listOfAllowedLocations = { value = var.allowed_locations } })
}

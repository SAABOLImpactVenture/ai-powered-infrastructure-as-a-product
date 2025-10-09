terraform {
  required_providers { azurerm = { source="hashicorp/azurerm", version=">= 3.115.0" } }
}
provider "azurerm" { features {} }
variable "mg_scope" { type=string }
variable "allowed_locations" { type=list(string) }

data "azurerm_policy_definition" "allowed" { display_name = "Allowed locations" }
data "azurerm_policy_definition" "cmek" { display_name = "Storage accounts should use customer-managed keys (CMK) for encryption" }

resource "azurerm_policy_assignment" "regions" {
  name = "allowed-locations"
  scope = var.mg_scope
  policy_definition_id = data.azurerm_policy_definition.allowed.id
  parameters = jsonencode({ listOfAllowedLocations = { value = var.allowed_locations } })
}

resource "azurerm_policy_assignment" "storage_cmek" {
  name = "storage-cmek-required"
  scope = var.mg_scope
  policy_definition_id = data.azurerm_policy_definition.cmek.id
  enforcement_mode = "Default"
}

terraform {
  required_providers { azurerm = { source = "hashicorp/azurerm", version = ">= 3.115.0" } }
}
provider "azurerm" { features {} }
variable "scope" { type = string }
data "azurerm_policy_definition" "https" {
  display_name = "Secure transfer to storage accounts should be enabled"
}
resource "azurerm_policy_assignment" "enforce_https" {
  name                 = "enforce-https-storage"
  scope                = var.scope
  policy_definition_id = data.azurerm_policy_definition.https.id
  display_name         = "Enforce HTTPS on storage"
  enforcement_mode     = "Default"
}

terraform {
  required_providers { azurerm = { source = "hashicorp/azurerm", version = ">= 3.115.0" } }
}
provider "azurerm" { features {} }
variable "scope" { type = string }
variable "required_tags" { type = map(string) }

data "azurerm_policy_definition" "tags" {
  display_name = "Inherit a tag from the resource group if missing"
}

resource "azurerm_policy_assignment" "req_tags" {
  name = "require-tags"
  scope = var.scope
  policy_definition_id = data.azurerm_policy_definition.tags.id
  parameters = jsonencode({ tagName = {value = "cost-center"} })
}

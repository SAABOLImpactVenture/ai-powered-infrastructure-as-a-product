terraform {
  required_providers { azurerm = { source="hashicorp/azurerm", version=">= 3.115.0" } }
}
provider "azurerm" { features {} }

variable "root_mg_id" { type=string }
variable "allowed_locations" { type=list(string) }

# Management groups
resource "azurerm_management_group" "platform" { display_name="platform" parent_management_group_id = var.root_mg_id }
resource "azurerm_management_group" "workloads" { display_name="workloads" parent_management_group_id = var.root_mg_id }

# Policies
data "azurerm_policy_definition" "allowed" { display_name = "Allowed locations" }
data "azurerm_policy_definition" "private_endpoints" { display_name = "Private endpoint should be enabled for PostgreSQL" }

resource "azurerm_management_group_policy_assignment" "regions" {
  name = "allowed-locations"
  management_group_id = azurerm_management_group.platform.id
  policy_definition_id = data.azurerm_policy_definition.allowed.id
  parameters = jsonencode({ listOfAllowedLocations = { value = var.allowed_locations } })
}

# Add more initiatives as needed (CMEK required, diagnostics)

terraform {
  required_providers { azurerm = { source="hashicorp/azurerm", version=">= 3.115.0" } }
}
provider "azurerm" { features {} }

variable "root_mg_id" { type=string }
variable "allowed_locations" { type=list(string) }

resource "azurerm_management_group" "platform" { display_name="platform" parent_management_group_id = var.root_mg_id }
resource "azurerm_management_group" "workloads" { display_name="workloads" parent_management_group_id = var.root_mg_id }

data "azurerm_policy_definition" "allowed" { display_name = "Allowed locations" }
data "azurerm_policy_definition" "cmk_storage" { display_name = "Storage accounts should use customer-managed keys (CMK) for encryption" }
data "azurerm_policy_definition" "private_endpoints_sql" { display_name = "Private endpoint should be enabled for Azure SQL Server" }

resource "azurerm_management_group_policy_assignment" "regions" {
  name = "allowed-locations"
  management_group_id = azurerm_management_group.platform.id
  policy_definition_id = data.azurerm_policy_definition.allowed.id
  parameters = jsonencode({ listOfAllowedLocations = { value = var.allowed_locations } })
}

resource "azurerm_management_group_policy_assignment" "cmk" {
  name = "cmk-storage-required"
  management_group_id = azurerm_management_group.workloads.id
  policy_definition_id = data.azurerm_policy_definition.cmk_storage.id
}

resource "azurerm_management_group_policy_assignment" "sql_private" {
  name = "sql-private-endpoints"
  management_group_id = azurerm_management_group.workloads.id
  policy_definition_id = data.azurerm_policy_definition.private_endpoints_sql.id
}

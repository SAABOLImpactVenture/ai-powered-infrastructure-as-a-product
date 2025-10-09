terraform {
  required_providers { azurerm = { source = "hashicorp/azurerm", version = ">= 3.115.0" } }
}
provider "azurerm" { features {} }
variable "rg_name" { type = string }
variable "location" { type = string }
variable "profile_name" { type = string }
variable "primary_fqdn" { type = string }
variable "secondary_fqdn" { type = string }

resource "azurerm_traffic_manager_profile" "tm" {
  name                = var.profile_name
  resource_group_name = var.rg_name
  location            = var.location
  traffic_routing_method = "Priority"
  dns_config { relative_name = var.profile_name ttl = 30 }
  monitor_config { protocol = "HTTPS" port = 443 path = "/healthz" }
}

resource "azurerm_traffic_manager_endpoint" "primary" {
  name                = "primary"
  profile_id          = azurerm_traffic_manager_profile.tm.id
  type                = "externalEndpoints"
  target              = var.primary_fqdn
  priority            = 1
}
resource "azurerm_traffic_manager_endpoint" "secondary" {
  name       = "secondary"
  profile_id = azurerm_traffic_manager_profile.tm.id
  type       = "externalEndpoints"
  target     = var.secondary_fqdn
  priority   = 2
}

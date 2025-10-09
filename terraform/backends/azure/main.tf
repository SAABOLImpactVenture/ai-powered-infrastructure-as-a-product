terraform {
  required_providers { azurerm = { source = "hashicorp/azurerm", version = ">= 3.115.0" } }
}
provider "azurerm" { features {} }
variable "rg_name" { type = string }
variable "location" { type = string }
variable "sa_name" { type = string }
variable "kv_name" { type = string }

resource "azurerm_resource_group" "rg" { name = var.rg_name location = var.location }
resource "azurerm_key_vault" "kv" {
  name                = var.kv_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  purge_protection_enabled = true
  soft_delete_retention_days = 90
}
data "azurerm_client_config" "current" {}
resource "azurerm_storage_account" "sa" {
  name                     = var.sa_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  allow_blob_public_access = false
  min_tls_version          = "TLS1_2"
}
resource "azurerm_storage_container" "st" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}
output "backend" {
  value = <<EOT
backend "azurerm" {
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  storage_account_name = "${azurerm_storage_account.sa.name}"
  container_name       = "${azurerm_storage_container.st.name}"
  key                  = "terraform.tfstate"
}
EOT
}

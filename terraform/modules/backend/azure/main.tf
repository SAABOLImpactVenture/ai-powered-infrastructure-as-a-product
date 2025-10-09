terraform {
  required_providers { azurerm = { source = "hashicorp/azurerm", version = ">= 3.115.0" } }
}
provider "azurerm" { features {} }

variable "name_prefix" { type = string }
variable "location" { type = string }
variable "vnet_subnet_id" { type = string }

resource "azurerm_resource_group" "rg" { name = "${var.name_prefix}-rg" location = var.location }

resource "azurerm_key_vault" "kv" {
  name                        = "${var.name_prefix}kv"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true
}
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_key" "kek" {
  name         = "tfstate-kek"
  key_vault_id = azurerm_key_vault.kv.id
  key_type     = "RSA"
  key_size     = 2048
}

resource "azurerm_storage_account" "sa" {
  name                              = replace("${var.name_prefix}state", "-", "")
  location                          = var.location
  resource_group_name               = azurerm_resource_group.rg.name
  account_tier                      = "Standard"
  account_replication_type          = "GRS"
  allow_blob_public_access          = false
  min_tls_version                   = "TLS1_2"
  infrastructure_encryption_enabled = true
  identity { type = "SystemAssigned" }
  encryption {
    key_source            = "Microsoft.Keyvault"
    key_vault_key_id      = azurerm_key_vault_key.kek.id
    services { blob { enabled = true } }
  }
  blob_properties { versioning_enabled = true }
  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [var.vnet_subnet_id]
    bypass                     = ["AzureServices"]
  }
}

resource "azurerm_storage_container" "tf" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_private_endpoint" "pe" {
  name                = "${var.name_prefix}-pe-blob"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = var.vnet_subnet_id
  private_service_connection {
    name                           = "blob-privlink"
    private_connection_resource_id = azurerm_storage_account.sa.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}

output "backend_block" {
  value = <<EOT
backend "azurerm" {
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  storage_account_name = "${azurerm_storage_account.sa.name}"
  container_name       = "${azurerm_storage_container.tf.name}"
  key                  = "terraform.tfstate"
}
EOT
}

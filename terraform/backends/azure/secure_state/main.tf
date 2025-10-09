terraform {
  required_providers { azurerm = { source = "hashicorp/azurerm", version = ">= 3.115.0" } }
}
provider "azurerm" { features {} }
variable "rg_name" { type=string }
variable "location" { type=string }
variable "sa_name" { type=string }
variable "kv_name" { type=string }
variable "vnet_id" { type=string }
variable "subnet_id" { type=string }

resource "azurerm_resource_group" "rg" { name = var.rg_name location = var.location }

resource "azurerm_key_vault" "kv" {
  name                = var.kv_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  purge_protection_enabled     = true
  soft_delete_retention_days   = 90
}

data "azurerm_client_config" "current" {}

resource "azurerm_storage_account" "sa" {
  name                     = var.sa_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  allow_nested_items_to_be_public = false
  allow_blob_public_access = false
  min_tls_version          = "TLS1_2"
  infrastructure_encryption_enabled = true
  blob_properties { versioning_enabled = true }
  queue_encryption_key_type = "Account"
  table_encryption_key_type = "Account"
  identity { type = "SystemAssigned" }
  encryption {
    key_source = "Microsoft.Keyvault"
    services { blob { enabled = true } }
    key_vault_key_id = azurerm_key_vault_key.kek.id
  }
  network_rules {
    default_action = "Deny"
    bypass = ["AzureServices"]
    virtual_network_subnet_ids = [var.subnet_id]
  }
}

resource "azurerm_key_vault_key" "kek" {
  name         = "tfstate-kek"
  key_vault_id = azurerm_key_vault.kv.id
  key_type     = "RSA"
  key_size     = 2048
}

resource "azurerm_private_endpoint" "pe" {
  name                = "pe-state"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = var.subnet_id
  private_service_connection {
    name                           = "blob-privlink"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.sa.id
    subresource_names              = ["blob"]
  }
}

resource "azurerm_storage_container" "tf" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
  immutability_policy {
    allow_protected_append_writes_all = true
    period_since_creation_in_days     = 30
    state                             = "Unlocked"
  }
}

output "backend" {
  value = <<EOT
backend "azurerm" {
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  storage_account_name = "${azurerm_storage_account.sa.name}"
  container_name       = "${azurerm_storage_container.tf.name}"
  key                  = "terraform.tfstate"
}
EOT
}

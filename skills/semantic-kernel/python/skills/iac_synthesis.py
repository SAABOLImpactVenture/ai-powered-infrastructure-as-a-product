from typing import Dict

from jinja2 import Template


MAIN_TF = Template(
    """
    terraform {
      required_version = ">= 1.6.0"
      required_providers {
        azurerm = {
          source  = "hashicorp/azurerm"
          version = ">= 3.80.0"
        }
      }
    }

    provider "azurerm" {
      features {}
    }

    resource "azurerm_resource_group" "this" {
      name     = "${resource_group_name}"
      location = "${location}"
      tags     = var.tags
    }

    resource "azurerm_storage_account" "this" {
      name                     = "${storage_account_name}"
      resource_group_name      = azurerm_resource_group.this.name
      location                 = azurerm_resource_group.this.location
      account_tier             = "Standard"
      account_replication_type = "ZRS"
      min_tls_version          = "TLS1_2"
      allow_blob_public_access = false
      enable_https_traffic_only = true

      blob_properties {
        delete_retention_policy {
          days = 7
        }
      }

      tags = var.tags
    }

    resource "azurerm_private_endpoint" "blob" {
      name                = "${storage_account_name}-pe-blob"
      location            = azurerm_resource_group.this.location
      resource_group_name = azurerm_resource_group.this.name
      subnet_id           = var.subnet_id

      private_service_connection {
        name                           = "${storage_account_name}-pe-blob-conn"
        is_manual_connection           = false
        private_connection_resource_id = azurerm_storage_account.this.id
        subresource_names              = ["blob"]
      }

      tags = var.tags
    }
    """
)


VARIABLES_TF = """
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "storage_account_name" {
  type        = string
  description = "Globally unique storage account name."
}

variable "subnet_id" {
  type        = string
  description = "Subnet id for private endpoint."
}

variable "tags" {
  type        = map(string)
  description = "Standard resource tags."
  default     = {}
}
"""


OUTPUTS_TF = """
output "storage_account_id" {
  value       = azurerm_storage_account.this.id
  description = "ID of the storage account."
}

output "storage_account_name" {
  value       = azurerm_storage_account.this.name
  description = "Name of the storage account."
}
"""


EXAMPLE_TF = """
module "secure_storage" {
  source = "../.."

  resource_group_name  = "rg-secure-storage"
  location             = "eastus"
  storage_account_name = "stsecurestorage001"
  subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-spoke/subnets/snet-private-endpoints"

  tags = {
    owner         = "platform-team"
    product       = "secure-storage-product"
    classification = "sensitive"
    managed-by    = "ai-iaap-platform"
  }
}
"""


def synthesize_secure_storage_module(product_name: str) -> Dict[str, str]:
    """Return file map for a secure storage Terraform module and example."""
    slug = product_name.lower().replace(" ", "")[:18]
    storage_account_name = f"st{slug}001"
    rg_name = f"rg-{slug[:20]}"
    main_tf = MAIN_TF.render(
        resource_group_name=rg_name,
        storage_account_name=storage_account_name,
        location="eastus",
    )
    return {
        "iac/modules/secure-storage/main.tf": main_tf.strip() + "\n",
        "iac/modules/secure-storage/variables.tf": VARIABLES_TF.strip() + "\n",
        "iac/modules/secure-storage/outputs.tf": OUTPUTS_TF.strip() + "\n",
        "iac/examples/secure-storage/main.tf": EXAMPLE_TF.strip() + "\n",
    }

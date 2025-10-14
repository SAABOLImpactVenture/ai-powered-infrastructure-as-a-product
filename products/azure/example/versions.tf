terraform {
  required_version = ">= 1.6"
  backend "azurerm" {
    use_azuread_auth     = true
    use_oidc             = true
    tenant_id            = var.tenant_id
    subscription_id      = var.platform_subscription_id
    storage_account_name = var.state_storage_account
    container_name       = var.state_container
    key                  = "azure/example.tfstate"
  }
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" }
  }
}

provider "azurerm" {
  alias           = "platform"
  features {}
  use_oidc        = true
  tenant_id       = var.tenant_id
  subscription_id = var.platform_subscription_id
  client_id       = var.client_id
}

provider "azurerm" {
  alias           = "workload"
  features {}
  use_oidc        = true
  tenant_id       = var.tenant_id
  subscription_id = var.workload_subscription_id
  client_id       = var.client_id
}

variable "tenant_id" {}
variable "platform_subscription_id" {}
variable "workload_subscription_id" {}
variable "client_id" {}
variable "state_storage_account" {}
variable "state_container" {}

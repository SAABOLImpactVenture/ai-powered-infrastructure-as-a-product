terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.114"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" { features {} }

resource "azurerm_resource_group" "demo" {
  name     = "rg-aiap-demo"
  location = "eastus"
  tags = { provisioned_by = "github-actions" }
}

resource "azurerm_resource_group" "example" {
  name     = "rg-aiap-example"
  location = "eastus"
  tags = { provisioned_by = "github-actions" }
}

terraform {
  backend "azurerm" {
    resource_group_name  = "platform-rg"
    storage_account_name = "platformtfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

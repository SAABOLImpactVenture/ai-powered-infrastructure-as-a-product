terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.114"
    }
  }

  # One (and only one) backend block per module.
  # The actual credentials/values are fed by -backend-config in the workflow.
  backend "azurerm" {}
}

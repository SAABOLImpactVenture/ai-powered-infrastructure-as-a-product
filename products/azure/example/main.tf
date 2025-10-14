# Sample resources to exercise CI/apply

resource "azurerm_resource_group" "demo" {
  name     = "rg-aiap-demo"
  location = "eastus"

  tags = {
    provisioned_by = "github-actions"
  }
}

resource "azurerm_resource_group" "example" {
  name     = "rg-aiap-example"
  location = "eastus"

  tags = {
    provisioned_by = "github-actions"
  }
}

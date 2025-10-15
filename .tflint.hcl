# .tflint.hcl

plugin "azurerm" {
  enabled = true
  version = "0.76.1" # known-good at time of writing; update as needed
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

# General config
config {
  module = true
  force  = true
}

# Example: tune severity or disable selected rules here (optional)
# rule "azurerm_resource_no_deprecated" {
#   enabled = true
# }

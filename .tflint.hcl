plugin "azurerm" {
  enabled = true
  version = "0.27.1"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

config {
  module = true
  force  = false
}

rule "terraform_unused_declarations" { enabled = true }
rule "terraform_deprecated_interpolation" { enabled = true }

# Example: tune false positives here as repo grows
# rule "azurerm_resource_missing_tags" { enabled = true }

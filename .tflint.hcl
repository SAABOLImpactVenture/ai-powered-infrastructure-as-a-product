plugin "aws" {
  enabled = true
  version = "0.33.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
plugin "azurerm" {
  enabled = true
  version = "0.24.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}
plugin "google" {
  enabled = true
  version = "0.31.0"
  source  = "github.com/terraform-linters/tflint-ruleset-google"
}
plugin "oci" {
  enabled = true
  version = "0.6.1"
  source  = "github.com/terraform-linters/tflint-ruleset-oci"
}

config {
  call_module_type = "local"
  module = true
  deep_check = true
  force = false
  ignore_module = []
  plugin_dir = ".tflint.d/plugins"
  terraform_version = "1.8.0"
}

config { format = "compact" }
plugin "aws" { enabled = true }
plugin "azurerm" { enabled = true }
plugin "google" { enabled = true }
rule "terraform_required_version" { enabled = true }
rule "terraform_naming_convention" { enabled = true }

package terraform.providers
deny[msg] { input.provider.name == "azurerm"; not input.provider.version; msg := "Provider version pinning is required for azurerm" }
deny[msg] { input.provider.name == "aws";     not input.provider.version; msg := "Provider version pinning is required for aws" }
deny[msg] { input.provider.name == "google";  not input.provider.version; msg := "Provider version pinning is required for google" }
deny[msg] { input.provider.name == "oci";     not input.provider.version; msg := "Provider version pinning is required for oci" }

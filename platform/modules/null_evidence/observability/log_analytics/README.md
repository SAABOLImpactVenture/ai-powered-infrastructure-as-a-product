# Module: observability/log_analytics (Azure)

Creates a Log Analytics workspace.

## Provider
```hcl
terraform {
  required_version = ">= 1.4.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.100" }
  }
}
provider "azurerm" { features {} }
```

## Inputs
- `name` (string)
- `location` (string)
- `resource_group_name` (string)
- `retention_days` (number, default 30)

## Outputs
- `workspace_id`
- `workspace_resource_id`

# Module: networking/azure_vnet

Creates an Azure Virtual Network.

## Inputs
- `name` (string)
- `location` (string)
- `resource_group_name` (string)
- `address_space` (list(string))

## Outputs
- `id`

> Validate with `terraform validate`. Apply only in a configured Azure environment.

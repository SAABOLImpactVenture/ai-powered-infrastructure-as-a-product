# Module: identity/entra_service_principal

Creates an Entra Application and Service Principal. Use carefully; requires directory permissions.

## Inputs
- `display_name` (string)

## Outputs
- `application_id`
- `service_principal_id`

> Validate with `terraform validate`. Apply only with AzureAD credentials configured.

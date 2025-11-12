# Azure Arc — Policy Assignment via Terraform (azapi)

Assign an Azure Policy (definition/initiative) at the **Arc-connected Kubernetes** scope using `azapi_resource`.

## Inputs
- `subscription_id`, `resource_group_name`, `connected_cluster_name`
- `policy_assignment_name`, `policy_definition_id` (built-in or custom)
- `location`, `tags`

## Example
```hcl
module "arc_policy" {
  source                 = "../../infra/azure-arc/policy"
  subscription_id        = var.subscription_id
  resource_group_name    = var.resource_group_name
  connected_cluster_name = var.connected_cluster_name
  policy_assignment_name = "k8s-baseline"
  policy_definition_id   = "/providers/Microsoft.Authorization/policySetDefinitions/<initiative-id>"
  location               = var.location
  tags                   = { Program = "AI-PIaP", System = "Platform", Environment = "Prod", "Data-Class" = "Internal" }
}
```

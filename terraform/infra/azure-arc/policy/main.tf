data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# Connected cluster resource ID
locals {
  connected_cluster_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Kubernetes/connectedClusters/${var.connected_cluster_name}"
}

# Azure Policy Assignment at connectedClusters scope (using azapi)
resource "azapi_resource" "policy_assignment" {
  type      = "Microsoft.Authorization/policyAssignments@2022-06-01"
  name      = var.policy_assignment_name
  parent_id = local.connected_cluster_id
  body = jsonencode({
    properties = {
      displayName = var.policy_assignment_name
      policyDefinitionId = var.policy_definition_id
      enforcementMode = "Default"
    }
    location = var.location
    tags     = var.tags
  })
}

output "policy_assignment_id" {
  value = azapi_resource.policy_assignment.id
}

# Assign built-in Azure Policies for AKS secure baseline
# Note: these policy definition IDs are region-agnostic built-ins.
data "azurerm_policy_definition" "no_privileged" {
  display_name = "Kubernetes cluster should not allow privileged containers"
}

data "azurerm_policy_definition" "no_host_network" {
  display_name = "Kubernetes cluster should not allow containers using host networking and ports"
}

resource "azurerm_policy_assignment" "aks_no_privileged" {
  name                 = "${var.name_prefix}-aks-no-priv"
  scope                = azurerm_kubernetes_cluster.aks.id
  policy_definition_id = data.azurerm_policy_definition.no_privileged.id
  enforcement_mode     = "Default"
}

resource "azurerm_policy_assignment" "aks_no_hostnetwork" {
  name                 = "${var.name_prefix}-aks-nohost"
  scope                = azurerm_kubernetes_cluster.aks.id
  policy_definition_id = data.azurerm_policy_definition.no_host_network.id
  enforcement_mode     = "Default"
}

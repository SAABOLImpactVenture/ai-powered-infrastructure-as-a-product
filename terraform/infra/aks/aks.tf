resource "azurerm_user_assigned_identity" "workload" {
  name                = "${var.name_prefix}-workload-mi"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "random_password" "kubelet" {
  length  = 24
  special = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.name_prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.name_prefix}-aks"
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                 = "system"
    vm_size              = var.node_vm_size
    node_count           = var.node_count
    type                 = "VirtualMachineScaleSets"
    vnet_subnet_id       = azurerm_subnet.aks.id
    upgrade_settings {
      max_surge = "33%"
    }
    only_critical_addons_enabled = true
    os_disk_size_gb              = 128
  }

  identity {
    type = "SystemAssigned"
  }

  # Private cluster
  api_server_access_profile {
    enable_private_cluster           = true
    private_dns_zone_id              = local.private_dns_zone_id_final
    authorized_ip_ranges             = []
  }

  # Azure CNI or Cilium
  network_profile {
    network_plugin = var.enable_cilium_dataplane ? "azure" : "azure"
    # When Cilium dataplane is enabled in AKS, it's a cluster feature flag; here we leave plugin azure and rely on feature.
    load_balancer_sku = "standard"
    network_policy    = "calico"
  }

  azure_active_directory_role_based_access_control {
    enabled = true
    azure_rbac_enabled = true
    admin_group_object_ids = var.aad_admin_group_object_ids
  }

  oidc_issuer_enabled = true

  workload_identity_enabled = true

  microsoft_defender {
    log_analytics_workspace_id = local.law_id
    enabled = var.enable_defender
  }

  oms_agent {
    log_analytics_workspace_id = local.law_id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  azure_policy_enabled = true

  tags = var.tags
}

# Federated identity credential to allow ServiceAccount backstage/backstage-sa to access Azure via UAMI
resource "azurerm_federated_identity_credential" "backstage_fic" {
  name                = "${var.name_prefix}-fic-backstage"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.workload.id
  subject             = "system:serviceaccount:backstage:backstage-sa"
}

# Grant the workload identity access to Key Vault or other resources outside this module later via role assignments.

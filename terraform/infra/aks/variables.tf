variable "name_prefix" {
  type        = string
  description = "Lowercase alphanumeric prefix used for resource names."
}

variable "location" {
  type        = string
  description = "Azure region (e.g., usgovvirginia or eastus)."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for AKS and network."
}

variable "vnet_cidr" {
  type        = string
  default     = "10.40.0.0/16"
}

variable "aks_subnet_cidr" {
  type        = string
  default     = "10.40.1.0/24"
}

variable "pe_subnet_cidr" {
  type        = string
  default     = "10.40.2.0/24"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.30"
}

variable "node_count" {
  type        = number
  default     = 3
}

variable "node_vm_size" {
  type        = string
  default     = "Standard_D4ds_v5"
}

variable "aad_admin_group_object_ids" {
  type        = list(string)
  default     = []
  description = "Object IDs of Entra ID groups for AKS Admin (ClusterAdmin) access."
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "Existing Log Analytics Workspace ID (if null, one will be created)."
}

variable "private_dns_zone_id" {
  type        = string
  default     = null
  description = "Existing Private DNS Zone for AKS API (privatelink.<region>.azmk8s.io). If null, one will be created."
}

variable "enable_defender" {
  type        = bool
  default     = false
  description = "Enable Microsoft Defender for Containers (billing applies)."
}

variable "enable_cilium_dataplane" {
  type        = bool
  default     = false
  description = "Enable Cilium dataplane (aks eBPF). If false, defaults to Azure CNI (non-overlay)."
}

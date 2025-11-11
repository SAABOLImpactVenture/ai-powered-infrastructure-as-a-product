variable "name_prefix" {
  type        = string
  description = "Prefix for Azure resources (lowercase, alphanum)."
}

variable "location" {
  type        = string
  description = "Azure region, e.g., usgovvirginia or eastus."
}

variable "resource_group_name" {
  type        = string
  description = "Existing resource group name."
}

variable "vnet_id" {
  type        = string
  description = "Existing VNet ID where private endpoint will be created."
}

variable "subnet_id" {
  type        = string
  description = "Existing subnet ID for private endpoint (no NSGs that block PE)."
}

variable "kv_id" {
  type        = string
  description = "Azure Key Vault ID where secrets will be stored."
}

variable "postgres_version" {
  type        = string
  default     = "16"
  description = "PostgreSQL major version."
}

variable "sku_name" {
  type        = string
  default     = "GP_Standard_D2ds_v5"
  description = "SKU for PostgreSQL Flexible Server."
}

variable "backup_retention_days" {
  type        = number
  default     = 14
  description = "Backup retention in days."
}

variable "db_name" {
  type        = string
  default     = "backstage"
  description = "Application database name."
}

variable "admin_username" {
  type        = string
  default     = "pgadmin"
  description = "Admin username for PostgreSQL."
}

variable "cmk_encryption" {
  type        = bool
  default     = false
  description = "Enable CMK if you have a customer-managed key (not configured here)."
}

variable "tags" {
  type        = map(string)
  default     = {}
}

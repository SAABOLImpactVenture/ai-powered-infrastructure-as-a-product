variable "key_vault_id" {
  type        = string
  description = "Resource ID of the Azure Key Vault."
}

variable "principal_object_id" {
  type        = string
  description = "Object ID of the principal (e.g., UAMI) to assign roles to."
}

variable "tags" {
  type        = map(string)
  default     = {}
}

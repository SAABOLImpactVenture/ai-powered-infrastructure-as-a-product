# Key Vault Role Assignments (Terraform)

Assigns **Key Vault Secrets User** and **Key Vault Reader** to a principal (e.g., the AKS workload UAMI used by Backstage).

## Usage

```hcl
module "kv_ra" {
  source              = "../../infra/kv-role-assignments"
  key_vault_id        = azurerm_key_vault.main.id
  principal_object_id = module.aks.workload_identity_object_id
}
```

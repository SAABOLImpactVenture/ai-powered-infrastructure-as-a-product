# AKS Role Assignments & Helm Overlay

This add-on provides:
1) **Terraform** to grant the AKS **workload UAMI** the **Key Vault Secrets User** and **Key Vault Reader** roles.
2) A **Helm values overlay** for AKS that enables:
   - ServiceAccount annotation for **Workload Identity**
   - **mTLS** parameters for Postgres via `PGSSL*` env vars, CA trust via `NODE_EXTRA_CA_CERTS`
   - **Egress proxy** environment variables
   - NetworkPolicy egress CIDR allow-list for proxy and private endpoints

## Role assignments

Use the Terraform module:

```hcl
module "kv_role_assignments" {
  source              = "../../infra/kv-role-assignments"
  key_vault_id        = azurerm_key_vault.main.id
  principal_object_id = azurerm_user_assigned_identity.workload.principal_id
}
```

Or the CLI helper:

```bash
KEY_VAULT_ID=/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.KeyVault/vaults/<name>
PRINCIPAL_OBJECT_ID=$(az identity show -g <rg> -n <uamiName> --query principalId -o tsv)
scripts/aks/assign-kv-role.sh
```

## Helm overlay usage

Apply the overlay with your AKS-specific values:

```bash
helm upgrade --install backstage charts/backstage -n backstage   -f charts/backstage/values-prod.yaml   -f charts/backstage/values-aks-overlay.yaml   --set serviceAccount.annotations.azure\.workload\.identity/client-id=$(terraform -chdir=terraform/infra/aks output -raw workload_identity_client_id)
```

Populate the `backstage-mtls` Secret with your CA/client materials if your Postgres enforces **mTLS**. If not, you can still mount only `ca.crt` to trust private CAs used on your network.

Adjust the `networkPolicy.egressAllowCIDRs` to your environment for the proxy, Postgres private endpoint subnet, and Key Vault private endpoint subnet.

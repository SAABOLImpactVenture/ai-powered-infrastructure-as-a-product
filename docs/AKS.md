# AKS Platform Pack

This pack adds **AKS** infrastructure and bootstrap to the repo with FedRAMP/NIST-aligned defaults.

## What it delivers
- Terraform module for a **private AKS** cluster with:
  - VNet + subnets (AKS, Private Endpoint)
  - AAD RBAC (group-based), OIDC issuer, **Workload Identity** enabled
  - Azure Policy add-on + baseline assignments
  - Container Insights (Log Analytics) and optional Defender
  - Key Vault CSI provider rotation
  - UAMI + **Federated Identity Credential** for `system:serviceaccount:backstage:backstage-sa`
- Kubernetes bootstrap:
  - Namespaces (`backstage`, `ingress-nginx`, `gatekeeper-system`), pod-security labels
  - ServiceAccount annotated for Workload Identity (client ID injected)
  - External Secrets Operator SecretStore bound to **Azure Key Vault**
  - **Ingress NGINX** (internal LoadBalancer) hardened values
- Scripts:
  - `scripts/aks/bootstrap.sh` — installs Helm components and applies bootstrap manifests
  - `scripts/aks/get-credentials.sh` — convenience
  - `scripts/aks/assign-aad-rbac.sh` — map Entra ID groups to AKS RBAC roles

## How to use

### 1) Provision AKS
```bash
cd terraform/infra/aks
terraform init
terraform apply -var="name_prefix=aipiap"   -var="location=usgovvirginia"   -var="resource_group_name=<rg>"   -var='aad_admin_group_object_ids=["<GUID-PLATFORM-ADMINS>"]'   -var="tags={Program="AI-PIaP",System="Platform",Environment="Prod",Data-Class="Internal"}"
```

Outputs include:
- `aks_oidc_issuer_url`
- `workload_identity_client_id`
- `aks_id`

### 2) Bootstrap cluster add-ons
```bash
AKS_RG=<rg> AKS_NAME=<name> AKS_SUBSCRIPTION=<sub> AZURE_KEY_VAULT_NAME=<kv> WORKLOAD_IDENTITY_CLIENT_ID=$(terraform output -raw workload_identity_client_id) scripts/aks/bootstrap.sh
```

### 3) RBAC
Grant Entra ID groups cluster roles:
```bash
AKS_ID=$(terraform output -raw aks_id)
SUBSCRIPTION_ID=<sub>
GROUP_OBJECT_ID=<GUID-PLATFORM-ADMINS>
scripts/aks/assign-aad-rbac.sh
```

### 4) Deploy Backstage
Use the Helm chart provided earlier (step D) with private ingress class `private`. Secrets come from **External Secrets Operator** via the `SecretStore` created here.

## Security posture
- **Private API server** with Private DNS
- **AAD RBAC** (no local admin users)
- **Workload Identity** with UAMI + FIC (no kube secrets for cloud creds)
- **Policy add-on** and example Azure Policies
- Pod Security labels and hardened Ingress controller

## Notes
- Assign resource roles (e.g., Key Vault `Secrets User`) to the **workload UAMI** to grant Backstage-only permissions.
- If enabling Defender (`enable_defender=true`), ensure billing implications are accepted at the subscription.

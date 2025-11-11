# AKS Private Cluster (Terraform)

This module provisions:
- VNet with AKS and Private Endpoint subnets
- **Private** AKS cluster with AAD RBAC, OIDC, Workload Identity
- Log Analytics + Defender (optional)
- Azure Policy add-on + sample secure-baseline assignments
- User-Assigned Managed Identity (UAMI) for Workload Identity
- Federated Identity Credential for ServiceAccount `backstage/backstage-sa`

**Outputs** expose OIDC issuer URL and UAMI client ID for wiring to Kubernetes ServiceAccounts.

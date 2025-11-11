# D. Deployment (Kubernetes + Helm) — Backstage (App + Backend)

This Helm chart deploys the Backstage **backend** and **app** with hardened security defaults,
private ingress support, HPA/PDB, NetworkPolicies, and configmap-driven `app-config.production.yaml`.
It expects Kubernetes Secrets named `backstage-db` and `backstage-app` (from step C) to provide
database creds and app secrets via External Secrets Operator.

## Prereqs
- Kubernetes 1.25+ (PSA/PodSecurity labels supported)
- External Secrets Operator installed and the secrets from step C applied
- Ingress controller (private class), TLS secret in the Backstage namespace
- Images built/pushed for backend and app

## Install
```bash
helm upgrade --install backstage charts/backstage -n backstage --create-namespace   -f charts/backstage/values-prod.yaml
```

## Key values
- `images.*` — image repositories/tags for backend and app
- `ingress.*` — enable private ingress & DNS hosts
- `appConfig.productionYaml` — rendered directly into ConfigMap and mounted to both pods
- `serviceAccount.annotations` — set `azure.workload.identity/client-id` for AKS Workload Identity

## Secrets expected
- `backstage-db`: POSTGRES_HOST, POSTGRES_PORT, POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB
- `backstage-app`: BACKEND_AUTH_SECRET, MSFT_CLIENT_ID, MSFT_CLIENT_SECRET, MSFT_TENANT_ID, GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET, AZURE_STORAGE_ACCOUNT, AZURE_STORAGE_KEY, TECHDOCS_CONTAINER

## Security
- Distroless backend image, non-root (uid/gid 10001), read-only FS, dropped capabilities
- Pod Security set via namespace labels (baseline)
- NetworkPolicy deny-by-default with optional egress allows
- PDB and HPA for resilience

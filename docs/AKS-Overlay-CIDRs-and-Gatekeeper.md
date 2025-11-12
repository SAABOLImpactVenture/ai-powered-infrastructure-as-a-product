# Pre-wire AKS egress CIDRs (Postgres/Key Vault) + Gatekeeper enforcement for mTLS Secret

This add-on provides:
1) **scripts/aks/generate-aks-overlay.sh** — resolves exact Private Endpoint IPs for **Postgres** and **Key Vault** and generates
   `charts/backstage/values-aks-overlay.prod.yaml` with `/32` CIDRs under `networkPolicy.egressAllowCIDRs`.
2) **Gatekeeper** policy to require the `backstage-mtls` Secret to be mounted by Deployments in **prod** namespaces.

## Generate overlay with exact CIDRs
```bash
AZ_SUBSCRIPTION_ID=<sub> AZ_RESOURCE_GROUP=<rg-with-private-endpoints> PG_PE_NAME=<pg-private-endpoint-name> KV_PE_NAME=<kv-private-endpoint-name> WORKLOAD_IDENTITY_CLIENT_ID=$(terraform -chdir=terraform/infra/aks output -raw workload_identity_client_id) PROXY_IPS="10.50.0.10,10.50.0.11" scripts/aks/generate-aks-overlay.sh
```

This writes `charts/backstage/values-aks-overlay.prod.yaml` with **precise** egress allow CIDRs for the Postgres and Key Vault PEs.

## Enforce `backstage-mtls` Secret in prod with Gatekeeper
1. Install Gatekeeper (already included in AKS bootstrap), then apply template + constraint:
```bash
kubectl apply -f k8s/aks/gatekeeper/ct-required-secret-volume.yaml
kubectl apply -f k8s/aks/gatekeeper/require-backstage-mtls-secret.yaml
```

2. Label your Backstage namespace as production:
```bash
scripts/aks/label-namespace-prod.sh backstage
```

Any **Deployment** in namespaces labeled `workload.env=prod` will be denied unless it mounts a volume of type Secret
with `secretName: backstage-mtls`.

## Deploy with the generated overlay
```bash
helm upgrade --install backstage charts/backstage -n backstage   -f charts/backstage/values-prod.yaml   -f charts/backstage/values-aks-overlay.prod.yaml
```

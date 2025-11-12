#!/usr/bin/env bash
set -euo pipefail

NAMESPACE_BACKSTAGE=${NAMESPACE_BACKSTAGE:-backstage}
AKS_RG="${AKS_RG:?}"
AKS_NAME="${AKS_NAME:?}"
AKS_SUBSCRIPTION="${AKS_SUBSCRIPTION:?}"
AZURE_KEY_VAULT_NAME="${AZURE_KEY_VAULT_NAME:?}"
WORKLOAD_IDENTITY_CLIENT_ID="${WORKLOAD_IDENTITY_CLIENT_ID:?}"

echo "[1/6] Get AKS credentials"
az account set --subscription "${AKS_SUBSCRIPTION}"
az aks get-credentials -g "${AKS_RG}" -n "${AKS_NAME}" --admin --overwrite-existing

echo "[2/6] Install NGINX Ingress (internal)"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --create-namespace   -f k8s/aks/bootstrap/ingress-nginx-values.yaml

echo "[3/6] Install External Secrets Operator"
helm repo add external-secrets https://charts.external-secrets.io
helm upgrade --install external-secrets external-secrets/external-secrets -n external-secrets --create-namespace

echo "[4/6] Prepare namespaces and ServiceAccount with Workload Identity annotation"
kubectl apply -f k8s/aks/bootstrap/00-namespaces.yaml
# Render the SA with provided client ID
envsubst < k8s/aks/bootstrap/01-backstage-sa.yaml | kubectl apply -f -

echo "[5/6] Create SecretStore pointing to Key Vault"
AZURE_KEY_VAULT_NAME="${AZURE_KEY_VAULT_NAME}" envsubst < k8s/aks/bootstrap/02-eso-secretstore.yaml | kubectl apply -f -

echo "[6/6] (Optional) Install Gatekeeper for extra policy guardrails"
helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
helm upgrade --install gatekeeper gatekeeper/gatekeeper -n gatekeeper-system --create-namespace

echo "Bootstrap completed."

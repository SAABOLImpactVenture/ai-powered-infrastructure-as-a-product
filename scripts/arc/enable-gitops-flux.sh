#!/usr/bin/env bash
set -euo pipefail
#
# Enable GitOps (Flux v2) on an Arc-connected cluster and create a k8s-configuration
# that syncs from this repository.
#
# Required env:
#   AZ_SUBSCRIPTION_ID
#   AZ_RESOURCE_GROUP
#   ARC_CLUSTER_NAME
#   LOCATION
#   GIT_URL                     - HTTPS URL to this repo (or SSH)
#   GIT_BRANCH                  - Branch to sync (e.g., main)
#   GIT_PATHS                   - Comma-separated repo-relative paths to Kustomizations (e.g., gitops/arc/cluster,gitops/arc/apps)
#
# Optional:
#   CONFIG_NAME                 - Name for the configuration (default: backstage-platform)
#   GIT_USERNAME, GIT_PASSWORD  - If using HTTPS basic auth
#   GIT_SSH_KEY_B64             - Base64 private key for SSH auth
#
: "${AZ_SUBSCRIPTION_ID:?}"
: "${AZ_RESOURCE_GROUP:?}"
: "${ARC_CLUSTER_NAME:?}"
: "${LOCATION:?}"
: "${GIT_URL:?}"
: "${GIT_BRANCH:?}"
: "${GIT_PATHS:?}"

CONFIG_NAME="${CONFIG_NAME:-backstage-platform}"

az account set --subscription "${AZ_SUBSCRIPTION_ID}"

echo "Ensuring Flux extension is installed..."
az k8s-extension create   --name flux   --cluster-name "${ARC_CLUSTER_NAME}"   --resource-group "${AZ_RESOURCE_GROUP}"   --cluster-type connectedClusters   --extension-type microsoft.flux   --scope cluster   --release-train stable   --auto-upgrade-minor-version true || true

echo "Creating Flux configuration ${CONFIG_NAME} ..."
AUTH_ARGS=()
if [ -n "${GIT_USERNAME:-}" ] && [ -n "${GIT_PASSWORD:-}" ]; then
  AUTH_ARGS+=(--https-user "${GIT_USERNAME}" --https-key "${GIT_PASSWORD}")
fi
if [ -n "${GIT_SSH_KEY_B64:-}" ]; then
  AUTH_ARGS+=(--ssh-private-key "${GIT_SSH_KEY_B64}")
fi

IFS=',' read -ra PATHS <<< "${GIT_PATHS}"
for p in "${PATHS[@]}"; do
  NAME_SAFE="$(echo "${p}" | tr '/_' '-')"
  az k8s-configuration flux create     --cluster-name "${ARC_CLUSTER_NAME}"     --resource-group "${AZ_RESOURCE_GROUP}"     --cluster-type connectedClusters     --name "${CONFIG_NAME}-${NAME_SAFE}"     --namespace "flux-system"     --scope cluster     --url "${GIT_URL}"     --branch "${GIT_BRANCH}"     --kustomization name="${NAME_SAFE}" path="./${p}" prune=true     "${AUTH_ARGS[@]}"
done

echo "Flux configurations:"
az k8s-configuration flux list -g "${AZ_RESOURCE_GROUP}" -c "${ARC_CLUSTER_NAME}" --cluster-type connectedClusters -o table

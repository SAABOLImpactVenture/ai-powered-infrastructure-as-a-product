#!/usr/bin/env bash
set -euo pipefail
#
# Connect an existing Kubernetes cluster to Azure Arc.
#
# Required env:
#   AZ_SUBSCRIPTION_ID    - Subscription ID
#   AZ_RESOURCE_GROUP     - Resource Group to create the connected cluster
#   ARC_CLUSTER_NAME      - Desired name for the Arc-connected cluster
#   LOCATION              - Azure region for metadata (e.g., eastus or usgovvirginia)
#
# Optional:
#   CONNECT_TAGS          - 'key=value key2=value2' (space-separated) tags
#
# Requires: az CLI logged in with sufficient permissions and kubeconfig pointing to the target cluster.
#
: "${AZ_SUBSCRIPTION_ID:?}"
: "${AZ_RESOURCE_GROUP:?}"
: "${ARC_CLUSTER_NAME:?}"
: "${LOCATION:?}"

az account set --subscription "${AZ_SUBSCRIPTION_ID}"
az group create -n "${AZ_RESOURCE_GROUP}" -l "${LOCATION}" >/dev/null

echo "Connecting cluster to Azure Arc as ${ARC_CLUSTER_NAME} ..."
TAG_ARGS=()
if [ -n "${CONNECT_TAGS:-}" ]; then
  IFS=' ' read -ra KV <<< "${CONNECT_TAGS}"
  for pair in "${KV[@]}"; do TAG_ARGS+=(--tags "$pair"); done
fi

az connectedk8s connect   --name "${ARC_CLUSTER_NAME}"   --resource-group "${AZ_RESOURCE_GROUP}"   --location "${LOCATION}"   "${TAG_ARGS[@]}"

echo "Connected cluster resource:"
az connectedk8s show -n "${ARC_CLUSTER_NAME}" -g "${AZ_RESOURCE_GROUP}" -o table

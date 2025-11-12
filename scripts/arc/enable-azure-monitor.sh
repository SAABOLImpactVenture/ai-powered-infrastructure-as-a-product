#!/usr/bin/env bash
set -euo pipefail
#
# Enable Azure Monitor Container Insights (AMA) on Arc-connected Kubernetes.
#
# Required env:
#   AZ_SUBSCRIPTION_ID
#   AZ_RESOURCE_GROUP
#   ARC_CLUSTER_NAME
#   LAW_RESOURCE_ID           - Log Analytics Workspace resource ID
#
: "${AZ_SUBSCRIPTION_ID:?}"
: "${AZ_RESOURCE_GROUP:?}"
: "${ARC_CLUSTER_NAME:?}"
: "${LAW_RESOURCE_ID:?}"

az account set --subscription "${AZ_SUBSCRIPTION_ID}"

echo "Installing Azure Monitor containers extension..."
az k8s-extension create   --name azuremonitor-containers   --cluster-name "${ARC_CLUSTER_NAME}"   --resource-group "${AZ_RESOURCE_GROUP}"   --cluster-type connectedClusters   --extension-type Microsoft.AzureMonitor.Containers   --configuration-settings logAnalyticsWorkspaceResourceID="${LAW_RESOURCE_ID}"   --configuration-settings amalogs.stdout=true || true

az k8s-extension show -n azuremonitor-containers -c "${ARC_CLUSTER_NAME}" -g "${AZ_RESOURCE_GROUP}" --cluster-type connectedClusters -o table

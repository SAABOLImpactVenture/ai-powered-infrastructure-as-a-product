#!/usr/bin/env bash
set -euo pipefail
#
# Enable Azure Policy add-on for Arc K8s and assign built-in initiative.
#
# Required env:
#   AZ_SUBSCRIPTION_ID
#   AZ_RESOURCE_GROUP
#   ARC_CLUSTER_NAME
#   POLICY_ASSIGNMENT_NAME     - Name for the assignment
#   POLICY_DEFINITION_ID       - Definition or initiative ID (e.g., built-in "Kubernetes cluster pod security baseline")
#
: "${AZ_SUBSCRIPTION_ID:?}"
: "${AZ_RESOURCE_GROUP:?}"
: "${ARC_CLUSTER_NAME:?}"
: "${POLICY_ASSIGNMENT_NAME:?}"
: "${POLICY_DEFINITION_ID:?}"

az account set --subscription "${AZ_SUBSCRIPTION_ID}"

echo "Installing Azure Policy extension on Arc cluster..."
az k8s-extension create   --name azurepolicy   --cluster-name "${ARC_CLUSTER_NAME}"   --resource-group "${AZ_RESOURCE_GROUP}"   --cluster-type connectedClusters   --extension-type Microsoft.Azure.PolicyInsights || true

SCOPE="$(az connectedk8s show -n "${ARC_CLUSTER_NAME}" -g "${AZ_RESOURCE_GROUP}" --query id -o tsv)"

echo "Assigning policy ${POLICY_DEFINITION_ID} to scope ${SCOPE} ..."
az policy assignment create   --name "${POLICY_ASSIGNMENT_NAME}"   --scope "${SCOPE}"   --policy "${POLICY_DEFINITION_ID}"   --enforcement-mode Default

az policy assignment list --scope "${SCOPE}" -o table

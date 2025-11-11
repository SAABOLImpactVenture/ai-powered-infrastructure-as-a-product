#!/usr/bin/env bash
set -euo pipefail
# Assign AKS RBAC roles to Entra ID groups at the cluster scope.
AKS_ID="${AKS_ID:?}"
SUBSCRIPTION_ID="${SUBSCRIPTION_ID:?}"
GROUP_OBJECT_ID="${GROUP_OBJECT_ID:?}"
ROLE_NAME="${ROLE_NAME:-Azure Kubernetes Service RBAC Cluster Admin}"

az role assignment create   --assignee-object-id "${GROUP_OBJECT_ID}"   --assignee-principal-type Group   --role "${ROLE_NAME}"   --scope "${AKS_ID}"

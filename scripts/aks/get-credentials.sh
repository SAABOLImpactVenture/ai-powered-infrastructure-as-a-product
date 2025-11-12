#!/usr/bin/env bash
set -euo pipefail
AKS_RG="${AKS_RG:?}"
AKS_NAME="${AKS_NAME:?}"
AKS_SUBSCRIPTION="${AKS_SUBSCRIPTION:?}"
az account set --subscription "${AKS_SUBSCRIPTION}"
az aks get-credentials -g "${AKS_RG}" -n "${AKS_NAME}" --admin --overwrite-existing

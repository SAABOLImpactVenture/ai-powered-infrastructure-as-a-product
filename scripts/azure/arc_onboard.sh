#!/usr/bin/env bash
set -euo pipefail
# Simple helper for Azure Arc server onboarding (Linux). Requires az login with permissions.

if [ $# -lt 3 ]; then
  echo "Usage: $0 <resource-group> <arc-machine-name> <region>"
  exit 1
fi

RG="$1"; NAME="$2"; LOC="$3"

echo ">> Creating resource group (if missing)"
az group create -n "$RG" -l "$LOC" 1>/dev/null

echo ">> Installing azcmagent (if needed)"
if ! command -v azcmagent >/dev/null 2>&1; then
  curl -sSL https://aka.ms/InstallAzureArcAgent | bash
fi

echo ">> Connecting this machine to Azure Arc"
sudo azcmagent connect   --resource-group "$RG"   --location "$LOC"   --name "$NAME"

echo ">> Connected. Verify in Azure Portal: Azure Arc > Machines"

#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 3 ]; then
  echo "Usage: $0 <resource-group> <location> <workspace-name> [dcr-name]"
  exit 1
fi

RG="$1"; LOC="$2"; WS="$3"; DCR="${4:-iaap-dcr}"

echo ">> Ensuring resource group $RG in $LOC"
az group create -n "$RG" -l "$LOC" 1>/dev/null

echo ">> Deploying workspace + DCR"
az deployment group create -g "$RG"   --name "iaap-la-dcr-$(date +%s)"   --template-file iac/azure/main.bicep   --parameters workspaceName="$WS" location="$LOC" dcrName="$DCR"

echo ">> Done."

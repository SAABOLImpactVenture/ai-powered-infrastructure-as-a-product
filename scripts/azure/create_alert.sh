#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 3 ]; then
  echo "Usage: $0 <resource-group> <workspace-resource-id> <alert-json-path>"
  exit 1
fi

RG="$1"; WS_ID="$2"; FILE="$3"
TMP="$(mktemp)"
sed "s#<REPLACE_WITH_WORKSPACE_RESOURCE_ID>#$WS_ID#g" "$FILE" > "$TMP"

NAME="iaap-alert-$(basename "$FILE" .json)-$(date +%s)"
LOC=$(az group show -n "$RG" --query location -o tsv)

echo ">> Creating alert from $FILE"
az resource create   --resource-group "$RG"   --namespace "microsoft.insights"   --resource-type "scheduledqueryrules"   --name "$NAME"   --is-full-object   --location "$LOC"   --properties @"$TMP"

echo ">> Created alert $NAME"
rm -f "$TMP"

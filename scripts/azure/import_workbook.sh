#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <resource-group> <workbook-json-path>"
  exit 1
fi

RG="$1"; FILE="$2"
NAME="iaap-$(basename "$FILE" .json)-$(date +%s)"

SUB=$(az account show --query id -o tsv)
LOC=$(az group show -n "$RG" --query location -o tsv)

echo ">> Importing workbook from $FILE"
az monitor workbook create   --resource-group "$RG"   --location "$LOC"   --name "$NAME"   --display-name "$NAME"   --category "workbook"   --serialized "$(cat "$FILE")"

echo ">> Created workbook $NAME"

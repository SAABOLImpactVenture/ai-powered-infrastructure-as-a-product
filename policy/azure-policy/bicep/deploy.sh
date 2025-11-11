#!/usr/bin/env bash
set -euo pipefail
SUB_ID=${1:-""}
LOCATION=${2:-eastus}

if [[ -z "$SUB_ID" ]]; then
  echo "Usage: $0 <SUBSCRIPTION_ID> [location]" >&2
  exit 1
fi

az account set --subscription "$SUB_ID"

echo ">> Deploying policy definitions..."
DEF_OUT=$(az deployment sub create   --name iaap-policy-defs   --location "$LOCATION"   --template-file definitions.bicep   --only-show-errors -o json)

REQUIRE_TAGS_DEF_ID=$(echo "$DEF_OUT" | jq -r '.properties.outputs.requireTagsId.value')
ALLOWED_LOCS_DEF_ID=$(echo "$DEF_OUT" | jq -r '.properties.outputs.allowedLocationsId.value')

echo "Definitions:"
echo "  require-tags:      $REQUIRE_TAGS_DEF_ID"
echo "  allowed-locations: $ALLOWED_LOCS_DEF_ID"

echo ">> Deploying assignments..."
az deployment sub create   --name iaap-policy-assignments   --location "$LOCATION"   --template-file assignments.bicep   --parameters requireTagsDefinitionId="$REQUIRE_TAGS_DEF_ID"                allowedLocationsDefinitionId="$ALLOWED_LOCS_DEF_ID"   --only-show-errors

echo "Done."

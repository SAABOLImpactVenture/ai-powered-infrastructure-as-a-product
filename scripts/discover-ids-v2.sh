#!/usr/bin/env bash
set -euo pipefail

# discover-ids-v2.sh
# Reads or creates IDs needed for GitHub Secrets.
# Accepts subscription **names** or **IDs**. If IDs are provided, they take precedence.
#
# Usage (with IDs):
#   ./discover-ids-v2.sh \
#     --tenant-id <TENANT_ID> \
#     --sub-mgmt-id <MGMT_SUB_ID> \
#     --sub-dev-id <DEV_SUB_ID> \
#     --sub-app-id <APP_SUB_ID> \
#     [--app-name aiap-gha] [--create-app] \
#     [--create-storage --rg rg-aiap-platform --location eastus --sa-prefix staiap --state-container tfstate --evidence-container evidence]
#
# Usage (with names):
#   ./discover-ids-v2.sh \
#     --tenant-id <TENANT_ID> \
#     --sub-mgmt-name "Management Sub" \
#     --sub-dev-name "Sandbox Sub" \
#     --sub-app-name "LandingZone App Sub"
#
TENANT_ID=""
SUB_MGMT_ID=""
SUB_DEV_ID=""
SUB_APP_ID=""
SUB_MGMT_NAME=""
SUB_DEV_NAME=""
SUB_APP_NAME=""
APP_NAME="aiap-gha"
CREATE_APP="false"
CREATE_STORAGE="false"
RG="rg-aiap-platform"
LOCATION="eastus"
SA_PREFIX="staiap"
STATE_CONTAINER="tfstate"
EVIDENCE_CONTAINER="evidence"
REPO_SLUG="SAABOLImpactVenture/ai-powered-infrastructure-as-a-product"
BRANCH_REF="refs/heads/main"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tenant-id) TENANT_ID="$2"; shift 2;;
    --sub-mgmt-id) SUB_MGMT_ID="$2"; shift 2;;
    --sub-dev-id) SUB_DEV_ID="$2"; shift 2;;
    --sub-app-id) SUB_APP_ID="$2"; shift 2;;
    --sub-mgmt-name) SUB_MGMT_NAME="$2"; shift 2;;
    --sub-dev-name) SUB_DEV_NAME="$2"; shift 2;;
    --sub-app-name) SUB_APP_NAME="$2"; shift 2;;
    --app-name) APP_NAME="$2"; shift 2;;
    --create-app) CREATE_APP="true"; shift 1;;
    --create-storage) CREATE_STORAGE="true"; shift 1;;
    --rg) RG="$2"; shift 2;;
    --location) LOCATION="$2"; shift 2;;
    --sa-prefix) SA_PREFIX="$2"; shift 2;;
    --state-container) STATE_CONTAINER="$2"; shift 2;;
    --evidence-container) EVIDENCE_CONTAINER="$2"; shift 2;;
    --repo) REPO_SLUG="$2"; shift 2;;
    --branch) BRANCH_REF="$2"; shift 2;;
    -h|--help)
      grep '^# ' "$0" | sed 's/^# //'
      exit 0;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done

# login
az account show >/dev/null 2>&1 || az login --use-device-code >/dev/null

if [[ -z "$TENANT_ID" ]]; then
  TENANT_ID="$(az account show --query tenantId -o tsv)"
fi

# resolve names if IDs not given
resolve_sub_id() {
  local name="$1"
  az account list --query "[?name=='${name}'].id | [0]" -o tsv
}

if [[ -z "$SUB_MGMT_ID" ]]; then
  if [[ -n "$SUB_MGMT_NAME" ]]; then SUB_MGMT_ID="$(resolve_sub_id "$SUB_MGMT_NAME")"; fi
fi
if [[ -z "$SUB_DEV_ID" ]]; then
  if [[ -n "$SUB_DEV_NAME" ]]; then SUB_DEV_ID="$(resolve_sub_id "$SUB_DEV_NAME")"; fi
fi
if [[ -z "$SUB_APP_ID" ]]; then
  if [[ -n "$SUB_APP_NAME" ]]; then SUB_APP_ID="$(resolve_sub_id "$SUB_APP_NAME")"; fi
fi

if [[ -z "$SUB_MGMT_ID" || -z "$SUB_DEV_ID" || -z "$SUB_APP_ID" ]]; then
  echo "ERROR: Missing subscription IDs. Provide --sub-*-id or resolvable --sub-*-name." >&2
  exit 1
fi

# App registration
APP_ID="$(az ad app list --filter "displayName eq '${APP_NAME}'" --query "[0].appId" -o tsv || true)"
if [[ -z "$APP_ID" && "$CREATE_APP" == "true" ]]; then
  APP_ID="$(az ad app create --display-name "$APP_NAME" --query appId -o tsv)"
  az ad app federated-credential create --id "$APP_ID" --parameters "{
    \"name\":\"github-main\",
    \"issuer\":\"https://token.actions.githubusercontent.com\",
    \"subject\":\"repo:${REPO_SLUG}:${BRANCH_REF}\",
    \"audiences\":[\"api://AzureADTokenExchange\"]
  }" >/dev/null
fi

# Storage create (optional)
SA_NAME=""
if [[ "$CREATE_STORAGE" == "true" ]]; then
  az account set --subscription "$SUB_MGMT_ID"
  SA_NAME="${SA_PREFIX}$RANDOM"
  az group create -n "$RG" -l "$LOCATION" >/dev/null
  az storage account create -g "$RG" -n "$SA_NAME" -l "$LOCATION" --sku Standard_LRS --kind StorageV2 --enable-versioning true >/dev/null
  az storage container create --account-name "$SA_NAME" --name "$STATE_CONTAINER" >/dev/null
  az storage container create --account-name "$SA_NAME" --name "$EVIDENCE_CONTAINER" >/dev/null
fi

# Output for GitHub Secrets
echo "AZURE_TENANT_ID=${TENANT_ID}"
[[ -n "$APP_ID" ]] && echo "AZURE_CLIENT_ID=${APP_ID}" || echo "AZURE_CLIENT_ID=<create or supply app id>"
echo "PLATFORM_SUB_ID=${SUB_MGMT_ID}"
echo "DEV_SUB_ID=${SUB_DEV_ID}"
echo "APP_SUB_ID=${SUB_APP_ID}"
if [[ -n "$SA_NAME" ]]; then
  echo "STATE_STORAGE_ACCOUNT=${SA_NAME}"
  echo "STATE_CONTAINER=${STATE_CONTAINER}"
  echo "EVIDENCE_CONTAINER=${EVIDENCE_CONTAINER}"
else
  echo "STATE_STORAGE_ACCOUNT=<storage-account>"
  echo "STATE_CONTAINER=${STATE_CONTAINER}"
  echo "EVIDENCE_CONTAINER=${EVIDENCE_CONTAINER}"
fi

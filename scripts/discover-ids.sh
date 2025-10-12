#!/usr/bin/env bash
set -euo pipefail

# discover-ids.sh
# Reads your Azure IDs for GitHub Secrets. By default, READ-ONLY.
# Use flags to optionally create the Entra App and Storage resources if missing.
#
# Usage:
#   ./discover-ids.sh \
#     --tenant-id <TENANT_ID> \
#     --sub-mgmt-name "Management Sub" \
#     --sub-dev-name "Sandbox Sub" \
#     --sub-app-name "LandingZone App Sub" \
#     [--app-name aiap-gha] \
#     [--create-app] \
#     [--create-storage --rg rg-aiap-platform --location eastus --sa-prefix staiap --state-container tfstate --evidence-container evidence]
#
# Example (read-only):
#   ./discover-ids.sh --tenant-id 00000000-0000-0000-0000-000000000000 \
#     --sub-mgmt-name "Management Sub" --sub-dev-name "Sandbox Sub" --sub-app-name "LandingZone App Sub"
#
# Example (create app + storage if missing):
#   ./discover-ids.sh --tenant-id $AZURE_TENANT_ID \
#     --sub-mgmt-name "Management Sub" --sub-dev-name "Sandbox Sub" --sub-app-name "LandingZone App Sub" \
#     --create-app --create-storage --rg rg-aiap-platform --location eastus --sa-prefix staiap

TENANT_ID=""
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

# --- arg parse ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --tenant-id) TENANT_ID="$2"; shift 2;;
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

# --- login ---
echo ">> Checking Azure CLI login..."
az account show >/dev/null 2>&1 || az login --use-device-code >/dev/null

if [[ -z "$TENANT_ID" ]]; then
  TENANT_ID="$(az account show --query tenantId -o tsv)"
fi
echo "Tenant: $TENANT_ID"

# Helper to get subscription id by display name
get_sub_id() {
  local name="$1"
  az account list --query "[?name=='${name}'].id | [0]" -o tsv
}

SUB_MGMT_ID="$(get_sub_id "$SUB_MGMT_NAME")"
SUB_DEV_ID="$(get_sub_id "$SUB_DEV_NAME")"
SUB_APP_ID="$(get_sub_id "$SUB_APP_NAME")"

if [[ -z "${SUB_MGMT_ID}" || -z "${SUB_DEV_ID}" || -z "${SUB_APP_ID}" ]]; then
  echo "ERROR: Could not resolve one or more subscription IDs. Check the names." >&2
  echo "  MGMT: '$SUB_MGMT_NAME' -> ${SUB_MGMT_ID:-<not found>}" >&2
  echo "  DEV : '$SUB_DEV_NAME' -> ${SUB_DEV_ID:-<not found>}" >&2
  echo "  APP : '$SUB_APP_NAME' -> ${SUB_APP_ID:-<not found>}" >&2
  exit 1
fi

# --- App Registration ---
APP_ID="$(az ad app list --filter "displayName eq '${APP_NAME}'" --query "[0].appId" -o tsv || true)"
if [[ -z "$APP_ID" && "$CREATE_APP" == "true" ]]; then
  echo ">> Creating Entra App '${APP_NAME}'"
  APP_ID="$(az ad app create --display-name "$APP_NAME" --query appId -o tsv)"
  echo ">> Adding federated credential for repo ${REPO_SLUG} / ${BRANCH_REF}"
  az ad app federated-credential create --id "$APP_ID" --parameters "{
    \"name\":\"github-main\",
    \"issuer\":\"https://token.actions.githubusercontent.com\",
    \"subject\":\"repo:${REPO_SLUG}:${BRANCH_REF}\",
    \"audiences\":[\"api://AzureADTokenExchange\"]
  }" >/dev/null
fi
if [[ -z "$APP_ID" ]]; then
  echo "WARN: App '${APP_NAME}' not found and --create-app not set. You can create it later." >&2
fi

# --- Storage & containers (in MGMT sub) ---
SA_NAME=""
if [[ "$CREATE_STORAGE" == "true" ]]; then
  az account set --subscription "$SUB_MGMT_ID"
  SA_NAME="${SA_PREFIX}$RANDOM"
  echo ">> Creating resource group ${RG} (if not exists)"
  az group create -n "$RG" -l "$LOCATION" >/dev/null
  echo ">> Creating storage account ${SA_NAME} in MGMT sub"
  az storage account create -g "$RG" -n "$SA_NAME" -l "$LOCATION" --sku Standard_LRS --kind StorageV2 --enable-versioning true >/dev/null
  az storage container create --account-name "$SA_NAME" --name "$STATE_CONTAINER" >/dev/null
  az storage container create --account-name "$SA_NAME" --name "$EVIDENCE_CONTAINER" >/dev/null
else
  echo ">> Skipping storage creation (use --create-storage to create). If you already have one, set STATE_STORAGE_ACCOUNT manually."
fi

# --- Output ---
echo
echo "==== VALUES FOR GITHUB SECRETS ===="
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
  echo "STATE_STORAGE_ACCOUNT=<your-storage-account-name>"
  echo "STATE_CONTAINER=${STATE_CONTAINER}"
  echo "EVIDENCE_CONTAINER=${EVIDENCE_CONTAINER}"
fi

echo
echo "Tip: set them with GitHub CLI after 'gh auth login':"
cat <<EOF
gh secret set AZURE_TENANT_ID --body "${TENANT_ID}"
gh secret set AZURE_CLIENT_ID --body "<paste-app-id>"
gh secret set PLATFORM_SUB_ID --body "${SUB_MGMT_ID}"
gh secret set DEV_SUB_ID --body "${SUB_DEV_ID}"
gh secret set APP_SUB_ID --body "${SUB_APP_ID}"
gh secret set STATE_STORAGE_ACCOUNT --body "<storage-account>"
gh secret set STATE_CONTAINER --body "${STATE_CONTAINER}"
gh secret set EVIDENCE_CONTAINER --body "${EVIDENCE_CONTAINER}"
EOF

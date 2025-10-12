#!/usr/bin/env bash
set -euo pipefail

# discover-ids-v3.sh  — cloud-aware
# Adds: --cloud (AzureCloud | AzureUSGovernment | AzureChinaCloud | AzureGermanCloud)
# Will: az cloud set, az login (tenant), then proceed like v2 (accepts sub IDs or names).

TENANT_ID=""
CLOUD="AzureCloud"
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
    --cloud) CLOUD="$2"; shift 2;;
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
      cat <<'USAGE'
Usage:
  ./discover-ids-v3.sh --tenant-id <TENANT> --cloud AzureCloud \
    --sub-mgmt-id <ID> --sub-dev-id <ID> --sub-app-id <ID> [--create-app] [--create-storage ...]

Notes:
  - If you pass names instead of IDs (e.g., --sub-mgmt-name "Management Sub"), the script resolves them.
  - --cloud controls which Azure cloud to target (Commercial=AzureCloud, Gov=AzureUSGovernment, China, Germany).
USAGE
      exit 0;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done

# Set cloud and login
current_cloud="$(az cloud show --query name -o tsv 2>/dev/null || echo '')"
if [[ "$current_cloud" != "$CLOUD" ]]; then
  echo ">> Switching cloud: $current_cloud -> $CLOUD"
  az cloud set --name "$CLOUD"
fi
if [[ -z "$TENANT_ID" ]]; then
  echo "ERROR: --tenant-id is required"; exit 1
fi
echo ">> Logging into tenant $TENANT_ID"
az login --tenant "$TENANT_ID" --use-device-code >/dev/null

# Resolve names if IDs not given
resolve_sub_id() {
  local name="$1"
  az account list --query "[?name=='${name}'].id | [0]" -o tsv
}
if [[ -z "$SUB_MGMT_ID" && -n "$SUB_MGMT_NAME" ]]; then SUB_MGMT_ID="$(resolve_sub_id "$SUB_MGMT_NAME")"; fi
if [[ -z "$SUB_DEV_ID"  && -n "$SUB_DEV_NAME"  ]]; then SUB_DEV_ID="$(resolve_sub_id "$SUB_DEV_NAME")"; fi
if [[ -z "$SUB_APP_ID"  && -n "$SUB_APP_NAME"  ]]; then SUB_APP_ID="$(resolve_sub_id "$SUB_APP_NAME")"; fi

if [[ -z "$SUB_MGMT_ID" || -z "$SUB_DEV_ID" || -z "$SUB_APP_ID" ]]; then
  echo "ERROR: Missing subscription IDs. Provide --sub-*-id or resolvable --sub-*-name." >&2
  az account list -o table || true
  exit 1
fi

# App registration
APP_ID="$(az ad app list --filter "displayName eq '${APP_NAME}'" --query "[0].appId" -o tsv || true)"
if [[ -z "$APP_ID" && "$CREATE_APP" == "true" ]]; then
  echo ">> Creating Entra App $APP_NAME"
  APP_ID="$(az ad app create --display-name "$APP_NAME" --query appId -o tsv)"
  echo ">> Adding federated credential for repo ${REPO_SLUG}:${BRANCH_REF}"
  az ad app federated-credential create --id "$APP_ID" --parameters "{
    \"name\":\"github-main\",
    \"issuer\":\"https://token.actions.githubusercontent.com\",
    \"subject\":\"repo:${REPO_SLUG}:${BRANCH_REF}\",
    \"audiences\":[\"api://AzureADTokenExchange\"]
  }" >/dev/null
fi

# Storage (optional)
SA_NAME=""
if [[ "$CREATE_STORAGE" == "true" ]]; then
  echo ">> Creating Storage in MGMT subscription $SUB_MGMT_ID"
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

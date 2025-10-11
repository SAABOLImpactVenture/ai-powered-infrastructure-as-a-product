#!/usr/bin/env bash
set -euo pipefail

# ====== EDIT THESE 5 VALUES ======
TENANT_ID=""                   # e.g. 00000000-0000-0000-0000-000000000000 (leave empty to auto-detect)
SUB_MGMT=""                    # Management Subscription ID
SUB_DEV=""                     # Sandbox Subscription ID
SUB_APP=""                     # LandingZone App Subscription ID
REPO="SAABOLImpactVenture/ai-powered-infrastructure-as-a-product"  # org/repo
BRANCH="refs/heads/main"       # restrict federated credential to main
LOC="eastus"
RG="rg-aiap-platform"
SA="staiap$RANDOM"             # must be globally unique
CT_STATE="tfstate"
CT_EVID="evidence"

# ====== Login & context ======
echo ">> az login (interactive if needed)"
az account show >/dev/null 2>&1 || az login --use-device-code

if [[ -z "${TENANT_ID}" ]]; then
  TENANT_ID="$(az account show --query tenantId -o tsv)"
fi
echo "Tenant: $TENANT_ID"

echo ">> Ensure required subscriptions exist"
for S in "$SUB_MGMT" "$SUB_DEV" "$SUB_APP"; do
  if [[ -z "$S" ]]; then echo "ERROR: set SUB_MGMT, SUB_DEV, SUB_APP"; exit 1; fi
  az account show --subscription "$S" >/dev/null
done

# ====== Platform storage in Management sub ======
echo ">> Creating platform RG and Storage Account in MGMT subscription"
az account set --subscription "$SUB_MGMT"
az group create -n "$RG" -l "$LOC" >/dev/null
az storage account create -g "$RG" -n "$SA" -l "$LOC" --sku Standard_LRS --kind StorageV2 --enable-versioning true >/dev/null
az storage container create --account-name "$SA" --name "$CT_STATE" >/dev/null
az storage container create --account-name "$SA" --name "$CT_EVID" >/dev/null

# Optional immutability (90 days, append-only)
az storage container immutability-policy create   --account-name "$SA" --container-name "$CT_EVID"   --period 90 --allow-protected-append-writes true >/dev/null || true

# ====== App registration + Federated Credential (GitHub OIDC) ======
echo ">> Creating Entra App for GitHub OIDC"
APP_ID=$(az ad app create --display-name "aiap-gha" --query appId -o tsv)
echo "APP_ID: $APP_ID"
az ad app federated-credential create --id "$APP_ID" --parameters "{
  \"name\":\"github-main\",
  \"issuer\":\"https://token.actions.githubusercontent.com\",
  \"subject\":\"repo:${REPO}:${BRANCH}\",
  \"audiences\":[\"api://AzureADTokenExchange\"]
}" >/dev/null
SP_ID=$(az ad sp list --filter "appId eq '$APP_ID'" --query "[0].id" -o tsv)

# ====== RBAC assignments ======
echo ">> Assigning RBAC"
SA_ID=$(az storage account show -g "$RG" -n "$SA" --query id -o tsv)

# Data-plane: Storage Blob Data Contributor on each container
for CT in "$CT_STATE" "$CT_EVID"; do
  SCOPE="$SA_ID/blobServices/default/containers/$CT"
  az role assignment create     --assignee-object-id "$SP_ID" --assignee-principal-type ServicePrincipal     --role "Storage Blob Data Contributor" --scope "$SCOPE" >/dev/null
done

# Management-plane: Contributor on DEV and APP subs (tighten later)
for SUB in "$SUB_DEV" "$SUB_APP"; do
  az role assignment create     --assignee-object-id "$SP_ID" --assignee-principal-type ServicePrincipal     --role "Contributor" --scope "/subscriptions/$SUB" >/dev/null
done

echo
echo "==== OUTPUT (save these as GitHub Variables) ===="
echo "AZURE_TENANT_ID=$TENANT_ID"
echo "AZURE_CLIENT_ID=$APP_ID"
echo "PLATFORM_SUB_ID=$SUB_MGMT"
echo "DEV_SUB_ID=$SUB_DEV"
echo "APP_SUB_ID=$SUB_APP"
echo "STATE_STORAGE_ACCOUNT=$SA"
echo "STATE_CONTAINER=$CT_STATE"
echo "EVIDENCE_CONTAINER=$CT_EVID"

#!/usr/bin/env bash
set -euo pipefail

# Golden Path demo:
# 1) Run pytest (validates emitters)
# 2) Run Terraform offline MVP (emits local evidence)
# 3) (Optional) If AZURE env present: import dashboards and configure alerts

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

echo "==[1/3] Tests =="#
if command -v pytest >/dev/null 2>&1; then
  pytest -q || { echo "Tests failed"; exit 1; }
else
  echo "pytest not installed, skipping tests."
fi

echo "==[2/3] Terraform MVP (offline) =="#
pushd examples/mvps/mvp-03-terraform-null-resource >/dev/null
terraform init -input=false
terraform apply -auto-approve
popd >/dev/null

echo "Evidence written to .local-outbox/"
ls -1 .local-outbox || true

echo "==[3/3] Optional Azure steps =="#
if command -v az >/dev/null 2>&1 && [ -n "${IAAP_RG:-}" ] && [ -n "${IAAP_LOC:-}" ] && [ -n "${IAAP_WS:-}" ]; then
  echo "Azure detected; deploying workspace + DCR to RG=$IAAP_RG LOC=$IAAP_LOC WS=$IAAP_WS"
  chmod +x scripts/azure/*.sh || true
  ./scripts/azure/deploy_la_dcr.sh "$IAAP_RG" "$IAAP_LOC" "$IAAP_WS"
  # Import workbooks
  ./scripts/azure/import_workbook.sh "$IAAP_RG" dashboards/workbooks/iaap-evidence-workbook.json || true
  ./scripts/azure/import_workbook.sh "$IAAP_RG" dashboards/workbooks/aoai-requests-workbook.json || true
  # Create alerts
  WS_ID=$(az monitor log-analytics workspace show -g "$IAAP_RG" -n "$IAAP_WS" --query id -o tsv)
  ./scripts/azure/create_alert.sh "$IAAP_RG" "$WS_ID" docs/observability/ops-alerts/drift-freshness-alert.json || true
  ./scripts/azure/create_alert.sh "$IAAP_RG" "$WS_ID" docs/observability/ops-alerts/failure-alert.json || true
else
  echo "Azure not configured or env vars missing; skipping cloud steps."
  echo "Set IAAP_RG, IAAP_LOC, IAAP_WS to enable."
fi

echo "Golden Path completed."

#!/usr/bin/env bash
set -euo pipefail
NAMESPACE=${1:-backstage}
kubectl label namespace "${NAMESPACE}" workload.env=prod --overwrite
echo "Labeled namespace ${NAMESPACE} with workload.env=prod"

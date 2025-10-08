#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

echo "Simulating failure evidence..."
python scripts/emitters/infra-evidence/emit_evidence_to_log_analytics.py   --kind "drill" --status "failure" --detail "simulated failure"

echo "If cloud ingestion is enabled via DCR, alerts should fire within the next evaluation window."
echo "Local evidence saved under .local-outbox/"

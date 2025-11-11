#!/usr/bin/env bash
set -euo pipefail

RUN_ID="${1:-local}"
OUT="evidence/${RUN_ID}"
mkdir -p "$OUT"

# Copy known outputs if present
cp -R artifacts/. "$OUT"/artifacts 2>/dev/null || true
cp -R reports/. "$OUT"/reports 2>/dev/null || true

echo "Collected evidence into $OUT"

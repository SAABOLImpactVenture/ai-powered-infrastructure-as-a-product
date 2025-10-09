#!/usr/bin/env bash
set -euo pipefail
proj="${1:-$GOOGLE_CLOUD_PROJECT}"
if ! command -v gcloud >/dev/null; then echo "gcloud not found; skipping"; exit 0; fi
if [ -z "${proj:-}" ]; then echo "Set GOOGLE_CLOUD_PROJECT"; exit 1; fi
echo "Checking GCP compute quotas for $proj..."
gcloud compute regions list --project "$proj" >/dev/null && echo "OK: compute API reachable"

#!/usr/bin/env bash
set -euo pipefail
echo "Verifying observability backends are reachable (best-effort checks)"
if command -v az >/dev/null; then
  echo "Azure Monitor check: listing workspaces"
  az monitor log-analytics workspace list >/dev/null || echo "WARN: cannot list Log Analytics workspaces"
fi
if command -v aws >/dev/null; then
  echo "AWS CloudWatch check: describing log groups"
  aws logs describe-log-groups --max-items 5 >/dev/null || echo "WARN: cannot reach CloudWatch Logs"
fi
if command -v gcloud >/dev/null; then
  echo "GCP Logging check: listing sinks"
  gcloud logging sinks list >/dev/null || echo "WARN: cannot reach Cloud Logging"
fi

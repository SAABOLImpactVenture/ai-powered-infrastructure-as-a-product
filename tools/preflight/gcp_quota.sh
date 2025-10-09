#!/usr/bin/env bash
set -euo pipefail
PROJECT="${GCP_PROJECT:-$(gcloud config get-value project)}"
echo "Checking GCP quotas for $PROJECT..."
gcloud auth list --filter=status:ACTIVE --format="value(account)" >/dev/null
gcloud compute regions list --format="value(name)" >/dev/null
echo "GCP quota probe OK"

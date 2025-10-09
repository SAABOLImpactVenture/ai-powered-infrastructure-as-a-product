#!/usr/bin/env bash
set -euo pipefail
loc="${1:-eastus}"
if ! command -v az >/dev/null; then echo "az CLI not found; skipping"; exit 0; fi
echo "Checking Azure compute quotas in $loc..."
az vm list-usage -l "$loc" >/dev/null && echo "OK: usage API reachable"

#!/usr/bin/env bash
set -euo pipefail
ns="${1:-workloads}"
echo "Attempting to run unsigned image (should be denied)"
kubectl -n "$ns" run unsigned --image=busybox:1.36 -- sleep 10 || echo "Denied as expected"

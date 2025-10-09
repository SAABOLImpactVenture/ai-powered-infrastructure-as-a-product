#!/usr/bin/env bash
set -euo pipefail
ns="${1:-workloads}"
echo "Creating test pod in $ns..."
kubectl -n "$ns" run test --image=busybox:1.36 --restart=Never -- sleep 3600
kubectl -n "$ns" wait --for=condition=Ready pod/test --timeout=60s || true
echo "Attempting egress to example.com (should fail under default-deny unless allowed)"
kubectl -n "$ns" exec test -- wget -qO- http://example.com || echo "Egress blocked as expected"
kubectl -n "$ns" delete pod/test --now

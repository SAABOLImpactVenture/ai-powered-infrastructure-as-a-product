#!/usr/bin/env bash
set -euo pipefail

# Install/upgrade Gatekeeper using Helm and apply policies via Kustomize.
# Requires: helm, kubectl, kustomize (kubectl kustomize is ok)

echo "[1/3] Installing/upgrading Gatekeeper (Helm)"
helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts >/dev/null
helm upgrade --install gatekeeper gatekeeper/gatekeeper -n gatekeeper-system --create-namespace   -f helm/gatekeeper/values.yaml

echo "[2/3] Applying Gatekeeper config & templates/constraints (Kustomize)"
kubectl kustomize k8s/policy/gatekeeper/base | kubectl apply -f -

echo "[3/3] Verifying Gatekeeper status"
kubectl -n gatekeeper-system get pods -l app=gatekeeper
kubectl get constrainttemplates
kubectl get constraints --all-namespaces || true

echo "Gatekeeper installation and policy application completed."

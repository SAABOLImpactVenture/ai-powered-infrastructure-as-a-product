#!/usr/bin/env bash
set -euo pipefail
# Derive a semver-ish tag and unique SHA tag for CI
SHA="${GITHUB_SHA:-$(git rev-parse HEAD)}"
REF="${GITHUB_REF_NAME:-$(git symbolic-ref --short -q HEAD || echo dev)}"
DATE="$(date -u +%Y%m%d%H%M%S)"
SAFE_REF="$(echo "$REF" | tr '/' '-' | tr -cd '[:alnum:]-._')"
echo "sha=${SHA::12}"
echo "ref=${SAFE_REF}"
echo "date=${DATE}"
echo "version=${SAFE_REF}-${DATE}-${SHA::12}"

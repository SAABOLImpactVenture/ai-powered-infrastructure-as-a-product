#!/usr/bin/env bash
set -euo pipefail
# Usage: tools/tf/init.sh <backend.hcl> <module_path>
if [ $# -lt 2 ]; then
  echo "Usage: $0 backend.hcl path/to/module"; exit 2
fi
BACKEND="$1"; MOD="$2"
cd "$MOD"
terraform init -input=false -backend-config="$BACKEND"

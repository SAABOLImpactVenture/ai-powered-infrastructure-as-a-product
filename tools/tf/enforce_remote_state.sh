#!/usr/bin/env bash
set -euo pipefail
MOD="${1:-.}"
if [ -f "$MOD/terraform.tfstate" ] || [ -d "$MOD/.terraform" ] && [ -f "$MOD/.terraform/terraform.tfstate" ]; then
  echo "❌ Local state detected in $MOD. Governed modules must use remote, locked backends." >&2
  exit 1
fi
echo "✅ No local state detected in $MOD"

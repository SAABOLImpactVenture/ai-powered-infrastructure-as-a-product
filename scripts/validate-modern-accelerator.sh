#!/usr/bin/env bash
set -euo pipefail

forbidden_roots=(
  terraform iac backstage backstage-custom-actions backstage-plugins
  packages plugins custom-actions mcp servers charts catalog gitops
  platform identity dr orchestration workloads
)

for path in "${forbidden_roots[@]}"; do
  if [[ -e "$path" ]]; then
    echo "ERROR: superseded implementation path present: $path" >&2
    exit 1
  fi
done

if find . -type f \( -name '*.tf' -o -name '*.tfvars' -o -name '.terraform.lock.hcl' \) -print -quit | grep -q .; then
  echo "ERROR: Terraform implementation artifacts are not part of the maintained accelerator." >&2
  find . -type f \( -name '*.tf' -o -name '*.tfvars' -o -name '.terraform.lock.hcl' \) -print >&2
  exit 1
fi

echo "Modern accelerator boundary validated."

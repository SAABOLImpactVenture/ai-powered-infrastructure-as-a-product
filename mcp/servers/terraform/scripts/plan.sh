#!/usr/bin/env bash
set -euo pipefail
cd "${1:-.}"
terraform init -input=false -upgrade
terraform plan -input=false -out=tfplan
terraform show -json tfplan > plan.json

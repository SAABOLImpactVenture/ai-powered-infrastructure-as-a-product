#!/usr/bin/env bash
set -euo pipefail
region="${1:-${AWS_REGION:-us-east-1}}"
if ! command -v aws >/dev/null; then echo "aws CLI not found; skipping"; exit 0; fi
echo "Checking AWS EC2 vCPU quotas in $region..."
aws service-quotas get-service-quota --service-code ec2 --quota-code L-1216C47A --region "$region" >/dev/null && echo "OK: quota API reachable"

#!/usr/bin/env bash
set -euo pipefail
REGION="${AWS_REGION:-us-east-1}"
echo "Checking AWS quotas in $REGION..."
aws sts get-caller-identity >/dev/null
aws service-quotas list-service-quotas --service-code ec2 --max-results 10 --region "$REGION" >/dev/null
echo "AWS quota probe OK"

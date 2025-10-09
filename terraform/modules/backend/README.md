# Remote State Backends (Hardened)

This directory provisions **secure, locked, CMK-backed** Terraform state for Azure, AWS, and GCP and emits a ready-to-paste `backend` block.

## Quick start

```bash
# Azure
terraform -chdir=terraform/modules/backend/azure apply   -var 'name_prefix=platform' -var 'location=eastus' -var 'vnet_subnet_id=/subscriptions/.../subnets/backends'

# AWS
terraform -chdir=terraform/modules/backend/aws apply   -var 'region=us-east-1' -var 'bucket_name=platform-tfstate-123456'

# GCP
terraform -chdir=terraform/modules/backend/gcp apply   -var 'project_id=my-proj' -var 'bucket_name=platform-tfstate' -var 'kms_key=projects/.../cryptoKeys/...'
```

Then **copy** the printed `backend` block into each governed module's `backend.tf`. Local state in governed paths is **denied** by policy.

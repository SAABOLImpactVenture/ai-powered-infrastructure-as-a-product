
# GCP Organization Policy Pack

Applies two strong org policies at the project level:
- `compute.disableSerialPortAccess`: Enforce
- `compute.vmExternalIpAccess`: Deny all external IPs

Usage:
```bash
terraform -chdir=policies/gcp/org-policy init
terraform -chdir=policies/gcp/org-policy apply -var="project_id=<PROJECT_ID>"
```

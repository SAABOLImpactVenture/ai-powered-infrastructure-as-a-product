
# OCI IAM Policy Pack

Adds deny statements to prevent anonymous (any-user) access to buckets and objects
in a target compartment.

Usage:
```bash
terraform -chdir=policies/oci/iam-policies init
terraform -chdir=policies/oci/iam-policies apply -var="compartment_ocid=<OCID>" -var="name=baseline-deny-public"
```

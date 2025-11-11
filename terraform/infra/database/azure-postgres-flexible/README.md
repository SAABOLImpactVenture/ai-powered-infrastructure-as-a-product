# Azure PostgreSQL Flexible Server (Private) + Key Vault Secrets

This Terraform module provisions a zone-redundant PostgreSQL Flexible Server with a private endpoint,
and stores connection details (host/port/admin/password/db) in Azure Key Vault for use by Kubernetes via External Secrets.

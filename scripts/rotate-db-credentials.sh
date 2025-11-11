#!/usr/bin/env bash
set -euo pipefail

: "${AZ_SUBSCRIPTION_ID:?}"
: "${AZURE_RESOURCE_GROUP:?}"
: "${AZURE_KEY_VAULT_NAME:?}"
: "${NAME_PREFIX:?}"

# Generate a strong random password
NEW_PASS="$(tr -dc 'A-Za-z0-9_!@$%&*+' </dev/urandom | head -c 32)"

PG_ADMIN_PASSWORD_SECRET_NAME="${NAME_PREFIX}-pgflex-admin-password"

echo "Setting new admin password secret in Key Vault..."
az keyvault secret set --vault-name "${AZURE_KEY_VAULT_NAME}" --name "${PG_ADMIN_PASSWORD_SECRET_NAME}" --value "${NEW_PASS}" >/dev/null

cat <<EOF
Password rotated in Key Vault. Next steps:
1) Update the actual PostgreSQL admin password to match Key Vault (e.g., via az postgres flexible-server update).
2) External Secrets Operator will reconcile and update the Kubernetes Secret.
3) Restart Backstage backend pods to pick up the new secret if not using live reload.
EOF

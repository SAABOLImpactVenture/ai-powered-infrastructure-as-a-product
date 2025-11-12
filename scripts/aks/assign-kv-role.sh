#!/usr/bin/env bash
set -euo pipefail
: "${KEY_VAULT_ID:?}"
: "${PRINCIPAL_OBJECT_ID:?}"
# Role names are stable across clouds
KV_SCOPE="${KEY_VAULT_ID}"
echo "Assigning 'Key Vault Secrets User' to ${PRINCIPAL_OBJECT_ID} on ${KV_SCOPE}"
az role assignment create --assignee-object-id "${PRINCIPAL_OBJECT_ID}" --assignee-principal-type ServicePrincipal   --role "Key Vault Secrets User" --scope "${KV_SCOPE}" >/dev/null
echo "Assigning 'Key Vault Reader' to ${PRINCIPAL_OBJECT_ID} on ${KV_SCOPE}"
az role assignment create --assignee-object-id "${PRINCIPAL_OBJECT_ID}" --assignee-principal-type ServicePrincipal   --role "Key Vault Reader" --scope "${KV_SCOPE}" >/dev/null
echo "Done."

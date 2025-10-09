
# Azure OIDC for GitHub Actions

```bash
# Create federated credential on an existing App Registration
az ad app federated-credential create   --id <APP_OBJECT_ID>   --parameters '{
    "name":"github-oidc-main",
    "issuer":"https://token.actions.githubusercontent.com",
    "subject":"repo:<ORG>/<REPO>:ref:refs/heads/main",
    "audiences": ["api://AzureADTokenExchange"]
  }'

# Role assignment
az role assignment create   --assignee-object-id <APP_OBJECT_ID>   --assignee-principal-type ServicePrincipal   --role "Contributor"   --scope "/subscriptions/<SUB_ID>/resourceGroups/<RG_NAME>"
```

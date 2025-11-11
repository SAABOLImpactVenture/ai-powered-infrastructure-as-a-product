# Backstage Authentication & Identity (OIDC + RBAC)

This configuration enables:
- **OIDC with Microsoft Entra ID** (supports Entra ID Gov with alternate authority)
- **GitHub OAuth** fallback
- **Backstage Permission Framework** with a custom policy mapping Groups to permissions
- **Catalog Organization Model** (Groups and Users) for ownership and RBAC

## Steps
1. Create OAuth apps:
   - **Microsoft Entra ID** (or Entra ID Gov): Web redirect URI `https://<BACKEND>/auth/microsoft/handler/frame`
   - **GitHub OAuth App**: Homepage `https://<APP>`, Callback `https://<BACKEND>/auth/github/handler/frame`
2. Set environment variables (see `.env.example`) and wire to deployment environment.
3. Update `catalog/org/*.yaml` with your real users and groups.
4. (Gov) If using **Azure Government**, set `auth.providers.microsoft.authority: https://login.microsoftonline.us` in `app-config.production.yaml`.

## Group-based RBAC
- `group:default/platform-admins` — full access
- `group:default/security-reviewers` — read catalog/templates and execute scaffolder
- `group:default/developers` — read catalog/templates and execute scaffolder; entity mutations are conditional

Modify `packages/backend/src/permission/ServerPermissionPolicy.ts` to refine rules.

## Tokens & Sessions
The backend uses `backend.auth.keys[0].secret` (from `BACKEND_AUTH_SECRET`) to sign session cookies and tokens.

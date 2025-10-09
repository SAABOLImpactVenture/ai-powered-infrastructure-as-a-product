# OIDC/WIF policy

- All CI jobs that access cloud must set `permissions: { contents: read, id-token: write }`.
- Use cloud federation modules (identity/*) for role trust; **do not** store long-lived keys.
- Conftest policy `policy/conftest/terraform_no_static_creds.rego` denies static provider secrets.

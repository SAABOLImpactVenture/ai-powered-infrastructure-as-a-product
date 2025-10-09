# Make `ci-security` REQUIRED

In **Settings → Rulesets / Branch protection**, mark these as **Required**:
- `ci-security (iac-policy)`
- `validate (terraform-validate)` and `validate (iac-gates)` if present
- `deploy (policy)` and `deploy (cosign-verify)` for protected environments

Enable CODEOWNERS reviews for `platform/`, `policies/`, and `policy/**`.

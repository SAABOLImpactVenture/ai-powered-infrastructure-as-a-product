# Required checks (Rulesets → Branch protection)

Mark as **Required**:
- `ci-security (iac-policy)`
- `cosign-verify-gate-pinned`
- `terraform-validate-and-scan` (or `ci-matrix` equivalents)
- `e2e-suite` (optional)

Enable PR reviews by code owners and conversation resolution.

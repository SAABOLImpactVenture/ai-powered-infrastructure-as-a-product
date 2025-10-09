# Required status checks (set in Branch protection/rulesets)

Mark these as **Required** before merge:
- `ci-security (sbom-sign-and-scan)`
- `ci-security (iac-policy)`
- `cosign-verify-gate-pinned` (from earlier phase)
- `planreview-validate` (if present)
- `conftest-docker` (if present)
- `terraform-validate-and-scan` (from earlier phase)

Also enable:
- Require pull request reviews with code owners
- Require conversation resolution
- Require signed commits (optional but recommended)

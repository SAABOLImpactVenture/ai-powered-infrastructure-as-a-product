# Branch Protection / Rulesets (set in repo settings)

Required:
- Require a pull request before merging
- Require approvals from CODEOWNERS (platform/, policies/, policy/**)
- Require status checks to pass before merging
- Require conversation resolution
- Require signed commits (recommended)
- Restrict who can push to matching branches (e.g., main)

Required status checks (mark these as Required):
- ci-security (iac-policy)
- ci-matrix (terraform-validate)
- ci-matrix (iac-policy-gates)
- cosign-verify-gate-pinned
- terraform-validate-and-scan
- deploy (apply) — environment protection with reviewers

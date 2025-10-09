# Protect the default branch

In **Settings → Rulesets** (or Branch protection), mark these checks as **Required**:
- `ci-security (iac-security)`
- `ci-security (supply-chain)`

Also enable: required reviewers for `apply` workflows, secret scanning, dependency review, and block force-pushes.

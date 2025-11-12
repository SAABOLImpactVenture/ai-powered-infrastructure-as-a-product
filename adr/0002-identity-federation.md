# 0002 — Identity Federation

**Status**: Accepted  
**Context**: CI/CD must assume roles across clouds without long-lived credentials.  
**Decision**:
- **GitHub OIDC** to Entra (Azure) via Federated Credential (issuer `https://token.actions.githubusercontent.com`).
- **AWS**: IAM OIDC provider + role trust on GitHub `sub` to enable STS assume-role.
- **GCP**: Workload Identity Federation (pool + provider), mapped to a dedicated GSA with attribute binding.
- **OCI**: Dynamic Group & compartment policy to authorize GitHub-driven workloads or OKE workloads in scope.
**Consequences**: Short-lived tokens, auditable claim-based access, no secrets at rest in CI.

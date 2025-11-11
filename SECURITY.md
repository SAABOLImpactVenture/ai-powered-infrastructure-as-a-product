# Security Policy

## Reporting a Vulnerability
Email security@your-org.example with PoC, affected commit SHA, and recommended remediation.

## CI/CD Enforcement
The repository enforces:
- **IaC gates** (`policy-gates.yml`): Terraform validate/TFLint, Checkov (fail on HIGH/CRIT), Conftest (OPA).
- **Kubernetes gates**: kubeconform schema validation + OPA policies.
- **Secrets**: gitleaks with blocking.
- **Python SAST/Deps**: Bandit + pip-audit (SBOM under releases).
- **Containers**: Trivy config scan for `docker/`.
- **Supply chain**: CycloneDX SBOM signed with Cosign (keyless OIDC).
- **Evidence**: Consolidated SARIF → OSCAL POA&M under `evidence/latest`.

## Compliance
Controls align to FedRAMP High / NIST 800-53 Rev.5 AC, AU, CM, SC, SI with Zero Trust and TIC 3.0 posture.

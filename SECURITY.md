# Security Policy

## Supported Versions
Main branch is supported. Use tagged releases for production.

## Reporting a Vulnerability
Please email security@your-org.example with a proof-of-concept and affected commit SHA.

## Disclosure
We follow responsible disclosure with a 90-day remediation window.

## Secrets
Do not commit secrets. Gitleaks and GitHub Push Protection will block merges when leaks are detected.

## Compliance
This repo enforces IaC security against FedRAMP High/NIST 800-53 Rev.5 aligned controls via:
- Checkov, TFLint (static IaC checks)
- OPA/Conftest policy gates
- SBOM generation and signing
- Automated evidence capture to artifacts

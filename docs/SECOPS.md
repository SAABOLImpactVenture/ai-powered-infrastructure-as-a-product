# SecOps Runbook

## Pipelines
- policy-gates: Blocks merges on IaC violations (Checkov, TFLint, Conftest) and secret leaks (Gitleaks).
- supply-chain: Generates SBOM, signs artifacts with Cosign, records provenance.
- evidence: Converts SARIF to OSCAL POA&M and uploads artifacts for ATO evidence.

## Evidence
Artifacts are uploaded per run and retained according to GitHub settings. Archive them to `evidence/` during release.

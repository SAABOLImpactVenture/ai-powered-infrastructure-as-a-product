# Controls → Risks → Mechanisms → Evidence

| Control | Risk mitigated | Mechanism | Evidence |
|---|---|---|---|
| CM-3 / CM-6 | Unguarded changes | Plan→Policy→Env approval; read-only validate | Plan artifact, OPA/Checkov logs |
| AC-6 / CM-5 | Over-privileged CI | OIDC + least-priv roles; minimal permissions | Workflow YAML, cloud role JSON |
| SC-13 / SC-28 | Missing encryption/FIPS | TLS pin + backend SSE/KMS | TF plan KMS/SSE; ingress annotations |
| RA-5 / SI-2 | Misconfig ships | TfLint/Checkov/Conftest as blockers | CI non-zero exits; SARIF |
| AU-6 / AU-12 | No immutable evidence | Uploaded plans, SBOMs, signatures | Artifact SHAs, cosign logs |
| IR-4 | No rollback | Apply from artifact plan; deploy by digest | Saved plan + digest history |

# Controls → Mechanisms → Evidence

| Control | Failure prevented | Mechanism | Evidence |
|---|---|---|---|
| CM-3 / CM-6 | Unguarded/implicit changes | Plan→Policy→Env approval | Plan artifact, policy logs, approver record |
| AC-6 / CM-5 | Over-privileged tokens | OIDC + least-priv roles; minimal `permissions` | Workflow YAML + cloud role JSON |
| SC-13 / SC-28 | Missing encryption/FIPS | OPA deny rules; TLS pin in Ingress | Conftest report; TF plan showing KMS |
| RA-5 / SI-2 | Misconfig deploys | TfLint/Checkov/OPA as hard gates | CI exits non-zero on findings |
| AU-6 / AU-12 | No immutable evidence | Uploaded plans, signed SBOMs | Artifact SHAs, cosign attestations |
| IR-4 | No deterministic rollback | Apply from artifacted plan/images | Plan files + digest history |

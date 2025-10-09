# Golden Demo

End-to-end rehearsal to build confidence before touching production.

## Steps

1. Start the reference server:
   ```bash
   pip install -r reference-server/requirements.txt
   python reference-server/app.py
   ```
2. Validate agents readiness:
   ```bash
   python ../../scripts/validate_agents_readiness.py
   ```
3. Apply the reference change:
   ```bash
   cd reference-change
   terraform init && terraform apply -auto-approve
   ```
4. Emit infra evidence (optional cloud mode if creds exist):
   ```bash
   python ../../scripts/emitters/infra-evidence/emit_evidence_to_log_analytics.py      --kind golden-demo --status success --detail "local run"
   ```

## What this proves

- Your environment has the right tooling and can execute change safely.
- Evidence is produced consistently and can be routed to observability.
- All of this works even **offline** (local mode).

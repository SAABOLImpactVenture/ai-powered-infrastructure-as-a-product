# Infra Evidence Emitter

Posts JSON evidence to Azure Log Analytics using the HTTP Data Collector API.

## Env Vars

- `LA_WORKSPACE_ID` (required for cloud mode)
- `LA_SHARED_KEY` (required for cloud mode)
- `LA_LOG_TYPE` (optional, default: `IaapInfraEvidence_CL`)
- `LA_ENDPOINT` (optional, default derived from workspace)

## Fields Emitted

| Field | Description |
|---|---|
| `id` | UUID for the evidence record |
| `timestamp_utc` | ISO8601 timestamp |
| `kind` | Evidence kind (e.g., `validate`, `golden-demo`) |
| `status` | `success`, `failure`, or `warning` |
| `detail` | Human-readable detail |
| `repo` | Repository slug |
| `workflow` | CI workflow name if present |
| `run_id` | CI run identifier if present |

## Usage

```bash
python scripts/emitters/infra-evidence/emit_evidence_to_log_analytics.py   --kind validate --status success --detail "All good"
```

If env vars are missing, payload is saved to `.local-outbox/infra-evidence-<ts>.json`.

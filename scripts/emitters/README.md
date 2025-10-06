# Emitters

Emit operational evidence to observability backends.

- `infra-evidence/emit_evidence_to_log_analytics.py` – Python emitter to Azure Log Analytics Data Collector API.
- `aoai/emit_aoai_request_to_log_analytics.py` – Example for logging AOAI request metadata (no model calls performed).
- `aoai/Emit-AOAIRequestToLogAnalytics.ps1` – PowerShell variant.

## Local Mode

If required env vars are missing, emitters **do not fail**—they write payloads to `./.local-outbox/` and print the JSON. This keeps developer experience smooth.

## Cloud Mode

Set:
- `LA_WORKSPACE_ID`, `LA_SHARED_KEY`
- Optional: `LA_LOG_TYPE`, `LA_ENDPOINT`

The emitter signs and posts to the Data Collector API.

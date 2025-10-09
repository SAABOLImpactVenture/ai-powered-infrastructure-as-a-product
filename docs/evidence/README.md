# Evidence Lake (Schema → Ingestion → Retention → Lineage)

This project ships a normalized **Evidence schema** (`schemas/evidence.schema.json`), code to provision sinks (Azure **ADX** and AWS **S3+Athena**), and dashboards-as-code, all wired for FedRAMP retention.

- **Schema:** `schemas/evidence.schema.json` (OK/WARN/FAIL with `details` envelope).
- **Azure ADX:** `evidence/sinks/azure/adx/main.tf` creates cluster, DB, table and JSON mapping. Example dashboards under `observability/dashboards/azure/`.
- **AWS Athena:** `evidence/sinks/aws/s3_glue_athena/main.tf` provisions the bucket, Glue DB/table.

## Lineage

Every evidence record should include:
- `source`: workflow/job name (e.g., `ci-security/iac-security`)
- `path`: relative path or image ref
- repository, run-id (added as OSCAL props in the pipeline)

## Policy Status UI

The Policy Status card should call `/api/policy/aggregate` and link to the **immutable blob** produced by the OSCAL pipeline. See `docs/backstage/guardrails.md`.

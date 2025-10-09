# Policy Dashboard → Evidence Lake

Point the dashboard at the **Policy Evidence Adapter** (`/aggregate`) instead of a local volume.

## Compose (dev)
```yaml
# docker-compose.override.lake.yml
services:
  policy-evidence-adapter:
    build: ./services/policy-evidence-adapter
    environment:
      EVIDENCE_LAKE: adx
      ADX_URI: https://<cluster>.<region>.kusto.windows.net
      ADX_DB: evidence
      ADX_TOKEN: <bearer-token>
    ports: ["127.0.0.1:8088:8088"]
```

## UI call
```
POST http://localhost:8088/aggregate
{ "days": 30 }
```
The adapter queries ADX/Athena and returns aggregated counts. Use this response to render the Policy Status card.

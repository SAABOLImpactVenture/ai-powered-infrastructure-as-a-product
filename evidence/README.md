
# Evidence Model

- Written as JSON files by MCP servers under `./evidence/<cloud>/`.
- Ingest to Log Analytics via DCR or push via Data Collection Endpoint.

## Sample KQL
```kusto
Evidence_CL
| summarize count() by kind_s, status_s
```

## Fields
- `kind`: plan|apply|error|policy
- `status`: OK|ERROR
- `detail`: truncated CLI output or violation summary
- `ts`: ISO-8601 UTC
- `source`: mcp-azure|mcp-aws|mcp-gcp|mcp-oci
- `hash`: optional SHA-256 of `detail`

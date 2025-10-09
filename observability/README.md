
# Evidence Ingestion (Azure Monitor)

Deploy a DCE/DCR to ingest evidence JSON files from MCP hosts.

## Deploy (Bicep)
```bash
az deployment group create -g <RG> -f observability/dce-dcr-evidence.bicep -p location=<LOC> workspaceId=/subscriptions/<SUB>/resourceGroups/<RG>/providers/Microsoft.OperationalInsights/workspaces/<LAW>
```

## Workbook
Import `observability/workbook-evidence.json` into Azure Monitor Workbooks.

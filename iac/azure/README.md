# Azure Control-Plane Enablement

This package deploys a **Log Analytics Workspace** and a **Data Collection Rule (DCR)** ready to ingest
evidence and AOAI telemetry. You can optionally pass resource IDs to associate the DCR with Azure Arc servers or clusters.

## Parameters
- `workspaceName` (string)
- `location` (string)
- `dcrName` (string, default `iaap-dcr`)
- `associations` (array of resource IDs, default `[]`)

## Usage
```bash
./scripts/azure/deploy_la_dcr.sh <resource-group> <location> <workspace-name>
```

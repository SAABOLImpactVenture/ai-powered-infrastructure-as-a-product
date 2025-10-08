# Azure Scripts

- `deploy_la_dcr.sh` — Creates or updates a resource group and deploys `iac/azure/main.bicep`.
- `import_workbook.sh` — Imports an Azure Monitor Workbook from JSON.
- `create_alert.sh` — Creates a Scheduled Query Rule v2 (alert) from JSON.

Make executable:
```bash
chmod +x scripts/azure/*.sh
```

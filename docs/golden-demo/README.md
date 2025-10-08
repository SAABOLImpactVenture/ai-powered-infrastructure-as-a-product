# Golden Path Demo

This demo shows an end-to-end flow:
- Tests pass
- Terraform MVP applies and emits evidence
- (Optional) Dashboards imported and alerts created

## Prereqs
- Python 3.11+
- Terraform 1.4+
- (Optional) Azure CLI if you want cloud steps

## Run
```bash
chmod +x scripts/golden_path/run_golden_demo.sh
./scripts/golden_path/run_golden_demo.sh
```

### Expected Outcomes
- `pytest -q` succeeds.
- Terraform apply succeeds for MVP-03.
- `.local-outbox/infra-*.json` exists with `status: success`.
- If Azure vars set (IAAP_RG/IAAP_LOC/IAAP_WS):
  - Workspace + DCR deployed
  - Workbooks imported
  - Alerts created

### Drill (Alert)
```bash
chmod +x scripts/drills/simulate_failure.sh
./scripts/drills/simulate_failure.sh
```
If cloud ingestion is on, the **failure** alert should fire during the next evaluation.

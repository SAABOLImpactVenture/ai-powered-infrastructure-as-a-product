
# Rollback Runbook

1. Determine scope from plan evidence and applied resources.
2. If apply failed mid-flight, run targeted destroy only for partially created resources.
3. Re-run `plan` to confirm zero-drift.
4. Verify policy status = OK and observability is clean.
5. Document in PR and attach evidence JSONs.

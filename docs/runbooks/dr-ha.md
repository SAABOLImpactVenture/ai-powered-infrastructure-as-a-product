# DR/HA Runbook (RTO ≤ 60m / RPO ≤ 15m)

1. **Health Probes:** `/healthz` endpoints per region (5s interval). 
2. **Failover:** Route53 PRIMARY→SECONDARY or Azure Traffic Manager Priority profile.
3. **Data:** Cross-region read replica with PITR enabled; promote on failover.
4. **Game Day:** Use `.github/workflows/dr-gameday.yml` to simulate primary failure and verify DNS cutover (< 5 min).
5. **Rollback:** Restore healthy primary, switch priority back, confirm probes, and re-enable replication.

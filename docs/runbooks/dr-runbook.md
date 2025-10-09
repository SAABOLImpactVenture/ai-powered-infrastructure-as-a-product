# DR Runbook — RTO ≤ 60m / RPO ≤ 15m

1. Primary health degrades (SLO breach) — trigger failover workflow (`dr-gameday.yml` or real failover).
2. Confirm DNS health check red → Route53/Traffic Manager flips to secondary.
3. Verify:
   - `/healthz` 200 from secondary
   - Data lag < 15m (DB replica LSN/Timestamp)
4. Backfill evidence entries to Evidence Lake (ADX/Athena).
5. Initiate back-migration after primary is green × 24h.

Automated tests:
- Nightly `dr-gameday.yml` dry-run probe (no flip).
- Monthly **chaos** window: drain primary and measure time-to-serve on secondary.

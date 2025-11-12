SPDX-License-Identifier: Apache-2.0
# Runbook — Cross-Cloud DNS Failover

## Objectives
- RTO: ≤ 5 minutes stateless; ≤ 1 hour stateful
- RPO: ≤ 15 minutes

## Preconditions
- Health checks for each region edge.
- Route53 primary with Cloud DNS/OCI DNS secondaries synchronized.

## Steps
1. Confirm incident; validate health checks and logs.
2. Flip Route53 failover policy to healthy region(s); reduce TTLs if necessary.
3. Sync changes to secondaries if authoritative role changes.
4. Invalidate CDN caches where required.
5. Promote stateful replicas according to DB runbook; ensure replication lag within RPO.
6. Capture evidence (who/what/when; diffs; timestamps) and publish post-incident report.

## Back-out
- Restore original policy after recovery; verify health and client performance.

# Cross-Cloud DNS Failover Runbook

**Objective**: Achieve RTO ≤ 5 minutes (stateless) and ≤ 1 hour (stateful) with RPO ≤ 15 minutes.

## Preconditions
- Anycast WAF/CDN fronting region edges.
- Primary DNS: **Route 53**; Secondaries: **Cloud DNS** and **OCI DNS** in sync.
- Health checks for each region’s edge and backend readiness.
- Pre-staged DNS records with weighted/latency and failover policies.

## Health-Checked Threshold
- Trigger **failover when 2/3 regions** fail health checks for a given service.

## Steps
1. **Confirm Health**  
   Validate failing regions via health checks and synthetic probes.
2. **Flip DNS Policy**  
   - On Route 53, set failover from **primary** to **secondary** region(s) for impacted records.  
   - Push the same change to secondaries (Cloud DNS/OCI DNS) if acting as primaries due to split view.
3. **Invalidate CDN** (if necessary)  
   Invalidate regional caches where stale endpoints persist.
4. **Stateful Promotion**  
   Promote cross-region replicas (databases, queues) based on runbook; confirm replication lag < RPO.
5. **Evidence Capture**  
   - Write event to **ADX** table `evidence_dns_failover` with timestamps, impacted records, and operator.
   - Attach Cloud provider change IDs.
6. **Post-Event**  
   Conduct blameless review; update ADRs if design changes.

## RTO/RPO Targets
- Stateless: RTO ≤ **5m**; RPO ≤ **15m**  
- Stateful: RTO ≤ **1h**; RPO ≤ **15m**

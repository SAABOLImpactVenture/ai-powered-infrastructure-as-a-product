SPDX-License-Identifier: Apache-2.0
# Platform SLOs & Error Budgets

| SLO | Target | Measurement |
|-----|--------|-------------|
| Policy compliance | ≥ 99.5% | % passing resources per evaluation window |
| Plan gate latency | p95 ≤ 60s | CI step timing for policy gates |
| DNS failover RTO (stateless) | p95 ≤ 5m | Incident start → healthy service |
| Evidence freshness | p95 ≤ 24h | Artifact creation → OSCAL export |

**Error budgets** drive change policy: exceeding budget suspends L2/L3 autonomy in that lane until a corrective action plan is merged.

# 0003 — Cross-Cloud Network & DNS

**Status**: Accepted  
**Decision**:
- **Anycast WAF/CDN** in front of application edges.
- **Route 53** as **primary DNS**, **Cloud DNS** and **OCI DNS** as secondaries with zone transfers or CI-synced records.
- Health-checked failover with 2/3 regional failure threshold; automation triggers DNS policy flip.
**Consequences**: Fast failover, minimal DNS split-brain risk, deterministic runbook-driven changes.

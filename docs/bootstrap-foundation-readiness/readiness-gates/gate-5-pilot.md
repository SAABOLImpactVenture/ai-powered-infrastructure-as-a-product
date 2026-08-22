# Gate 5 — bounded customer pilot

**Requirement ID:** `BFR-GATE-005`

> **Status:** Architecture target. No current POC proves real customer workloads, actual human approval, operational support, recovery objectives, developer adoption, or production-like service outcomes.

## Gate objective

Evaluate the infrastructure product with named consumers and bounded real use while preserving explicit data, service, support, cost, incident, lifecycle, evidence, and exit boundaries.

## Entry criteria

- Gate 4 has repeatable live-sandbox evidence, not a single unexamined success.
- [Pilot prerequisites](../prerequisites/production-pilot-prerequisites.md) are met.
- Pilot sponsor, product owner, service owner, consumers, duration, and target are named.
- Permitted workloads and data classifications are explicit.
- Service objectives, support coverage, incident command, recovery, continuity, retirement, and cost ceilings are approved.
- Success, stop, rollback, and exit criteria are measurable before use begins.

## Pilot controls

- admit only approved consumer/product combinations;
- retain each order, approval, revision, reconciliation, incident, and retirement event;
- measure product outcomes without substituting engineering activity for customer value;
- test support escalation and at least one recovery or continuity scenario appropriate to scope;
- review privileges, exceptions, cost, and conditions during the pilot; and
- stop automatically or by named authority when an approved threshold is exceeded.

## Required outcome evidence

| Area | Evidence |
|---|---|
| Consumer | eligible population, actual orders, feedback method |
| Delivery | order, approval, accepted desired state, ready timestamps |
| Operations | alerts, incidents, support response, error budget where applicable |
| Resilience | tested restore, failover, rollback, or continuity outcome |
| Security | access review, findings, exceptions, data-boundary observations |
| Financial | baseline, allocation, alerts, observed spend, overrun disposition |
| Lifecycle | update, retirement, deletion, residual-resource evidence |
| Decision | success/stop criteria and named final disposition |

## Measurement boundary

Synthetic denials are not an exception rate. An encoded approval requirement is not an approval timestamp. Kubernetes reconciliation time is not order-to-ready. A POC user is not a representative developer population. The [POC evidence model](../../poc-baselines/2026-08-07-backstage-runtime-proven-v5.md) preserves these distinctions and should remain the precedent.

## Exit decision

- `CONTINUE`: the authorized pilot may continue within its term, or its evidence may be submitted for production consideration.
- `CONTINUE_WITH_CONDITIONS`: the pilot continues with narrower scope, compensating controls, named remediation, and expiration.
- `STOP`: safety, ownership, support, recovery, data handling, cost, consumer consent, or exit criteria are inadequate or breached.

Pilot completion never becomes production approval automatically.

## Related requirements

- [Gate 6 — production consideration](gate-6-production-consideration.md)
- [Retention, traceability, and export](../evidence/retention-traceability-and-export.md)
- [Exceptions and expiration](../decisions/exceptions-and-expiration.md)
- [Foundation domain owners](../responsibility-matrices/foundation-domain-owners.md)

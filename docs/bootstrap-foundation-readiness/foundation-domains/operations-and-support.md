# Operations and support

**Requirement ID:** `BFR-OPS-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It does not create a current vendor-operated service, availability commitment, or production support obligation.

## Requirement

The customer must assign operational ownership and define health, monitoring, support, incident, maintenance, dependency, capacity, recovery, change, escalation, communication, and retirement practices for the bootstrap and each live infrastructure product.

## Why this requirement exists

A product is not ready merely because it provisions once. Consumers depend on observable health, restoration, safe change, known support, and accountable lifecycle ownership. Unowned operational work quickly returns the product to a ticket-driven implementation service.

## Applicability

Assessment identifies future owners and gaps. Simulation validates runbooks and failure signals. Discovery requires access support and revocation. Live sandbox proves basic operations and teardown. Pilot/production consideration require sustained service practices and measured outcomes.

## Customer decisions

The customer must decide:

- service/product owner, operator, on-call or support coverage, and consumer support channel;
- health model, SLO/SLA aspirations, product outcomes, alerts, and dashboards;
- incident severity, command, escalation, communications, post-incident review, and resumption authority;
- dependency/vendor ownership and outage behavior;
- maintenance, upgrades, vulnerability remediation, compatibility, and change windows;
- capacity, quotas, performance, scaling, cost, and demand management;
- backup/recovery/continuity, runbooks, and exercises;
- retirement, consumer migration, data/evidence disposition, and orphan cleanup; and
- staffing, skills, access, documentation, and succession.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Operational owner, dependencies, support assumptions, and material gaps are identified. |
| Simulation | Health, failure, escalation, rollback, recovery, and retirement runbooks are tested with fixtures. |
| Read-only discovery | Access issues, data freshness, rate limits, and revocation have named support. |
| Live sandbox | Monitoring, alert response, failure diagnosis, rollback, recovery, teardown, and residual checks are exercised. |
| Pilot | Support coverage, incidents, capacity, maintenance, consumer communications, metrics, and repeated lifecycle behavior are observed. |
| Production consideration | Service acceptance, staffing, SLOs, continuity, dependency, financial, and retirement obligations are formally approved. |

## Composite AI assistance

Composite AI may summarize sanitized status, suggest runbook steps, correlate evidence, draft incident timelines, identify missing ownership, and prepare handoff or post-incident material.

It must not execute remediation, close incidents, change severity, contact parties without authorization, promise restoration time, suppress failure, or authorize resumption.

## Deterministic validation target

A future validator should verify service/product owner, monitored health signals, alert routes, support/escalation, incident and recovery runbooks, dependency inventory, maintenance process, capacity/cost controls, retirement, and exercise evidence. Unowned alerts, missing teardown, unsupported dependencies, or AI auto-remediation should fail closed for live stages. This is a proposed target.

## Human approval

Operations/service owners accept runbooks and support. Product owners accept consumer outcomes. Security and continuity owners approve incident and recovery interfaces. Finance approves material operating cost; authorization authority approves pilot/production service use.

## Required evidence

- service ownership and support model;
- health model, dashboards, alerts, and response tests;
- incident, escalation, communication, and resumption procedures;
- dependency/version/vulnerability inventory;
- maintenance, capacity, quota, and cost records;
- recovery and continuity exercise results;
- consumer support and outcome metrics; and
- retirement/migration/teardown runbook and test.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: the requested stage has owned, monitored, supportable, recoverable, and lifecycle-complete operations.
- `CONTINUE_WITH_CONDITIONS`: a time-bounded evaluation may proceed with explicitly limited hours, consumers, scale, or dependencies and named remediation.
- `STOP`: no operator/responder exists, material health is invisible, recovery/teardown is unproven, dependencies are unsupported, or service promises exceed capability.

## Forge handoff

Forge receives product health/status expectations, correlation/evidence references, runbook links, support owner, lifecycle constraints, and stop/resumption conditions. It does not become incident commander or autonomous remediator.

## Exceptions and prohibited shortcuts

Exceptions require service impact, consumers, compensating support, owner, expiry, and stop trigger. Never call best effort a committed service, rely on one engineer, count deployment success as availability proof, let AI close incidents, skip post-incident evidence, or retire a product without consumer and data disposition.

## Related requirements

- [`BFR-LOG-001` Logging and monitoring](logging-and-monitoring.md)
- [`BFR-SIEM-001` Security-event integration](security-event-integration.md)
- [`BFR-BCP-001` Backup, recovery, and continuity](backup-recovery-and-continuity.md)
- [`BFR-PRQ-005` Pilot and production-consideration prerequisites](../prerequisites/production-pilot-prerequisites.md)

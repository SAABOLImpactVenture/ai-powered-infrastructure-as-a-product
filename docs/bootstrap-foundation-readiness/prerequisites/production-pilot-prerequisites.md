# Pilot and production-consideration prerequisites

**Requirement ID:** `BFR-PRQ-005`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. This page defines evidence expected before customer authorization processes; it does not authorize a pilot or production deployment and does not change Forge V1 production-disabled status.

## Requirement

Before a customer workload pilot, the organization must prove repeated product lifecycle behavior, support and recovery readiness, security and data handling, cost ownership, consumer acceptance, and a bounded authorization. Production consideration requires a separate formal decision by the customer's accountable authorities.

## Why this requirement exists

A successful sandbox proves a narrow technical path, not sustained service ownership. Pilots introduce real consumers, operational dependencies, data, incidents, costs, lifecycle changes, and expectations that require explicit accountability and measurable exit criteria.

## Applicability

- **Assessment through read-only discovery:** used to identify future obligations only.
- **Live sandbox:** generates prerequisite evidence but does not satisfy the pilot gate by itself.
- **Pilot:** mandatory.
- **Production consideration:** mandatory baseline plus customer-specific legal, security, compliance, architecture, operational, and authorization processes.

## Customer decisions

The customer must decide:

- pilot sponsor, product owner, service owner, consumers, duration, scope, and success/stop criteria;
- permitted workload and data classifications;
- service expectations, support hours, escalation, incident command, and communications;
- capacity, quota, performance, availability, recovery, and continuity targets;
- change windows, rollback, retirement, consumer migration, and data disposition;
- control inheritance, system boundary, evidence owners, assessors, and risk authority;
- cost baseline, charge/allocation model, ceilings, and overrun response;
- model provider and AI data-processing limits, if any; and
- production decision forum, required artifacts, and explicit non-transfer of pilot approval.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Pilot obligations, candidate consumers, data constraints, and decision authorities are identified. |
| Simulation | Failure, rollback, evidence, and consumer-order scenarios are exercised with synthetic data. |
| Read-only discovery | Dependencies, quotas, existing controls, and integration owners are verified. |
| Live sandbox | Repeatable reconciliation, monitoring, cost, recovery, retirement, and teardown are demonstrated. |
| Pilot | Bounded real use, support, incident response, lifecycle metrics, consumer feedback, and exit criteria are authorized and observed. |
| Production consideration | Complete evidence is submitted to the customer's formal authorization and service-acceptance processes. |

## Composite AI assistance

Composite AI may draft pilot plans, identify evidence gaps, summarize sanitized metrics and incidents, compare outcomes with exit criteria, and prepare decision packets with source links.

It must not choose pilot participants, approve regulated data, set service commitments, accept residual risk, close incidents, suppress adverse outcomes, or recommend production as an automatic consequence of a passing score.

## Deterministic validation target

A future gate should verify named owners, exact pilot target and duration, allowed data, product and implementation revisions, completed sandbox evidence, support and incident plans, tested recovery, cost ceiling, measurable exit/stop criteria, consumer consent, evidence retention, and pilot authorization. Production flags must require a distinct external authorization reference. This is not current Forge V1 behavior.

## Human approval

The sponsor and product owner approve purpose and consumers. Security, data, architecture, operations, resilience, and financial owners approve their domains. The risk or authorization authority approves the pilot boundary. Production requires a new decision after pilot evidence is reviewed.

## Required evidence

- pilot charter, boundary, duration, consumers, and data classification;
- completed sandbox and repeated lifecycle results;
- service, support, incident, recovery, continuity, and retirement plans;
- security assessment and unresolved-risk register;
- cost baseline, ceiling, allocation, and observed spend;
- product outcome metrics and consumer feedback;
- exception register with expirations;
- pilot approval, monitoring reviews, and final disposition; and
- production-consideration packet or explicit decision not to proceed.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: the bounded pilot may begin or continue within its recorded approval; production still requires a separate decision.
- `CONTINUE_WITH_CONDITIONS`: a narrower pilot may proceed with explicit limits, owners, expiration dates, and stop triggers while noncritical gaps are remediated.
- `STOP`: sandbox evidence is incomplete, ownership or support is absent, data use is unauthorized, recovery or incident response is unproven, cost is unowned, or the requested scope exceeds approval.

## Forge handoff

Forge may consume only the approved pilot product orders and lifecycle transitions. The handoff includes pilot boundary, consumer/product identity, allowed data classification, service profile, approved target, immutable revisions, required evidence, decision reference, conditions, and expiration. It never converts pilot success into production authority.

## Exceptions and prohibited shortcuts

Exceptions must be visible to consumers and decision authorities, contain compensating controls, and expire no later than the pilot. Prohibited shortcuts include calling a sandbox a pilot, using production data without approval, inventing SLOs after incidents, omitting retirement obligations, treating absence of incidents as resilience proof, or allowing schedule pressure to override a `STOP`.

## Related requirements

- [`BFR-OPS-001` Operations and support](../foundation-domains/operations-and-support.md)
- [`BFR-BCP-001` Backup, recovery, and continuity](../foundation-domains/backup-recovery-and-continuity.md)
- [`BFR-DAT-001` Data classification](../foundation-domains/data-classification.md)
- [`BFR-FIN-001` Cost ownership and FinOps](../foundation-domains/cost-ownership-and-finops.md)
- [`BFR-EVD-001` Evidence and traceability](../foundation-domains/evidence-and-traceability.md)

# Logging and monitoring

**Requirement ID:** `BFR-LOG-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It does not claim current Guard or Forge V1 operates a customer monitoring service.

## Requirement

The customer must define, collect, protect, monitor, and retain the audit, platform, application, control-plane, network, identity, and product-lifecycle signals needed to attribute actions, detect failure, measure service health, and support evidence.

## Why this requirement exists

Without reliable telemetry, a reconciled resource can appear successful while controls, dependencies, or consumer outcomes fail. Logs are also sensitive data; collecting everything without minimization and access control creates a second risk.

## Applicability

- **Assessment:** evidence-source and telemetry gaps are documented.
- **Simulation:** deterministic outcomes and negative cases emit bounded test evidence.
- **Read-only discovery:** discovery calls and evidence ingestion are attributable.
- **Live sandbox:** control-plane, cloud, identity, network, cost, and acceptance telemetry are required.
- **Pilot/production consideration:** service-level monitoring, alert response, retention, scale, and continuity are exercised.

## Customer decisions

The customer must decide:

- required log/metric/trace/event sources and owners;
- central destinations, tenancy, region, encryption, access, and legal hold;
- schemas, clocks, correlation identifiers, product/owner metadata, and sampling;
- health indicators, product outcomes, thresholds, alerts, routing, and escalation;
- sensitive-field filtering, redaction, retention, deletion, and export;
- monitoring for gaps, tampering, ingestion failure, and cost growth;
- availability and recovery of the telemetry path; and
- how operational signals become attributable evidence without claiming authorization.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Required sources, owners, destinations, retention, and known blind spots are identified. |
| Simulation | Test runs emit deterministic, sanitized, correlated results. |
| Read-only discovery | Every access is logged with principal, target, time, action, and outcome. |
| Live sandbox | Platform/cloud/control-plane/network/security/cost signals and alerts are tested end to end. |
| Pilot | Product health, time-to-provision, failures, support, capacity, and consumer outcomes are observed. |
| Production consideration | Monitoring SLOs, on-call response, scale, retention, recovery, and compliance obligations are accepted. |

## Composite AI assistance

Composite AI may summarize sanitized telemetry, correlate approved evidence, identify missing signals, draft queries/dashboards, and explain anomalies with source references and uncertainty.

It must not receive secrets or unrestricted raw logs, change alert thresholds, close incidents, suppress failed evidence, invent missing samples, or treat predicted health as observed health.

## Deterministic validation target

A future validator should check mandatory sources, destination, encryption, access, time synchronization, correlation IDs, redaction, retention, alert routes, ingestion health, and representative event tests. Missing audit logs, unowned alerts, mutable-only evidence, secret leakage, or fabricated default metrics should fail closed. This is a proposed target.

## Human approval

Operations and security owners approve sources, alerting, and response. Data/privacy and evidence owners approve fields and retention. Product owners approve health and outcome measures; finance approves material observability cost.

## Required evidence

- telemetry source/destination inventory;
- schema, classification, redaction, and retention policy;
- access-control and encryption evidence;
- representative correlated audit, health, and lifecycle events;
- alert delivery and response test;
- ingestion-gap/tamper monitoring result;
- dashboard/query definitions and product metrics; and
- recovery/export test.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: required signals are attributable, protected, retained, monitored, and operationally owned.
- `CONTINUE_WITH_CONDITIONS`: a bounded stage may proceed with explicitly documented blind spots that do not conceal material action or safety signals and have remediation dates.
- `STOP`: material actions are unaudited, health cannot be observed, alerts are unowned, sensitive data is exposed, or evidence integrity cannot be established.

## Forge handoff

Forge receives approved telemetry profile references, required correlation metadata, health/acceptance criteria, and evidence destinations. It does not become the customer's monitoring authority or rewrite observed results.

## Exceptions and prohibited shortcuts

Exceptions must identify missing signal, impact, compensating evidence, owner, expiry, and trigger to stop. Never disable logging to reduce cost, retain secrets, use dashboards without underlying attributable data, mark missing metrics as zero, let AI manufacture summaries, or treat a green alert as approval.

## Related requirements

- [`BFR-SIEM-001` Security-event integration](security-event-integration.md)
- [`BFR-EVD-001` Evidence and traceability](evidence-and-traceability.md)
- [`BFR-OPS-001` Operations and support](operations-and-support.md)
- [`BFR-FIN-001` Cost ownership and FinOps](cost-ownership-and-finops.md)

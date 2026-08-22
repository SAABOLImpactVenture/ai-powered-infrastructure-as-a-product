# Cost ownership and FinOps

**Requirement ID:** `BFR-FIN-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It does not establish pricing, payment activation, customer spending authority, or a commercial claim for current IaaP products.

## Requirement

Every bootstrap, discovery, model, sandbox, product, evidence, and operational cost must have an accountable owner, approved boundary, allocation metadata, monitoring, forecast/ceiling, anomaly response, and lifecycle disposition before spend occurs.

## Why this requirement exists

Cloud and AI services can create cost through idle resources, retries, logs, data transfer, model calls, and incomplete teardown. A budget alert observes spending; it does not authorize it or prevent it. Product economics also require cost per supported outcome rather than infrastructure activity alone.

## Applicability

Assessment identifies potential cost sources and owners. Simulation should remain credential-free/low cost. Discovery requires rate and API-cost bounds. Live sandbox requires exact ceilings and teardown. Pilot/production consideration require allocation, forecasting, optimization, unit economics, and operational ownership.

## Customer decisions

The customer must decide:

- financial owner, funding source, cost center, tags/labels, and allocation model;
- authorized services, regions, SKUs, licenses, model endpoints, and third-party charges;
- budget/forecast, hard or procedural ceiling, alert thresholds, and stop authority;
- quotas, schedules, scaling limits, retention, data transfer, and log-volume controls;
- anomaly investigation, disputed cost, and escalation process;
- teardown and residual-cost queries;
- product unit measures such as cost per environment, order, consumer, or supported service; and
- who may approve commercial services, subscriptions, maintenance, or payment.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Cost sources, assumptions, owners, and nonfree dependencies are visible. |
| Simulation | No unapproved paid dependency; deterministic local costs and optional-service boundaries are documented. |
| Read-only discovery | API frequency/rate and evidence storage have approved limits and owners. |
| Live sandbox | Exact target ceiling, owner, tags, alerts, quotas, observed spend, teardown, and residual query are proven. |
| Pilot | Forecast accuracy, allocation, unit costs, anomalies, support labor, and consumer value are measured. |
| Production consideration | Sustainable funding, charge/allocation, capacity, licensing, optimization, and governance are formally accepted. |

## Composite AI assistance

Composite AI may categorize approved cost exports, identify anomalies or missing ownership, draft forecasts and optimization options, and explain tradeoffs with cited assumptions.

It must not authorize spend, enroll paid services, purchase licenses, change budgets/quotas, terminate resources, hide cost uncertainty, or treat an estimate as an invoice or approval.

## Deterministic validation target

A future validator should check target, service/SKU allowlist, cost owner, cost center/tags, ceiling, alert routes, quotas, model-call limits, retention, teardown plan, residual query, and approval reference. Missing owner/ceiling, unbounded scaling/model calls, unsupported paid service, or budget-as-authorization language should fail closed. This is a proposed target.

## Human approval

Financial and product owners approve budgets and unit measures. Platform/operations owners approve resource controls. Procurement/legal authorities approve licenses, subscriptions, and payment under customer processes. Deployment approval remains distinct from spending approval.

## Required evidence

- cost model and assumptions;
- accountable owner, cost center, tags/labels, and funding decision;
- authorized services/SKUs/regions/license boundaries;
- budget/ceiling, quotas, schedules, and alert tests;
- observed cost and anomaly records;
- teardown and residual-cost verification;
- pilot unit-cost and operating-effort measures; and
- commercial/procurement decision references where applicable.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: scope has approved funding, exact limits, attribution, monitoring, stop authority, and lifecycle cost control.
- `CONTINUE_WITH_CONDITIONS`: credential-free work or a lower-cost bounded run may proceed while optional paid services remain disabled.
- `STOP`: spend is unowned, unlimited, unattributable, commercially unauthorized, or cannot be stopped/verified after teardown.

## Forge handoff

Forge receives cost-owner metadata, approved product profile, ceilings/quotas, tags, evidence destination, and stop conditions. It does not activate payment, select a paid model/provider, or infer authorization from an available billing account.

## Exceptions and prohibited shortcuts

Exceptions require amount, duration, owner, funding authority, monitoring, and expiry. Never treat a budget alert as a guardrail that prevents spend, omit data-transfer/log/model cost, use a personal card/account, leave idle resources after validation, fabricate product unit economics, or roll sandbox authorization into recurring cost.

## Related requirements

- [`BFR-HIE-001` Resource hierarchy](resource-hierarchy.md)
- [`BFR-OPS-001` Operations and support](operations-and-support.md)
- [`BFR-PRQ-004` Live provisioning prerequisites](../prerequisites/provisioning-prerequisites.md)
- [`BFR-AIG-001` AI governance](ai-governance.md)

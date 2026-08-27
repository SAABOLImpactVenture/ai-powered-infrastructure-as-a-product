# Deterministic Product Outcome Metrics

All metrics in this package are calculated from observed `IaaPProductOutcomeRecord` facts. No metric may substitute an estimate for a missing observation unless the estimate is stored separately and explicitly labeled as estimated.

## 1. Approved demand to Ready

**Purpose:** measures end-to-end product delivery latency from the business decision to an operable product outcome.

`approved_to_ready_seconds = ready_at - demand_approved_at`

Required observations:
- `lifecycle.demand_approved_at`
- `lifecycle.ready_at`

If either timestamp is absent, the metric is `null`.

Supporting stage durations may include approval-to-order, order-to-policy-complete, policy-complete-to-human-approval, approval-to-reconciliation-start, and reconciliation-start-to-Ready.

## 2. Adoption and reuse

**Adoption rate**

`adoption_rate = adopting_consumers / eligible_consumers`

**Reuse ratio**

`reuse_ratio = orders_using_existing_product_contract / total_product_orders`

If the denominator is zero or unknown, the metric is `null`.

Reuse means consumption of an already-versioned product contract or approved profile. A copied implementation that creates a new unmanaged variant is not reuse.

## 3. Policy rejection and exception rates

**Policy rejection rate**

`policy_rejection_rate = rejected_policy_evaluations / total_policy_evaluations`

**Exception rate**

`exception_rate = approved_or_pending_exceptions / total_product_requests`

Rejection categories should use stable reason codes such as identity, network, region, security, data classification, cost, product contract, unsupported configuration, missing evidence, or other.

## 4. Reconciliation failure and recovery

**Reconciliation failure rate**

`reconciliation_failure_rate = failed_reconciliation_attempts / total_reconciliation_attempts`

**Recovery success rate**

`recovery_success_rate = successful_recoveries / recovery_attempts`

**Mean time to product recovery**

For products that recover:

`recovery_seconds = recovered_at - failure_detected_at`

Population means must identify the time window and number of recovered products included.

## 5. Evidence completeness and audit traceability

**Evidence completeness**

`evidence_completeness = present_required_evidence / required_evidence`

Evidence integrity should also expose counts for:
- complete;
- missing;
- expired;
- invalid;
- broken lineage; and
- not applicable.

**Traceability completeness** is true only when required lineage can be followed across the configured chain, such as demand → order → requirement → policy/control → approval → implementation → runtime status → evidence.

A partial chain must remain partial; it cannot be inferred complete by AI.

## 6. Upgrade, teardown, and lifecycle success

**Upgrade success rate**

`upgrade_success_rate = successful_upgrades / attempted_upgrades`

**Rollback rate**

`rollback_rate = rollbacks / attempted_upgrades`

**Teardown success rate**

`teardown_success_rate = clean_teardowns / teardown_attempts`

**Orphan rate**

`orphan_rate = teardowns_with_orphans / teardown_attempts`

**Supported-version rate**

`supported_version_rate = active_products_on_supported_versions / active_products`

## 7. Infrastructure-product cost-to-serve

Cost-to-serve is a product unit-economics measure, not merely cloud spend.

For a defined period:

`cost_to_serve = infrastructure_cost + platform_cost + licensing_cost + operations_labor_cost + support_labor_cost + exception_remediation_cost`

Useful unit views include:
- cost per active product instance;
- cost per consuming team;
- cost per environment;
- cost per successful fulfillment; and
- cost per supported product per month.

Each cost observation must identify currency, time period, source, and whether it is observed, allocated, or estimated. Estimated values must never be presented as observed actuals.

## 8. Consumer experience and support demand

Supported measures include:
- Developer or Consumer NPS;
- self-service completion rate;
- order abandonment rate;
- human-intervention rate;
- support cases per 100 completed orders;
- repeat-support rate; and
- mean time to support resolution.

**Support demand rate**

`support_cases_per_100_orders = support_cases / completed_orders * 100`

When no completed orders exist, the metric is `null`.

## Scorecard behavior

An executive scorecard may show current value, target, trend, sample size, period, and status. Targets are customer-defined and must not be embedded as universal claims.

A scorecard with no observation must show `No data`, `Not instrumented`, or equivalent. It must never fabricate a favorable value for presentation purposes.

# Live provisioning prerequisites

**Requirement ID:** `BFR-PRQ-004`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It does not authorize Forge V1 production use or modify its proposal-only, deterministic, human-approved authority boundary.

## Requirement

Before any live nonproduction provisioning, the customer must approve a bounded target and product contract, provide workload identity and foundation attachment points, establish deterministic policy and human approval, and prove monitoring, evidence capture, rollback, teardown, and cost containment.

## Why this requirement exists

An infrastructure product can reconcile safely only when its target foundation supplies dependable identity, networking, DNS, logging, encryption, security, operations, and financial interfaces. Technical executability is not proof that those dependencies or institutional permissions exist.

## Applicability

- **Assessment, simulation, and read-only discovery:** live provisioning remains blocked.
- **Live sandbox:** mandatory entry gate.
- **Pilot:** retained and strengthened by service, resilience, and support requirements.
- **Production consideration:** necessary but insufficient; formal authorization remains external.

## Customer decisions

The customer must decide:

- exact nonproduction target, region, resource hierarchy, and isolation boundary;
- approved infrastructure-product contract and allowed implementation adapter;
- workload identity subject, permissions, audience, duration, and revocation;
- network, DNS, ingress, egress, logging, security-event, encryption, and secret interfaces;
- protected repository, required checks, material-change reviewers, and deployment approver;
- lifecycle behavior for update, rollback, retirement, deletion, and orphan handling;
- evidence destination, acceptance tests, and reassessment trigger;
- cost ceiling, owner, alerts, quotas, and emergency shutdown; and
- teardown authority, order, waiters, and residual-resource queries.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Provisioning dependencies and ownership gaps are identified; no write access exists. |
| Simulation | Product contract, policies, lifecycle, evidence, and negative cases pass without cloud mutation. |
| Read-only discovery | Target assumptions are verified; discovery and execution identities remain separate. |
| Live sandbox | One bounded target, approved workload identity, all dependencies, cost ceiling, evidence, and teardown are proven. |
| Pilot | Support, recovery, concurrency, quotas, consumer acceptance, and repeated lifecycle behavior are demonstrated. |
| Production consideration | Customer authorization bodies evaluate the complete evidence package; no automatic promotion occurs. |

## Composite AI assistance

Composite AI may explain failed preflight controls, compare proposed dependencies with the approved product contract, draft remediation options, summarize sanitized reconciliation status, and assemble evidence references.

It must not approve, merge, apply, create credentials, expand permissions, select a production target, alter policy, suppress a failed gate, or declare a deployment authorized.

## Deterministic validation target

A future provisioning preflight should validate exact target identity, nonproduction flag, supported product/profile, workload federation, least privilege, foundation attachment contracts, protected change evidence, required approval, cost ceiling, acceptance tests, evidence destination, teardown plan, and residual query. Missing or mismatched inputs must produce no write action. This is a future validation target and does not claim current Forge V1 deployment capability.

## Human approval

Platform, security, network, data, operations, and financial owners approve their respective dependencies. A named deployment authority approves the exact target, immutable change, cost ceiling, and time window. Approval for one run is not reusable for another target or revision.

## Required evidence

- immutable product and implementation revisions;
- deterministic contract/policy/test results;
- target and nonproduction-boundary proof;
- workload-identity and effective-permission evidence;
- network, DNS, logging, encryption, and security integration approvals;
- change-review and deployment-approval record;
- monitoring and acceptance results;
- cost ceiling and observed cost;
- teardown execution and residual-resource verification; and
- decision, conditions, and reassessment record.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: one exact live sandbox run is permitted within the recorded boundary and approval window.
- `CONTINUE_WITH_CONDITIONS`: simulation or discovery may continue, or provisioning may be limited to a narrower isolated target explicitly covered by the conditions.
- `STOP`: any required dependency, identity, human approval, evidence path, cost control, rollback, teardown, or target boundary is missing or inconsistent.

## Forge handoff

Forge receives a reference to the approved product order, immutable Guard/advisory evidence selected by a human, target profile, workload-identity binding, foundation interface references, lifecycle policy, required checks, approval record, evidence destination, and teardown contract. It does not receive risk-acceptance authority or raw administrative credentials.

## Exceptions and prohibited shortcuts

Exceptions must be target-specific, time-bounded, approved by the responsible authority, and tested with compensating controls. Never bypass failed preflight, use static administrator keys, let a storefront or AI apply directly, share identities across discovery and execution, treat a budget alert as spending approval, omit teardown, or promote sandbox approval to pilot or production.

## Related requirements

- [`BFR-WID-001` Workload identity](../foundation-domains/workload-identity.md)
- [`BFR-NET-001` Networking and connectivity](../foundation-domains/networking-and-connectivity.md)
- [`BFR-DEL-001` Delivery and change governance](../foundation-domains/delivery-and-change-governance.md)
- [`BFR-PRD-001` Infrastructure-product contracts](../foundation-domains/infrastructure-product-contracts.md)
- [`BFR-FIN-001` Cost ownership and FinOps](../foundation-domains/cost-ownership-and-finops.md)

# Governance and ownership

**Requirement ID:** `BFR-GOV-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It is a documentation target, not a current Guard or Forge V1 rule or authority grant.

## Requirement

The customer must assign accountable ownership for the foundation, each infrastructure product, security and architecture decisions, operations, evidence, finance, AI governance, exceptions, and risk acceptance before the corresponding stage proceeds.

## Why this requirement exists

Technology cannot resolve unclear institutional authority. Without named decision owners, gaps become implicit implementation-team decisions, exceptions persist indefinitely, and evidence cannot establish who accepted an outcome or remains responsible for it.

## Applicability

Governance is required at every stage. The number and formality of roles may grow from assessment to production consideration, but responsibility must never be inferred from repository access or technical capability.

## Customer decisions

The customer must decide:

- who sponsors the foundation and owns its outcomes;
- who owns each product contract and consumer promise;
- who has architecture, security, data, operational, financial, and AI-governance decision rights;
- who may approve material changes, exceptions, deployments, pilots, and risk acceptance;
- which duties must be separated and how delegates are recorded;
- how conflicts, absences, and escalations are handled; and
- how ownership is reviewed when organizations or services change.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Sponsor, foundation owner, assessment owner, security/architecture reviewers, and evidence owner are named. |
| Simulation | Product, policy, test, and decision owners approve the simulated boundary. |
| Read-only discovery | Cloud/resource and data owners authorize scope and access. |
| Live sandbox | Deployment, operations, finance, teardown, and incident owners are named for the exact target. |
| Pilot | Service, consumer, risk, support, and continuity owners accept pilot obligations. |
| Production consideration | Formal decision rights, delegates, separation of duties, and recertification are approved. |

## Composite AI assistance

Composite AI may extract named roles from approved sources, identify missing or conflicting ownership, draft a RACI, and route questions to the recorded role. It must show provenance and uncertainty.

It must not invent an owner, treat a repository maintainer as a risk authority, assign work, approve on someone's behalf, or resolve an organizational conflict.

## Deterministic validation target

A future validator should require named role identifiers, accountable/consulted distinctions, decision types, delegation rules, separation-of-duty constraints, review dates, and source approvals. Empty groups, self-approval of prohibited combinations, expired delegates, and unresolved required roles should fail closed. This is not current V1 enforcement.

## Human approval

The executive or platform sponsor approves the governance model. Each named accountable owner accepts the responsibility. Risk-acceptance authority must be identified through the customer's institutional process, not derived from the IaaP toolchain.

## Required evidence

- ownership and decision-rights matrix;
- role acceptance and delegation records;
- separation-of-duty policy;
- escalation and dispute process;
- product/service ownership records;
- exception and risk-authority designations; and
- periodic ownership review results.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: every required role for the requested stage is named, accepted, current, and appropriately separated.
- `CONTINUE_WITH_CONDITIONS`: a narrower activity may proceed while a nonmaterial supporting role is filled by a documented temporary delegate with an expiry.
- `STOP`: accountable ownership, deployment authority, risk authority, evidence ownership, or a required separation of duties is absent or contradictory.

## Forge handoff

Forge receives stable owner references, required reviewer roles, decision identifiers, and escalation contacts associated with a product initiative. It must not convert those references into an authority model or permit the submitter to self-approve a material change.

## Exceptions and prohibited shortcuts

Exceptions require an approving authority, rationale, compensating control, expiry, and succession plan. Prohibited shortcuts include group names with no accountable person/process, implicit ownership based on code authorship, approval by the proposed change, permanent temporary delegates, and assigning risk acceptance to AI or automation.

## Related requirements

- [`BFR-PRQ-001` Assessment prerequisites](../prerequisites/assessment-prerequisites.md)
- [`BFR-DEL-001` Delivery and change governance](delivery-and-change-governance.md)
- [`BFR-OPS-001` Operations and support](operations-and-support.md)
- [`BFR-AIG-001` AI governance](ai-governance.md)

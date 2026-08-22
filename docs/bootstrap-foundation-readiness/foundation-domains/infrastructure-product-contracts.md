# Infrastructure-product contracts

**Requirement ID:** `BFR-PRD-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It reinforces the existing product-boundary principle but does not alter or broaden any frozen Forge V1 schema.

## Requirement

Every infrastructure product must expose a stable, outcome-oriented, versioned consumer contract with accountable ownership, bounded choices, deterministic validation, lifecycle/status semantics, support expectations, evidence obligations, and an implementation-independent handoff.

## Why this requirement exists

Without a product contract, consumers order implementation machinery and inherit platform complexity. Stable contracts allow providers, compositions, modules, policies, and storefronts to evolve while consumer intent, ownership, and expected outcomes remain understandable.

## Applicability

Assessment identifies candidate products and contract gaps. Simulation validates schemas and mappings. Discovery confirms required foundation dependencies. Live sandbox proves lifecycle behavior. Pilot and production consideration prove consumer value, support, compatibility, and evolution.

## Customer decisions

The customer must decide:

- product purpose, consumers, owner, support owner, and measurable outcomes;
- allowed profiles, environments, regions, classifications, capacities, and ownership metadata;
- which choices belong to consumers and which implementation details remain platform-owned;
- versioning, compatibility, defaults, deprecation, migration, and rollback policy;
- status, conditions, health, lifecycle, retirement, deletion, and orphan semantics;
- security, cost, evidence, service, and exception obligations; and
- mapping to implementation adapters without creating multiple authoritative reconcilers.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Product purpose, owner, consumers, desired outcomes, dependencies, and contract gaps are identified. |
| Simulation | Versioned schema, deterministic validation, defaults, negative cases, proposal, and lifecycle/status model pass. |
| Read-only discovery | Product assumptions match approved foundation capabilities and limits. |
| Live sandbox | One bounded profile reconciles, reports status, enforces lifecycle, produces evidence, and tears down safely. |
| Pilot | Repeated orders, consumer usability, support, compatibility, cost, reliability, and outcome metrics are observed. |
| Production consideration | Product/service governance, scale, availability, support, migration, and authorization are formally accepted. |

## Composite AI assistance

Composite AI may translate approved intent into a candidate contract, identify ambiguous choices, explain policy feedback, propose alternatives, and draft documentation or acceptance criteria.

It must not add fields beyond the authoritative schema, expose provider credentials/topology, select its own implementation, change lifecycle policy, approve the contract, or claim a proposal is reconciled.

## Deterministic validation target

A future validator should verify schema/version, owner, bounded enums/patterns, classification/environment alignment, implementation-field exclusion, lifecycle/status/evidence requirements, compatibility policy, and proposal equality to deterministic rendering. Unknown fields, raw credentials, provider configuration, consumer-controlled deletion policy, or unsupported production requests should fail closed. This statement does not expand current Forge V1 contracts.

## Human approval

The product owner approves consumer outcomes and contract. Architecture/security/platform owners approve boundaries and implementation mappings. Operations and finance accept lifecycle/support/cost. Material versions require governed customer review.

## Required evidence

- product charter and owner;
- versioned schema and examples;
- positive/negative/compatibility test results;
- consumer-to-implementation mapping and authority model;
- lifecycle, status, rollback, retirement, and teardown tests;
- security, cost, support, and evidence requirements;
- consumer acceptance and product outcome measures; and
- approval, release, deprecation, and migration records.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: the product contract is bounded, owned, versioned, validated, lifecycle-complete, and appropriate for the requested stage.
- `CONTINUE_WITH_CONDITIONS`: assessment/simulation or a narrow sandbox profile may proceed while missing noncritical product/service capabilities remain explicit.
- `STOP`: consumer contract exposes implementation authority, lacks ownership/lifecycle/evidence, accepts unsupported scope, or conflicts with foundation limits.

## Forge handoff

Forge consumes only a contract/version it explicitly supports and a human-approved product order. New bootstrap or foundation-readiness documents cannot be smuggled into existing Forge V1 schemas; any executable successor requires a separately versioned contract, compatibility tests, and migration guidance.

## Exceptions and prohibited shortcuts

Exceptions must be expressed outside the consumer contract with authority, scope, expiry, and remediation. Never expose raw IAM, provider configs, compositions, Terraform workspaces, lifecycle/deletion switches, unrestricted regions, or hidden defaults; do not label a one-off template a product without ownership and lifecycle.

## Related requirements

- [`BFR-DEL-001` Delivery and change governance](delivery-and-change-governance.md)
- [`BFR-GOV-001` Governance and ownership](governance-and-ownership.md)
- [`BFR-OPS-001` Operations and support](operations-and-support.md)
- [`BFR-EVD-001` Evidence and traceability](evidence-and-traceability.md)

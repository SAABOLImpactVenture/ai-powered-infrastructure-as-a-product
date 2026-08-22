# Read-only discovery prerequisites

**Requirement ID:** `BFR-PRQ-003`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. Current IaaP Guard V1 does not request customer-cloud credentials, and this page does not change that boundary.

## Requirement

Before any adapter inspects a live cloud environment, the customer must authorize an exact read-only scope, bind it to a revocable short-lived identity where supported, log every discovery action, and define collection, redaction, retention, and evidence ownership.

## Why this requirement exists

Cloud metadata can reveal network topology, account structure, identities, resource names, security controls, and sensitive operational context. “Read-only” limits mutation but does not eliminate confidentiality, privacy, cost, availability, or authorization risk.

## Applicability

- **Assessment and simulation:** not required when evidence is supplied as approved exports or synthetic fixtures.
- **Read-only discovery:** mandatory.
- **Live sandbox and pilot:** retained for discovery functions even when a separate execution identity exists.
- **Production consideration:** discovery access requires its own ongoing authorization and monitoring.

## Customer decisions

The customer must decide:

- exact organization, account, subscription, project, folder, region, service, and environment scope;
- discovery principal, federation method, session duration, and revocation owner;
- permitted APIs and explicitly denied data-plane or secret-reading actions;
- what metadata may be collected, normalized, retained, exported, or supplied to Composite AI;
- redaction rules for identifiers, network data, logs, and regulated information;
- discovery frequency, maintenance window, rate limits, and cost limits;
- audit-log and evidence destinations; and
- the event that ends access or requires reassessment.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Customer-supplied exports may be used with source, timestamp, scope, and redaction recorded. |
| Simulation | Discovery behavior is tested against synthetic or sanitized snapshots. |
| Read-only discovery | Exact scope, approved principal, API allowlist, logging, redaction, retention, and revocation are proven. |
| Live sandbox | Discovery and execution identities are separate and distinguishable in logs. |
| Pilot | Recurring discovery, drift handling, alerting, and access review are exercised. |
| Production consideration | Continuous access receives formal customer authorization and periodic recertification. |

## Composite AI assistance

Composite AI may analyze approved normalized metadata, identify gaps, compare observed state with documented expectations, and propose follow-up questions. It should receive the minimum sanitized representation needed for the task.

It must not obtain cloud credentials, invoke discovery APIs directly unless a future separately authorized adapter mediates and logs the call, request data-plane contents, infer authorization from technical access, or retain raw sensitive exports outside policy.

## Deterministic validation target

A future preflight should verify exact target identifiers, read-only action allowlists, explicit denies for mutation and secret/data access, identity expiry, audit destination, collection schema, redaction policy, retention, evidence digest, and revocation procedure. Wildcards without documented necessity or any write-capable action should fail closed. This is a proposed adapter contract, not Guard V1 behavior.

## Human approval

The cloud resource owner authorizes target scope; identity/security owners approve the principal and permissions; the data owner approves collected fields and AI processing; and operations approves timing and rate limits.

## Required evidence

- approved target and API scope;
- effective permissions or policy simulation result;
- identity subject, issuer, audience, and expiration;
- audit-log capture test;
- collection and redaction schema;
- sample sanitized discovery artifact with source timestamp and digest;
- retention and deletion rule;
- revocation test; and
- named approvals.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: the requested discovery is exact, read-only, auditable, minimized, revocable, and approved.
- `CONTINUE_WITH_CONDITIONS`: assessment continues using customer-supplied exports or a narrower target while live discovery remains disabled.
- `STOP`: scope is ambiguous, permissions permit mutation or sensitive data access, logging or consent is absent, or access cannot be revoked.

## Forge handoff

Discovery findings may inform a human-selected Forge initiative, but the discovery identity is never transferred to Forge as an execution identity. The handoff contains normalized observations, immutable source scope, timestamps, confidence/provenance, and approved remediation selections.

## Exceptions and prohibited shortcuts

Exceptions must narrow, never silently broaden, access. Prohibited shortcuts include reusing administrator credentials, using static keys when federation is available, combining discovery and provisioning principals, collecting secret values or workload payloads, treating cached data as current, and granting organization-wide scope merely for convenience.

## Related requirements

- [`BFR-PRQ-001` Assessment prerequisites](assessment-prerequisites.md)
- [`BFR-IAM-001` Identity and access](../foundation-domains/identity-and-access.md)
- [`BFR-DAT-001` Data classification](../foundation-domains/data-classification.md)
- [`BFR-EVD-001` Evidence and traceability](../foundation-domains/evidence-and-traceability.md)
- [`BFR-AIG-001` AI governance](../foundation-domains/ai-governance.md)

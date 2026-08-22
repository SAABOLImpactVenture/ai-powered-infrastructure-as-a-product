# Identity and access

**Requirement ID:** `BFR-IAM-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It is provider-neutral guidance and does not grant current Guard, Forge, Console, or Composite AI access to customer systems.

## Requirement

The customer must authenticate human and nonhuman actors through approved identity sources, apply least privilege and separation of duties, control privileged access, and make access attributable, reviewable, revocable, and time bounded where practicable.

## Why this requirement exists

Every later control depends on knowing who or what acted and under which authority. Shared accounts, static privilege, weak federation, or unreviewed inherited roles make approvals and evidence unreliable even when the underlying configuration is otherwise sound.

## Applicability

Identity and access are required at every stage. Assessment may use no cloud identity, but access to repositories, documents, the bootstrap runtime, and evidence still requires authenticated and authorized users.

## Customer decisions

The customer must decide:

- authoritative workforce and workload identity providers;
- authentication strength, session duration, device/location conditions, and break-glass controls;
- role model for consumers, operators, reviewers, approvers, auditors, and administrators;
- privileged-access request, elevation, monitoring, and revocation process;
- separation between discovery, provisioning, approval, evidence, and model-provider roles;
- guest, contractor, service-provider, and machine-identity rules;
- joiner/mover/leaver and periodic access-review cadence; and
- logging, alerting, and investigation ownership.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Authenticated repository/evidence access and named reviewers; no cloud write identity. |
| Simulation | Isolated roles, no static cloud credentials, and deterministic authority-denial tests. |
| Read-only discovery | Dedicated read-only principal, exact scope, short session, logging, and revocation. |
| Live sandbox | Separate workload identity, human approvers, privileged operators, and emergency access. |
| Pilot | Recertification, incident monitoring, service identities, and consumer access lifecycle are exercised. |
| Production consideration | Enterprise IAM, PAM, federation, recertification, and audit obligations are formally accepted. |

## Composite AI assistance

Composite AI may summarize approved role definitions, flag privilege conflicts, explain effective access evidence, and draft least-privilege recommendations.

It must not authenticate as a person, obtain or reveal credentials, approve elevation, create roles, infer authority from group membership alone, or decide that excessive privilege is acceptable.

## Deterministic validation target

A future validator should verify approved issuers, subjects, audiences, role/action/resource constraints, MFA or equivalent controls for humans, expiry and revocation, separation-of-duty conflicts, privileged paths, and audit logging. Shared principals, wildcard administrative access without exception, dormant privileges, or AI/tool credentials should fail closed for live stages. This is not current runtime behavior.

## Human approval

Identity/security owners approve federation and role design. Resource owners approve access to their scope. Privileged-access and risk authorities approve exceptions. Individuals must not approve their own material elevation.

## Required evidence

- identity-provider and trust configuration;
- role and effective-permission matrix;
- human authentication and privileged-access policy;
- workload-identity inventory;
- approval and revocation records;
- access-review results;
- break-glass test and monitoring evidence; and
- attributable audit events for representative actions.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: required actors are federated, least-privileged, separated, auditable, and revocable for the requested stage.
- `CONTINUE_WITH_CONDITIONS`: work continues without live mutation or within a narrower scope while noncritical role cleanup has a named owner and expiry.
- `STOP`: identity is shared, unauditable, overprivileged, nonrevocable, self-approving, or dependent on prohibited static credentials.

## Forge handoff

Forge receives identity references and permitted operations, never credential values. The execution subject, human approval roles, and evidence-reader roles remain distinct. Cloud-native IAM remains the enforcement boundary.

## Exceptions and prohibited shortcuts

Exceptions require resource/action scope, justification, compensating monitoring, approver, and expiry. Never place credentials in repositories or prompts, share service accounts, grant organization administrator for convenience, reuse discovery identities for apply, disable MFA for automation, or treat repository write access as deployment approval.

## Related requirements

- [`BFR-WID-001` Workload identity](workload-identity.md)
- [`BFR-SEC-001` Secrets management](secrets-management.md)
- [`BFR-DEL-001` Delivery and change governance](delivery-and-change-governance.md)
- [`BFR-PRQ-003` Read-only discovery prerequisites](../prerequisites/discovery-prerequisites.md)

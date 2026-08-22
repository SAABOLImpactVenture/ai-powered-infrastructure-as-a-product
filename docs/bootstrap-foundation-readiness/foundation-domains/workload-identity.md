# Workload identity

**Requirement ID:** `BFR-WID-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It preserves Forge V1's short-lived-federation principle and does not claim that a current Forge proposal provisions live identity.

## Requirement

Every automation or control-plane workload that accesses repositories, platforms, models, or clouds must use a dedicated, narrowly scoped, attributable, revocable workload identity based on short-lived federation where supported. Static long-lived cloud credentials are prohibited for the reference path.

## Why this requirement exists

Workload identity determines the real execution boundary. Static keys are easy to copy, difficult to attribute, and often outlive the workload or approval that justified them. Federation binds access to an issuer, subject, audience, target, and session.

## Applicability

- **Assessment:** no cloud workload identity is needed for repository-only assessment; bootstrap services still need service identities.
- **Simulation:** identity contracts are validated without minting live cloud credentials.
- **Read-only discovery:** dedicated read-only federation is required.
- **Live sandbox and later stages:** dedicated execution identities and lifecycle management are mandatory.

## Customer decisions

The customer must decide:

- trusted issuer, exact subject, audience, target role, and allowed claims;
- identity per environment, product, adapter, and function;
- permitted actions/resources and explicit denies;
- token/session lifetime, refresh behavior, replay controls, and clock assumptions;
- creation, rotation of trust, suspension, revocation, and deletion ownership;
- separation of discovery, provisioning, model, evidence, and CI identities;
- monitoring and alert rules for anomalous use; and
- emergency disablement and recovery procedure.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Bootstrap service identities are inventoried; no unnecessary cloud access exists. |
| Simulation | Issuer/subject/audience and least-privilege policies validate without live token use. |
| Read-only discovery | Dedicated short-lived read identity, exact scope, audit, and revocation test. |
| Live sandbox | Dedicated execution identity, protected trust change, permission test, monitoring, and teardown. |
| Pilot | Identity lifecycle, concurrency, rotation/revocation, incident response, and recertification are exercised. |
| Production consideration | Customer IAM authorities approve durable federation, monitoring, recovery, and operational ownership. |

## Composite AI assistance

Composite AI may explain trust relationships, identify wildcard claims, compare effective permissions with required operations, and draft a least-privilege proposal from approved product behavior.

It must not mint tokens, read credential material, modify trust, choose its own identity, grant privilege, or turn suggested permissions into an applied policy.

## Deterministic validation target

A future validator should check approved issuer, exact subject and audience, target/environment binding, token lifetime, action/resource allowlist, explicit prohibition of static keys, separate functional identities, logging, and revocation/teardown. Wildcard subjects, unbounded audiences, administrator roles, stored access keys, or missing expiry should fail closed. This is a proposed target.

## Human approval

Identity/security and target-resource owners approve the trust and permissions. Platform operations approves lifecycle and emergency disablement. The deployment approver authorizes use of the identity for an exact run or governed operating mode.

## Required evidence

- trust policy and immutable revision;
- issuer, subject, audience, target, and environment mapping;
- effective-permission and negative-permission tests;
- token lifetime and secret-scan results;
- representative attributable audit event;
- monitoring and anomaly alert test;
- revocation/disablement test; and
- identity cleanup evidence after teardown.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: the workload identity is exact, short-lived, least-privileged, monitored, and approved for the requested scope.
- `CONTINUE_WITH_CONDITIONS`: simulation or read-only work may proceed while execution identity remains disabled or limited to a narrower approved target.
- `STOP`: static credentials, wildcard trust, excess privilege, shared identity, missing auditability, or untested revocation is present.

## Forge handoff

Forge receives a nonsecret identity binding reference plus allowed operations and target scope. It must not render secret values, broaden trust, or assume that an identity binding constitutes permission to apply. The approved change path activates any live use.

## Exceptions and prohibited shortcuts

Exceptions must be rare, time-bound, monitored, and approved by identity/security authorities with a migration plan to federation. Never put access keys in Kubernetes Secrets for the reference path, share one identity across environments, trust an entire organization/repository namespace without necessity, or retain identity after target teardown.

## Related requirements

- [`BFR-IAM-001` Identity and access](identity-and-access.md)
- [`BFR-PRQ-003` Read-only discovery prerequisites](../prerequisites/discovery-prerequisites.md)
- [`BFR-PRQ-004` Live provisioning prerequisites](../prerequisites/provisioning-prerequisites.md)
- [`BFR-SEC-001` Secrets management](secrets-management.md)

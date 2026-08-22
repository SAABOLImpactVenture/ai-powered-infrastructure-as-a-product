# Encryption and key management

**Requirement ID:** `BFR-KMS-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It does not assert compliance, mandate one provider service, or change current Guard or Forge V1 behavior.

## Requirement

The customer must define approved encryption in transit and at rest, key ownership, trust boundaries, access, rotation, recovery, revocation, separation of duties, evidence, and lifecycle for bootstrap data, evidence, product resources, backups, and integrations.

## Why this requirement exists

Encryption is only as reliable as its key ownership and lifecycle. Default encryption can protect media while leaving unclear administrators, uncontrolled cross-account use, unrecoverable data, or keys that survive after the product and its evidence should be retired.

## Applicability

Encryption applies to stored and transmitted assessment material at the first persistent stage. Read-only discovery, live sandbox, pilot, and production consideration require increasingly specific key bindings, monitoring, recovery, and lifecycle evidence.

## Customer decisions

The customer must decide:

- data and connections requiring encryption and approved algorithms/protocol profiles;
- provider-managed, customer-managed, external, or hardware-backed key patterns by classification;
- key administrator, user, auditor, recovery, and deletion roles;
- account/project/region placement, residency, sharing, and cross-boundary use;
- creation, rotation, aliasing, versioning, revocation, disablement, archival, and destruction;
- certificate ownership, issuance, renewal, trust stores, and expiry monitoring;
- backup/recovery dependencies and behavior during key unavailability; and
- audit, alerting, evidence retention, and exception process.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Data classes, encryption expectations, key/certificate owners, and gaps are identified. |
| Simulation | Key references and policies validate without real secret or key material. |
| Read-only discovery | Effective encryption, key policies, rotation, and logging are observed without reading plaintext data. |
| Live sandbox | Approved key binding, least privilege, TLS, monitoring, recovery/disablement, and teardown behavior are tested. |
| Pilot | Rotation, certificate renewal, failure, backup recovery, cross-service use, and incident playbooks are exercised. |
| Production consideration | Enterprise cryptographic policy, residency, custody, resilience, and lifecycle are formally accepted. |

## Composite AI assistance

Composite AI may compare approved metadata with policy, identify missing owners or rotation evidence, explain key-pattern tradeoffs, and draft recovery or decision questions using sanitized configuration.

It must not receive private keys or plaintext secrets, choose custody, rotate/disable/delete keys, approve algorithms, infer compliance, or recommend exposing key material for troubleshooting.

## Deterministic validation target

A future validator should check encryption flags, approved protocol/profile, exact key/certificate reference, ownership, policy, separation of duties, rotation/expiry, logging, recovery, deletion state, and classification alignment. Plaintext transport/storage, broad key administration, disabled audit, unresolved residency, or embedded key material should fail closed. This is a proposed target.

## Human approval

Security/cryptographic authorities approve patterns and exceptions. Data owners approve key type and residency. Platform/operations owners approve lifecycle and recovery. Destructive key actions require authorized human approval and recovery-impact confirmation.

## Required evidence

- encryption and key/certificate inventory;
- data-classification-to-cryptography mapping;
- key policies and effective access;
- rotation and expiry monitoring results;
- TLS and at-rest configuration evidence;
- audit events and alert tests;
- key/certificate failure and recovery exercise; and
- disablement, retirement, and destruction records where applicable.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: required data and connections use approved encryption with owned, least-privileged, monitored, recoverable key lifecycle.
- `CONTINUE_WITH_CONDITIONS`: synthetic/local work or a lower-class isolated sandbox may proceed while stronger customer-managed controls remain a gate for higher stages.
- `STOP`: plaintext exposure, missing key authority, excessive access, expired/unknown certificates, untested recovery, or incompatible residency/lifecycle exists.

## Forge handoff

Forge receives approved encryption profiles and nonsecret key/certificate references. Key creation or lifecycle is handled by a separately governed platform product or customer service; consumers and AI do not supply raw key material.

## Exceptions and prohibited shortcuts

Exceptions require affected data, duration, compensating control, security/data approvals, and exit plan. Never place keys in repositories, prompts, logs, or product orders; disable TLS validation; share one unrestricted key across environments; delete a key before retention obligations end; or treat provider defaults as proof of policy compliance.

## Related requirements

- [`BFR-SEC-001` Secrets management](secrets-management.md)
- [`BFR-DAT-001` Data classification](data-classification.md)
- [`BFR-BCP-001` Backup, recovery, and continuity](backup-recovery-and-continuity.md)
- [`BFR-IAM-001` Identity and access](identity-and-access.md)

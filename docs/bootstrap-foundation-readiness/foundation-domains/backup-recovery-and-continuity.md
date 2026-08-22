# Backup, recovery, and continuity

**Requirement ID:** `BFR-BCP-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It does not make a production RTO, RPO, availability, or live-recovery claim for current Guard, Forge, or Console V1.

## Requirement

The customer must define what bootstrap, product, configuration, state, evidence, key, and operational data must be protected; set customer-approved recovery objectives; assign recovery authority; and prove restore, continuity, reconciliation, and retirement behavior appropriate to the requested stage.

## Why this requirement exists

A backup setting is not recovery evidence. Foundation services can fail through repository corruption, identity compromise, key loss, control-plane loss, provider outage, evidence-store failure, or operator error. Recovery must preserve authority and evidence, not restore unsafe or stale state automatically.

## Applicability

Assessment identifies protected assets and obligations. Simulation/tabletop validates order and decisions. Discovery protects collected evidence and configuration. Live sandbox proves selected restore/teardown paths. Pilot and production consideration require repeated, measured exercises and continuity ownership.

## Customer decisions

The customer must decide:

- protected assets, authoritative sources, dependencies, and excluded transient data;
- recovery time and recovery point objectives by stage/product;
- backup location, isolation, encryption, key dependency, immutability, retention, and access;
- restoration order for identity, repositories, evidence, control plane, products, networking, DNS, and integrations;
- regional/provider outage, ransomware, corruption, and lost-key scenarios;
- who may declare disaster, restore, fail over, reconcile, or resume service;
- validation frequency, test data, success criteria, and evidence; and
- retirement, legal hold, destruction, and residual-data handling.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Protected assets, authorities, dependencies, retention, and recovery gaps are inventoried. |
| Simulation | Recovery order, authority, failure scenarios, and evidence handling pass tabletop/deterministic checks. |
| Read-only discovery | Collected evidence and configuration snapshots are integrity-protected and recoverable. |
| Live sandbox | Representative configuration/evidence restore, control-plane recovery or rebuild, rollback, and teardown are tested. |
| Pilot | Objectives are measured; identity/key/repository/provider failures and consumer communications are exercised. |
| Production consideration | Formal continuity, regional strategy, staffing, dependencies, exercises, and risk acceptance are approved. |

## Composite AI assistance

Composite AI may map dependencies, draft scenarios and checklists, summarize sanitized exercise evidence, identify missing recovery steps, and compare measured results with customer-set objectives.

It must not declare disaster, initiate restore/failover, choose recovery objectives, use recovery credentials, authorize resumption, or replace missing test results with predicted outcomes.

## Deterministic validation target

A future validator should verify asset inventory, authoritative source, backup policy, encryption/key availability, isolation, retention, objective, restoration order, assigned roles, last test, measured result, residual checks, and exception expiry. Untested backups, circular key dependencies, mutable-only evidence, missing authority, or fabricated RTO/RPO results should fail closed for later stages. This is a proposed target.

## Human approval

Product/service and continuity owners approve objectives and procedures. Security/data owners approve protection, isolation, and retention. Operations approves restoration and resumption playbooks. Risk authorities accept unresolved continuity gaps through customer processes.

## Required evidence

- protected-asset and dependency inventory;
- backup, replication, retention, legal-hold, and destruction policy;
- encryption/key recovery and access evidence;
- immutable backup or reproducible-build evidence;
- restoration/failover/rebuild runbooks;
- tabletop and technical exercise records with measured times and data loss;
- reconciliation and residual-resource results; and
- human decision to resume, remediate, or stop.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: recovery scope, objectives, authority, protected copies, dependencies, and tested outcomes satisfy the requested stage.
- `CONTINUE_WITH_CONDITIONS`: a bounded evaluation may proceed with reduced objectives and explicit nonproduction data while missing later-stage capabilities remain tracked.
- `STOP`: required data/evidence is unrecoverable, restoration is untested, keys/identity create a circular dependency, objectives lack owners, or service resumption is automatic/unapproved.

## Forge handoff

Forge receives lifecycle recovery requirements, backup/evidence destination references, product restore/reconcile expectations, and human resumption gates. It may render repeatable desired state but must not assume that reconciliation replaces backup or continuity planning.

## Exceptions and prohibited shortcuts

Exceptions require affected assets, objective impact, compensating procedure, owner, expiry, and test date. Never claim recovery from backup completion, store all copies in one failure domain, delete keys before retention ends, auto-restore compromised state, omit evidence recovery, or substitute teardown for data disposition.

## Related requirements

- [`BFR-OPS-001` Operations and support](operations-and-support.md)
- [`BFR-KMS-001` Encryption and key management](encryption-and-key-management.md)
- [`BFR-EVD-001` Evidence and traceability](evidence-and-traceability.md)
- [`BFR-PRQ-005` Pilot and production-consideration prerequisites](../prerequisites/production-pilot-prerequisites.md)

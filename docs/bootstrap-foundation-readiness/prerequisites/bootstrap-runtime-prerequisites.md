# Bootstrap runtime prerequisites

**Requirement ID:** `BFR-PRQ-002`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It does not alter the frozen Guard or Forge V1 runtime, authorize production, or claim that the current customer-hosted synthetic profile implements this target.

## Requirement

Before customer-hosted assessment services run, the customer must provide a bounded nonproduction runtime with customer-controlled identity, encryption, secrets handling, audit logging, monitoring, backup, network restrictions, repository connectivity, cost ownership, and an identified operator.

## Why this requirement exists

Composite AI can help design a larger foundation only after its own processing and evidence boundary is trustworthy. The bootstrap is intentionally smaller than an enterprise landing zone, but it still handles architecture material, decisions, and evidence that must not be placed in an unmanaged environment.

## Applicability

- **Assessment:** required when assessment processing is hosted rather than performed entirely offline.
- **Simulation:** required for shared or persistent simulation services.
- **Read-only discovery:** mandatory and extended by discovery controls.
- **Live sandbox, pilot, and production consideration:** mandatory; later stages require stronger, customer-specific authorization.

## Customer decisions

The customer must decide:

- runtime owner, operator, hosting platform, region, and nonproduction boundary;
- workforce identity provider, roles, session controls, and privileged-access process;
- encryption and key owner for data at rest and in transit;
- secret store, secret consumers, rotation, and emergency-revocation process;
- allowed inbound and outbound connectivity, repositories, registries, and model endpoints;
- audit, application, security, and evidence-log destinations;
- backup scope, recovery objectives for the bootstrap, and restoration owner;
- software/package provenance rules, update windows, and vulnerability response; and
- budget, cost alerts, capacity limits, and shutdown authority.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Approved nonproduction host, authenticated access, encryption, audit trail, evidence store, and named operator. |
| Simulation | Pinned components, isolated execution, synthetic/sanitized fixtures, deterministic tests, backup, and budget controls. |
| Read-only discovery | Controlled egress, read-only identity separation, discovery activity logs, and evidence-ingestion limits. |
| Live sandbox | Workload identity, protected change path, monitoring, incident response, recovery test, and authorized target binding. |
| Pilot | Support coverage, capacity, dependency ownership, tested restoration, and customer-specific threat model. |
| Production consideration | Formal operational acceptance and authorization outside this documentation package. |

## Composite AI assistance

Composite AI may compare the declared bootstrap against approved patterns, identify missing decisions, propose a component inventory, draft a threat-model agenda, and explain provider-neutral options using sanitized context.

It must not select an authoritative control without human decision, configure the runtime, receive administrative credentials, weaken isolation, or claim the bootstrap is production ready.

## Deterministic validation target

A future validator should check that the runtime profile identifies owners, environment, identity mode, encryption, secret store, logging, monitoring, backup, egress policy, repository/registry allowlists, cost ceiling, and prohibited authorities. Unknown components, static cloud keys, vendor control of customer evidence, missing audit logging, or production flags should fail closed. This target is not an assertion about current Guard or Forge V1 enforcement.

## Human approval

The platform owner accepts the runtime design; security approves trust boundaries and data flow; the data/evidence owner approves retention; operations accepts support and recovery; and the financial owner accepts the cost boundary. Production authorization is always separate.

## Required evidence

- bootstrap architecture and data-flow diagram;
- asset, dependency, and version inventory;
- identity and role matrix;
- encryption, key, and secret-store configuration evidence;
- network and egress policy with enforcement test;
- audit/monitoring destinations and alert test;
- backup and restoration record;
- package provenance and vulnerability-management record;
- cost ceiling, owner, and alert configuration; and
- human approvals and expiration/review dates.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: the bootstrap satisfies the controls required for the requested nonproduction stage.
- `CONTINUE_WITH_CONDITIONS`: bounded local or simulation work may proceed while named noncritical operational gaps are remediated; cloud access remains disabled when its prerequisites are incomplete.
- `STOP`: identity, encryption, auditability, evidence ownership, network containment, recovery, or accountable operation is missing, or production authority is implied.

## Forge handoff

Forge receives only the approved runtime-facing interfaces it needs for a later stage: protected repository, workload identity subject, control-plane endpoint, evidence destination, allowed namespace, and approval reference. The bootstrap profile must not expose administrative credentials or make Forge the owner of customer operations.

## Exceptions and prohibited shortcuts

Exceptions require a bounded stage, compensating control, owner, expiry, and reassessment trigger. Never use personal accounts, shared administrators, long-lived cloud keys, unrestricted model egress, mutable-only evidence, unpinned packages, unaudited direct changes, or an evaluation runtime as a de facto production service.

## Related requirements

- [`BFR-IAM-001` Identity and access](../foundation-domains/identity-and-access.md)
- [`BFR-NET-001` Networking and connectivity](../foundation-domains/networking-and-connectivity.md)
- [`BFR-KMS-001` Encryption and key management](../foundation-domains/encryption-and-key-management.md)
- [`BFR-OPS-001` Operations and support](../foundation-domains/operations-and-support.md)
- [`BFR-BCP-001` Backup, recovery, and continuity](../foundation-domains/backup-recovery-and-continuity.md)

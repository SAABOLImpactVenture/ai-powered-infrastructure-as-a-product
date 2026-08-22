# DNS responsibilities

**Requirement ID:** `BFR-DNS-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It does not claim that current Guard or Forge V1 creates, validates, or operates customer DNS.

## Requirement

Before a live product depends on name resolution, the customer must define ownership, authority, delegation, resolution paths, access, logging, availability, change, rollback, incident, and lifecycle responsibilities for every applicable public and private namespace.

## Why this requirement exists

DNS is both a dependency and a security boundary. Unclear zone authority, overlapping private namespaces, broken hybrid forwarding, or unsafe automated deletion can make otherwise healthy infrastructure unreachable, misroute traffic, or expose a service publicly.

## Applicability

- **Assessment:** namespace, resolver, forwarding, and owner inventory is required.
- **Simulation:** dependencies and proposed records are expressed without zone mutation.
- **Read-only discovery:** zones, delegations, resolvers, policies, and logging are verified.
- **Live sandbox:** only an authorized private namespace and controlled record lifecycle may be used unless public DNS is separately approved.
- **Pilot/production consideration:** availability, hybrid resolution, security, recovery, automation, and support must be proven.

## Customer decisions

The customer must decide:

- who owns public domains, authoritative name servers, registrar access, DNSSEC, and certificate dependencies;
- who owns private zones, resolver endpoints, forwarding rules, search domains, and split-horizon behavior;
- which namespaces a platform product may use and which team approves zones and records;
- allowed record types, TTL ranges, naming conventions, aliases, wildcard use, and health-check behavior;
- how cloud, on-premises, partner, and multi-region resolution paths connect;
- which identity may create, update, or delete zones and records;
- logging, alerting, incident response, backup/export, rollback, and disaster-recovery expectations;
- deletion, orphan detection, ownership transfer, and domain-expiration processes; and
- whether any public exposure requires a separate security and change decision.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Public/private namespaces, authorities, delegations, resolution paths, and owners are inventoried. |
| Simulation | Proposed zone/record dependencies, TTLs, lifecycle, and prohibited public exposure are represented without changes. |
| Read-only discovery | Authoritative zones, delegation chains, resolver/forwarder configuration, access, and logs are verified. |
| Live sandbox | Authorized private namespace, bounded record types, auditable change, rollback, resolution tests, and cleanup are proven. |
| Pilot | Hybrid and failure resolution, availability, monitoring, incident ownership, certificate coupling, and recovery are exercised. |
| Production consideration | Domain/registrar governance, resilient authoritative/resolver design, security, support, and lifecycle are formally accepted. |

## Composite AI assistance

Composite AI may reconcile approved zone inventories, flag missing ownership or conflicting namespaces, explain provider-specific DNS choices, draft a resolution-path diagram, propose record/TTL patterns, and assemble evidence.

It must not register or transfer domains, change name servers, create/delete zones or records, approve public exposure, access registrar credentials, choose an organizational namespace, or resolve ownership conflicts.

## Deterministic validation target

A future validator should check approved namespace and zone IDs, public/private type, owner, delegation chain, allowed record types, TTL bounds, resolver/forwarder associations, access policy, query/change logging, rollback, deletion policy, and required resolution tests. Unknown authority, overlapping namespaces, unapproved wildcard/public records, disabled logging, or unsafe automatic zone deletion should fail closed. This is a future target only.

## Human approval

Domain/registrar and DNS service owners approve namespaces and delegations. Network and security owners approve resolver paths, forwarding, public exposure, and logging. Product and operations owners approve record lifecycle and service dependencies. Public DNS changes require the customer's designated change authority.

## Required evidence

- domain, zone, delegation, resolver, and forwarding inventory;
- namespace ownership and approval record;
- resolution-path/data-flow diagram;
- access policy and representative change audit event;
- query/change logging and alert configuration;
- internal, external, hybrid, negative, and failure-resolution test results;
- zone/record backup or export and rollback test;
- lifecycle/deletion/orphan procedure; and
- public-exposure and exception decisions.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: namespace authority, resolution, access, logging, lifecycle, tests, and owners satisfy the requested stage.
- `CONTINUE_WITH_CONDITIONS`: assessment, simulation, or an isolated private sandbox may proceed without enterprise/public DNS integration under explicit limits.
- `STOP`: DNS authority is unresolved, namespace overlap exists, public exposure is unapproved, hybrid resolution is undefined, access is excessive, or rollback/ownership is missing.

## Forge handoff

Forge receives only an approved product-facing DNS contract: permitted namespace/zone reference, private/public classification, allowed record types and TTL profile, network associations, logging destination, lifecycle/deletion policy, owner, and approval reference. Provider-specific provisioning remains behind the product boundary.

## Exceptions and prohibited shortcuts

Exceptions must identify exact names/records, business need, security review, monitoring, owner, expiry, and rollback. Never use a personal domain, expose a service publicly to avoid private DNS work, grant registrar or zone-admin access to the product runtime, use broad wildcards without explicit approval, delete shared zones during teardown, or treat successful lookup from one network as end-to-end proof.

## Related requirements

- [`BFR-NET-001` Networking and connectivity](networking-and-connectivity.md)
- [`BFR-ING-001` Ingress and egress](ingress-and-egress.md)
- [`BFR-IAM-001` Identity and access](identity-and-access.md)
- [`BFR-OPS-001` Operations and support](operations-and-support.md)
- [`BFR-BCP-001` Backup, recovery, and continuity](backup-recovery-and-continuity.md)

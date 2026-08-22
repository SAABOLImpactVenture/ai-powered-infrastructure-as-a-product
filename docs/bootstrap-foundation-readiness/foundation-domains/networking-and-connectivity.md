# Networking and connectivity

**Requirement ID:** `BFR-NET-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It does not extend the fixed network fields in current Forge V1 contracts or claim live enterprise-network integration.

## Requirement

The customer must define ownership and approved patterns for address space, segmentation, routing, private connectivity, shared services, DNS dependencies, inspection, ingress, egress, telemetry, and lifecycle before a product attaches to a live network.

## Why this requirement exists

Network placement determines reachability, exposure, failure propagation, data paths, and operational ownership. A deployable subnet is not necessarily safe or routable, and an isolated sandbox result does not establish enterprise connectivity readiness.

## Applicability

- **Assessment:** current topology, owners, dependencies, and known conflicts are documented.
- **Simulation:** desired attachments and prohibited paths are modeled.
- **Read-only discovery:** effective routes, policies, endpoints, and associations are verified.
- **Live sandbox:** one isolated, approved attachment and test plan are required.
- **Pilot/production consideration:** shared services, scale, resilience, monitoring, and incident ownership are proven.

## Customer decisions

The customer must decide:

- authoritative IPAM, address ranges, overlap policy, and allocation owner;
- segmentation pattern by environment, data class, product, and trust zone;
- routing, transit, peering, private service access, and on-premises connectivity owners;
- DNS resolution and namespace responsibilities;
- approved ingress, egress, inspection, proxy, firewall, and endpoint patterns;
- availability-zone/region design and failure containment;
- network change, rollback, monitoring, troubleshooting, and incident processes; and
- lifecycle treatment for attachments, routes, endpoints, and orphaned allocations.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Topology, address ownership, segmentation, dependencies, and unresolved overlaps are identified. |
| Simulation | Attachments, routes, allow/deny paths, DNS, ingress, and egress expectations are testable without mutation. |
| Read-only discovery | Effective routing/security policy and shared-service associations are verified. |
| Live sandbox | Isolated address space, approved attachment, least connectivity, flow telemetry, rollback, and teardown are proven. |
| Pilot | Hybrid/shared-service paths, capacity, resilience, failure tests, and incident operations are exercised. |
| Production consideration | Enterprise network authorities accept architecture, scale, availability, security, and support. |

## Composite AI assistance

Composite AI may normalize diagrams and inventories, identify missing owners, detect documented CIDR overlap, compare observed routes with approved patterns, and propose alternatives with dependencies and tradeoffs.

It must not allocate address space, create connectivity, approve exposure, change routes/firewalls, infer sensitive topology beyond authorized evidence, or treat a syntactically valid path as institutionally approved.

## Deterministic validation target

A future validator should check exact target networks, nonoverlapping approved address allocations, environment/trust-zone alignment, attachment identifiers, required/forbidden paths, DNS and ingress/egress references, flow logging, rollback, and teardown. Unknown routes, broad default access, conflicting CIDRs, or missing ownership should fail closed for live stages. This is not current Forge V1 validation.

## Human approval

Network architecture and operations owners approve address allocation, segmentation, routing, and shared-service attachments. Security approves trust-zone crossings and inspection. Application/product owners accept required dependencies; change authority approves live modification.

## Required evidence

- current and target network/data-flow diagrams;
- IPAM allocation and overlap check;
- route, attachment, endpoint, firewall, and association inventory;
- required and prohibited connectivity matrix;
- flow-log and monitoring evidence;
- connectivity, isolation, failure, rollback, and teardown test results;
- ownership/support matrix; and
- approval and exception records.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: the requested stage has an exact, least-connected, monitored, approved network path with lifecycle ownership.
- `CONTINUE_WITH_CONDITIONS`: simulation or an isolated sandbox may proceed without enterprise connectivity while dependencies and limits remain explicit.
- `STOP`: address conflict, unknown ownership, unapproved trust crossing, unrestricted path, missing telemetry, or absent rollback/teardown exists.

## Forge handoff

Forge receives an approved network product or attachment reference and allowed connectivity profile, not raw topology controls. Network CIDRs, routing machinery, firewall implementation, and lifecycle remain platform-owned unless an explicitly versioned product contract deliberately exposes a bounded choice.

## Exceptions and prohibited shortcuts

Exceptions require exact flows, source/destination, ports/protocols, justification, logging, owner, expiry, and removal test. Never use broad any/any rules, unmanaged peering, ad hoc overlapping ranges, disabled flow logs, consumer-supplied routes, or sandbox connectivity approval as production authorization.

## Related requirements

- [`BFR-DNS-001` DNS responsibilities](dns-responsibilities.md)
- [`BFR-ING-001` Ingress and egress](ingress-and-egress.md)
- [`BFR-LOG-001` Logging and monitoring](logging-and-monitoring.md)
- [`BFR-HIE-001` Resource hierarchy](resource-hierarchy.md)

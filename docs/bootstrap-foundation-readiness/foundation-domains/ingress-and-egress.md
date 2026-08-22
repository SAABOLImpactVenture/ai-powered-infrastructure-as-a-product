# Ingress and egress

**Requirement ID:** `BFR-ING-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It does not authorize current IaaP components or Composite AI to open network paths.

## Requirement

The customer must explicitly approve, enforce, observe, and lifecycle-manage every inbound and outbound path required by the bootstrap or infrastructure product, with default denial for paths not justified by the selected product and stage.

## Why this requirement exists

Unbounded ingress creates exposure; unbounded egress enables data loss, uncontrolled dependencies, and bypass of inspection. “Private” resources can still communicate through unmanaged endpoints, and model/provider connectivity can move sensitive context outside the customer boundary.

## Applicability

Ingress/egress decisions apply whenever a runtime communicates beyond its process boundary. Assessment may be offline; later stages require increasingly complete enforcement, telemetry, availability, and incident handling.

## Customer decisions

The customer must decide:

- allowed sources, destinations, protocols, ports, identities, domains, services, and purposes;
- public, private, partner, administrative, repository, registry, cloud API, and model-provider paths;
- load-balancing, API gateway, web application firewall, proxy, NAT, private endpoint, and inspection patterns;
- TLS/mTLS, certificate, authentication, rate-limit, and denial behavior;
- egress allowlisting, DNS dependency, data-loss controls, and third-party processing terms;
- flow/request logging, alerting, ownership, and retention;
- availability, failure, rollback, and emergency isolation; and
- creation, change, expiry, and removal processes.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Required flows, data classifications, destinations, and owners are listed; offline operation is preferred where sufficient. |
| Simulation | Allow/deny policy and negative cases are validated without external calls. |
| Read-only discovery | Only required cloud APIs and evidence destinations are reachable and logged. |
| Live sandbox | Exact least-access paths, TLS, inspection/controls, telemetry, rollback, and isolation are tested. |
| Pilot | Capacity, rate limiting, certificate lifecycle, third parties, failure response, and incident playbooks are exercised. |
| Production consideration | Enterprise edge/egress authorities approve resilient operation, monitoring, privacy, and support. |

## Composite AI assistance

Composite AI may map approved data flows, identify undocumented destinations, explain policy differences, propose a minimal allowlist, and summarize sanitized flow evidence.

It must not request unrestricted internet access, change network policy, approve a third-party processor, bypass inspection, disable TLS verification, or decide that sensitive data may leave the customer boundary.

## Deterministic validation target

A future validator should compare declared flows with enforced rules and verify source, destination, protocol/port, identity, TLS, purpose, data class, logging, expiry, and owner. Any/any rules, unmanaged public exposure, unknown destinations, disabled certificate validation, or unapproved external-model egress should fail closed. This is a proposed target.

## Human approval

Network and security owners approve paths and enforcement. Data/privacy owners approve outbound processing. Service owners approve dependencies and availability. Change authority approves live changes; model-provider egress requires AI-governance approval.

## Required evidence

- approved connectivity and data-flow matrix;
- enforced gateway/firewall/proxy/endpoint policies;
- TLS/certificate and authentication evidence;
- flow/request log samples and alert tests;
- positive and negative connectivity tests;
- rate-limit, failure, rollback, and isolation results;
- third-party destination and processing approvals; and
- expiration/removal records.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: every required path is minimal, approved, encrypted, enforced, observable, and owned.
- `CONTINUE_WITH_CONDITIONS`: offline/simulation or a narrower private path may proceed while optional or external connectivity stays disabled.
- `STOP`: public or external exposure is unapproved, paths are overly broad, data handling is unresolved, logging/TLS is absent, or emergency isolation is unproven.

## Forge handoff

Forge receives named ingress/egress profiles or endpoint references approved by the platform, never consumer-defined raw firewall rules. The product contract states required outcomes; cloud-native controls enforce the selected implementation.

## Exceptions and prohibited shortcuts

Exceptions require exact flow, justification, owner, monitoring, data classification, expiry, and removal verification. Never open `0.0.0.0/0` or unrestricted egress for troubleshooting without a governed emergency process, whitelist broad domains, bypass proxies, send raw evidence to models, or leave temporary rules after teardown.

## Related requirements

- [`BFR-NET-001` Networking and connectivity](networking-and-connectivity.md)
- [`BFR-DNS-001` DNS responsibilities](dns-responsibilities.md)
- [`BFR-DAT-001` Data classification](data-classification.md)
- [`BFR-AIG-001` AI governance](ai-governance.md)

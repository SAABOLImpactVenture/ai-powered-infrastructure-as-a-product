# Security-event integration

**Requirement ID:** `BFR-SIEM-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It does not claim a current IaaP component operates a SIEM, SOC, incident-response service, or compliance control.

## Requirement

Security-relevant identity, cloud, network, control-plane, repository, model, evidence, and product events must reach an approved customer security-monitoring boundary with defined detections, ownership, escalation, retention, and response.

## Why this requirement exists

Central logs without detections or responders do not provide security operations. IaaP activity crosses repositories, runtime, models, control plane, and cloud boundaries; security events must be correlated without transferring incident authority to AI or the product runtime.

## Applicability

Assessment identifies sources and SOC interfaces. Simulation tests representative events. Discovery and live stages require attributable events, alert routing, and response. Pilot and production consideration require operational coverage and exercised playbooks.

## Customer decisions

The customer must decide:

- authoritative SIEM/security-data platform and SOC/incident owner;
- required event sources and normalized correlation fields;
- detections for identity abuse, policy bypass, secret exposure, unusual egress, repository tampering, control-plane failure, evidence tampering, and AI boundary violations;
- alert severity, routing, service hours, escalation, and containment authority;
- data residency, access, retention, legal hold, and third-party processing;
- tuning, false-positive handling, detection change governance, and evidence preservation; and
- how security incidents pause discovery, provisioning, pilots, or model use.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Security-event sources, gaps, destination, and response owners are identified. |
| Simulation | Synthetic events prove parsing, correlation, routing, and authority boundaries. |
| Read-only discovery | Discovery identity misuse and access anomalies are detectable and attributable. |
| Live sandbox | Repository, workload identity, cloud, control-plane, network, evidence, and AI violations route to responders. |
| Pilot | Coverage hours, triage, containment, communications, evidence preservation, and recovery are exercised. |
| Production consideration | SOC integration, detection lifecycle, scale, resilience, and incident authority are formally accepted. |

## Composite AI assistance

Composite AI may explain sanitized alerts, correlate approved event references, suggest detection gaps, and draft a timeline or response checklist for human review.

It must not close or downgrade alerts, execute containment, reveal sensitive event data to an unapproved provider, attribute malicious intent, or determine reportability or risk acceptance.

## Deterministic validation target

A future validator should verify mandatory source onboarding, event fields, destination, encryption, retention, detection identifiers, alert route, responder, test event, and pause/containment procedure. Missing critical sources, unowned alerts, silent parse failure, disabled detection, or AI auto-disposition should fail closed. This is a future target only.

## Human approval

Security operations approves sources, detections, severity, and response. System/product owners approve containment impacts. Data/privacy/legal owners decide handling and reporting obligations through customer processes. AI governance approves any model-assisted analysis boundary.

## Required evidence

- security-event source and detection catalog;
- SIEM onboarding and parser health evidence;
- correlation and identity/product metadata mapping;
- synthetic alert and routing results;
- response, escalation, containment, and evidence-preservation playbooks;
- access, retention, and legal-hold rules;
- tabletop or exercise report; and
- detection exceptions and tuning history.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: material events are collected, detected, routed, owned, retained, and exercised for the requested stage.
- `CONTINUE_WITH_CONDITIONS`: a narrower activity may proceed with documented noncritical coverage gaps and compensating monitoring.
- `STOP`: privileged or live actions lack security visibility, critical alerts have no responder, event integrity/handling is unresolved, or AI can autonomously dispose of alerts.

## Forge handoff

Forge receives security event/correlation requirements, alert-pause conditions, and evidence references. It may expose bounded status but does not operate the SOC, decide incident severity, or authorize resumption after a security stop.

## Exceptions and prohibited shortcuts

Exceptions require exact source/detection, risk owner, compensating control, expiry, and validation date. Never claim SIEM integration from log forwarding alone, suppress noisy alerts without review, route to an unattended mailbox, expose raw sensitive events to models, or resume provisioning automatically after a security incident.

## Related requirements

- [`BFR-LOG-001` Logging and monitoring](logging-and-monitoring.md)
- [`BFR-OPS-001` Operations and support](operations-and-support.md)
- [`BFR-AIG-001` AI governance](ai-governance.md)
- [`BFR-EVD-001` Evidence and traceability](evidence-and-traceability.md)

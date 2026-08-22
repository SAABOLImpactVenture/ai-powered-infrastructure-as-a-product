# Foundation domain owners

**Requirement ID:** `BFR-RSP-002`

> **Status:** Architecture target. Owner and cost metadata in the product POC provide partial traceability only; they do not establish accountable enterprise domain ownership.

## Requirement

Every applicable foundation domain must have a named accountable customer role, an operationally responsible role, consulted authorities, evidence ownership, and an escalation path before the domain is used as a live product dependency.

## Domain ownership matrix

| Domain | Accountable customer role | Responsible role | Required consultation | Non-delegable decision |
|---|---|---|---|---|
| Governance and product portfolio | platform executive/product owner | platform product team | architecture, finance, consumers | outcomes, priority, product retirement |
| Resource hierarchy | cloud platform owner | cloud foundation team | security, finance, provider/partner | account/subscription/project boundaries |
| Workforce identity | identity owner | identity engineering | security, HR/legal as applicable | authentication and privileged-access policy |
| Workload identity | cloud/security owner | platform engineering | application/product owners | trust, privilege, revocation |
| Networking and connectivity | network owner | cloud network engineering | security, application, operations | routing and trust boundaries |
| DNS | DNS/service owner | DNS/network operations | security, application owners | namespace, delegation, authoritative ownership |
| Ingress and egress | security/network owner | security/network engineering | data, application, operations | exposure and inspection policy |
| Logging and monitoring | operations owner | observability team | security, evidence, product owners | required telemetry and alert response |
| Security-event integration | security operations owner | SOC/security engineering | platform, incident, evidence owners | detection routing and incident ownership |
| Encryption and keys | key-management/security owner | KMS/HSM operations | data, recovery, application owners | key custody and lifecycle |
| Secrets | secrets/identity owner | secrets platform team | security, application owners | secret authority and rotation |
| Delivery and change | platform delivery owner | platform engineering | security, architecture, operations | protected path and promotion policy |
| Infrastructure-product contracts | product owner | product engineering | consumers, architecture, operations | consumer outcome and lifecycle contract |
| Operations and support | service owner | operations/SRE | product, security, consumers | support model and service acceptance |
| Backup, recovery, continuity | resilience owner | operations/recovery team | data, product, security | RPO/RTO and recovery acceptance |
| Cost and FinOps | financial owner | FinOps/platform operations | product and consumer owners | budgets, allocation, overrun response |
| Evidence and traceability | evidence/records owner | assurance/platform team | all domain owners | retention, export, integrity, disposition |
| Data classification | data owner | data governance/privacy | security, legal, product owners | permitted data and processing boundary |
| AI governance | AI/data-risk owner | approved AI platform team | security, privacy, legal, product owners | model/input/output and authority boundary |
| Risk and authorization | delegated risk authority | assurance coordination | all affected domain owners | residual-risk acceptance/authorization |

## Ownership rules

- A provider or implementation partner may be responsible for contracted work but is not automatically accountable for customer risk or policy.
- A platform team may operate a shared control but cannot declare that an application inherits it without documented scope and evidence.
- A product owner owns the consumer contract, not every underlying enterprise service.
- A domain owner cannot approve another domain merely because the same person attends both reviews.
- An absent owner is a readiness gap, not an implementation-team default.

## Handoff record

For every live foundation attachment, record:

- domain and service/interface name;
- accountable and responsible roles;
- consumer and product responsibilities;
- support hours and escalation;
- approved configuration/profile revision;
- evidence and monitoring locations;
- service, security, recovery, and cost obligations;
- exception and change process; and
- retirement or ownership-transfer process.

## Decision behavior

- `CONTINUE`: every domain required by the requested stage has accountable and responsible owners.
- `CONTINUE_WITH_CONDITIONS`: a domain not used by the narrowed scope may remain pending with an owner and due date.
- `STOP`: a live dependency, operational obligation, or residual risk is unowned.

## Related requirements

- [Bootstrap RACI](bootstrap-raci.md)
- [Provider and partner boundaries](provider-partner-boundaries.md)
- [Provider-neutral contract](../providers/provider-neutral-contract.md)
- [Evidence requirements](../evidence/evidence-requirements.md)

# Human review and risk acceptance

**Requirement ID:** `BFR-DEC-003`

> **Status:** Architecture target with partial POC evidence. The POCs encode `requiresHumanApproval: true` and deny AI approval/merge/apply authority. They do not prove an actual accountable human approval event or organizational risk acceptance.

## Requirement

Every material foundation decision must be reviewed by a named person with authority for the affected domain. Risk acceptance must remain distinct from technical validation, architecture recommendation, product ownership, and execution.

## Material decision examples

Human review is mandatory for:

- trust boundaries and customer-hosted deployment location;
- workforce or workload privilege and federation;
- public exposure, DNS authority, routing, ingress, or egress;
- data classification, model processing, retention, or cross-boundary transfer;
- encryption, key custody, secrets, logging, and security-event handling;
- production targets, provider/region changes, regulated data, and control exceptions;
- recovery objectives, data loss tolerance, retirement, and destructive lifecycle behavior;
- material cost or service-level commitments; and
- acceptance of unresolved risk.

## Reviewer responsibilities

| Role | Reviews | Does not inherit automatically |
|---|---|---|
| Sponsor/product owner | outcome, scope, priority, consumer impact | security or risk authority |
| Architecture authority | patterns, dependencies, trust boundaries | operational acceptance |
| Security/identity/network owner | privilege, exposure, monitoring, control design | data-owner consent |
| Data/privacy owner | classification, processing, retention, transfer | production operations |
| Operations/resilience owner | support, incident, backup, recovery, continuity | risk acceptance |
| Financial owner | budget, allocation, limits, lifecycle cost | technical approval |
| Risk/authorization authority | documented residual risk within delegated authority | falsifying or waiving test evidence |

See [foundation domain owners](../responsibility-matrices/foundation-domain-owners.md).

## Valid disposition

A valid human disposition records:

- reviewer identity and authenticated account;
- organizational role and delegated authority;
- exact decision, product revision, target, scope, and stage;
- evidence reviewed;
- approve, reject, request-change, or accept-risk outcome;
- conditions, prohibited activities, and expiration;
- timestamp and integrity protection; and
- separation-of-duties exception where one person fills multiple roles.

A check box, label, comment, or `requiresHumanApproval` field proves an approval requirement only. It is not approval evidence unless the customer has designated that event, identity, and workflow as authoritative.

## Risk-acceptance rules

- State the risk and affected objective clearly.
- Identify why remediation is not complete.
- Preserve failed or unverified controls unchanged.
- Record residual likelihood, impact, compensating controls, scope, and duration.
- Use an authority whose delegation covers that risk and system boundary.
- Set review and expiration dates.
- Revoke or reassess on material change or control failure.
- Never let AI, policy engines, implementers, or vendors accept customer risk.

## Deterministic validation target

A future validator should confirm that every material decision has the required reviewer roles, authenticated identities, valid authority, revision match, scope match, decision time, and nonexpired conditions. It should fail when the approver is the AI runtime, the execution identity, an unverified account, or outside delegated authority.

## POC traceability boundary

The Composite AI POC's local PR proposal and tool denylist establish proposal-only authority. The integration baseline explicitly states that human approval is encoded but not exercised. Documentation and evidence must preserve that exact limitation until a real human-controlled approval and GitOps handoff are observed.

## Related requirements

- [Authority, provenance, and human review](../composite-ai/authority-provenance-and-human-review.md)
- [Foundation readiness decisions](foundation-readiness-decisions.md)
- [Exceptions and expiration](exceptions-and-expiration.md)
- [Evidence integrity](../evidence/evidence-integrity.md)

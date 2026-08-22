# Gate 0 — intake

**Requirement ID:** `BFR-GATE-000`

> **Status:** Architecture target. The four credential-free POC repositories do not implement a customer foundation-intake gate. This page does not add a Guard V1 verdict, a Forge V1 lifecycle state, or deployment authority.

## Gate objective

Establish a bounded, owned, and lawful assessment request before repositories, documents, configuration exports, or cloud metadata enter the IaaP advisory boundary.

Gate 0 answers one question:

> Do we know what is being assessed, who owns the decision, which evidence may be used, and how that evidence may be handled?

## Entry criteria

The requester identifies:

- the business outcome and requested readiness stage;
- organizations, platforms, repositories, clouds, and environments in scope;
- the executive or platform sponsor;
- architecture, security, data, operations, financial, and evidence owners needed for the scope;
- authorized evidence sources and their owners;
- the maximum data classification and Composite AI processing boundary;
- retention, export, deletion, and legal or contractual constraints; and
- activities that remain prohibited, including cloud mutation.

See [assessment prerequisites](../prerequisites/assessment-prerequisites.md) and the [bootstrap RACI](../responsibility-matrices/bootstrap-raci.md).

## Permitted activity

- collect an inventory of proposed sources without copying unapproved content;
- clarify ownership, scope, terminology, and desired outcome;
- classify missing information;
- draft an assessment charter; and
- determine whether processing can occur offline or requires the customer-hosted bootstrap.

## Prohibited activity

- requesting provisioning credentials;
- starting live-cloud discovery;
- treating technical access as consent;
- ingesting unrestricted logs, secrets, regulated payloads, or personal data;
- allowing Composite AI to expand scope or invent an owner; or
- representing intake completion as architecture, security, or production approval.

## Required exit evidence

| Evidence | Minimum content |
|---|---|
| Intake record | purpose, requested stage, scope, exclusions, date |
| Responsibility record | named accountable and consulted roles |
| Source register | source owner, authority level, version or collection date |
| Data-handling decision | classification, AI use, retention, export, deletion |
| Prohibited-authority declaration | no discovery or execution authority at intake |
| Approval record | sponsor and data/evidence owner disposition |

## Exit decision

- `CONTINUE`: scope, ownership, evidence authority, and handling are complete enough for assessment.
- `CONTINUE_WITH_CONDITIONS`: a narrower assessment can begin while named, nonblocking inputs remain due.
- `STOP`: scope, sponsorship, evidence authority, consent, or handling boundaries are absent or contradictory.

These values belong to the proposed [`FoundationReadinessDecision`](../decisions/foundation-readiness-decisions.md), not to a frozen Guard V1 schema.

## POC traceability boundary

The credential-free POCs demonstrate bounded product requests, required owner/cost/change metadata, and no-execution AI authority. They do **not** prove customer intake, evidence consent, source classification, or a readiness charter. Gate 0 is therefore wholly new product architecture.

## Related requirements

- [Gate 1 — assessment](gate-1-assessment.md)
- [Approved AI inputs and proposals](../composite-ai/approved-inputs-and-proposals.md)
- [Evidence requirements](../evidence/evidence-requirements.md)
- [Human review and risk acceptance](../decisions/human-review-and-risk-acceptance.md)

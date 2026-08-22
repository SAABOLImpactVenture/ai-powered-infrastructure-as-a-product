# Assessment prerequisites

**Requirement ID:** `BFR-PRQ-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. This page does not redefine IaaP Guard `readiness-report/v1`, modify a frozen Guard or Forge V1 contract, or claim that the current runtime enforces this target.

## Requirement

Before a foundation-readiness assessment begins, the customer must identify the assessment scope, accountable owners, authorized evidence sources, data-handling limits, and the decision the assessment is intended to support. Repository or cloud write access is not required.

## Why this requirement exists

An assessment assembled from undefined scope or unowned evidence can look complete while omitting the systems, authorities, or constraints that determine whether a foundation is usable. A bounded intake establishes who may provide evidence, what may be processed, and which later activity remains prohibited.

## Applicability

- **Assessment:** mandatory entry condition.
- **Simulation:** assessment scope and ownership remain in force.
- **Read-only discovery:** must be supplemented by [`BFR-PRQ-003`](discovery-prerequisites.md).
- **Live sandbox:** must be supplemented by [`BFR-PRQ-004`](provisioning-prerequisites.md).
- **Pilot and production consideration:** prior assessment evidence must be current or explicitly revalidated.

## Customer decisions

The customer must decide:

- the organization, platform, clouds, environments, repositories, and product boundaries in scope;
- the executive sponsor, platform owner, security reviewer, architecture reviewer, and evidence owner;
- the allowed evidence sources and whether each source is authoritative, corroborating, or informational;
- the highest data classification permitted in the assessment boundary;
- retention, redaction, export, and deletion obligations for collected material;
- whether Composite AI may process each evidence class and through which approved model boundary; and
- the requested outcome: assessment only, simulation readiness, discovery readiness, or preparation for a later live gate.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Scope, named owners, allowed evidence sources, data classification, and assessment purpose are recorded. |
| Simulation | Synthetic or approved sanitized fixtures are identified and traceable to the assessed requirements. |
| Read-only discovery | The original scope is mapped to exact cloud targets and approved read-only identities. |
| Live sandbox | Findings selected for implementation have named owners, acceptance criteria, and separate execution approval. |
| Pilot | Assessment findings and conditions are revalidated against the pilot boundary. |
| Production consideration | Accountable authorities confirm that scope, evidence, and unresolved conditions are current. |

## Composite AI assistance

Composite AI may summarize approved inputs, identify missing information, normalize terminology, suggest interview questions, and draft a scoped evidence inventory. It must preserve source attribution and mark inferences as proposals.

Composite AI must not enlarge scope, authorize access, infer consent, change data classification, declare evidence authoritative, or convert missing evidence into a positive finding.

## Deterministic validation target

A future validator should be able to verify that the assessment record contains nonempty scope, named roles, allowed source types, classification, retention rule, requested outcome, and an all-false execution-authority declaration. It should fail closed on unknown stages, unowned evidence, missing consent, or an attempt to request write credentials. This is a proposed validation target, not current Guard or Forge V1 behavior.

## Human approval

The executive or platform sponsor approves scope. The data owner approves evidence handling. Security and architecture owners acknowledge their review roles. Any later expansion requires a separately recorded decision rather than an untracked update to the original intake.

## Required evidence

- approved assessment charter or intake record;
- in-scope system, repository, and environment inventory;
- named role and responsibility record;
- data-classification and handling decision;
- evidence-source register with source owners and revisions;
- Composite AI processing decision, including prohibited data; and
- timestamped approval and reassessment date.

## `FoundationReadinessDecision` behavior

These are proposed decision semantics for this documentation package, not Guard V1 conclusions.

- `CONTINUE`: scope, ownership, handling, and evidence-source requirements are complete for assessment.
- `CONTINUE_WITH_CONDITIONS`: a bounded assessment may proceed using identified sources while named, nonblocking evidence gaps remain visible with owners and due dates.
- `STOP`: scope, accountable ownership, evidence authority, consent, or data-handling boundaries are absent or contradictory.

## Forge handoff

No automatic Forge handoff occurs. A human may later select assessment findings for a separately governed Forge initiative. The handoff should contain only immutable source references, selected finding identifiers, acceptance criteria, conditions, and the new approval record; it must not treat assessment completion as deployment authorization.

## Exceptions and prohibited shortcuts

An exception must name its owner, rationale, affected scope, compensating controls, expiration, and revalidation trigger. Prohibited shortcuts include collecting unrestricted repository or cloud data, accepting anonymous evidence, treating workshops as approval, using production credentials for intake, or allowing AI to fill gaps without cited evidence.

## Related requirements

- [`BFR-GOV-001` Governance and ownership](../foundation-domains/governance-and-ownership.md)
- [`BFR-DAT-001` Data classification](../foundation-domains/data-classification.md)
- [`BFR-EVD-001` Evidence and traceability](../foundation-domains/evidence-and-traceability.md)
- [`BFR-AIG-001` AI governance](../foundation-domains/ai-governance.md)

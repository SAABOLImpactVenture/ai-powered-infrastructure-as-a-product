# Foundation readiness assessment

**Requirement ID:** `BFR-SCH-002`

> **Status:** New architecture target. No `FoundationReadinessAssessment` schema exists in the four POC repositories. The example is illustrative and non-executable and does not extend Guard V1 or Forge V1.

## Purpose

Represent a point-in-time, evidence-backed assessment of a named scope while preserving source status, findings, material decisions, missing evidence, human review, and the distinction between readiness advice and authorization.

## Required model

### Assessment identity

- assessment ID and revision;
- customer scope and bootstrap-profile reference;
- requested gate and evaluation time;
- assessor/provider identities; and
- applicable requirement/catalog version.

### Source inventory

Every source records owner, authority level, type, scope, version or collection time, classification, transformation/redaction, integrity reference, and availability.

### Domain result

Each foundation domain records:

- applicable requirement IDs;
- status such as satisfied, partial, unmet, unverified, or not applicable;
- observations and source references;
- assumptions and conflicts;
- findings and materiality; and
- required reviewer roles.

### Findings and decisions

Each finding records owner, affected gates, remediation, acceptance criteria, due date, and evidence for closure. Decisions are referenced, not embedded as anonymous booleans.

## Illustrative assessment

**Illustrative, non-executable YAML — not a Guard V1 or Forge V1 schema:**

```yaml
apiVersion: iaap.example/v1alpha1
kind: FoundationReadinessAssessment
metadata:
  id: assessment-example-001
  revision: example-r1
spec:
  bootstrapProfileRef: bootstrap-example-001
  scopeRef: scope-example-001
  requestedGate: gate-2-simulation
  requirementCatalogVersion: customer-reviewed
  assessedAt: YYYY-MM-DDTHH:MM:SSZ
  sources: []
  domains:
    - domain: identity-and-access
      requirementIds:
        - BFR-IAM-001
      status: unverified
      observationRefs: []
      assumptions: []
      findingRefs: []
  findings:
    - id: finding-example-001
      materiality: material
      affectedGates:
        - gate-3-read-only-discovery
      owner: role-reference-required
      remediation: define-read-only-federated-role
      due: YYYY-MM-DD
      closureEvidence: []
  missingEvidence: []
  materialDecisionRefs: []
  reviewerDispositions: []
  proposedDecisionRef: decision-example-001
```

## Status rules

- `satisfied`: required evidence and human disposition support the exact scope and gate.
- `partial`: some required outcomes exist, but limitations are material and explicit.
- `unmet`: a requirement is absent or failed.
- `unverified`: evidence cannot establish a trustworthy result.
- `not-applicable`: a documented scope fact makes the requirement inapplicable; reviewer confirmation is required.

Do not collapse these values into one numeric maturity score without retaining the underlying domain status and evidence.

## Validation targets

A future validator should reject:

- unknown requirement IDs or gates;
- sources without owner, scope, time/revision, classification, or authority status;
- findings without owner, affected gate, and closure criteria;
- `satisfied` results supported only by inference or missing evidence;
- `not-applicable` without rationale and reviewer disposition;
- decisions whose scope/revision does not match the assessment; and
- claims of compliance, ATO, production authorization, or deployment.

## Composite AI boundary

Composite AI may draft observations, findings, alternatives, and a proposed decision reference. All AI-authored content must be attributable, identify assumptions, and remain proposal status until human review.

## POC traceability boundary

The POCs contain machine-readable product requests, deterministic policy results, sanitized evidence, and acceptance controls. They do not contain this customer-domain assessment model, foundation materiality model, or BFR decision semantics.

## Related requirements

- [Gate 1 — assessment](../readiness-gates/gate-1-assessment.md)
- [Foundation readiness decisions](../decisions/foundation-readiness-decisions.md)
- [Reference evidence map](../evidence/reference-evidence-map.md)
- [Foundation domain owners](../responsibility-matrices/foundation-domain-owners.md)

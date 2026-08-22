# Foundation readiness decisions

**Requirement ID:** `BFR-DEC-001`

> **Status:** Architecture target. `FoundationReadinessDecision` is a proposed documentation and future contract concept. It is not an existing Guard V1 conclusion, Forge V1 lifecycle state, compliance determination, or production authorization.

## Purpose

Provide one consistent decision vocabulary for every bootstrap and foundation-readiness gate while preserving the exact scope, stage, evidence, conditions, and human authority behind the decision.

## Decision values

### `CONTINUE`

All mandatory requirements for the **named stage and scope** are satisfied, evidence is current, and the required human disposition exists.

`CONTINUE` permits only the activity named by the decision. For example, a Gate 2 decision permits the approved simulation; it does not permit discovery, provisioning, pilot, or production.

### `CONTINUE_WITH_CONDITIONS`

A deliberately narrower activity may proceed while visible, nonblocking gaps remain. Every condition must have:

- an owner;
- required remediation or compensating control;
- affected scope;
- prohibited activities;
- due date or expiration;
- reassessment trigger; and
- evidence required for closure.

A condition must never silently convert a mandatory later-stage prerequisite into an optional one.

### `STOP`

The requested activity is blocked because a mandatory requirement, authority, evidence item, safety control, ownership decision, or boundary is missing, failed, expired, or contradictory.

A `STOP` decision must identify whether a narrower non-mutating activity remains permissible. It must not prescribe an unauthorized workaround.

## Required decision record

Every decision must contain:

- stable decision and assessment identifiers;
- requested gate, activity, and exact scope;
- product, policy, evidence, and target revisions where applicable;
- applicable BFR requirement identifiers;
- findings and deterministic results considered;
- decision value and rationale;
- conditions, prohibitions, owners, dates, and reassessment triggers;
- human reviewer identity, role, authority, and disposition;
- issued, effective, expiration, and supersession timestamps; and
- links to prior and resulting evidence.

**Illustrative, non-executable example — not a Guard V1 or Forge V1 schema:**

```yaml
apiVersion: iaap.example/v1alpha1
kind: FoundationReadinessDecision
metadata:
  id: decision-example-001
spec:
  gate: gate-3-read-only-discovery
  scopeRef: scope-example-001
  decision: CONTINUE_WITH_CONDITIONS
  permittedActivities:
    - analyze-customer-supplied-export
  prohibitedActivities:
    - live-discovery
    - provisioning
  requirementIds:
    - BFR-GATE-003
  conditions:
    - owner: identity-owner
      due: YYYY-MM-DD
      action: approve-read-only-federated-role
  evidenceRefs: []
  humanDispositions: []
  expires: YYYY-MM-DD
```

## Evaluation rules

- Evaluate requirements for the requested stage only, then apply any inherited conditions from earlier stages.
- A failed non-waivable requirement produces `STOP`.
- Conflicting evidence remains visible and cannot be averaged into a pass.
- Missing evidence is `missing` or `unverified`, never an inferred pass.
- Technical feasibility cannot substitute for organizational authority.
- The narrowest applicable decision controls.
- An expired or superseded decision cannot authorize new activity.

## Decision hierarchy

| Record | What it can decide | What it cannot decide |
|---|---|---|
| Deterministic test | whether an explicit rule passed | risk acceptance or business intent |
| BFR decision | whether evidence supports a bounded readiness activity | compliance, ATO, or production use |
| Domain approval | acceptance within assigned responsibility | another domain's risk |
| Risk acceptance | acceptance of documented residual risk by authorized person | technical test results |
| Production authorization | customer-defined permission to operate | supplied by this package |

## POC traceability boundary

The POCs use `accepted`, `denied`, `needs_input`, and evidence results such as `pass`, `fail`, or `unverified`. Those records inform this model but are not equivalent to BFR decisions. Existing POC outcomes must be cited with their original semantics.

## Related requirements

- [Exceptions and expiration](exceptions-and-expiration.md)
- [Human review and risk acceptance](human-review-and-risk-acceptance.md)
- [Foundation readiness assessment](../schemas/foundation-readiness-assessment.md)
- [Evidence requirements](../evidence/evidence-requirements.md)

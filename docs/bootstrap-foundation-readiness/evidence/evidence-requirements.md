# Evidence requirements

**Requirement ID:** `BFR-EVD-010`

> **Status:** Architecture target with partial POC proof. Existing POCs produce machine-readable, redacted, and scored evidence for a credential-free scope. They do not provide a complete customer readiness, live-cloud, retention, approval, or production evidence system.

## Requirement

Every readiness conclusion must be reproducible from retained source references, observations, deterministic results, human dispositions, and resulting lifecycle evidence. Missing evidence must remain visible.

## Evidence classes

| Class | Meaning | Example |
|---|---|---|
| Source | authoritative or corroborating input | policy revision, repository file, approved export |
| Observation | what a tool or person observed | effective permission, product condition, cost record |
| Proposal | AI or human recommendation not yet approved | target-state option, remediation backlog |
| Validation | deterministic rule or test result | schema denial, policy result, teardown query |
| Decision | named human disposition | architecture approval, scoped risk acceptance |
| Execution | what an authorized engine attempted and produced | reconciliation event, cloud audit event |
| Operations | service behavior after execution | alert, incident, recovery result, retirement |

## Observation status

Use explicit status rather than implying completeness:

- `observed`: collected from an approved real system or human event;
- `poc-observed`: technically observed inside a bounded POC only;
- `asserted`: supplied by an owner but not independently verified;
- `inferred`: reasoned from sources and labeled as inference;
- `unverified`: expected evidence could not establish a trustworthy result;
- `not-observed`: the population or event did not exist; and
- `not-applicable`: the requirement is demonstrably outside the exact scope.

`not-observed`, `unverified`, and `not-applicable` are not interchangeable with `pass`.

## Minimum evidence envelope

Each evidence item should contain:

- evidence identifier, type, status, and applicable BFR requirement IDs;
- source system, owner, authority level, scope, and collection time;
- product, policy, configuration, and target revisions where applicable;
- collection method and tool/adapter version;
- original or integrity-protected source reference;
- redaction, transformation, and normalization record;
- result, uncertainty, limitations, and related findings;
- digest and stronger provenance/attestation when required;
- retention class, export controls, and deletion disposition; and
- links to proposals, validations, decisions, execution, and superseding evidence.

## Evidence by gate

| Gate | Minimum distinguishing evidence |
|---|---|
| Intake | scope, owners, source authorization, data handling |
| Assessment | finding/source trace, missing evidence, material decisions |
| Simulation | immutable inputs, positive/negative tests, authority, reconciliation, teardown |
| Discovery | target/API scope, effective read-only permissions, collection, redaction, revocation |
| Live sandbox | human approval, workload identity, cloud audit, reconciliation, cost, teardown |
| Pilot | actual orders/approvals, support, incidents, recovery, consumer and cost outcomes |
| Production consideration | complete control, operational, risk, and authorization package |

## Evidence chain

```text
requirement and source
  → observation or finding
  → proposal and assumptions
  → deterministic validation
  → named human disposition
  → authorized revision and target
  → execution and operational outcome
  → retained or superseded evidence
```

No arrow may be implied solely because the records share a name. Identifiers and revision links must make the relationship explicit.

## Quality rules

- Preserve adverse, failed, expired, and contradictory evidence.
- Separate raw observation from evaluated control result.
- Require expected-failure tests to prove the intended denial reason, not merely any command failure.
- Do not present a synthetic scenario as adoption, an encoded approval as an approval event, or reconciliation time as end-to-end time-to-provision.
- Record the exact boundary of POC evidence.
- Treat absent evidence as a decision input, not an invitation for AI completion.

## Required human review

The evidence owner accepts completeness and retention; each domain owner validates authoritative sources; the decision authority confirms that the evidence set corresponds to the exact scope and revision considered.

## Related requirements

- [Reference evidence map](reference-evidence-map.md)
- [Evidence integrity](evidence-integrity.md)
- [Retention, traceability, and export](retention-traceability-and-export.md)
- [Foundation readiness decisions](../decisions/foundation-readiness-decisions.md)

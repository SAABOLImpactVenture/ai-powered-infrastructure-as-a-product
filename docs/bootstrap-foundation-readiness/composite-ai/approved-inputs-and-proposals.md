# Composite AI approved inputs and proposal types

**Requirement IDs:** `BFR-AI-010` through `BFR-AI-019`

## Requirement

Every Composite AI use must declare which input classes are authorized, which proposal type is requested, what information must be removed or transformed, and who may review the result. Access to a source system does not itself authorize every record in that system for model processing.

## Approved input classes

Subject to customer classification and authorization, inputs may include:

| Input class | Minimum controls | Example proposal |
|---|---|---|
| Architecture and decision records | owner, version, classification | current-state summary or decision gap |
| Infrastructure repositories | bounded read access, secret scanning, revision identity | product-contract candidate |
| Configuration exports | approved scope, redaction, collection time | foundation capability gap |
| Policies and control catalogs | source and version pinning | traceability mapping |
| Cost and operations summaries | aggregation and tenant isolation | lifecycle or capacity recommendation |
| Interviews and questionnaires | consent, attribution policy, retention | decision backlog |
| Sanitized runtime status | allowlisted fields and identifiers | diagnostic hypothesis |

Unreviewed secrets, credentials, regulated records, production payloads, unrestricted logs, private keys, and personal data are prohibited unless a later customer-specific authorization explicitly establishes the lawful and technical boundary. This public package does not provide that authorization.

## Proposal types

Composite AI may create clearly labeled proposals for:

- missing-information requests;
- current-state models;
- gap and dependency assessments;
- target-state alternatives;
- foundation product requests;
- control and evidence mappings;
- architecture decision drafts;
- test and acceptance criteria;
- remediation backlogs; and
- sanitized diagnostic or evidence summaries.

No proposal is an approved change, compliance conclusion, risk acceptance, or production authorization.

## Required proposal envelope

Each proposal should include:

```yaml
kind: AdvisoryProposal
status: proposal
scope: customer-defined
stage: assessment
requirementIds:
  - BFR-AI-010
sources: []
assumptions: []
openQuestions: []
materialDecisions: []
requiredReviewers: []
prohibitedActions:
  - approve
  - merge
  - apply
  - grant-privilege
```

This example is illustrative and non-executable. It is not a frozen Guard V1 or Forge V1 schema.

## Customer decisions

The customer must decide:

- allowed source systems and information classes;
- whether inputs may leave the customer boundary;
- approved model and adapter locations;
- redaction, retention, and deletion rules;
- whether source attribution may identify people;
- permitted proposal types by stage; and
- reviewers for architecture, security, privacy, operations, and risk.

## Deterministic validation target

Validation should reject an unclassified source, a missing owner or revision, an unapproved proposal type, absent prohibited-action declarations, or an output that presents itself as executed or approved.

## Required evidence

- authorization for each source class;
- collection scope and time;
- revision or version identity;
- classification and redaction result;
- proposal envelope;
- model/adapter provenance;
- deterministic checks; and
- reviewer disposition.

## FoundationReadinessDecision behavior

- `CONTINUE`: all proposed inputs and output types are authorized for the requested stage.
- `CONTINUE_WITH_CONDITIONS`: use may proceed with narrower inputs, additional redaction, or a non-executable proposal type.
- `STOP`: prohibited information, missing authorization, or an execution/approval claim is present.

## Related requirements

- [Data classification](../foundation-domains/data-classification.md)
- [Evidence requirements](../evidence/evidence-requirements.md)
- [Advisory operating model](advisory-operating-model.md)
- [Read-only discovery prerequisites](../prerequisites/discovery-prerequisites.md)

# Evidence and traceability

**Requirement ID:** `BFR-EVD-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It preserves the rule that evidence is not authorization and does not modify Guard V1 evidence-continuity semantics.

## Requirement

Every readiness statement and material lifecycle action must trace from requirement and source through finding, proposal, deterministic validation, human decision, immutable change, execution/observation, operational outcome, exception, and retained evidence without rewriting upstream evidence.

## Why this requirement exists

A folder of logs cannot show why a decision was made or whether evidence belongs to the evaluated revision and target. Traceability makes gaps visible, supports reassessment, separates AI proposals from facts, and prevents technical success from being mistaken for institutional authorization.

## Applicability

Evidence begins at intake and accumulates through every stage. Later gates require stronger provenance, integrity, target binding, retention, export, and independent review; passing one gate never supplies missing evidence for another.

## Customer decisions

The customer must decide:

- authoritative requirement/control sources and versions;
- stable identifiers for requirements, findings, proposals, decisions, changes, targets, tests, exceptions, and outcomes;
- evidence owners, classification, storage, encryption, access, retention, legal hold, export, and deletion;
- accepted provenance, signatures/digests, clocks, and immutable revision formats;
- how AI input/output provenance and uncertainty are recorded;
- which evidence is required for each gate and who validates sufficiency;
- reassessment triggers, freshness, supersession, revocation, and gap handling; and
- how customer authorization evidence remains separate from product-generated evidence.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Every finding cites an approved source, scope, observation, owner, timestamp, and gap status. |
| Simulation | Inputs, rules/tests, outputs, negative cases, AI provenance, and digests are reproducible. |
| Read-only discovery | Target, principal, query/action, time, collection schema, observation, redaction, and artifact digest are bound. |
| Live sandbox | Intent, approval, immutable change, identity, target, execution, acceptance, cost, teardown, and residual results trace end to end. |
| Pilot | Operational metrics, incidents, consumer outcomes, exceptions, reviews, and final disposition are retained. |
| Production consideration | Customer authorities assess a complete, current, integrity-protected package under their own process. |

## Composite AI assistance

Composite AI may assemble indexes, map cited sources to requirements, summarize gaps, draft evidence requests, and explain decision history while clearly marking generated text and inference.

It must not invent evidence, alter source artifacts, mark a gap satisfied, fabricate metrics, sign on behalf of a person, infer continuing authority, or describe evidence continuity as approval/compliance.

## Deterministic validation target

A future validator should verify stable IDs, source/version, immutable revision/digest, target/time, actor/authority reference, schema, required links, classification, retention, and gap/exception state. Broken links, mutable-only sources, digest mismatch, missing samples represented as success, or AI output presented as observed evidence should fail closed. This target is separate from frozen Guard V1 contracts.

## Human approval

Evidence owners approve collection and retention. Domain reviewers attest to observations within their authority. Decision authorities approve dispositions separately. Legal/compliance/authorization officials determine sufficiency for their processes; the IaaP system does not do so.

## Required evidence

- versioned requirement/source inventory;
- scope and finding records;
- AI provenance and sanitized input/output digests;
- deterministic validation and negative-case results;
- human decision, role, conditions, and timestamp;
- immutable change, target, execution, acceptance, cost, and teardown records;
- exception/expiry and reassessment history; and
- integrity, access, retention, and export verification.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: all mandatory evidence for the requested stage is attributable, current, integrity-protected, traceable, and human-reviewed.
- `CONTINUE_WITH_CONDITIONS`: nonblocking evidence gaps remain explicit with owners, due dates, and a narrower permitted scope; no missing fact becomes an assumed pass.
- `STOP`: a material requirement, source, approval, target, outcome, integrity check, or authority link is missing, inconsistent, stale, or tampered.

## Forge handoff

Forge receives immutable selected evidence references and a separate human-selection record. It cannot rewrite Guard or advisory evidence, close findings on another product's behalf, or treat an evidence digest as deployment authorization. Forge outputs append new traceable evidence.

## Exceptions and prohibited shortcuts

Exceptions require evidence of authority, scope, rationale, compensating control, expiry, and reassessment. Never overwrite original evidence, use mutable branch names as sole provenance, mark `null` as success, retain raw secrets/customer data unnecessarily, accept screenshots without source context when machine evidence is available, or equate a passing test with authorization.

## Related requirements

- [`BFR-PRQ-001` Assessment prerequisites](../prerequisites/assessment-prerequisites.md)
- [`BFR-DEL-001` Delivery and change governance](delivery-and-change-governance.md)
- [`BFR-LOG-001` Logging and monitoring](logging-and-monitoring.md)
- [`BFR-AIG-001` AI governance](ai-governance.md)

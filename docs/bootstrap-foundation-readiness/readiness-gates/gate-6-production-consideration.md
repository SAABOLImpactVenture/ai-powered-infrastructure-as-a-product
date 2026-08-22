# Gate 6 — production consideration

**Requirement ID:** `BFR-GATE-006`

> **Status:** Architecture target and external authorization handoff. The POCs explicitly exclude production, regulated data, compliance conclusions, authorization to operate, production SLOs, and recovery claims. This gate does not authorize production and does not change frozen Guard or Forge V1 boundaries.

## Gate objective

Assemble a complete, internally consistent decision package for the customer's accountable production, security, architecture, risk, legal, privacy, financial, and service-acceptance authorities.

The IaaP readiness package may support those authorities. It cannot replace them.

## Entry criteria

- the bounded pilot is complete or formally waived by an authority permitted to do so;
- every prior decision, condition, exception, and expiration is current;
- the production system boundary, consumers, data, dependencies, regions, service objectives, recovery objectives, and operating model are exact;
- control inheritance and customer-owned controls are documented;
- evidence covers build, release, identity, policy, execution, operations, incidents, recovery, cost, retirement, and supply chain; and
- residual risk has a named decision authority.

## Required decision package

- executive and product outcome summary;
- architecture, trust boundary, data flow, and dependency records;
- final product and implementation revisions;
- control, requirement, test, and evidence traceability;
- identity, privilege, access-review, logging, and security-event evidence;
- data classification, encryption, key, privacy, and retention decisions;
- availability, recovery, continuity, capacity, and operational acceptance;
- pilot metrics, incidents, defects, and unresolved limitations;
- cost model and financial ownership;
- exception and residual-risk register;
- software supply-chain and third-party dependency record; and
- formal decisions from each required customer authority.

## Decision boundary

The proposed `FoundationReadinessDecision` may state only whether the package is complete enough to submit:

- `CONTINUE`: submit the package to the customer's production authorization process.
- `CONTINUE_WITH_CONDITIONS`: complete named nonproduction work; production remains blocked.
- `STOP`: do not submit or deploy because material evidence, ownership, safety, or authorization is absent.

The customer's authorization result must be recorded separately and must never be synthesized into a BFR result.

## Reassessment triggers

Reassessment is required for material changes to product contract, provider, region, trust boundary, data classification, identity, network, encryption, execution engine, model boundary, control inheritance, SLO, recovery objective, critical dependency, or risk posture.

## POC traceability boundary

Credential-free POC scores measure narrow acceptance controls, not production readiness. Repository checks, synthetic reconciliation, dry-run publication, hashes, or a 100/100 POC score must never appear as production authorization evidence without their scope limits.

## Related requirements

- [Foundation readiness decisions](../decisions/foundation-readiness-decisions.md)
- [Human review and risk acceptance](../decisions/human-review-and-risk-acceptance.md)
- [Evidence integrity](../evidence/evidence-integrity.md)
- [Retention, traceability, and export](../evidence/retention-traceability-and-export.md)

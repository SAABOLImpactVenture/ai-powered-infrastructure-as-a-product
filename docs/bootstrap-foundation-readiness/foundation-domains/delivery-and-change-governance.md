# Delivery and change governance

**Requirement ID:** `BFR-DEL-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It preserves human authorization and protected-change principles without claiming that current Forge V1 applies customer infrastructure.

## Requirement

Every material foundation or product change must originate from an attributable request, pass deterministic validation, receive required independent human review, bind to an immutable revision and target, and produce deployment, rollback, and evidence records through a protected change path.

## Why this requirement exists

Version control alone does not establish authority. A technically valid change can still target the wrong environment, bypass required reviewers, rely on stale approval, or leave no recoverable link between intent, implementation, execution, and outcome.

## Applicability

Assessment changes govern the specification and evidence. Simulation proves gates. Discovery governs access/configuration changes. Live sandbox, pilot, and production consideration require protected review, exact target binding, deployment authority, and lifecycle evidence.

## Customer decisions

The customer must decide:

- authoritative repositories, branches, artifact registries, and release channels;
- change types and materiality criteria;
- required schemas, policy, security, test, provenance, and compatibility gates;
- reviewer/approver roles and separation from authors and automation;
- target binding, deployment windows, concurrency, and environment promotion;
- rollback, forward-fix, emergency-change, and failed-deployment behavior;
- artifact signing, provenance, dependency/update, and vulnerability response; and
- evidence retention, reassessment, and exception process.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Authoritative sources, owners, materiality, and documentation review are defined. |
| Simulation | Positive/negative validation, immutable revisions, and authority-denial tests pass. |
| Read-only discovery | Access/configuration changes use review, target scope, expiry, and audit. |
| Live sandbox | Protected branch, required checks, independent approval, exact target, rollback, evidence, and teardown are proven. |
| Pilot | Release, promotion, emergency, dependency, rollback, communication, and support processes are exercised repeatedly. |
| Production consideration | Enterprise change/release authorities accept governance, scale, recovery, and audit. |

## Composite AI assistance

Composite AI may draft proposals, explain deterministic failures, summarize diffs, identify impacted requirements, and assemble a review packet with source citations.

It must not approve, merge, sign, release, apply, change required checks, choose an environment, mark reviews resolved, or create an exception to its own proposal.

## Deterministic validation target

A future validator should verify request identity, immutable base/head, supported contracts, policy/tests, provenance, materiality, reviewer separation, required approval, target and window, rollback/teardown, and evidence destination. Mutable refs, self-approval, missing checks, mismatched target/revision, or auto-apply by AI/storefront should fail closed. This is a proposed target.

## Human approval

Product and platform owners approve intent; domain owners review impacts; authorized reviewers approve the exact immutable change; deployment authority approves the exact target and window. Emergency changes require retrospective review and evidence under the customer's policy.

## Required evidence

- attributable change request and decision record;
- immutable base/head and artifact digests;
- schema, policy, security, test, and provenance results;
- materiality and impacted-requirement analysis;
- review-thread and independent approval records;
- target/window authorization;
- deployment, acceptance, rollback/teardown, and residual results; and
- Guard or independent reassessment reference where applicable.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: the exact change path is protected, validated, independently approved, target-bound, recoverable, and evidenced.
- `CONTINUE_WITH_CONDITIONS`: documentation, simulation, or nonmaterial work may proceed while live deployment remains blocked or narrowly constrained.
- `STOP`: provenance, validation, review, separation, target binding, rollback, evidence, or deployment authority is missing or stale.

## Forge handoff

Forge may produce a reviewable, immutable change package that references selected evidence and required approvals. The repository and customer deployment system enforce review and execution. Forge and Composite AI cannot self-approve or treat a generated package as applied.

## Exceptions and prohibited shortcuts

Exceptions require materiality, owner, approving authority, compensating checks, exact target/revision, expiry, and retrospective review. Never push directly to protected branches, reuse approval after a revision changes, disable checks to meet schedule, let AI resolve its own review, use mutable tags for release, or skip rollback/teardown evidence.

## Related requirements

- [`BFR-GOV-001` Governance and ownership](governance-and-ownership.md)
- [`BFR-PRD-001` Infrastructure-product contracts](infrastructure-product-contracts.md)
- [`BFR-EVD-001` Evidence and traceability](evidence-and-traceability.md)
- [`BFR-PRQ-004` Live provisioning prerequisites](../prerequisites/provisioning-prerequisites.md)

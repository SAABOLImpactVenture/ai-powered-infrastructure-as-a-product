# Gate 1 — assessment

**Requirement ID:** `BFR-GATE-001`

> **Status:** Architecture target. Existing POCs contain product, security, and boundary documentation, but they do not implement a customer cloud-foundation assessment. Any existing Guard V1 repository assessment remains authoritative within its frozen contract and is not redefined here.

## Gate objective

Create an evidence-backed current-state and readiness assessment without live cloud mutation. Assessment must separate observed facts, customer assertions, Composite AI proposals, deterministic results, and unresolved questions.

## Entry criteria

- Gate 0 has a valid `CONTINUE` or applicable `CONTINUE_WITH_CONDITIONS` decision.
- Authorized sources and their revisions are available.
- The assessment team can identify authoritative versus corroborating evidence.
- The required hosting boundary satisfies [bootstrap runtime prerequisites](../prerequisites/bootstrap-runtime-prerequisites.md), or the work is explicitly approved for offline processing.
- Composite AI input and output types are authorized.

## Assessment coverage

The assessment should address, where applicable:

- governance and ownership;
- resource hierarchy and environment separation;
- workforce and workload identity;
- networking, DNS, ingress, egress, and connectivity;
- logging, monitoring, security events, encryption, keys, and secrets;
- delivery, product contracts, operations, resilience, and retirement;
- cost ownership and product outcomes;
- evidence, data classification, and AI governance; and
- dependencies on cloud-provider or partner advisory work.

## Required assessment record

Every finding must include:

- a stable finding identifier;
- applicable BFR requirement identifiers;
- source references and collection time;
- observation versus inference;
- confidence and missing evidence;
- materiality and affected stage;
- proposed remediation or decision question;
- responsible owner and due date; and
- reviewer disposition.

## Composite AI role

Composite AI may summarize approved evidence, detect inconsistencies, draft findings, compare alternatives, and propose questions or backlog items. It may not declare evidence authoritative, accept risk, approve an architecture, or convert absent evidence into a passing result.

## Required exit evidence

- current-state and source inventory;
- domain-by-domain findings;
- missing-evidence register;
- material-decision register;
- proposed minimum viable foundation boundary;
- dependencies and responsibility assignments;
- remediation backlog with acceptance criteria; and
- named human disposition for every material finding.

## Exit decision

- `CONTINUE`: evidence is sufficient to enter credential-free simulation for the approved scope.
- `CONTINUE_WITH_CONDITIONS`: simulation may proceed within a narrower boundary while named evidence or design gaps remain visible.
- `STOP`: a foundational authority, ownership, data-handling, or trust-boundary conflict makes even bounded simulation misleading or unsafe.

## POC traceability boundary

The POCs supply reusable evidence about a minimal seed, a bounded product contract, proposal-only AI, deterministic policy, and credential-free reconciliation. They are reference evidence for possible patterns—not evidence that a customer's foundation is ready. Customer assessment workflow, finding semantics, and materiality routing are new targets.

## Related requirements

- [Gate 0 — intake](gate-0-intake.md)
- [Gate 2 — simulation](gate-2-simulation.md)
- [Foundation readiness assessment schema](../schemas/foundation-readiness-assessment.md)
- [Foundation domain owners](../responsibility-matrices/foundation-domain-owners.md)
- [Provider-neutral contract](../providers/provider-neutral-contract.md)

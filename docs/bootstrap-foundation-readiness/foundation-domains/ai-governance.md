# AI governance

**Requirement ID:** `BFR-AIG-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It preserves the frozen Composite AI proposal-only boundary and does not claim current AI can inspect clouds, approve decisions, or execute infrastructure.

## Requirement

Every Composite AI use must have an approved purpose, role, data boundary, model/provider, version, input/output schema, tool policy, provenance, deterministic validation, human reviewer, failure behavior, monitoring, retention, and explicit denial of approval or execution authority.

## Why this requirement exists

Composite AI can accelerate discovery and proposal work, but outputs are probabilistic and may omit evidence, follow malicious instructions, expose sensitive context, or exceed intended authority. Multiple AI roles do not create independent institutional authority; deterministic controls and accountable humans remain decisive.

## Applicability

- **Assessment:** AI use is optional and limited to approved evidence interpretation and drafting.
- **Simulation:** deterministic/no-model baseline and hostile/negative fixtures are required.
- **Read-only discovery:** AI receives only approved normalized, sanitized observations; cloud credentials remain outside the model.
- **Live sandbox:** AI may propose/explain and summarize bounded status but cannot approve or apply.
- **Pilot/production consideration:** provider lifecycle, quality, privacy, monitoring, fallback, and human oversight require formal approval.

## Customer decisions

The customer must decide:

- permitted use cases and separate request, review, operations, and evidence roles;
- model/provider, region, account, version, data-processing terms, retention/training, and cost limits;
- allowed input classes, minimization/redaction, output schemas, and provenance;
- whether tools exist; permitted tools must remain least-authority, mediated, and separately approved;
- deterministic validators, equality/policy gates, confidence/uncertainty display, and fail-closed behavior;
- named human reviewers and decisions that always require accountable authority;
- injection, exfiltration, hallucination, provider failure, drift, and model-change testing;
- monitoring, incident response, rollback/disablement, evidence, and reassessment cadence; and
- prohibited actions: approval, merge, apply, privilege grant, policy change, risk acceptance, compliance/ATO determination, and autonomous remediation.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Optional approved role, sanitized sources, no tools, clear generated/inferred labeling, and human review. |
| Simulation | Deterministic reference result, schema enforcement, hostile inputs, redaction, provider-failure, and authority-denial tests pass. |
| Read-only discovery | Approved normalized metadata only; credentials and direct unmediated APIs remain outside model context. |
| Live sandbox | Proposal/status explanation is bounded, deterministically validated, cost-limited, attributable, and followed by human approval. |
| Pilot | Model/version change, quality, privacy, incident, fallback, monitoring, and consumer disclosure are exercised. |
| Production consideration | Customer AI, security, data, legal/procurement, risk, and authorization authorities formally accept use. |

## Composite AI assistance

Within this domain, Composite AI may inventory its own approved role definitions, explain the authority matrix, identify missing evidence, draft test cases, and produce schema-bounded proposals or sanitized summaries.

It must never self-assess as authoritative, edit its own guardrails, choose a broader model/data/tool scope, approve its output, execute remediation, conceal provider/model identity, or replace deterministic validation.

## Deterministic validation target

A future validator should verify use case, role, provider/model/version, data classes, retention/training terms, egress, input/output schema, tool allowlist, all-false prohibited authority flags, validator, human-review requirement, cost ceiling, provenance, redaction, hostile tests, and disablement path. Unknown tools, credential markers, schema expansion, authority flags, unsupported provider/model changes, or missing human review should fail closed. This target must not be confused with a current V1 capability expansion.

## Human approval

AI governance, data/privacy, security, legal/procurement, product, and risk owners approve their respective boundaries. An accountable domain expert reviews material outputs. Only the customer's designated authorities approve architecture, risk, deployment, incident disposition, compliance, or production decisions.

## Required evidence

- approved AI use-case and authority matrix;
- provider/model/version, processing terms, region, retention/training, and cost decision;
- input/output schemas, data classification, minimization, and redaction tests;
- tool policy and proof that prohibited authority is absent;
- deterministic equality/policy/schema results;
- injection, exfiltration, hallucination, timeout/refusal, drift, and credential-marker tests;
- input/output/proposal digests and human-review decision; and
- monitoring, incident, disablement, fallback, and model-change records.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: the optional AI use is bounded, minimized, attributable, tested, deterministically constrained, cost-controlled, and human-governed.
- `CONTINUE_WITH_CONDITIONS`: the workflow may use deterministic/no-model mode or exclude sensitive data/tools while provider, quality, or governance gaps remain tracked.
- `STOP`: AI can approve/merge/apply/grant privilege/change policy, receives credentials or prohibited data, uses an unapproved model/provider/tool, bypasses deterministic gates, or lacks accountable human review.

## Forge handoff

Forge accepts AI output only as untrusted, schema-bounded proposal or explanation tied to immutable input and model provenance. It compares product proposals with deterministic rendering and routes accepted proposals to human review. It never interprets AI text as authorization or introduces a new contract field from AI output.

## Exceptions and prohibited shortcuts

Authority prohibitions are not waivable within this reference model. Other exceptions require exact use/data/model/tool scope, owner, risk approval, compensating controls, expiry, and reassessment. Never paste credentials or unrestricted repositories into prompts, enable tools “temporarily,” let one agent approve another agent, treat model consensus as human authority, silently switch models, or retain raw model text contrary to policy.

## Related requirements

- [`BFR-DAT-001` Data classification](data-classification.md)
- [`BFR-EVD-001` Evidence and traceability](evidence-and-traceability.md)
- [`BFR-DEL-001` Delivery and change governance](delivery-and-change-governance.md)
- [`BFR-SEC-001` Secrets management](secrets-management.md)
- [`BFR-FIN-001` Cost ownership and FinOps](cost-ownership-and-finops.md)

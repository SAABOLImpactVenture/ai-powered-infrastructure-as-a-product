# Secrets management

**Requirement ID:** `BFR-SEC-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It preserves the no-static-cloud-credential reference boundary and does not claim a current IaaP component manages customer secrets.

## Requirement

Secrets that cannot be eliminated through workload identity must be stored, accessed, rotated, monitored, recovered, and retired through an approved customer-controlled secrets service. Secret values must never enter source control, evidence, logs, prompts, or consumer product contracts.

## Why this requirement exists

Secrets copied into repositories or automation become hard to inventory, rotate, and revoke. Composite AI and evidence pipelines increase propagation risk because a single leaked value may be reproduced in prompts, summaries, artifacts, or retained logs.

## Applicability

- **Assessment:** secret values are not required; only management patterns and redacted metadata may be assessed.
- **Simulation:** synthetic placeholders are used and secret-marker rejection is tested.
- **Read-only discovery:** the adapter must not read secret payloads.
- **Live sandbox and later:** unavoidable secrets require approved store integration and lifecycle evidence.

## Customer decisions

The customer must decide:

- which credentials can be replaced by federation and which secrets remain unavoidable;
- authoritative secret stores, tenancy, region, encryption, availability, and owner;
- identity-based access, retrieval method, caching, injection, and process isolation;
- creation, rotation frequency, versioning, revocation, expiry, and retirement;
- break-glass and recovery behavior;
- scanning and response for repositories, images, logs, artifacts, and prompts;
- redaction/tokenization before AI or evidence processing; and
- incident notification and dependent-service recovery.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Secret sources and owners are inventoried without collecting values; static-cloud-key use is identified as a gap. |
| Simulation | Placeholders only; scanners and input/output rejection detect credential-like material. |
| Read-only discovery | No secret-value permission; identity and collection schemas explicitly exclude payloads. |
| Live sandbox | Approved store, least-privilege retrieval, rotation/revocation, scanning, monitoring, and cleanup are tested. |
| Pilot | Rotation without outage, break-glass, leak response, cache expiry, backup/recovery, and dependency ownership are exercised. |
| Production consideration | Enterprise secret lifecycle, resilience, audit, incident, and recertification are formally accepted. |

## Composite AI assistance

Composite AI may identify likely credential markers after local redaction, explain replacement patterns, draft rotation plans, and summarize sanitized leak-response evidence.

It must not receive, reveal, generate for live use, store, retrieve, rotate, or validate secret values; access secret stores; or claim redaction is effective without deterministic tests.

## Deterministic validation target

A future validator should scan supported inputs/outputs for secret patterns, verify approved store references, workload identity, least-privilege access, rotation/expiry, audit, redaction, and cleanup. Raw values, environment dumps, long-lived cloud keys, unbounded retrieval, or secret-bearing evidence should fail closed. This is a proposed target.

## Human approval

Security and secret-store owners approve patterns and access. Resource owners approve use of their credentials. Operations approves rotation, recovery, and incident procedures. Static-credential exceptions require explicit senior security approval and expiry.

## Required evidence

- secret inventory containing metadata only;
- federation/elimination analysis;
- store, access-policy, and encryption evidence;
- rotation, revocation, and application-reload test;
- repository/artifact/log/prompt scan results;
- redaction and negative-fixture results;
- leak-response exercise; and
- cleanup/retirement evidence.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: no prohibited values are present and unavoidable secrets use an approved, least-privileged, monitored lifecycle.
- `CONTINUE_WITH_CONDITIONS`: synthetic or offline activity may proceed while live secret-dependent functions remain disabled.
- `STOP`: secret values appear in source/evidence/prompts, static cloud keys are required by the reference path, access is excessive, or rotation/revocation is unproven.

## Forge handoff

Forge receives only a secret-free product contract and, when unavoidable, an approved secret-reference interface resolved by the customer runtime. Forge outputs and evidence must preserve redaction; Composite AI receives no secret store tool.

## Exceptions and prohibited shortcuts

Exceptions require exact secret, system, reason, controls, owner, expiry, and migration to federation. Never paste secrets into chat or issues, store them in Kubernetes/GitHub plaintext, use one credential across environments, log resolved values, turn off scanners because of false positives, or retain credentials after teardown.

## Related requirements

- [`BFR-WID-001` Workload identity](workload-identity.md)
- [`BFR-IAM-001` Identity and access](identity-and-access.md)
- [`BFR-KMS-001` Encryption and key management](encryption-and-key-management.md)
- [`BFR-AIG-001` AI governance](ai-governance.md)

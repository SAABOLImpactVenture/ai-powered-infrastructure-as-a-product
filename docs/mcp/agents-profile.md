# Agents Workload Profile (MCP)

## Purpose
This profile defines mandatory security controls, assumptions, and evidence requirements for Agentic/MCP workloads operated under FedRAMP High / FISMA Moderate-High, aligned to NIST 800-53 Rev.5 and CISA Zero Trust.

## Assumptions
- **Autonomy:** Bounded. Destructive or financially-impacting actions require human approval.
- **Identity:** Entra ID federation. Per-tool service principals (SPs) with **short-lived credentials ≤ 60 minutes**.
- **Data Zoning:** {Public, Internal, Sensitive}. Retrieval uses **ABAC** on chunk tags.
- **Egress:** All tool traffic exits via a **proxy with domain allowlists** per tool; no direct internet from chat front ends.
- **Sovereign Regions:** Default to US Gov regions where applicable (GCC/GovCloud).

## In-Scope Risks
1. Indirect Prompt Injection via retrieved pages/chunks.
2. Tool Abuse from over-permissioned connectors or wildcard scopes.
3. Data Exfiltration via model outputs (PII/secrets/embeddings).
4. Poisoned Knowledge/RAG; backdoored seeds.
5. Model/Embedding Memorization of sensitive strings.
6. Supply-chain compromise in MCP servers/plugins.
7. Cross-tenant/channel context confusion.
8. Oversharing telemetry to non-approved processors.
9. Prompt leakage & policy bypass (jailbreaks).
10. Hallucination-driven actions (“phantom certainty”).
11. Insecure function calling/SSRF.
12. Governance gaps (no DPIA/TRA, no owner, no runbook).

## Required Controls

### Identity & Access
- Per-tool SPs; **no shared prod creds** with chat surfaces (AC-2, AC-3, AC-6).
- JIT elevation via ticket with expiry; default **read-only scopes** (AC-17).
- Deny wildcard scopes (`*`, `admin`, `owner`, `full_access`) at policy layer.

### Data
- **Pre-ingest scrubbing** (HTML/MD sanitizer removes `<script>`, `on*`, `data:` URLs; strips tracking pixels).
- **Chunk-time redaction** (PII/secret detectors); store `<REDACTED:TYPE>` tokens, not raw secrets (SC-18, SC-28).
- **ABAC-gated retrieval**: requester attributes must match chunk tags.
- Canary/honeytoken secrets embedded in vectors to detect leakage.

### Model & Prompting
- **Signed system prompts**; provenance headers injected into each call.
- Tool allowlist + natural-language **justification** required; **danger verbs** require human approval.
- Output filters: PII/secret scanners; link-safety checks; “no-exfil” regex before egress.

### Supply Chain (MCP/Plugins)
- **Cosign-verified** images; **SBOM required**; versions pinned by digest.
- Third-party tools run in **network-restricted sandboxes** (read-only FS).
- Policy registry: unknown tools blocked at runtime.

### Monitoring & Response
- **Dual logging**: user prompt, context diff, tool I/O; never store raw secrets (AU-2/6/8).
- LLM red-teaming/evals (prompt injection, tool abuse, exfil) in CI.
- **AI Incident Runbook** with kill-switch, SP rotation, vector index quarantine.

## Evidence for cATO
- Cosign verify logs + SBOMs per tool build.
- Signed prompt commit + signature attached to each release.
- OPA decision logs for tool calls (allow/deny + rationale).
- Egress proxy logs showing only allowlisted FQDNs.
- Eval results: all suites green in last CI run.

## Control Mappings (NIST 800-53r5 / FedRAMP High)
- AC-2, AC-3, AC-6, AC-17: Per-tool SPs, least privilege, JIT.
- IA-2(1): MFA at federation boundary; short-lived tokens.
- SC-7, SC-7(3),(5): Egress proxy + allowlists; micro-segmentation for runners.
- SC-18, SC-23, SC-28: Sanitization + output filters; encryption at rest.
- SA-11, SA-15, CM-8: SBOMs, signature verification, inventory of MCP servers.
- AU-2, AU-6, AU-8: Dual logging; signed timestamps; correlation IDs.
- IR-4, IR-5, IR-8: AI runbook; detections; exercises.
- RA-3, PM-31: AI threat model and risk governance.

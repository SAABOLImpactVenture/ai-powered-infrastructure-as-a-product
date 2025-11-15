# Threat Model Addendum: Agents/MCP

This addendum connects the repository’s existing threat model to the **Agents Workload Profile** and mandates controls that differ from classic apps.

## Assets
- Chat transcripts, model call logs (without raw secrets), tool I/O.
- Vector store chunks with sensitivity tags and redactions.
- System prompt templates + signatures.
- MCP server images and SBOMs.

## Trust Boundaries
- Chat frontend → Policy Layer (OPA) → Orchestrator → Per-Tool Runners → Egress Proxy → External APIs
- Orchestrator ↔ Vector Store (ABAC gated)

## Dataflow Diagram (Mermaid)
```mermaid
flowchart LR
  UI[Chat Frontend (no creds)]
  OPA[Policy Layer (OPA)]
  ORCH[Agent Orchestrator]
  RUN[Sandboxed Tool Runners]
  PROXY[Egress Allowlist Proxy]
  RAG[Vector Store (ABAC, redacted chunks)]
  AUD[Audit Bus (append-only)]
  SEC[Security Services (DLP/CASB/SIEM/Canaries)]
  UI --> OPA --> ORCH --> RUN --> PROXY
  ORCH --> RAG
  ORCH --> AUD
  RUN --> AUD
  PROXY --> AUD
  AUD --> SEC
```

## Key Scenarios
1. **Indirect prompt injection → dangerous tool call.** Attacker instructions hide in retrieved content and attempt to change DNS, make data public, or exfiltrate tokens.
2. **Tool abuse via over-permissioned SPs.** Agent uses a “helper” tool that has write/delete access where only read was intended.
3. **RAG poisoning and shadow approvals.** Poisoned chunks attempt to encode auto-approval semantics (for example, “ZETA-OK” backdoors) that bypass human review.
4. **Cross-tenant misuse.** Tool calls routed to the wrong tenant or environment, violating data residency or segmentation rules.
5. **Supply-chain compromise of MCP servers.** Malicious image or dependency added to a tool runner, attempting to beacon out or alter responses.

## Required Controls (Delta from Classic Apps)
- **Per-tool identity and scopes** are mandatory (see `terraform/identity/agents-tools` and `policies/opa/agents_tool_scopes.rego`). No shared “agent” SPs.
- **Danger verbs gated by humans** using `policies/opa/agents_danger_verbs.rego`; all destructive actions require explicit approval + justification.
- **Strict egress control** via `policies/opa/egress_allowlist.rego` and the `k8s/agents-tools/mcp-tool-runner.yaml` sidecar proxy pattern.
- **Prompt and RAG hardening** using the eval corpus in `tests/agents-evals` (prompt injection, tool abuse, exfil, poisoning, SSRF).
- **Continuous evidence** recorded under `governance/cato-evidence` and verified in `.github/workflows/agents-security.yml` for every main-branch change.

## Evidence Hooks
- **Policy decisions:** OPA allow/deny logs for tool scopes, actions, and egress decisions.
- **Image integrity:** Cosign verification logs and SBOM presence for MCP images.
- **Eval coverage:** CI artifacts proving all agents eval suites pass (no bypasses or leaks).
- **Runbook execution:** AI incident records referencing `docs/mcp/ai-incident-runbook.md` and communication templates in `governance/cato-evidence/templates`.

Together, these controls form the minimal delta needed to operate Agents/MCP workloads under a cATO posture beyond traditional web or API services.

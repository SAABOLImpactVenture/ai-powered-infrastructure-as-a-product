SPDX-License-Identifier: Apache-2.0
# MCP Threat Model & Mitigations

| STRIDE | Threat | Example | Mitigation |
|--------|--------|---------|------------|
| Spoofing | Untrusted MCP server | Imposter image providing fake tools | Pin image digests, require signatures/SBOM, allow-list endpoints |
| Tampering | Malicious tool output | Poisoned results altering PR content | Schema-validate outputs; require deterministic diffs; human review |
| Repudiation | No audit trail | Missing logs for tool calls | JSONL call logs stored as artifacts; ADX ingestion |
| Information Disclosure | Overscoped access | Secrets accessible via tools | Read-only defaults; least-privilege tokens; secret scanning |
| DoS | Runaway calls | Infinite tool loops | Global rate/time/byte caps; circuit breaker in workflow |
| EoP | Write tools in prod | Direct prod changes | Prod deny policies; manual approvals; CODEOWNERS gates |

**Residual risk:** contained by PR-only pattern, immutable logs, and deny-by-default in prod.

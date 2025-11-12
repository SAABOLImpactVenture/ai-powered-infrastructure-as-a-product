SPDX-License-Identifier: Apache-2.0
# MCP Server & Client Configuration

## Servers (minimal set)
- **azure**: read-mostly queries for Arc, Azure Policy initiative status, diagnostics.
- **backstage**: catalog and scaffolder metadata access.
- **fs-ro**: repository filesystem read-only (for diff/search).

## Client policy
- Tool allowlists; deny unknown tools.
- Limits: `maxBytes=5MB`, `timeout=30s`, `rate=30/min` (example bounds).
- Evidence: every call recorded to JSONL (`mcp-call-log.jsonl`) and uploaded as a CI artifact; optional ADX ingestion.

## Auth
- OIDC per job; no stored credentials; tokens bound to repository, branch, and workflow.

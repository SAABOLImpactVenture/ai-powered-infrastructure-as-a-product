SPDX-License-Identifier: Apache-2.0
# MCP Overview & Principles

**Model Context Protocol (MCP)** provides a uniform tool surface for agents. In this platform, MCP is an **optional integration** used sparingly to query systems like **Azure (control plane)**, **Backstage**, and the **repository filesystem**.

## Principles
- Prefer IaC + CI artifacts; add MCP only when runtime queries are necessary.
- Read-only by default; mutating tools require `workflow_dispatch` and nonprod scope.
- Strong identity: OIDC tokens with audience/issuer pinning.
- Rate, byte, and time caps on tool invocation. All calls are logged and exported.

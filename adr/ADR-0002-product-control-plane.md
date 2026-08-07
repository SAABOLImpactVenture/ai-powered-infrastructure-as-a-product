# ADR-0002: Product Contract and Crossplane Are the Strategic Center

- **Status:** Accepted
- **Date:** 2026-08-06

## Decision

The strategic infrastructure architecture is centered on:

```text
consumer intent
→ bounded composite AI
→ GitHub proposal, deterministic validation, and human approval
→ stable infrastructure product API
→ Crossplane product control plane
→ cloud-specific implementation
→ product status and evidence
```

The product contract defines consumer outcomes, profiles, required metadata, lifecycle, guarantees, exclusions, status, and versioning.

Crossplane is the maintained product-control-plane mechanism for the reference POCs where provider coverage and lifecycle behavior are sufficient.

Composite AI may interpret intent, draft proposals, explain policy, diagnose sanitized status, and assemble evidence. It may not directly apply/delete infrastructure, approve/merge its own work, read unrestricted secrets/state, create privileged identities, or modify its own policy/tool boundary.

## Consequences

- Consumer contracts are decoupled from implementation topology.
- Foundation capabilities can be established incrementally as products after a minimal trusted seed exists.
- Multi-cloud differences remain behind the contract unless they are a deliberate product choice.
- GitHub provides change governance and evidence, not cloud reconciliation.
- Cloud-native IAM remains the final permission boundary.
- One external resource has one authoritative reconciler.

## Supersession note

The reference implementation no longer carries the previous Terraform, Arc, Backstage, or legacy execution-MCP stack. See `ADR-0005-supersede-legacy-implementation-stack.md`.

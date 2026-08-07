# ADR-0005: Supersede the Legacy Accelerator Implementation Stack

- **Status:** Accepted
- **Date:** 2026-08-07

## Context

The original accelerator accumulated Terraform modules, TFE-oriented workflows, Azure Arc, Backstage, legacy cloud-execution MCP servers, PromptFlow/Semantic Kernel experiments, and duplicated cloud-specific implementation trees.

Those assets were useful during discovery, but the bounded Crossplane, infrastructure-product, composite-AI, and integration POCs now express a clearer target architecture.

Continuing to maintain both stacks on `main` creates architectural ambiguity and CI cost.

## Decision

The maintained accelerator will remove the legacy implementation stack and use Git history as the preservation mechanism.

The pre-supersession state is frozen at:

- branch `archive/legacy-accelerator-v1`;
- commit `be5fa73c72f77043ac666d32868ec7b82f9e83b1`.

The maintained reference implementation will contain only the current thesis, architecture, operating model, decisions, evidence baseline, bounded AI-security policies/evaluations, and GitHub governance needed to support the modern POC portfolio.

## Rationale

- The repository should tell one architectural story.
- A reference implementation should not carry every technology explored on the path to the current design.
- Git already provides historical preservation.
- Removing a technology from the accelerator does not declare it universally obsolete.
- External enterprise integrations are clearer than dormant internal dependencies.

## Consequences

### Positive

- Smaller attack and dependency surface.
- Simpler CI and support model.
- Clear Crossplane/composite-AI product-control-plane story.
- TFE optionality becomes demonstrable by architecture rather than only asserted in prose.
- Easier onboarding and executive explanation.

### Tradeoffs

- Legacy demos no longer run from `main`.
- Organizations wanting the V1 accelerator must use the recovery branch/commit.
- Any reintroduction requires an explicit product and lifecycle justification.

## Reintroduction criteria

A removed implementation may return only if a new ADR identifies a required product capability that cannot be satisfied through the maintained architecture or an external integration, and documents ownership, lifecycle cost, evidence, and exit criteria.

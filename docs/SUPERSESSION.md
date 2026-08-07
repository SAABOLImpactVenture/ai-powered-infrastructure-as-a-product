# Supersession Record

## Decision

The maintained accelerator no longer carries the earlier Terraform/TFE, Azure Arc, Backstage, legacy execution-MCP, PromptFlow/Semantic Kernel, or duplicated provider-specific implementation stack.

The older material remains recoverable through Git rather than remaining beside the current architecture.

- **Recovery branch:** `archive/legacy-accelerator-v1`
- **Frozen commit:** `be5fa73c72f77043ac666d32868ec7b82f9e83b1`
- **Supersession date:** 2026-08-07

## Why

Keeping every implementation explored during discovery made the repository look like several competing platforms at once. The current POC portfolio now provides a clearer and more modern reference architecture.

The purpose of deletion is therefore architectural clarity, not a claim that the superseded technologies are universally obsolete.

## Removed from the maintained accelerator

- Terraform implementation directories and Terraform-specific CI.
- TFE-oriented execution assumptions.
- Azure Arc control-plane and Arc GitOps implementation assets.
- Backstage application, backend, templates, custom actions, plugins, and charts.
- Legacy cloud-execution MCP servers and policy-image stubs.
- PromptFlow and Semantic Kernel implementation experiments.
- Duplicated provider-specific landing-zone, identity, DR, workload, and golden-demo implementation trees.
- Historical CI that existed only to validate those removed surfaces.

## Retained

- Product thesis and architecture.
- POC portfolio references.
- Frozen acceptance evidence.
- Product and TFE decision ADRs.
- Composite-AI security policies and negative evaluations.
- Documentation visuals and Mermaid diagrams.
- GitHub governance and docs workflows.

## Reintroduction rule

A superseded implementation may be reintroduced only through a new ADR that identifies the product capability it uniquely supplies, the owning team, lifecycle cost, evidence, exit criteria, and why an external integration is insufficient.

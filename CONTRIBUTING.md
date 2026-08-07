SPDX-License-Identifier: Apache-2.0

# Contributing

This project treats infrastructure as a product rather than a collection of implementation tools.

## Contribution principles

1. Preserve the mental model: **IaaS is what we buy; infrastructure-as-a-product is what we build.**
2. Keep product contracts independent of provider implementation details that consumers do not need.
3. Keep composite AI bounded to proposal, explanation, diagnosis, and evidence.
4. Keep deterministic policy and human authorization authoritative.
5. Do not add Terraform/TFE, Azure Arc, Backstage, or legacy execution-MCP implementations back to the maintained reference architecture without a new accepted ADR.
6. Prefer bounded implementation work in the corresponding POC repository rather than duplicating runtime code here.
7. Add evidence for material architectural claims.

## Workflow

- Open an issue for material architecture changes.
- Use an ADR for durable decisions.
- Run `make validate` before submitting a PR.
- Keep documentation and Mermaid diagrams synchronized with the implemented POC portfolio.
- Do not claim live-cloud, production, or investment proof from simulated evidence.

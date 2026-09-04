SPDX-License-Identifier: Apache-2.0

# Security Policy

## Scope

`main` contains the maintained Infrastructure-as-a-Product thesis, architecture, policy, agent-security evaluations, and evidence baseline. Runtime implementations live in the bounded POC repositories referenced by this project.

## Reporting a vulnerability

Report suspected security vulnerabilities privately through [GitHub private vulnerability reporting](https://github.com/InfrastructureProductWorks/ai-powered-infrastructure-as-a-product/security/advisories/new). Include the affected path or repository, reproduction steps, impact, and any suggested mitigation. Do not disclose suspected vulnerabilities in a public issue.

## Security principles

- No long-lived cloud credentials in source.
- Workload identity/federation is preferred for live cloud execution.
- Composite AI is proposal, explanation, diagnosis, and evidence only.
- AI may not approve, merge, apply, delete, expand privileges, modify policy, or read unrestricted secrets/state.
- Deterministic policy and tests are authoritative over AI output.
- One external resource has one authoritative reconciler.
- Pull-request validation is credential-free by default.
- Live-cloud and production actions are separate, explicit trust boundaries.
- Git history and evidence digests preserve accepted proof points.

## Supported branch

- `main`: actively maintained.
- `archive/legacy-accelerator-v1`: historical recovery branch; not maintained or supported as a current architecture.

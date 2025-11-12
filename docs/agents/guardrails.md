SPDX-License-Identifier: Apache-2.0
# Agent Guardrails & Risk Controls

## Branch & merge controls
- Protected branches (`main`, `release/*`); agents cannot push directly.
- Required checks: pre-commit, policy gates, link-check.
- CODEOWNERS for sensitive paths; 2 approvals for infra logic.

## Path governance
- Default allowlist: `modules/**`, `charts/**`, `gitops/**`, `docs/**`.
- Denylist (agent-prohibited): `secrets/**`, `scripts/privileged/**`, `infra/prod/**`.

## Environment fences
- Agents act in `dev/test` by default. Promotions to `prod` require human `environment: prod` approval labels.

## Secrets & identity
- OIDC/JWT only; no long-lived keys.
- Least-privilege roles scoped to read-mostly; mutating actions only in nonprod and under `workflow_dispatch`.

## Egress & supply chain
- All network egress via proxy allow-lists; DNS restricted.
- SBOMs and signature verification (Cosign) for dependencies.

## Evidence
- Upload all artifacts to CI; store hashes; export indexes to ADX; maintain retention ≥ 12 months.

SPDX-License-Identifier: Apache-2.0
# Policy-as-Code Layers & Exceptions

## Layers
1. **Org Guardrails**: Azure Policy initiative; AWS Config; GCP Policy Controller; OCI Cloud Guard.
2. **Product Baselines**: Kubernetes Gatekeeper constraints; image repo allow-lists; required labels.
3. **Workload Contracts**: OPA/Conftest rules per service.

## Enforcement
- CI gates run Conftest/Checkov on each PR.
- Gatekeeper runs `audit` in nonprod; promotion requires clean audit.

## Exceptions
- Raised via PR with documented rationale, scope, duration, and compensating controls.
- Tracked in `COMPLIANCE.md` with POA&M references.
- Expire automatically; reviewed quarterly.

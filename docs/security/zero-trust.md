SPDX-License-Identifier: Apache-2.0
# Zero Trust & TIC 3.0 Alignment

## Identity
- Entra ID with MFA, PIM/JIT; workload identities for CI/agents in all CSPs.

## Network
- Private endpoints; egress proxies; DNS allow-lists; TLS everywhere (FIPS-validated crypto).

## Workload
- Signed images (Cosign); SBOM required; policy enforcement at admission (PSA + Gatekeeper).

## Data
- Encryption at rest & in transit; key management with separation of duties; rotation policies documented.

## Operations
- Immutable audit logs; incident response playbooks; evidence freshness SLO: ≤ 24h.

# Credential-Free Backstage Multi-Cloud Foundation Baseline v2

- **Baseline ID:** `credential-free-backstage-multicloud-foundation-v2`
- **Status:** Passed, historical/superseded
- **Validation date:** 2026-08-07
- **Workflow run:** [31210928432](https://github.com/SAABOLImpactVenture/multicloud-foundation-poc-integration/actions/runs/31210928432)
- **Integration commit:** `3984c0dde508be10b0e07ddcdac319bd996efcde`
- **Superseded by:** `credential-free-backstage-contract-aligned-v3`

## Purpose

Freeze the first successful executable baseline that extended the credential-free multi-cloud Infrastructure-as-a-Product proof through the independent Backstage storefront.

This record is intentionally retained even though a later six-repository evaluation discovered storefront/product schema drift that the representative scenarios did not exercise. The run remains valid evidence for the scenarios it executed; it is not the current contract-aligned baseline.

## Immutable source inputs

| Component | Repository | Commit |
|---|---|---|
| Crossplane seed | `SAABOLImpactVenture/crossplane-multicloud-seed-poc` | `2afa74322adddda5b24f6ad1dc04ec05de0d7aa0` |
| Foundation product | `SAABOLImpactVenture/multicloud-foundation-product-poc` | `164fe8d9d5e7698770f056e5daac3125d9a2c247` |
| Composite AI | `SAABOLImpactVenture/composite-ai-infrastructure-product-poc` | `08af22093ee69c683948175512ca800f75fecab9` |
| Backstage storefront | `SAABOLImpactVenture/backstage-infrastructure-product-storefront-poc` | `2c3ea43cabb57de016b9a6bcbb8cf14ea4fde0eb` |
| Integration/evidence harness | `SAABOLImpactVenture/multicloud-foundation-poc-integration` | `3984c0dde508be10b0e07ddcdac319bd996efcde` |

## Matrix result

| Kubernetes | Result | Score | Evidence artifact | SHA-256 digest |
|---|---:|---:|---|---|
| 1.34 | Pass | 100/100 | `poc-evidence-kubernetes-1.34` (ID `9006702474`) | `15d9377ec8183e93867cdd9c8614cee97e8d2cb8a0d9f4ef1a9b63ccd9e2b839` |
| 1.35 | Pass | 100/100 | `poc-evidence-kubernetes-1.35` (ID `9006703569`) | `6f4e158851895afb2b76a550d055f596dc3469ea55e91665194d449b7659d379` |
| 1.36 | Pass | 100/100 | `poc-evidence-kubernetes-1.36` (ID `9006705030`) | `baae3ded10ec9fcb9aa349e48dc3b58128f42303bfa345e3c4a3fb0c6c130542` |

## What this baseline proved

Across all three Kubernetes versions, the integrated path successfully exercised:

- the Backstage `InfrastructureProductOrder` scenarios for AWS and GCP;
- bounded Composite AI request/review behavior;
- deterministic policy and negative request handling;
- a human-approval requirement encoded in the proposal contract;
- `CloudFoundationEnvironment` reconciliation through Crossplane;
- four Ready simulated product instances;
- no direct AI create authority; and
- deterministic teardown with zero remaining product components.

## Later-discovered limitation

The six-repository evaluation found that this storefront version accepted a wider owner/cost-center input domain than the downstream product/AI contract. The representative valid scenarios used by this run did not hit those edge cases, so the 100/100 score did not detect the drift.

That finding does not invalidate this run's executed scenarios. It explains why this baseline is historical and why v3 added an explicit cross-repository compatibility guard.

## Scope boundaries

This baseline is credential-free and simulated. It does **not** prove:

- live AWS/GCP provisioning;
- production readiness or authorization;
- actual Backstage server execution of the template;
- an actual person approving a GitHub PR;
- a live LLM/model adapter; or
- a direct implemented TFE comparison.

## Evidence-based conclusion

The baseline demonstrated the first complete reference consumer path from storefront intent through bounded AI, deterministic validation, Crossplane reconciliation, evidence, and teardown without Terraform Enterprise being a mandatory dependency.

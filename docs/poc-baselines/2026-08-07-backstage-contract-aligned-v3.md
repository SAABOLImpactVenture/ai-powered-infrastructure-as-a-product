# Credential-Free Backstage Contract-Aligned Baseline v3

- **Baseline ID:** `credential-free-backstage-contract-aligned-v3`
- **Status:** Passed, current credential-free baseline
- **Validation date:** 2026-08-07
- **Workflow run:** [31222507218](https://github.com/SAABOLImpactVenture/multicloud-foundation-poc-integration/actions/runs/31222507218)
- **Integration commit:** `e66f2ceed93167f894c002103692a8d59b845e9d`
- **Previous baseline:** `credential-free-backstage-multicloud-foundation-v2`

## Purpose

Freeze the corrected credential-free Infrastructure-as-a-Product baseline after remediating the highest-priority six-repository evaluation finding: storefront/product contract drift.

This baseline preserves the Backstage-inclusive product journey while adding an executable cross-repository invariant: every value accepted by the storefront for the checked fields must also be valid under the canonical `CloudFoundationEnvironment` product contract.

## Immutable source inputs

| Component | Repository | Commit |
|---|---|---|
| Crossplane seed | `SAABOLImpactVenture/crossplane-multicloud-seed-poc` | `2afa74322adddda5b24f6ad1dc04ec05de0d7aa0` |
| Foundation product | `SAABOLImpactVenture/multicloud-foundation-product-poc` | `164fe8d9d5e7698770f056e5daac3125d9a2c247` |
| Composite AI | `SAABOLImpactVenture/composite-ai-infrastructure-product-poc` | `08af22093ee69c683948175512ca800f75fecab9` |
| Backstage storefront | `SAABOLImpactVenture/backstage-infrastructure-product-storefront-poc` | `2a30c77a9d479a0506c890091e325f9c71e85d8b` |
| Integration/evidence harness | `SAABOLImpactVenture/multicloud-foundation-poc-integration` | `e66f2ceed93167f894c002103692a8d59b845e9d` |

## Matrix result

| Kubernetes | Result | Score | Evidence artifact | SHA-256 digest |
|---|---:|---:|---|---|
| 1.34 | Pass | 100/100 | `poc-evidence-kubernetes-1.34` (rerun ID `9011038538`) | `7df76e771d9cdf7a455d4554e5a2d500512aca6eb9aa6746c99a6bef0c0fa8a3` |
| 1.35 | Pass | 100/100 | `poc-evidence-kubernetes-1.35` (ID `9010939680`) | `4b09bcaee8e01dcd4536e2de38d5cc482b4c40bd74e66cb16fe42e9441ddacee` |
| 1.36 | Pass | 100/100 | `poc-evidence-kubernetes-1.36` (ID `9010939315`) | `ecbe5f065b2661a877eb8addbd0d8242cfd6d311034f52c65343792d1b6ca489` |

The earlier 1.34 artifact from the first attempt (`9010941957`) is retained by GitHub as historical run evidence but is not the v3 frozen artifact. The rerun artifact above is authoritative for this baseline.

## Contract-compatibility evidence

The matrix generated `contract-compatibility.json` with `result: pass` on each Kubernetes version. It enforced:

- rule: `storefront-accepted-domain-must-be-subset-of-product-contract`;
- owner: storefront/product minimum 3, maximum 63, same DNS-style pattern;
- cost center: storefront/product minimum 3, maximum 32, same `[A-Za-z0-9_-]+` pattern;
- cloud: storefront `aws,gcp` is equal to the product cloud domain; and
- region: storefront `us-east-1,us-east1` is a valid subset of the product's broader AWS/GCP region domain.

The guard executes before Kind cluster creation, so future drift in these constraints fails the integration matrix before runtime provisioning work begins.

## Integrated outcomes proven

Across Kubernetes 1.34, 1.35, and 1.36:

1. Exact upstream commit locks were verified.
2. The corrected Backstage storefront validated and rendered AWS/GCP product orders.
3. The storefront/product compatibility guard passed.
4. Composite AI remained bounded to proposal/review/evidence behavior.
5. The human-approval requirement remained encoded in the proposal contract.
6. Production and TFE-coupled storefront orders failed closed.
7. Crossplane reconciled the simulated product instances to Ready.
8. The AI identity had no direct create authority for the product API.
9. Active ingress and egress NetworkPolicy probes passed.
10. Teardown completed with `remainingProductComponents: 0` and `productApiUninstall: pass`.
11. Every scored acceptance control passed for a final score of 100/100.

## Scope boundaries

This is still a **credential-free, simulated POC baseline**. It does not prove:

- live AWS/GCP resource provisioning;
- production readiness, compliance, or authorization;
- actual Backstage server execution of the template/action;
- an actual person approving a GitHub order PR;
- a live LLM/model adapter;
- immutable verification of every external build dependency; or
- an observed TFE-vs-Crossplane lifecycle comparison.

## Evidence-based conclusion

The corrected POC demonstrates that a developer-facing infrastructure product order can pass through a bounded storefront, composite-AI assistance, deterministic policy, an encoded human-approval boundary, and Crossplane reconciliation with auditable evidence and teardown without Terraform Enterprise being a mandatory dependency.

The highest-priority contract-drift finding from the six-repository evaluation is closed for the checked storefront/product fields. The next correction gate is build/supply-chain reproducibility before live-cloud evidence is treated as an enterprise control demonstration.

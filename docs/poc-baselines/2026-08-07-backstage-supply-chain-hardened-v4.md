# Credential-Free Backstage Supply-Chain-Hardened Baseline v4

- **Baseline ID:** `credential-free-backstage-supply-chain-hardened-v4`
- **Status:** Passed, current credential-free baseline
- **Validation date:** 2026-08-07
- **Workflow run:** [31228108701](https://github.com/SAABOLImpactVenture/multicloud-foundation-poc-integration/actions/runs/31228108701)
- **Integration commit:** `3810d15817f9d1f43e290e6bda8ac9b25c0f97ff`
- **Previous baseline:** `credential-free-backstage-contract-aligned-v3`

## Purpose

Freeze the credential-free Infrastructure-as-a-Product baseline after hardening the integration and bootstrap supply chain without changing the architectural authority model or introducing cloud credentials.

This baseline preserves the v3 storefront/product contract-compatibility invariant and adds executable evidence that the integration workflow uses immutable GitHub Action revisions, a pinned Python runtime, hash-locked Python dependencies, and checksum-verified bootstrap binaries before execution.

## Immutable source inputs

| Component | Repository | Commit |
|---|---|---|
| Crossplane seed | `SAABOLImpactVenture/crossplane-multicloud-seed-poc` | `08a406b721e1514d4b17500fce441374b07ae8d6` |
| Foundation product | `SAABOLImpactVenture/multicloud-foundation-product-poc` | `164fe8d9d5e7698770f056e5daac3125d9a2c247` |
| Composite AI | `SAABOLImpactVenture/composite-ai-infrastructure-product-poc` | `08af22093ee69c683948175512ca800f75fecab9` |
| Backstage storefront | `SAABOLImpactVenture/backstage-infrastructure-product-storefront-poc` | `2a30c77a9d479a0506c890091e325f9c71e85d8b` |
| Integration/evidence harness | `SAABOLImpactVenture/multicloud-foundation-poc-integration` | `3810d15817f9d1f43e290e6bda8ac9b25c0f97ff` |

## Matrix result

| Kubernetes | Result | Score | Evidence artifact | SHA-256 digest |
|---|---:|---:|---|---|
| 1.34 | Pass | 100/100 | `poc-evidence-kubernetes-1.34` (ID `9012843867`) | `e6973e72a342546a87a8d518995f92dcf8ef191f4f02f6cbf1faf7f6e683bf91` |
| 1.35 | Pass | 100/100 | `poc-evidence-kubernetes-1.35` (ID `9012844165`) | `e107c785888842f4bceeeb674dcad3bd399e45be132fa14e6462d01be681d917` |
| 1.36 | Pass | 100/100 | `poc-evidence-kubernetes-1.36` (ID `9012843999`) | `c1a7feffdbdae4008d5490681f169e0798258947cc43a684b53dcc7ba6ede34f` |

## Supply-chain evidence

Across the full matrix:

- `actions/checkout` was referenced by immutable commit `11d5960a326750d5838078e36cf38b85af677262`;
- `actions/setup-python` was referenced by immutable commit `a26af69be951a213d495a4c3e4e4022e16d87065`;
- `actions/upload-artifact` was referenced by immutable commit `ea165f8d65b6e75b540449e92b4886f43607fa02`;
- Python was pinned to `3.12.13`;
- PyYAML `6.0.3` was installed with `--require-hashes` and binary-only resolution;
- Kind, kubectl, and Helm were downloaded before installation and verified against publisher-provided SHA-256 values;
- the checksum verifier failed closed in its regression tests; and
- the integration repository validates that future workflow changes do not reintroduce floating Action tags or unhashed pip installs.

The run also emitted a GitHub-hosted-runner compatibility warning because the pinned Action revisions target Node.js 20 and GitHub forced them to execute on Node.js 24. The jobs passed, but that warning remains a maintenance item and is not represented as a failed POC control.

## Integrated outcomes proven

Across Kubernetes 1.34, 1.35, and 1.36:

1. Exact upstream commit locks were verified.
2. Storefront/product accepted-domain compatibility passed before cluster creation.
3. The corrected Backstage storefront validated and rendered AWS/GCP product orders.
4. Composite AI remained proposal-and-evidence-only with no direct product create authority.
5. The human-approval requirement remained encoded in the proposal contract; no claim is made that an actual person approved a PR during this harness run.
6. Production and TFE-coupled storefront requests failed closed.
7. Publisher SHA-256 verification succeeded for Kind, kubectl, and Helm before installation.
8. Active ingress and egress NetworkPolicy dataplane probes passed.
9. Crossplane reconciled the simulated product instances to Ready.
10. Teardown completed with `remainingProductComponents: 0` and `productApiUninstall: pass`.
11. Every scored acceptance control passed for a final score of 100/100.

## Scope boundaries

This remains a **credential-free, simulated POC baseline**. It does not prove:

- live AWS/GCP resource provisioning;
- production readiness, compliance, or authorization;
- actual Backstage server execution of the template/action;
- actual human approval of a GitHub order PR;
- a live LLM/model adapter;
- complete immutability or signature verification of every external artifact in the broader platform supply chain; or
- an observed TFE-vs-Crossplane lifecycle comparison.

The product repository's semantic CIDR/lifecycle corrections also remain required before a live-cloud gate should be treated as enterprise product evidence.

## Evidence-based conclusion

The v4 POC demonstrates that the credential-free Backstage-to-Crossplane infrastructure-product path remains portable and 100/100 across Kubernetes 1.34, 1.35, and 1.36 after materially hardening workflow and bootstrap reproducibility.

Terraform Enterprise remains non-mandatory for the demonstrated path. The result does not eliminate justified TFE exception use cases such as brownfield Terraform state, migration/import, or unsupported-resource gaps, and it does not permit TFE and Crossplane to co-manage the same external resource.

The next evidence gate is an actual Backstage runtime smoke test that executes the reference template/action while preserving the same bounded authority model. Product CIDR/lifecycle semantics remain a blocker before live AWS evidence is treated as enterprise-grade product proof.

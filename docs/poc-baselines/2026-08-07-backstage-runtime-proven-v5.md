# Credential-Free Backstage Runtime-Proven Baseline v5

- **Baseline ID:** `credential-free-backstage-runtime-proven-v5`
- **Status:** Passed, current credential-free baseline
- **Validation date:** 2026-08-07
- **Integration workflow run:** [31232799819](https://github.com/SAABOLImpactVenture/multicloud-foundation-poc-integration/actions/runs/31232799819)
- **Integration commit:** `db60636e5f2c6225ce3093b10626df4be63195df`
- **Independent Backstage runtime run:** [31231470219](https://github.com/SAABOLImpactVenture/backstage-infrastructure-product-storefront-poc/actions/runs/31231470219)
- **Previous baseline:** `credential-free-backstage-supply-chain-hardened-v4`

## Purpose

Freeze the credential-free Infrastructure-as-a-Product baseline after closing the actual Backstage runtime evidence gate without changing the bounded authority model or introducing cloud, Kubernetes, TFE, or real GitHub publication credentials.

v5 preserves the v4 supply-chain controls and the v3 accepted-domain compatibility invariant. It adds an evidence chain between two separate proofs:

1. the storefront revision was independently executed in an actual Backstage backend through the Software Catalog and Scaffolder dry-run API; and
2. the merged storefront revision carrying that runtime-proven content was then pinned into the full Kubernetes 1.34/1.35/1.36 integration matrix and passed every scored control at 100/100.

The integration harness itself does **not** start Backstage. The runtime proof and the integration proof remain separate evidence layers and are linked by immutable source lineage.

## Immutable source inputs

| Component | Repository | Commit |
|---|---|---|
| Crossplane seed | `SAABOLImpactVenture/crossplane-multicloud-seed-poc` | `08a406b721e1514d4b17500fce441374b07ae8d6` |
| Foundation product | `SAABOLImpactVenture/multicloud-foundation-product-poc` | `164fe8d9d5e7698770f056e5daac3125d9a2c247` |
| Composite AI | `SAABOLImpactVenture/composite-ai-infrastructure-product-poc` | `08af22093ee69c683948175512ca800f75fecab9` |
| Backstage storefront | `SAABOLImpactVenture/backstage-infrastructure-product-storefront-poc` | `2f684771b618bf7cf17b3bb01ba7985979c931f6` |
| Integration/evidence harness | `SAABOLImpactVenture/multicloud-foundation-poc-integration` | `db60636e5f2c6225ce3093b10626df4be63195df` |

## Actual Backstage runtime evidence

The storefront runtime smoke executed on PR head `694fba9e2e1b24ff5d051d683acba92ef556bcf7`, which was subsequently merged into storefront commit `2f684771b618bf7cf17b3bb01ba7985979c931f6` used by the v5 integration run.

Runtime workflow run `31231470219` proved that:

- an actual Backstage backend started;
- `template:default/cloud-foundation-environment` registered in the actual Software Catalog;
- the runtime exposed `fetch:template` and `publish:github:pull-request`;
- `fetch:template` actually rendered the expected `InfrastructureProductOrder`;
- `publish:github:pull-request` actually executed in Backstage's supported **dry-run** path;
- no real GitHub write credential was provided to the Backstage runtime;
- no real GitHub order PR was created; and
- no cloud, Kubernetes, TFE, or infrastructure-apply authority was introduced.

The runtime evidence artifact is `backstage-runtime-smoke-evidence` (ID `9013980966`), SHA-256 `c54ea0b93039c49660bb77e305d5b44b87ca6f18bc0bec97255fa5242e6f8008`.

The ephemeral runtime used `@backstage/create-app@0.9.0`, Node.js `24.18.1`, and Yarn `4.13.0`. The generated dependency graph required one explicit resolution pass; the resulting `yarn.lock` SHA-256 was `14457ebe5801208269c99c145e5f0351039983b66dd8ba2f4f307496c3bb5192`, followed by a successful immutable reinstall before Backstage was started. This proves run-local dependency stability, not cross-run dependency immutability.

## Integration matrix result

| Kubernetes | Result | Score | Evidence artifact | SHA-256 digest |
|---|---:|---:|---|---|
| 1.34 | Pass | 100/100 | `poc-evidence-kubernetes-1.34` (ID `9014412485`) | `90a546e76e0eb2ead8c8bde24c53b783d7dca95e25913f8a5abca37857b8ee90` |
| 1.35 | Pass | 100/100 | `poc-evidence-kubernetes-1.35` (ID `9014419556`) | `9547a5db404b7f9e6090d7c50b81687ef10d2a2ef1e8feef53878d8f7023c52c` |
| 1.36 | Pass | 100/100 | `poc-evidence-kubernetes-1.36` (ID `9014411323`) | `60db757f613e800782c7421a0d5fc315bfe1744a1d17fbb5ce101a9ac0cb08d8` |

These integration artifacts were created from `main` at `db60636e5f2c6225ce3093b10626df4be63195df` and are scheduled to expire on 2026-11-06 unless retained elsewhere.

## Supply-chain evidence retained from v4

Across the full integration matrix:

- `actions/checkout` remained pinned to `11d5960a326750d5838078e36cf38b85af677262`;
- `actions/setup-python` remained pinned to `a26af69be951a213d495a4c3e4e4022e16d87065`;
- `actions/upload-artifact` remained pinned to `ea165f8d65b6e75b540449e92b4886f43607fa02`;
- Python remained pinned to `3.12.13`;
- PyYAML `6.0.3` remained binary-only and hash-locked with `--require-hashes`;
- Kind, kubectl, and Helm were checksum-verified against publisher-provided SHA-256 values before installation; and
- the integration repository continued to reject floating Action tags and unhashed workflow pip installs.

The GitHub-hosted runner continued to warn that the pinned Action revisions target Node.js 20 and were being forced to run on Node.js 24. The jobs passed; the warning remains a maintenance item rather than a passed security guarantee.

## Integrated outcomes proven

Across Kubernetes 1.34, 1.35, and 1.36:

1. Exact upstream source locks were verified, including storefront commit `2f684771b618bf7cf17b3bb01ba7985979c931f6`.
2. Storefront/product accepted-domain compatibility passed before cluster creation.
3. Storefront-to-Composite-AI handoff verification passed.
4. AWS and GCP development orders were accepted while production, region-mismatch, and TFE-coupled requests failed closed.
5. Composite AI remained proposal-and-evidence-only with no product create authority.
6. The proposal contract continued to encode `human-required`; no claim is made that a person actually approved a GitHub order PR during the harness.
7. Active ingress and egress NetworkPolicy dataplane probes passed.
8. Crossplane reconciled the simulated product instances to Ready.
9. Negative admission and operations prompt-injection containment passed.
10. Teardown completed with `remainingProductComponents: 0` and `productApiUninstall: pass`.
11. Every scored acceptance control passed for a final score of 100/100.

## Scope boundaries

v5 remains a **credential-free, simulated infrastructure POC baseline with independently proven Backstage runtime execution**. It does not prove:

- a real GitHub order PR created by Backstage;
- actual human approval of an order;
- browser/user-interface execution of the storefront;
- live AWS or GCP resource provisioning;
- a live LLM/model adapter;
- production readiness, compliance, authorization, SLOs, or recovery behavior;
- cross-run immutability of the ephemeral Backstage dependency graph;
- complete signed provenance/attestation of the broader platform supply chain; or
- an observed TFE-vs-Crossplane lifecycle comparison.

## Evidence-based conclusion

v5 demonstrates a bounded developer-storefront-to-control-plane architecture in which the reference Backstage template has now been executed in an actual Backstage runtime, while the exact merged storefront revision carrying that proof also passes the full credential-free Kubernetes 1.34/1.35/1.36 integration matrix at 100/100.

Terraform Enterprise remains non-mandatory for the demonstrated path. This does not eliminate justified TFE exception use cases such as brownfield Terraform state, migration/import, or unsupported-resource gaps, and it does not permit TFE and Crossplane to co-manage the same external resource.

The next evidence gate is **product live-cloud readiness correction**: semantic CIDR validation/containment, an explicit lifecycle-field ownership decision, and removal of unobserved pre-scoring from the TFE comparison example. After those corrections are independently proven and repinned, the next major execution gate is a live AWS non-production sandbox using workload identity rather than static credentials.

# POC Baseline Lineage

The program preserves successful evidence milestones instead of rewriting a single moving baseline. A later baseline can supersede an earlier one for current decision-making without invalidating what the earlier run actually proved.

| Baseline | Status | Workflow run | What changed |
|---|---|---:|---|
| [`credential-free-multicloud-foundation-v1`](2026-08-07-credential-free-multicloud-foundation.md) | Passed, historical | `31136204337` | First credential-free Crossplane + bounded Composite AI multi-cloud foundation proof. |
| [`credential-free-backstage-multicloud-foundation-v2`](2026-08-07-backstage-multicloud-foundation-v2.md) | Passed, historical/superseded | `31210928432` | Added independent Backstage storefront to the complete simulated product journey. |
| [`credential-free-backstage-contract-aligned-v3`](2026-08-07-backstage-contract-aligned-v3.md) | Passed, historical/superseded | `31222507218` | Corrected storefront/product schema drift and made accepted-domain compatibility an executable cross-repository invariant. |
| [`credential-free-backstage-supply-chain-hardened-v4`](2026-08-07-backstage-supply-chain-hardened-v4.md) | Passed, historical/superseded | `31228108701` | Preserved v3 contract compatibility while pinning workflow Actions/Python, hash-locking CI dependencies, and checksum-verifying Kind/kubectl/Helm before installation. |
| [`credential-free-backstage-runtime-proven-v5`](2026-08-07-backstage-runtime-proven-v5.md) | **Passed, current** | `31232799819` | Pins the independently runtime-proven Backstage storefront revision into the full hardened Kubernetes 1.34/1.35/1.36 integration matrix; all entries remain 100/100. |

## Current credential-free decision baseline

Use **v5** for current architectural claims about the credential-free simulated reference path and the independently proven Backstage runtime layer.

The corresponding machine-readable records are under `artifacts/poc-baselines/`.

## Evidence discipline

A baseline is evidence for exactly the scenarios and controls it executed. It is not evidence for capabilities outside its recorded scope.

The current v5 baseline establishes actual Backstage backend/catalog/Scaffolder execution through the independently captured storefront runtime smoke, but publication was dry-run and the full infrastructure journey remained simulated. v5 therefore does **not** establish a real GitHub order PR, browser UI interaction, actual human PR approval, live-cloud provisioning, a live LLM adapter, production readiness, cross-run immutability of the ephemeral Backstage dependency graph, or complete signed provenance/attestation of every external artifact in the broader platform supply chain.

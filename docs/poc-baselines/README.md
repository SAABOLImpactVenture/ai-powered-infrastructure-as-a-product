# POC Baseline Lineage

The program preserves successful evidence milestones instead of rewriting a single moving baseline. A later baseline can supersede an earlier one for current decision-making without invalidating what the earlier run actually proved.

| Baseline | Status | Workflow run | What changed |
|---|---|---:|---|
| [`credential-free-multicloud-foundation-v1`](2026-08-07-credential-free-multicloud-foundation.md) | Passed, historical | `31136204337` | First credential-free Crossplane + bounded Composite AI multi-cloud foundation proof. |
| [`credential-free-backstage-multicloud-foundation-v2`](2026-08-07-backstage-multicloud-foundation-v2.md) | Passed, historical/superseded | `31210928432` | Added independent Backstage storefront to the complete simulated product journey. |
| [`credential-free-backstage-contract-aligned-v3`](2026-08-07-backstage-contract-aligned-v3.md) | **Passed, current** | `31222507218` | Corrected storefront/product schema drift and made accepted-domain compatibility an executable cross-repository invariant. |

## Current credential-free decision baseline

Use **v3** for current architectural claims about the credential-free simulated reference path.

The corresponding machine-readable records are under `artifacts/poc-baselines/`.

## Evidence discipline

A baseline is evidence for exactly the scenarios and controls it executed. It is not evidence for capabilities outside its recorded scope. In particular, the current v3 baseline does not establish live-cloud provisioning, production readiness, an actual Backstage runtime/user interaction, actual human PR approval, a live LLM adapter, or fully immutable external build dependencies.

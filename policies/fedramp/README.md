
# FedRAMP Baseline Packs

Minimal, deployable baselines to jump-start alignment with FedRAMP Moderate/High controls across AWS, Azure, GCP, and OCI.

> These are *additive baselines*—they enable encryption, logging, and core guardrails. You should extend them with environment-specific policies and document control inheritance.

- AWS: Security Hub standards + AWS Config rules + CloudTrail + WORM-ish logging bucket.
- Azure: Assign policy initiative (Azure Security Benchmark as a starting point) + diagnostics to Log Analytics.
- GCP: SCC enablement + Org Policy constraints (no serial, no external IPs) + CMEK requirement example.
- OCI: Cloud Guard target + deny public storage access.

See each folder for `main.tf`/`baseline.bicep`. Run with OIDC/WIF in CI.

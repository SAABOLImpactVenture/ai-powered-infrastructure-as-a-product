# Enable FedRAMP controls on GCP

## Scope
- Attach org/root-level policies
- Enforce CMEK, private endpoints, region allow-lists
- Wire evidence exporters

## Steps
1. Provision landing zone in `landing-zones/gcp/...`
2. Apply policy/initiative at org/root scope
3. Enable evidence sinks under `evidence/sinks/...`
4. Mark `ci-security` as **Required** in branch protection.

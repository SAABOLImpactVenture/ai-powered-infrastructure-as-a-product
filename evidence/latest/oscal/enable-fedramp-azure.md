# Enable FedRAMP controls on AZURE

## Scope
- Attach org/root-level policies
- Enforce CMEK, private endpoints, region allow-lists
- Wire evidence exporters

## Steps
1. Provision landing zone in `landing-zones/azure/...`
2. Apply policy/initiative at org/root scope
3. Enable evidence sinks under `evidence/sinks/azure/adx`
4. Mark `ci-security` as **Required** in branch protection.

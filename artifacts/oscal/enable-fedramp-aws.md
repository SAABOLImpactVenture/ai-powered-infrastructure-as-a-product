# Enable FedRAMP controls on AWS

## Scope
- Attach org/root-level policies
- Enforce CMEK, private endpoints, region allow-lists
- Wire evidence exporters

## Steps
1. Provision landing zone in `landing-zones/aws/...`
2. Apply policy/initiative at org/root scope
3. Enable evidence sinks under `evidence/sinks/aws/s3_glue_athena`
4. Mark `ci-security` as **Required** in branch protection.

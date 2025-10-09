# Enable FedRAMP Baseline on AWS

This guide attaches **policy packs at org/root scope** and wires evidence links for SSP inheritance.

## Steps
1. Deploy landing zone under `landing-zones/aws/...`.
2. Attach policy/initiative at org scope:
3. Record Evidence URI (immutable blob from `evidence.yml`) in SSP.

## Terraform example
```hcl
# attach policy here (example placeholder for actual policy IDs)
# ensure scope is org/root; feed variables accordingly
```

# Turnkey Landing Zones

Deploy baseline enterprise controls per cloud with **region allow-lists**, **CMEK-required** storage, and **private-only** endpoints.

- Azure: `landing-zones/azure/enterprise-scale-lite/` (Management Groups + Policy Assignments)
- AWS: `landing-zones/aws/orgs_control_baseline/` (Organizations + SCP deny outside approved regions)
- GCP: `landing-zones/gcp/org_policies/` (disable SA key creation; extend with CMEK & TLS policies)
- OCI: `landing-zones/oci/compartments/`

> Apply these at org/root scope first, then layer product modules.

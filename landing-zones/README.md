# Turnkey Landing Zones (minimal, deployable)

- **Azure Enterprise-Scale (lite)**: `landing-zones/azure/enterprise-scale-lite/`
  - Management Groups, Allowed Locations, CMEK-required Storage, Private Endpoint policies
- **AWS Control Plane**: `landing-zones/aws/orgs_control_baseline/`
  - AWS Organizations + SCP deny outside approved regions; attach to OUs; pair with Control Tower where available
- **GCP Org Policies**: `landing-zones/gcp/org_policies/`
  - Disable SA Key creation, extend with CMEK/TLS policies
- **OCI Compartments**: `landing-zones/oci/compartments/`

Apply these at **org/root scope**, then layer governed product modules. Region allow-lists and CMEK requirements block drift by default.

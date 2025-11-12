SPDX-License-Identifier: Apache-2.0
# OSCAL Evidence & Continuous Monitoring

## Evidence sources
- CI artifacts: policy reports, Terraform plans, Helm diffs, SBOMs, signatures.
- Runtime posture (optional): Azure Policy/AWS Config/GCP Policy Controller/OCI Cloud Guard exports.

## Pipeline
1. Collect artifacts in CI, compute SHA256.
2. Write index manifest (JSON) and upload to storage.
3. Export daily OSCAL `assessment-results` referencing artifact URIs and hashes.
4. Ingest indexes to ADX for dashboards and sampling.

## Retention & integrity
- Retain evidence ≥ 12 months; prevent tampering with append-only stores and signatures.

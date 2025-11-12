SPDX-License-Identifier: Apache-2.0

# Compliance & Control Mapping (NIST 800-53 Rev. 5)

> This project **embeds controls as product features**. The table shows how capabilities map to NIST families. Evidence artifacts are generated to **OSCAL** and stored under `artifacts/oscal`.

| Capability                                                   | Control Families | Notes / Evidence                                                                  |
| ------------------------------------------------------------ | ---------------- | --------------------------------------------------------------------------------- |
| Identity & Access (workload identities, least privilege IAM) | AC, IA, AU, CM   | Terraform modules enforce least privilege; evidence: IAM policies + drift reports |
| Network Baselines (hub-spoke/mesh, private endpoints, DNS)   | AC, SC, SI, CM   | Templates enforce egress allow-lists; evidence: policy pass reports, route tables |
| Data Protection (KMS, backups, encryption)                   | SC, CP, MP, SI   | Evidence: KMS key policies, backup jobs, encryption settings                      |
| Logging & Monitoring (centralized logs, SLOs)                | AU, SI, IR       | Evidence: log sinks, SIEM routes, SLO dashboards exports                          |
| GitOps & Change Control (PR gates, approvals)                | CM, SA, RA, CA   | Evidence: PR checks, required reviewers, branch protection configs                |
| Policy-as-Code (OPA/Checkov gates)                           | CA, CM, RA       | Evidence: CI artifacts and policy result sets                                     |
| Artifact Integrity (SBOM, Cosign)                            | SI, SA           | Evidence: SBOMs, signature attestations                                           |
| DR & Resilience (RTO/RPO targets)                            | CP, SA           | Evidence: runbooks, DR test outputs                                               |

## Evidence generation

Run:

```bash
make evidence
```

This produces OSCAL catalogs for automated control narratives under `artifacts/oscal/` and attaches CI artifacts (policy reports, SBOMs, signatures) for auditors.

## Shared responsibility

The accelerator provides **technical controls and evidence hooks**. Your organization remains responsible for the full security program, continuous monitoring, POA&M management, and ATO sponsorship.

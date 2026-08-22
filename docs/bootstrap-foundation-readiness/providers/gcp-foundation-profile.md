# GCP foundation profile

**Requirement ID:** `BFR-PRV-030`

> **Status:** Architecture target with partial POC design evidence. The product POC contains a GCP development live-composition template, but no GCP resources, ProviderConfig, workload federation, project integration, or live teardown were validated.

## Profile purpose

Bind the provider-neutral contract to one exact, customer-approved GCP nonproduction project while exposing all organization, identity, network, security, evidence, operations, and cost dependencies.

## Existing POC evidence

The bounded POC includes templates for:

- one VPC network and subnetwork;
- one service account without demonstrated federation bindings or keys;
- one Cloud Storage bucket with uniform access and public-access prevention;
- ownership and cost labels;
- approved development regions; and
- namespaced ProviderConfig guidance that prohibits committed service-account keys.

It does not prove organization/folder/project vending, Shared VPC, enterprise DNS, workload identity federation, centralized logging, customer-managed encryption, security integration, or live GCP behavior.

## Customer decisions required

### Organization and target

- organization, folder, billing account, and project ownership;
- exact sandbox project, region, environment, and service-perimeter relationship where applicable;
- project-vending or externally supplied project boundary;
- organization-policy and allowed-service ownership; and
- brownfield/import and authoritative-engine rules.

### Identity

- workforce federation and privileged group ownership;
- workload identity federation pool/provider, subject mapping, audience, and revocation;
- separate discovery and provisioning service identities;
- IAM role scope and effective-access proof; and
- service-account impersonation and key-prohibition controls.

### Network and DNS

- standalone or Shared VPC ownership;
- IP allocation, subnet, route, firewall, hybrid connectivity, and inspection ownership;
- public/private managed-zone ownership, forwarding, resolvers, and delegation;
- private service access/endpoints, ingress, and egress controls; and
- flow, firewall, DNS, and connectivity log destinations.

### Security, data, and operations

- audit, configuration, security-event, and asset-inventory destinations;
- KMS key owner, location, policy, rotation, recovery, and destruction controls;
- secret lifecycle;
- storage retention, versioning, backup, recovery, and deletion behavior;
- monitoring, alerting, quotas, service health, support, and incident response; and
- labels, billing allocation, budgets, alerts, and shutdown authority.

## Live-sandbox evidence required

- exact project and nonproduction proof;
- federation and effective IAM permissions;
- enabled APIs and organization-policy result;
- network, DNS, logging, key, and security integration tests;
- product reconciliation and GCP audit records;
- public-exposure, key-creation, prohibited-region, and privilege negative tests;
- observed billing/quota effects;
- deletion, retention, and zero-residual query; and
- named human approval and conditions.

## Decision behavior

- `CONTINUE`: the exact GCP profile and project satisfy the requested gate.
- `CONTINUE_WITH_CONDITIONS`: simulation, discovery, or a narrower isolated project may proceed; unsupported enterprise integration stays blocked.
- `STOP`: project ownership, federation, effective access, network/DNS, audit, encryption, cost, or lifecycle evidence is missing or contradictory.

## Prohibited shortcuts

Do not create service-account keys, reuse one identity for discovery and provisioning, infer Shared VPC or organization-policy readiness from a standalone VPC, treat public-access prevention as the complete data-protection model, or call one network/subnetwork/service-account/bucket set a complete GCP foundation.

## Related requirements

- [Provider-neutral contract](provider-neutral-contract.md)
- [Gate 4 — live sandbox](../readiness-gates/gate-4-live-sandbox.md)
- [Provider and partner boundaries](../responsibility-matrices/provider-partner-boundaries.md)
- [Evidence requirements](../evidence/evidence-requirements.md)

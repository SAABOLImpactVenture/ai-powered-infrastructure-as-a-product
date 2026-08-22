# Cloud foundation environment contract

**Requirement ID:** `BFR-SCH-003`

> **Status:** Architecture target derived from partial POC proof. The product POC owns an executable `platform.example.gov/v1alpha1` `CloudFoundationEnvironment` POC XRD. The example on this page is illustrative, non-executable, and is not that XRD, a Guard V1 schema, or a Forge V1 schema.

## Existing POC contract

The POC contract proves a bounded development request with:

- `aws` or `gcp` implementation selection;
- `standard-dev` profile;
- development environment and internal data classification;
- approved regions;
- owner, cost center, and change ID;
- platform-supplied RFC1918 network/subnet values; and
- product-level status over simulated reconciliation.

The POC intentionally does not guarantee production SLOs, enterprise routing, DNS, inspection, centralized logging, production IPAM, full authorization evidence, disaster recovery, account/project vending, or cross-cloud semantic identity.

## Target contract principle

The durable consumer request should express the product outcome and approved profile. Platform-owned implementation details—provider resources, raw CIDRs, deletion policy, ProviderConfigs, Terraform/TFE constructs, state, and pipelines—stay behind the product boundary.

In the illustrative target below, `CloudFoundationEnvironmentRequest` denotes a desired-state request, while the POC `CloudFoundationEnvironment` is the existing executable proof. The illustrative name neither renames nor supersedes that XRD; any future split between request and realized-environment resources requires a separately reviewed, versioned contract.

## Illustrative product request

**Illustrative, non-executable YAML — not the POC XRD and not a Guard V1 or Forge V1 schema:**

```yaml
apiVersion: iaap.example/v1alpha1
kind: CloudFoundationEnvironmentRequest
metadata:
  id: environment-example-001
  changeRef: change-example-001
spec:
  providerProfileRef: aws-standard-development-example
  environment: development
  dataClassification: internal
  owner: application-team
  costCenter: cost-reference
  serviceProfile: standard-development
  foundationAttachmentRef: approved-foundation-interface
  requestedCapabilities:
    - private-network
    - workload-identity
    - private-object-storage
  decisionRef: decision-example-001
```

## Platform-owned resolution

The provider profile and foundation attachment should resolve:

- exact account, subscription, or project;
- region and availability choices;
- address allocation and subnet design;
- network, DNS, ingress, egress, and connectivity;
- workload identity and permissions;
- logging, monitoring, security events, encryption, keys, and secrets;
- lifecycle, retention, deletion, and recovery behavior;
- tags/labels, budgets, quotas, and allocation; and
- evidence and operational destinations.

These resolved fields belong in controlled implementation/evidence records, not necessarily in the consumer request.

## Contract validation targets

- accept only registered provider and service profiles;
- require ownership, financial, classification, and change metadata;
- prevent consumers from selecting execution engines or lifecycle escape hatches;
- bind the request to a valid BFR decision for the exact stage and target;
- validate provider-profile capability and semantic differences;
- reject production, prohibited data, unsupported regions/services, or expired decisions;
- preserve one authoritative engine per external resource; and
- produce product-level status without hiding provider-specific failure evidence.

## Lifecycle authority

The customer and platform must define create, update, rollback, drift, import, retire, delete, retain, and recover semantics before live use. Consumers may request lifecycle outcomes only where the product explicitly offers them; they must not choose raw managed-resource deletion behavior as an implementation shortcut.

## POC traceability boundary

The credential-free baseline proves simulated product acceptance, reconciliation, negative admission, and teardown for the frozen POC contract. Live AWS/GCP semantic equivalence and the expanded customer foundation attachments on this page remain unproven targets.

## Related requirements

- [Provider-neutral contract](../providers/provider-neutral-contract.md)
- [Gate 2 — simulation](../readiness-gates/gate-2-simulation.md)
- [Gate 4 — live sandbox](../readiness-gates/gate-4-live-sandbox.md)
- [Customer bootstrap profile](customer-bootstrap-profile.md)

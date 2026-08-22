# Azure foundation profile

**Requirement ID:** `BFR-PRV-020`

> **Status:** New architecture target. Azure is absent from the bounded seed/product/integration POC path. Nothing on this page is Azure runtime proof, a supported Forge V1 implementation, or production guidance.

## Profile purpose

Define the evidence and customer decisions required before an Azure implementation may claim conformance with the provider-neutral infrastructure-product contract.

## Required customer decisions

### Tenant, hierarchy, and target

- tenant and management-group ownership;
- exact nonproduction subscription and region scope;
- subscription-vending or externally supplied target boundary;
- policy assignment and exemption ownership;
- resource-provider registration and allowed-service controls; and
- brownfield ownership/import behavior.

### Identity

- workforce federation, privileged access, and emergency-access ownership;
- workload federation or managed-identity pattern;
- separate discovery and provisioning identities;
- role assignments, custom-role ownership, scope, session/revocation behavior, and effective-access proof; and
- consumer-facing workload identity contract.

### Network and DNS

- virtual network and subnet allocation;
- hub/spoke, virtual WAN, routing, peering, hybrid connectivity, and inspection ownership;
- private/public DNS zones, resolvers, forwarding, and delegation;
- private endpoints, public endpoints, ingress, and egress rules; and
- flow, firewall, DNS, and diagnostic log destinations.

### Security, data, and operations

- activity, resource, identity, policy, and security-event destinations;
- key-vault/HSM ownership, key lifecycle, recovery, and deletion controls;
- secret lifecycle and access model;
- storage privacy, encryption, retention, backup, and recovery;
- monitoring, alerts, quotas, service health, support, and incident response; and
- tags, budgets, allocation, alerts, and shutdown authority.

## Validation sequence

Azure must progress through the same gates as any provider:

1. document the profile and ownership;
2. validate a credential-free contract and negative cases;
3. exercise read-only discovery with a revocable identity;
4. execute one approved nonproduction sandbox product;
5. prove auditability, failure handling, deletion, and residual queries; and
6. obtain separate pilot and production consideration decisions.

## Required evidence

- exact tenant, management group, subscription, region, and environment;
- policy and exemption inventory;
- federated or managed identity and effective role assignments;
- network, DNS, endpoint, logging, key, secret, and monitoring interfaces;
- product-level reconciliation and provider audit records;
- negative exposure, privilege, region, and policy tests;
- cost and quota observations;
- lifecycle, deletion, recovery, and residual-resource results; and
- reviewer dispositions and conditions.

## Decision behavior

- `CONTINUE`: the Azure profile is implemented and evidenced for the exact requested stage.
- `CONTINUE_WITH_CONDITIONS`: provider-neutral simulation or narrower discovery may proceed while Azure live support remains disabled.
- `STOP`: documentation alone, a generic Azure diagram, or another provider's evidence is being used as Azure runtime proof.

## Prohibited shortcuts

Do not infer Azure support from AWS/GCP product equivalence, treat a subscription as a complete foundation, use broad owner roles as a bootstrap convenience, allow untracked policy exemptions, or translate provider terminology without testing lifecycle semantics.

## Related requirements

- [Provider-neutral contract](provider-neutral-contract.md)
- [Cloud foundation environment](../schemas/cloud-foundation-environment.md)
- [Gate 3 — discovery](../readiness-gates/gate-3-read-only-discovery.md)
- [Gate 4 — live sandbox](../readiness-gates/gate-4-live-sandbox.md)

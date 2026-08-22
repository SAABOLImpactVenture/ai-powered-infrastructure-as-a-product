# Provider-neutral foundation contract

**Requirement ID:** `BFR-PRV-000`

> **Status:** Architecture target with partial POC proof. The product POC proves one stable AWS/GCP development contract over simulated implementations. It does not prove equivalent live semantics, a complete cloud foundation, Azure, or provider-independent production portability.

## Requirement

The consumer-facing infrastructure-product contract must describe the outcome, ownership, policy, lifecycle, evidence, and service expectations without requiring the consumer to understand a provider resource graph, execution engine, workspace, state backend, or pipeline topology.

Provider-specific implementations remain replaceable only to the extent that their observed outcomes meet the same approved contract. Provider neutrality is an interface discipline, not a claim that clouds are identical.

## Required contract layers

| Layer | Provider-neutral responsibility | Provider-profile responsibility |
|---|---|---|
| Consumer intent | product, environment, classification, owner, cost, service profile | map choices to allowed provider options |
| Foundation attachment | named identity, network, DNS, logging, encryption, evidence interfaces | bind to exact account/subscription/project resources |
| Policy | mandatory outcomes and prohibited states | implement and test provider-specific controls |
| Lifecycle | create, observe, update, retire, delete, recover | translate into safe provider behavior |
| Status | product-level conditions and evidence | normalize provider observations without hiding provider failure |
| Operations | ownership, escalation, support, recovery | integrate native events, quotas, and diagnostics |

## Minimum provider-profile interface

Every provider profile must declare:

- organization/resource-hierarchy boundary;
- approved environments and regions;
- workforce and workload identity integration;
- execution identity and effective permissions;
- network, DNS, ingress, egress, and connectivity attachment points;
- logging, monitoring, and security-event destinations;
- encryption, key, and secret interfaces;
- allowed services, policies, quotas, and prohibited configurations;
- metadata, ownership, budget, and allocation rules;
- lifecycle, import/brownfield, deletion, and recovery behavior;
- evidence sources, normalization, retention, and export; and
- provider, customer, partner, and IaaP responsibilities.

## Non-co-management rule

One authoritative engine owns each external resource. A resource may be:

- reconciled by an approved Crossplane provider;
- managed by Terraform/OpenTofu, HCP Terraform, TFE, or another approved adapter;
- managed directly by a provider-native mechanism; or
- observed as an external dependency.

It must not be actively managed by multiple engines. Changing engines requires an explicit ownership-transfer plan and evidence.

## Semantic-equivalence rule

Two provider implementations satisfy the same product contract only when the required outcome and lifecycle semantics are tested. Matching names such as “network,” “identity,” or “private storage” are insufficient.

The assessment must record provider differences in:

- isolation and hierarchy;
- identity and trust;
- routing and DNS;
- encryption and key behavior;
- audit coverage;
- service availability and quotas;
- deletion and retention semantics;
- recovery and failure modes; and
- cost model.

## Decision behavior

- `CONTINUE`: one exact provider profile satisfies the requested gate and contract.
- `CONTINUE_WITH_CONDITIONS`: a narrower provider profile or simulated implementation may proceed with visible gaps; unsupported semantics remain blocked.
- `STOP`: the profile cannot meet a mandatory outcome, ownership is ambiguous, or evidence normalizes away a material provider difference.

## POC traceability boundary

The POC `CloudFoundationEnvironment` demonstrates AWS/GCP contract selection, owner/cost/change metadata, RFC1918 CIDR validation, and simulated reconciliation. It explicitly excludes enterprise DNS, routing, centralized logging, disaster recovery, project/account vending, production SLOs, and live provider validation. See the [reference evidence map](../evidence/reference-evidence-map.md).

## Related requirements

- [AWS foundation profile](aws-foundation-profile.md)
- [Azure foundation profile](azure-foundation-profile.md)
- [GCP foundation profile](gcp-foundation-profile.md)
- [Provider and partner boundaries](../responsibility-matrices/provider-partner-boundaries.md)
- [Cloud foundation environment](../schemas/cloud-foundation-environment.md)

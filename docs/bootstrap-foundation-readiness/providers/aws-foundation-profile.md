# AWS foundation profile

**Requirement ID:** `BFR-PRV-010`

> **Status:** Architecture target with partial POC design evidence. The product POC contains an AWS development live-composition template, but no AWS resources, ProviderConfig, workload identity, or live teardown were validated.

## Profile purpose

Bind the provider-neutral contract to one exact, customer-approved AWS nonproduction target while making inherited foundation dependencies and customer decisions explicit.

## Existing POC evidence

The bounded POC includes templates for:

- one VPC and private subnet;
- one IAM role whose trust policy intentionally denies assumption until its trust relationship is explicitly reviewed and approved;
- one S3 bucket plus public-access blocking;
- ownership and cost metadata;
- approved development regions; and
- namespaced ProviderConfig guidance that prohibits committed static cloud keys.

This is useful contract and safety-scaffold evidence. It is not a working workload identity, enterprise network, KMS design, logging integration, account vending system, or live AWS proof.

## Customer decisions required

### Organization and target

- organization and organizational-unit ownership;
- exact sandbox account, environment, and approved regions;
- account-vending or externally supplied account boundary;
- service-control and regional restrictions; and
- ownership-transfer/import rules for brownfield resources.

### Identity

- workforce federation and privileged-role ownership;
- execution role issuer, subject, audience, trust conditions, session limits, and revocation;
- separate discovery and provisioning roles;
- permissions boundary and effective-permission test; and
- workload identity contract delivered to product consumers.

### Network and DNS

- VPC and subnet allocation from approved IPAM or equivalent process;
- route, transit, on-premises, inspection, endpoint, and firewall ownership;
- public/private hosted-zone ownership, resolver paths, forwarding, and delegation;
- ingress and egress control points; and
- network and DNS logging destinations.

### Security, data, and operations

- audit and configuration-log destinations and delegated readers;
- security-event aggregation and incident owner;
- KMS key owner, policies, rotation, recovery, and deletion controls;
- secret stores and consumers;
- storage retention, versioning, backup, and recovery requirements;
- monitoring, quotas, service health, support, and escalation; and
- tags, budget, allocation, alert, and shutdown authority.

## Live-sandbox evidence required

- target account and nonproduction proof;
- execution role trust and effective permissions;
- provider runtime identity separate from package-pull identity;
- service/policy allowlist result;
- network, DNS, log, key, and security integration tests;
- product reconciliation and AWS audit events;
- public-exposure and prohibited-region negative tests;
- observed cost and quota effects;
- deletion/retention behavior and zero-residual query; and
- named human approval and conditions.

## Decision behavior

- `CONTINUE`: the exact AWS profile and target satisfy the requested gate.
- `CONTINUE_WITH_CONDITIONS`: simulation, discovery, or a narrower isolated AWS sandbox may proceed while enterprise integrations remain blocked.
- `STOP`: account, role trust, effective permission, network/DNS ownership, audit, encryption, cost, or lifecycle evidence is absent or exceeds scope.

## Prohibited shortcuts

Do not replace the deny-all role trust placeholder with broad principals, use access keys when approved federation is available, reuse an administrator role for discovery and execution, create unowned DNS or routes, rely on default encryption as customer KMS approval, or call a VPC/subnet pair a complete AWS foundation.

## Related requirements

- [Provider-neutral contract](provider-neutral-contract.md)
- [Gate 4 — live sandbox](../readiness-gates/gate-4-live-sandbox.md)
- [Provider and partner boundaries](../responsibility-matrices/provider-partner-boundaries.md)
- [Evidence requirements](../evidence/evidence-requirements.md)

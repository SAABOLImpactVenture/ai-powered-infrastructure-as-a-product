# Resource hierarchy

**Requirement ID:** `BFR-HIE-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It does not change any frozen product schema or assert that current Guard or Forge V1 inspects or vends cloud hierarchy.

## Requirement

The customer must define how organizations, management groups or folders, accounts/subscriptions/projects, environments, regions, and resource containers separate ownership, policy, billing, data, and lifecycle boundaries.

## Why this requirement exists

Resource hierarchy is the inheritance spine for identity, policy, logging, networking, quotas, and cost. Provisioning into an ambiguous parent can place a product under the wrong controls, expose it to unintended administrators, or make clean retirement impossible.

## Applicability

- **Assessment:** current and intended hierarchy must be documented.
- **Simulation:** target selection and inheritance are modeled without creating resources.
- **Read-only discovery:** hierarchy and effective policy are verified.
- **Live sandbox:** one approved nonproduction target and parent chain are required.
- **Pilot/production consideration:** vending, lifecycle, scale, and exception behavior must be governed.

## Customer decisions

The customer must decide:

- authoritative organization/tenant boundaries and ownership;
- hierarchy pattern for platform, shared services, workloads, data classifications, and environments;
- account/subscription/project vending and retirement authority;
- where policy, identity, networking, logging, quotas, and billing inherit;
- naming, metadata, region, and environment conventions;
- treatment of acquisitions, external partners, sandboxes, and exceptions; and
- how moved or orphaned resources are detected and reconciled.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Current hierarchy, owners, intended boundaries, and known inheritance gaps are recorded. |
| Simulation | Proposed targets and effective-control expectations are represented deterministically. |
| Read-only discovery | Parent chains, policies, administrators, billing linkage, and region controls are verified. |
| Live sandbox | Dedicated nonproduction target exists with approved parent, ownership, policy, logging, and cost attachment. |
| Pilot | Vending/retirement, quota, movement, and exception paths are exercised. |
| Production consideration | Enterprise hierarchy and inheritance are formally accepted and continuously governed. |

## Composite AI assistance

Composite AI may normalize provider-specific hierarchies, compare current state with approved patterns, identify ambiguous inheritance, and propose alternative target placements with stated tradeoffs.

It must not create or move hierarchy nodes, choose the authoritative tenant, override inherited policy, infer ownership from naming, or recommend consolidation without evidence of legal and operational boundaries.

## Deterministic validation target

A future validator should check exact parent identifiers, environment and classification alignment, required inherited controls, owner/cost metadata, approved regions, vending/retirement references, and absence of unmanaged roots. Provider-specific discovery should compare effective—not merely declared—policy. This is a proposed target only.

## Human approval

Cloud governance and platform owners approve the hierarchy pattern. Security, networking, finance, data, and operations owners approve relevant inheritance. Creating or moving a live target requires the designated cloud authority.

## Required evidence

- hierarchy diagram and machine-readable inventory;
- parent/child ownership and administration matrix;
- effective policy and identity inheritance evidence;
- billing and cost-center attachment;
- environment/classification/region rules;
- vending, movement, quarantine, and retirement procedures; and
- orphan or drift detection results.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: the requested stage has an exact, approved target with understood inheritance and ownership.
- `CONTINUE_WITH_CONDITIONS`: assessment or simulation may proceed while live use is limited to an isolated approved target and enterprise hierarchy gaps remain tracked.
- `STOP`: target parentage, tenant authority, inherited controls, billing, or lifecycle ownership is unknown or incompatible.

## Forge handoff

Forge receives a provider-neutral target profile referencing the approved account/subscription/project and logical environment. Hierarchy creation or movement remains a separately governed product capability; consumers do not choose raw parent identifiers unless the product contract intentionally exposes an approved selection.

## Exceptions and prohibited shortcuts

Exceptions must record the affected inheritance, compensating controls, owner, expiry, and migration plan. Never provision into a personal subscription/project, bypass enterprise parents, use naming as proof of environment, create unmanaged “temporary” accounts, or rely on declared policy without checking effective inheritance.

## Related requirements

- [`BFR-GOV-001` Governance and ownership](governance-and-ownership.md)
- [`BFR-IAM-001` Identity and access](identity-and-access.md)
- [`BFR-FIN-001` Cost ownership and FinOps](cost-ownership-and-finops.md)
- [`BFR-DAT-001` Data classification](data-classification.md)

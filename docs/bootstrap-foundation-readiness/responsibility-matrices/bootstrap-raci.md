# Bootstrap RACI

**Requirement ID:** `BFR-RSP-001`

> **Status:** Architecture target. The POCs require selected metadata and human approval boundaries but do not implement this customer organizational RACI. Customers must replace role labels with named people or governed groups.

## Purpose

Prevent the technical implementation team, cloud provider, partner, Composite AI, Guard, or Forge from silently inheriting customer sponsorship, evidence ownership, operations, or risk authority.

## RACI legend

- **A — Accountable:** owns the decision and outcome; exactly one accountable role is preferred.
- **R — Responsible:** performs or coordinates the work.
- **C — Consulted:** provides required domain input before completion.
- **I — Informed:** receives the result.

One person may fill multiple customer roles only when policy allows it and separation-of-duties risk is recorded.

## Default bootstrap matrix

| Activity | Sponsor | Platform owner | Security/architecture | Data/evidence owner | Operations owner | Financial owner | IaaP/partner team |
|---|---|---|---|---|---|---|---|
| Define outcome and scope | A | R | C | C | I | I | C |
| Approve source and data handling | I | C | C | A/R | I | I | C |
| Design bootstrap runtime | I | A/R | C | C | C | C | R |
| Approve workforce/workload identity | I | R | A | I | C | I | C |
| Configure hosting/network boundary | I | A | C | I | R | I | R |
| Define evidence retention/export | I | C | C | A | R | I | C |
| Approve Composite AI boundary | I | C | C | A | C | I | R |
| Operate and patch bootstrap | I | A | C | I | R | I | C/R |
| Set budget and shutdown limits | I | R | I | I | C | A | C |
| Assess foundation readiness | I | A | C | C | C | C | R |
| Approve discovery scope | I | R | A | C | C | I | C |
| Approve live sandbox run | I | A | C | C | C | C | R |
| Accept residual risk | I | C | C | C | C | C | customer risk authority only |
| Authorize pilot | A | R | C | C | C | C | C |
| Authorize production | customer-defined authorization authority | C | C | C | C | C | I |

## Product/system authority

The organizational RACI does not grant software authority:

| Component | Bounded role | Never accountable for |
|---|---|---|
| IaaP Console | surface onboarding, findings, decisions, evidence, and lifecycle status | customer risk or product execution |
| IaaP Guard | evaluate its frozen contracts and preserve assessment evidence | provisioning or customer authorization |
| Composite AI | interpret, propose, explain, and assemble evidence | approval, risk acceptance, or execution |
| Deterministic policy | validate explicit rules | organizational intent or exceptions |
| IaaP Forge | manage approved product lifecycle within its frozen boundary | inventing approval or owning customer foundation operations |
| Execution adapter | reconcile an authorized product revision | defining outcome or accepting risk |

This table documents target relationships and does not modify frozen Guard V1 or Forge V1.

## Required evidence

- named person/group for every applicable accountable and responsible role;
- organizational authority or delegation reference;
- conflict/separation-of-duties review;
- backup/deputy and escalation path;
- effective and review dates;
- acknowledgement of support, evidence, and cost obligations; and
- updated assignments after organization or vendor change.

## Decision behavior

- `CONTINUE`: applicable roles are named, authorized, and acknowledge their responsibilities.
- `CONTINUE_WITH_CONDITIONS`: non-mutating work may proceed while a noncritical consulted role is filled by a due date.
- `STOP`: sponsor, platform, security, data/evidence, operations, financial, or risk accountability required for the stage is missing or assigned to AI/software by default.

## Related requirements

- [Foundation domain owners](foundation-domain-owners.md)
- [Provider and partner boundaries](provider-partner-boundaries.md)
- [Human review and risk acceptance](../decisions/human-review-and-risk-acceptance.md)
- [Customer bootstrap profile](../schemas/customer-bootstrap-profile.md)

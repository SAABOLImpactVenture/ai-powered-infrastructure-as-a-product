# Gate 4 — live nonproduction sandbox

**Requirement ID:** `BFR-GATE-004`

> **Status:** Partially designed, not live-cloud proven. The product POC contains manual AWS and GCP live-sandbox templates and workload-identity guidance, but its validation record confirms that no AWS/GCP resource creation, ProviderConfig validation, workload-identity validation, or live teardown was executed.

## Gate objective

Authorize and prove one exact, bounded, nonproduction infrastructure-product lifecycle against a real cloud target using workload identity, deterministic controls, named human approval, complete evidence, and verified teardown.

## Entry criteria

- Gates 0 through 3 have applicable decisions.
- [Live provisioning prerequisites](../prerequisites/provisioning-prerequisites.md) are satisfied.
- The product contract and implementation revision are immutable.
- The target is a named sandbox account, subscription, or project with no production trust.
- The execution identity is least-privileged, short-lived or federated, and separate from discovery.
- Network, DNS, logging, security-event, encryption, secret, cost, and operations dependencies have named owners.
- Change, rollback, teardown, residual-query, and evidence plans are approved.

## Required execution sequence

1. Revalidate target, identity, product revision, conditions, and approval window.
2. Run deterministic preflight with no writes on failure.
3. Record the approved desired-state digest.
4. Reconcile only through the authorized product-control-plane path.
5. Capture cloud audit, control-plane, policy, cost, and product-status evidence.
6. Exercise expected update or failure behavior without expanding scope.
7. Tear down through the approved lifecycle path.
8. Query for residual resources and reconcile evidence before closing the run.

## POC-derived constraints

The existing live composition is a safe development scaffold, not a ready enterprise profile:

- its AWS role uses a deny-all trust placeholder;
- its GCP service account has no demonstrated federation binding;
- its network resources do not establish enterprise routing, DNS, inspection, or hybrid connectivity;
- encryption relies on provider behavior rather than a customer KMS contract; and
- live cloud execution and deletion were not validated.

Those limitations must be resolved or explicitly bounded before `CONTINUE`.

## Required exit evidence

- exact target and nonproduction proof;
- approved workload-identity and effective-permission record;
- preflight, human approval, desired-state digest, and execution identity;
- cloud and control-plane reconciliation results;
- network, DNS, logging, security, encryption, and cost observations;
- negative/denial test results;
- update, rollback, failure, and recovery observations appropriate to scope;
- teardown events and zero-residual query; and
- exceptions, conditions, incidents, and reviewer disposition.

## Exit decision

- `CONTINUE`: the sandbox proof is complete enough to consider a separately scoped pilot.
- `CONTINUE_WITH_CONDITIONS`: additional sandbox iterations may proceed within explicit limits; pilot remains blocked.
- `STOP`: identity, target, approval, evidence, lifecycle safety, cost control, or teardown is missing or fails.

## Related requirements

- [AWS profile](../providers/aws-foundation-profile.md)
- [GCP profile](../providers/gcp-foundation-profile.md)
- [Azure profile](../providers/azure-foundation-profile.md)
- [Gate 5 — pilot](gate-5-pilot.md)
- [Human review and risk acceptance](../decisions/human-review-and-risk-acceptance.md)

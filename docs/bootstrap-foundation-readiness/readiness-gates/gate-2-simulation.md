# Gate 2 — credential-free simulation

**Requirement ID:** `BFR-GATE-002`

> **Status:** Partially proven. The credential-free POC baseline proves a narrow Crossplane, policy, Composite AI, simulated-product, evidence, and teardown path. This gate extends that proof into a customer-readiness target; it does not claim live cloud or current Forge V1 provisioning.

## Gate objective

Prove the product contract, deterministic controls, authority separation, lifecycle behavior, evidence chain, and failure handling without cloud-provider credentials or external-resource mutation.

## Entry criteria

- Gate 1 identifies the exact product and foundation capabilities to simulate.
- Inputs are synthetic, sanitized, or explicitly approved.
- The bootstrap runtime is nonproduction and bounded.
- Product and policy revisions are immutable for the test.
- Composite AI remains proposal-only.
- No cloud ProviderConfig, static cloud key, or production target is present.

## Required scenarios

At minimum, simulation should cover:

- valid product requests for every supported provider profile;
- missing metadata and unsupported choices;
- production and prohibited-data requests;
- policy and schema failures;
- AI prompt-injection and authority-expansion attempts;
- reconciliation to a product-level ready state;
- update and drift behavior where simulated faithfully;
- failed dependency and not-ready diagnostics;
- deletion, teardown, and orphan detection; and
- evidence validation against the required schema.

## Passing boundary

A passing simulation proves only the bounded contract and control behavior represented by its fixtures. It does not prove:

- live provider permissions or API behavior;
- enterprise DNS, routing, logging, encryption, or identity integration;
- actual human approval;
- a live model adapter;
- performance, availability, recovery, or production operations; or
- consumer adoption or satisfaction.

## Required exit evidence

| Evidence | Expected result |
|---|---|
| Immutable source set | exact product, policy, test, and runtime revisions |
| Positive cases | accepted and reconciled as designed |
| Negative cases | fail closed for the expected reason |
| AI authority test | no apply, approve, merge, credential, or admin authority |
| Reconciliation evidence | status and component outcomes recorded |
| Teardown evidence | expected simulated resources removed; residual query passes |
| Scorecard | every required control evaluated; no missing result hidden |

## Exit decision

- `CONTINUE`: the approved simulated scope passes and may move to separately authorized discovery.
- `CONTINUE_WITH_CONDITIONS`: simulation may continue, but discovery or live provisioning remains disabled until named gaps are closed.
- `STOP`: contract drift, unsafe authority, ambiguous failure evidence, or incomplete teardown invalidates the proof.

## Existing POC proof

The [credential-free multi-cloud foundation baseline](../../poc-baselines/2026-08-07-credential-free-multicloud-foundation.md) records a 100/100 Kubernetes 1.34, 1.35, and 1.36 matrix for the frozen baseline. The [Backstage runtime-proven baseline](../../poc-baselines/2026-08-07-backstage-runtime-proven-v5.md) adds a separately linked dry-run storefront proof. Both explicitly exclude live AWS/GCP, actual human approval, a live model, production authorization, and recovery claims.

## Related requirements

- [Gate 3 — read-only discovery](gate-3-read-only-discovery.md)
- [Evidence integrity](../evidence/evidence-integrity.md)
- [Cloud foundation environment](../schemas/cloud-foundation-environment.md)
- [Composite AI authority](../composite-ai/authority-provenance-and-human-review.md)

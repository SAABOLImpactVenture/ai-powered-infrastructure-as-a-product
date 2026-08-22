# Customer bootstrap profile

**Requirement ID:** `BFR-SCH-001`

> **Status:** New architecture target. No `CustomerBootstrapProfile` exists in the four POC repositories. The example below is illustrative, non-executable, and is not a Guard V1 schema, Forge V1 schema, Kubernetes CRD, or supported API.

## Purpose

Represent the customer's approved bootstrap boundary in a versioned, reviewable record that can drive documentation, future deterministic preflight, and Console guidance without carrying credentials or granting authority.

## Required sections

| Section | Purpose |
|---|---|
| Identity | record/profile revision and customer scope |
| Requested stage | constrain the activity being evaluated |
| Ownership | name accountable domain roles |
| Runtime | describe nonproduction hosting and operations boundary |
| Evidence | classification, storage, retention, export, and integrity |
| Composite AI | approved inputs, model boundary, proposal-only authority |
| Discovery | exact read-only scope or explicit disabled state |
| Provisioning | exact live target or explicit disabled state |
| Decisions | reference approvals, conditions, exceptions, and expiry |
| Prohibitions | machine-visible authority that must remain absent |

## Illustrative profile

**Illustrative, non-executable YAML — not a Guard V1 or Forge V1 schema:**

```yaml
apiVersion: iaap.example/v1alpha1
kind: CustomerBootstrapProfile
metadata:
  id: bootstrap-example-001
  revision: example-r1
spec:
  deploymentMode: customer-hosted
  requestedStage: assessment
  scopeRef: scope-example-001
  environments:
    - nonproduction
  ownership:
    sponsor: role-reference-required
    platformOwner: role-reference-required
    securityOwner: role-reference-required
    evidenceOwner: role-reference-required
    operationsOwner: role-reference-required
  runtime:
    hostingBoundary: customer-defined
    operator: role-reference-required
    networkPolicyEvidence: required-before-shared-use
    packagePolicy: pinned-and-approved
  identity:
    workforceProvider: customer-defined
    workloadFederationRequired: true
    staticCloudKeysAllowed: false
  repositories:
    accessMode: read-only
    allowlist: []
  evidence:
    classification: customer-defined
    retentionClass: customer-defined
    exportPolicy: customer-defined
    integrityPolicy: customer-defined
  compositeAI:
    mode: advisory-proposal-only
    approvedInputClasses: []
    directExecutionAllowed: false
    approvalAuthorityAllowed: false
    credentialAccessAllowed: false
  cloudDiscovery:
    enabled: false
    scopeRefs: []
  cloudProvisioning:
    enabled: false
    targetRefs: []
  decisionRefs: []
  prohibitedAuthorities:
    - approve
    - accept-risk
    - merge
    - apply
    - grant-privilege
```

## Validation targets

A future deterministic validator should:

- require a unique ID, revision, scope, requested stage, and named owners;
- allow only nonproduction bootstrap environments in the public reference profile;
- require customer control of identity, evidence, and operations;
- require explicit data classification, retention, export, and integrity policies;
- reject static cloud keys, AI execution/approval authority, and unknown stages;
- require discovery and provisioning to default to disabled;
- require exact scope, identity, approvals, and expiry before either is enabled;
- prevent a later-stage flag from bypassing its prerequisite gate; and
- retain prior revisions and supersession relationships.

## Credential boundary

The profile contains references to identities, secret stores, targets, and evidence—not secret values, kubeconfigs, access keys, tokens, passwords, private keys, or provider credentials.

The bounded seed POC accepts a separately supplied bootstrap identity path and
prefers workload federation when the provider boundary is known. That POC
behavior must not be confused with a customer production identity design or
with permission to place credentials in this proposed profile.

## Decision behavior

- `CONTINUE`: the profile is complete for the requested stage and matches its evidence.
- `CONTINUE_WITH_CONDITIONS`: a narrower profile revision may proceed while named fields remain blocked.
- `STOP`: ownership, handling, identity, runtime, or authority declarations are unsafe, missing, or contradictory.

## Related requirements

- [Bootstrap runtime prerequisites](../prerequisites/bootstrap-runtime-prerequisites.md)
- [Bootstrap RACI](../responsibility-matrices/bootstrap-raci.md)
- [Foundation readiness assessment](foundation-readiness-assessment.md)
- [Evidence requirements](../evidence/evidence-requirements.md)

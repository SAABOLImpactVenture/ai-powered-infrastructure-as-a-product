# Evidence integrity

**Requirement ID:** `BFR-EVD-020`

> **Status:** Architecture target with partial POC proof. POC repositories use SHA-256 manifests and the Composite AI POC hashes normalized, redacted inputs and outputs. Those hashes are not signed provenance, durable immutability, or proof of who produced the evidence.

## Requirement

Evidence must make unauthorized change detectable, bind results to the source and execution context, preserve producer identity where required, and remain interpretable after tools or hosted artifacts expire.

## Integrity layers

| Layer | Purpose | Minimum control |
|---|---|---|
| Content identity | detect byte or canonical-content change | documented digest algorithm and canonicalization |
| Source lineage | bind evidence to exact inputs | source revisions, target identity, collection time |
| Producer authenticity | identify who or what issued the record | authenticated identity and, when required, signature/attestation |
| Workflow integrity | prove required steps and authority separation | protected workflow, approvals, immutable dependencies |
| Storage protection | prevent or expose alteration/deletion | access controls, versioning, retention lock where required |
| Verification | ensure the record remains usable | schema, digest, signature, and relationship checks |

## Digest limitations

A SHA-256 digest can show that content differs from a previously known value. It does not by itself prove:

- who created the content;
- that the original value was trustworthy;
- that an actor did not replace both content and digest;
- that the producer or build environment was uncompromised;
- that evidence was retained durably; or
- that the evidence supports a broader claim than its recorded scope.

Do not use `immutable` when the actual control is only `hashed`. Prefer `integrity-digested`, `versioned`, `signed`, `attested`, or `retention-locked` according to the observed control.

## Required integrity metadata

- digest algorithm and value;
- canonicalization or byte-preservation method;
- source and producer identities;
- tool, model adapter, policy, product, and workflow revisions;
- execution environment and dependency identities appropriate to risk;
- collection and verification timestamps;
- signature or attestation identity when required;
- storage version and retention state; and
- verification result and verifier version.

## Supply-chain requirement

For evidence supporting live or later-stage decisions, source commit locks are insufficient by themselves. The evidence should identify and protect:

- CI actions and reusable workflows;
- runtime, package, container, and binary versions or digests;
- downloaded artifacts and verification source;
- policy and schema versions;
- model and adapter versions where AI contributes; and
- the identity authorized to publish or execute.

## POC proof boundary

The credential-free baselines preserve exact source lineage, artifact digests, package pinning, active network-policy results, and redacted AI evidence. The public baseline records also state that hosted artifacts are retention-bound and broader signed provenance is incomplete. These controls support bounded reproducibility; they do not establish an immutable enterprise evidence service.

See the [reference evidence map](reference-evidence-map.md) and the [credential-free baseline](../../poc-baselines/2026-08-07-credential-free-multicloud-foundation.md).

## Deterministic validation target

A future verifier should fail closed on digest mismatch, unknown canonicalization, missing source revision, expired or invalid signature, untrusted producer, mutable dependency reference where immutability is required, missing retention state, or a claim whose scope exceeds the evidence envelope.

## Composite AI boundary

Composite AI may assemble references and explain verification results. It must not mint trust, sign on behalf of a human authority, suppress verification failure, or call self-generated content immutable.

## Related requirements

- [Evidence requirements](evidence-requirements.md)
- [Retention, traceability, and export](retention-traceability-and-export.md)
- [Authority, provenance, and human review](../composite-ai/authority-provenance-and-human-review.md)
- [Reference evidence map](reference-evidence-map.md)

# Evidence retention, traceability, and export

**Requirement ID:** `BFR-EVD-030`

> **Status:** Architecture target. Existing POC artifacts and public baseline manifests preserve useful identities and digests, but hosted evidence is retention-bound and no complete customer retention, legal hold, export, deletion, or restoration service is proven.

## Requirement

The customer must define how readiness evidence is classified, retained, located, exported, superseded, placed on hold, verified, restored, and disposed of without losing the relationships needed to reconstruct a decision.

## Retention classes

The customer should classify at least:

- intake and assessment sources;
- AI prompts/inputs, proposals, and provenance;
- deterministic validation and negative-test results;
- human approvals, rejections, and risk acceptances;
- cloud discovery and execution audit evidence;
- operational, incident, recovery, cost, and retirement records;
- exceptions and expiration history; and
- exports and verification receipts.

Each class needs an owner, classification, minimum/maximum duration, deletion rule, legal-hold behavior, storage protection, and authorized audiences.

## Traceability requirements

Traceability must support both directions:

- from a requirement or decision to every supporting and contradictory source; and
- from a source, change, incident, or expired exception to every affected decision and product instance.

Supersession must preserve history. A corrected record links to the prior record; it does not overwrite the fact that the prior record informed an earlier decision.

## Export package

An export should include:

- export manifest, schema version, scope, requestor, and creation time;
- evidence objects and relationship index;
- source references and revisions permitted for export;
- redaction and omission report;
- decisions, conditions, exceptions, and expirations;
- digests, signatures/attestations where present, and verification instructions;
- retention and legal-hold metadata permitted for disclosure; and
- plain-language scope limitations.

**Illustrative, non-executable example — not a Guard V1 or Forge V1 schema:**

```yaml
kind: FoundationEvidenceExport
status: assembled
scopeRef: scope-example-001
schemaVersion: illustrative-v1
createdAt: YYYY-MM-DDTHH:MM:SSZ
evidenceRefs: []
relationshipIndex: []
redactions: []
omissions: []
integrity:
  algorithm: sha256
  manifestDigest: example-only
limitations:
  - not-a-production-authorization
```

## Export controls

- Re-evaluate classification and audience at export time.
- Minimize secrets, personal data, topology details, and proprietary implementation content.
- Record omitted and redacted items so absence is not mistaken for completeness.
- Do not export model credentials, hidden platform secrets, or unrestricted raw logs.
- Verify the package after transfer.
- Preserve who exported, who received, and what policy authorized the transfer.

## Deletion and restoration

Deletion must distinguish an expired hosted artifact from deliberate disposition. Restoration tests must verify that evidence, indexes, relationships, integrity metadata, and access controls recover together. A digest without recoverable bytes is an identity record, not retained evidence.

## POC traceability boundary

The public POC baselines record artifact identities and digests even after hosted downloads expire. That is useful lineage, but it does not provide durable evidence bytes, legal hold, customer export, or restoration. Those capabilities remain architecture targets.

## Related requirements

- [Evidence requirements](evidence-requirements.md)
- [Evidence integrity](evidence-integrity.md)
- [Reference evidence map](reference-evidence-map.md)
- [Exceptions and expiration](../decisions/exceptions-and-expiration.md)

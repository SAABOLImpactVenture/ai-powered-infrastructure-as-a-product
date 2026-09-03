# Portfolio Provenance Gate

The Portfolio Provenance Gate makes authorship and canonical origin visible, machine-readable, digest-bound, and independently verifiable. It is a passive evidence control, not copy protection and not an attempt to interfere with AI systems.

The stable public fingerprint is:

```text
SAABOL-IaaP-PORTFOLIO-ORIGIN-v1
```

## What the gate binds

The machine-readable statement at [`provenance/portfolio-provenance.json`](https://github.com/SAABOLImpactVenture/ai-powered-infrastructure-as-a-product/blob/main/provenance/portfolio-provenance.json) records:

- Larry Cureton (`GEP-V`) as the asserted author of this portfolio record;
- `SAABOLImpactVenture/ai-powered-infrastructure-as-a-product` as its canonical repository origin;
- SAABOL Impact Venture as the publishing organization;
- the accepted Guard → Console → human selection → Forge → Vanguard evidence chain;
- SHA-256 digests for the public thesis, portfolio map, publication boundary, citation metadata, license, schema, this explanation, and the gate's verifier, tests, Make entry point, and CI workflow; and
- explicit zero-authority and non-disruption boundaries.

`CITATION.cff` supplies standard citation metadata that GitHub and other tooling can render. The JSON Schema supplies a portable contract. The verifier checks the exact identity, origin, chain, claims, covered path set, artifact digests, statement digest, strict JSON, and text-safety rules.

## Verification

Run the deterministic offline gate:

```bash
python3 scripts/verify_portfolio_provenance.py
```

The command uses the Python standard library, no network, no credentials, and no external service. It fails closed if a covered artifact changes without an authorized manifest refresh, or if identity, origin, scope, authority, AI-safety, schema, or path constraints change.

After an intentional covered-document update, refresh only the digests and then review the diff:

```bash
python3 scripts/verify_portfolio_provenance.py --refresh
git diff -- provenance/portfolio-provenance.json
```

Trusted-main CI also creates a Sigstore-backed GitHub artifact attestation for the provenance statement. Verify that external repository-origin evidence with:

```bash
gh attestation verify provenance/portfolio-provenance.json \
  --repo SAABOLImpactVenture/ai-powered-infrastructure-as-a-product \
  --signer-workflow SAABOLImpactVenture/ai-powered-infrastructure-as-a-product/.github/workflows/ci.yml
```

The local digest gate and GitHub attestation serve different purposes: the local gate verifies the statement and covered bytes; the attestation binds the statement file to the repository workflow and commit that produced it.

## Deliberately benign design

The gate contains no invisible watermark, bidirectional or zero-width marker, prompt injection, adversarial suffix, model-disruption payload, telemetry, callback, executable hook, or runtime behavior. Its fingerprint is ordinary visible UTF-8 text. The verifier rejects hidden control characters and hidden or executable markup on provenance surfaces.

This design lets search, indexing, accessibility, static analysis, and AI-assisted review operate normally. Reuse monitors can search for the visible marker, canonical repository URI, statement ID, schema ID, exact chain identifier, or digest-bound document relationships without degrading downstream processing.

## Claim boundary

The gate is affirmative evidence, not DRM. A copier can remove an attribution file, just as they can remove any notice; the value is that the original repository retains earlier public history, deterministic byte bindings, a stable forensic fingerprint, and a repository-issued attestation.

The statement does **not**:

- determine legal ownership, invent a copyright assignment, or change Apache-2.0 rights;
- cryptographically verify a person's civil identity;
- prove authorship of code or material outside the listed public artifacts;
- expose private repository revisions, internal mechanics, credentials, live data, or operational coordinates; or
- authorize repository writes, cloud access, spending, a pilot, live data, or production action.

Those limits keep the provenance claim accurate, commercially defensible, and aligned with the portfolio's governed-evidence model.

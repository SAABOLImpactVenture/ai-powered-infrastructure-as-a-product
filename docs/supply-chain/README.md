# Supply Chain — SLSA + Cosign

This repo now:
- Builds and pushes **8 distroless images** (multi-arch) to GHCR.
- **Signs** each image via **cosign keyless (OIDC)**.
- Generates **SLSA provenance** (asset attached to the workflow run).
- Verifies signatures in a **PR gate** (`cosign-verify-gate`).

## Notes
- Ensure your repo visibility and GHCR permissions allow package writes.
- Cosign verification can be constrained with `--certificate-oidc-issuer` and `--certificate-identity-regexp` for stricter identity.

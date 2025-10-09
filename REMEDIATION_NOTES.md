# Remediation Notes
## Summary
- Replaced contract schemas containing placeholders with full JSON Schemas (evidence, product, policy-pack, catalog).
- Consolidated `example/` into `examples/` and updated internal references.
- Removed/rewrote 'mock' content and all references to `null_resource` / `local-exec` in examples.
- Replaced placeholder product definitions under `contracts/examples/` and `examples/` with real product JSON.
## Suggested deletions (perform in git):
- Remove the `example/` directory (content has been migrated to `examples/`).
- Remove any legacy `null_evidence` modules if still present, or promote to real modules under `platform/<cloud>/...`.
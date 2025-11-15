# cATO Evidence Bundle (Agents/MCP)

Store cryptographic and procedural evidence supporting continuous ATO.

## Contents
- `prompts/`: signed system prompt templates + signatures.
- `sbom/`: per-tool SBOM artifacts for the MCP servers used.
- `cosign/`: verification logs (image digests, transparency entries).
- `policy/`: OPA decisions (allow/deny + inputs), versioned.
- `egress/`: proxy policy snapshots and host allowlists.
- `evals/`: CI run outputs for injection/exfil/abuse tests.

## Requirements
- Evidence must accompany each tagged release.
- Do not store raw secrets. Redact in place with `<REDACTED:TYPE>`.

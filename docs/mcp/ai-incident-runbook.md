# AI Incident Runbook (Agents/MCP)

## Triggers
- `secretDetectorHit=true` on output.
- Tool call with **danger verb** without approval.
- Egress to non-allowlisted host.
- Unknown/unregistered tool ID at runtime.
- Injection signals (classifier/high-risk pattern) preceding a tool call.

## Immediate Actions (within 15 minutes)
1. **Kill-Switch:** Set OPA override `deny_all=true` for agent tool calls.
2. **Credential Hygiene:** Revoke JIT elevations; rotate affected SP secrets; purge caches.
3. **Containment:** Quarantine vector index segments by content IDs in the last session.
4. **Network:** Block tool FQDNs at proxy policy; freeze deployments of implicated MCP images.
5. **Preservation:** Snapshot dual logs (prompt/context diff/tool I/O), signed prompt hash, SBOM and image digest.

## Triage (within 60 minutes)
- Determine data classes impacted (Public/Internal/Sensitive).
- Confirm whether exfil reached external hosts.
- Identify tool scopes used; compare to least-privilege baseline.
- Correlate with SIEM detections and canary/honeytoken alerts.

## Eradication & Recovery
- Add new injection samples to eval suite; create regression tests.
- Tighten allowlists; strip new indicators in pre-ingest sanitizer.
- Re-index quarantined segments after cleansing.
- Resume OPA policy normal state with monitored “watch” window.

## Communications
- Notify data owners, privacy, legal, SecOps; open incident record.
- Stakeholder update template in `/governance/cato-evidence/templates/comm-incident.md`.

## Post-Incident
- Root cause analysis; update threat model; document compensating controls.
- Evidence bundle attached to release (`governance/cato-evidence/bundles/<incident-id>/`).

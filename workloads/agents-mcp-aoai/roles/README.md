
# Agent Roles & Governance

This accelerator formalizes four human-in-the-loop roles that steer the autonomous flow:

- **Product Manager (PM)** — value, scope, non-functional requirements, business risk sign-off.
- **Delivery Architect (DA)** — architecture fitness, cloud landing zone alignment, integration patterns.
- **Responsible Engineer (RE)** — implementation quality, test coverage, rollback, SLO/SLA.
- **Security & Identity Expert (SIE)** — policy/gate alignment, identity/keys, data protection.

## RACI (per change)

| Task | PM | DA | RE | SIE |
|---|---|---|---|---|
| Define product change intent | **R/A** | C | C | C |
| Architecture & policy impact review | C | **R/A** | C | **R** |
| Implement & test | C | C | **R/A** | C |
| Identity & secrets review | C | C | C | **R/A** |
| Approve apply to prod | **A** | **A** | **A** | **A** |

> All approvals are captured as PR labels or review approvals and verified by CI (see `.github/workflows/agent-governance.yml`).

## Evidence → Controls (examples)

| Evidence | Control Families (NIST 800-53r5) |
|---|---|
| Plan/Apply outputs, drift checks | CM-2, CM-3, CM-6, CA-7 |
| Policy check (K8s/AWS/GCP/OCI) | SI-7, CM-7, SC-7 |
| Identity federation proof (OIDC/WIF) | AC-2, IA-2, IA-5 |
| SBOM + attestations | SA-11, SR-4 |
| OSCAL export | AU-6, CA-2, CA-7 |

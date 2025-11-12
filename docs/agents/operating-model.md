SPDX-License-Identifier: Apache-2.0
# Agent Operating Model (L1 → L3)

Agents operate **only via Pull Requests**; they never push to protected branches or mutate live systems directly. Autonomy is graduated across levels and tightly scoped to specific **lanes**.

## Autonomy levels

| Level | Definition | Permitted Changes | Disallowed Actions |
|------|------------|-------------------|--------------------|
| **L1** | Executes requested tasks without initiative | Scaffolding, docs, lint, Gatekeeper **audit** constraints, Arc Flux Kustomization drafts | Any prod changes; changing `deny` effects; direct cluster writes |
| **L2** | Proposes remediations proactively based on signals | Version pin bumps, drift PRs, parameterized policy updates in nonprod; DRY fixes | Creation/removal of critical resources; prod policy effect escalation |
| **L3** | Limited ownership in narrow lanes | Readme/compliance/evidence refreshes; policy parameter updates; non-breaking chart/module bumps | Any change beyond allowlisted paths; bypassing review gates |

## Change classes & review policy

| Class | Examples | Required Checks | Review & Merge |
|------|----------|-----------------|----------------|
| **Docs/Evidence** | README/SECURITY/OSCAL updates | pre-commit, markdownlint, link check | Auto-merge if CODEOWNERS path approved |
| **Policy Parameters** | Azure Policy initiative params, Gatekeeper allowed repos list | Conftest/Checkov, Gatekeeper **dry-run**, unit tests | 1 maintainer approval + passing checks |
| **Infra Logic** | Terraform/Bicep/Helm logic changes | Full static/policy tests, plan diff, helm diff, SAST | 2 maintainers + no prod deployment without human promotion |

## Risk scoring (for bots)

- **Blast radius** (0–5): number of environments impacted.
- **Effect change** (+3): audit→deny escalations.
- **Secrets/IAM** (+4): role/binding/policy modifications.
- **Stateful data** (+5): DB/storage/network peering.

**Auto-merge only if score ≤ 2** and paths are allowlisted.

## Evidence requirements

Each agent PR must include:
- Problem statement and intent.
- Plan/diff artifacts (Terraform plan JSON, `helm diff`, Gatekeeper audit report).
- Risk score and rollback steps.
- Evidence metadata (commit SHAs, timestamps).

All artifacts are retained ≥ 12 months for audit.

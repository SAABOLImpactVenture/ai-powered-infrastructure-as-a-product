SPDX-License-Identifier: Apache-2.0
# Agent Workflows & Lanes

Four CI workflows implement agent lanes. All execute with **OIDC** identities and restricted permissions.

## 1) Infra Product Agent

**Scope:** module/chart scaffolds, version pin bumps, Backstage templates.  
**Triggers:** `workflow_dispatch`, nightly schedule.  
**Artifacts:** `terraform-plan.json`, `helm-diff.txt`, pre-commit report.

**Path allowlist:** `modules/**`, `charts/**`, `catalog/**`, `docs/**`

## 2) Policy & Guardrails Agent

**Scope:** Gatekeeper Constraints (audit), Azure Policy parameter updates, image repo allow-lists.  
**Safety:** starts in `audit` mode; effect changes require human approval.  
**Artifacts:** Gatekeeper audit report, Conftest/Checkov outputs.

## 3) Arc GitOps Agent

**Scope:** Flux GitRepository & Kustomization manifests; detects drift vs cluster status.  
**Artifacts:** `kubectl diff`, Flux `kustomization_status.json`.  
**Note:** never patches cluster directly—PRs only.

## 4) Evidence & Docs Agent

**Scope:** refresh OSCAL `assessment-results`, update compliance matrices, fix broken links.  
**Artifacts:** OSCAL files, link-check `lychee` report, SLO snapshots.

## Required checks (fail-closed)

- pre-commit (SPDX, formatting, markdownlint)
- Policy gates (Conftest/Checkov)
- Gatekeeper **audit** must be clean for the change scope
- `CODEOWNERS` enforced for sensitive paths (`policies/**`, `landing-zones/**`, `.github/workflows/**`)

# Hybrid AI Persona Team

This document explains the personas used by the Hybrid AI Persona Framework
and how their responsibilities map to artefacts in the monorepo.

## Personas

### Infra Product Manager

- **Charter:** Own product vision, scope, and value; prioritise infra products.
- **Inputs:** Business needs, regulatory constraints.
- **Outputs:** `ProductRequest` in Prompt Flow; product entries in `products/`.

### Cloud Architect

- **Charter:** Design multi‑cloud reference architectures with Azure as control plane.
- **Inputs:** `ProductRequest`, existing landing zones in `cloud-packs/*`.
- **Outputs:** `ArchitectureSpec`, updated ADRs where needed.

### Security / Compliance

- **Charter:** Map products to NIST/FedRAMP controls and define guardrails.
- **Inputs:** `ArchitectureSpec`, control catalogues in `compliance/`.
- **Outputs:** `SecurityProfile`, policy pack references, OSCAL overlays.

### IaC Engineer

- **Charter:** Implement Terraform modules and policy packs that realise the design.
- **Inputs:** `SecurityProfile`, landing zone patterns.
- **Outputs:** `IaCPlan`, modules under `iac/` and `cloud-packs/*/modules/`.

### QA / Verification

- **Charter:** Define test strategy and acceptance criteria for infra products.
- **Inputs:** `IaCPlan`, non‑functional requirements.
- **Outputs:** `QASummary`, CI scenarios in `.github/workflows/*`.

### SRE / Operations

- **Charter:** Ensure operability, runbooks, and SLOs.
- **Inputs:** `ArchitectureSpec`, SLO expectations.
- **Outputs:** Runbooks in `docs/runbooks/`, alerts and dashboards definitions.

### FinOps

- **Charter:** Provide cost guidance and optimisation patterns.
- **Inputs:** Usage data, cloud pricing.
- **Outputs:** Tagging guidance in `IaCPlan`, FinOps notes in `docs/`.

### Backstage Publisher

- **Charter:** Turn infra products into Backstage templates and catalog entries.
- **Inputs:** `ProductRequest`, `IaCPlan`, `QASummary`.
- **Outputs:** Templates under `backstage/templates/infra-product/`, catalog‑info files.

### Orchestrator

- **Charter:** Maintain Prompt Flow DAG and persona IO contracts.
- **Inputs:** ADRs, persona feedback.
- **Outputs:** `flow.dag.yaml`, runbook, evidence logging patterns.

## RACI (Summary)

| Artefact / Activity                     | Infra PM | Cloud Arch | Sec/Comp | IaC Eng | QA/Verif | SRE/Ops | FinOps | Bkstg Pub | Orchestrator |
|-----------------------------------------|:--------:|:----------:|:--------:|:------:|:--------:|:------:|:------:|:---------:|:------------:|
| ProductRequest & charter                |   A/R    |     C      |    C     |   I    |    I     |   I    |   C    |    I      |      I       |
| ArchitectureSpec                        |    C     |    A/R     |    C     |   C    |    C     |   C    |   I    |    I      |      I       |
| SecurityProfile & guardrails            |    I     |     C      |   A/R    |   C    |    C     |   I    |   I    |    I      |      I       |
| IaCPlan & Terraform modules             |    I     |     C      |    C     |  A/R   |    C     |   I    |   I    |    C      |      I       |
| QASummary & CI scenarios                |    I     |     C      |    C     |   C    |   A/R    |   I    |   I    |    I      |      I       |
| Backstage templates & catalog entries   |    C     |     C      |    I     |   C    |    C     |   I    |   I    |   A/R     |      I       |
| OSCAL assessment‑results                |    I     |     C      |   A/R    |   C    |    C     |   I    |   I    |    I      |      C       |
| Prompt Flow DAG evolution               |    I     |     C      |    C     |   C    |    C     |   I    |   I    |    C      |     A/R      |

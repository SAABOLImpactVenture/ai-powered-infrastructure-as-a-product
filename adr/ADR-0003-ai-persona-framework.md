# ADR-0003: Hybrid AI Persona Framework and Monorepo Strategy

- Status: Accepted
- Date: 2025-11-16
- Context: AI-Powered Infrastructure-as-a-Product (IaaP) for multi-cloud, FedRAMP / FISMA workloads.

## Problem

We operate a large infrastructure-as-a-product monorepo that:

- Uses **Azure** as the control plane (identity, policy, monitoring).
- Uses **AWS, GCP, and OCI** as execution planes via federated identities.
- Needs AI assistance to convert cloud services into curated infra products published in Backstage.
- Must satisfy strict auditability (NIST 800-53 / FedRAMP) and support a commercialization path where
  downstream packs are split into separate repositories.

We must decide:

1. How AI personas are orchestrated so behaviour is deterministic and auditable.
2. How to structure the monorepo so we can safely split it later while keeping it as the master.

## Decision 1 – Hybrid AI Persona Framework

We adopt a **Hybrid AI Persona Framework**:

- **Workflow‑first:** Azure AI Prompt Flow orchestrates a fixed sequence of persona tools and collects
  inputs/outputs, metadata, and run logs.
- **Code‑first:** Persona tools are implemented as **pure Python functions** with strict Pydantic models.
  Semantic Kernel–style skills live in `skills/semantic-kernel/python` and perform deterministic rendering
  of Terraform modules, policy packs, Backstage bundles, and OSCAL documents.

### Personas

The framework standardises these personas:

- Infra Product Manager
- Cloud Architect
- Security / Compliance
- IaC Engineer
- QA / Verification
- SRE / Operations
- FinOps
- Backstage Publisher
- Orchestrator

Prompt Flow orchestrates them in this order (with a human‑in‑the‑loop gate):

1. ProductManager
2. CloudArchitect
3. SecurityCompliance
4. IaCEngineer
5. QA
6. BackstagePublisher
7. Approvals (HITL)
8. EvidenceSink

### Drivers

- **Auditability:** Each persona logs JSON‑Lines artefacts under `artifacts/evidence/runs/`. Prompt Flow
  captures run metadata. Together they form a defensible trail for assessors.
- **Determinism:** Persona tools and skills are pure functions: no external network calls, no randomness,
  and no mutable global state. The same inputs always produce the same outputs.
- **Developer UX:** The end result is a Backstage template bundle and catalog entry plus Terraform and
  policy packs, not just raw YAML or ad‑hoc scripts.
- **Clear contracts:** All persona IO is expressed as Pydantic models (`ProductRequest`, `ArchitectureSpec`,
  `SecurityProfile`, `IaCPlan`, `QASummary`, `BackstageBundle`, `EvidenceRecord`). This makes schema drift
  and ad‑hoc shortcuts easy to detect.

### Alternatives

1. **LLM‑only prompts.**
   - Pros: fast to start.
   - Cons: weak auditability, brittle prompts, no strong typing, and high risk of “prompt injection” changing
     behaviour. Not acceptable for FedRAMP High.

2. **Code‑only automation (no orchestrator).**
   - Pros: deterministic and testable.
   - Cons: no first‑class concept of personas or HITL; difficult to explain to auditors and product owners.

3. **Generic orchestrators (Airflow, custom DAGs, GitHub Actions).**
   - Pros: familiar.
   - Cons: no native concept of prompt flows, and more plumbing to get equivalent logging and approval
     semantics.

The hybrid approach gives us strong governance without losing flexibility.

## Decision 2 – Monorepo Strategy (“Monorepo now, split later”)

We keep a **single authoritative monorepo** as the long‑term source of truth. Downstream public and private
distributions are created by exporting subtrees from tagged versions of this monorepo.

### Top‑Level Layout

We standardise on this layout:

- `core/` – AI engine, MCP servers, agents, orchestration, shared libs.
- `backstage/` – Backstage app, plugins, templates, catalog entities.
- `cloud-packs/` – Cloud‑specific packs:
  - `cloud-packs/azure/`
  - `cloud-packs/aws/`
  - `cloud-packs/gcp/`
  - `cloud-packs/oci/`
- `products/` – Golden paths and packaged infra products.
- `compliance/` – OSCAL content, mappings, dashboards, detections, evidence schemas.
- `adr/` – Architecture Decision Records (including this one).
- `artifacts/` – Generated evidence and other non‑source artefacts.

### Migrating Existing Folders

Existing content is mapped as follows (illustrative but prescriptive in intent):

- Core services, MCP servers, and dev stack → `core/`
  - `services/*` → `core/services/*`
  - `mcp/*` → `core/mcp/*`
  - `agents/*` → `core/agents/*`
  - `docker/dev/*` → `core/devstack/*`
- Backstage templates and plugins → `backstage/`
  - `backstage-plugins/*` → `backstage/plugins/*`
  - `templates/*` or `backstage-templates/*` → `backstage/templates/*`
  - Backstage catalog files → `backstage/catalog/*`
- Terraform / landing zones → `cloud-packs/*`
  - Azure resources → `cloud-packs/azure/*`
  - AWS resources → `cloud-packs/aws/*`
  - GCP resources → `cloud-packs/gcp/*`
  - OCI resources → `cloud-packs/oci/*`
- Product marketplace / golden paths → `products/*`
- Evidence schemas, OSCAL profiles, dashboards, detections → `compliance/*`
- Runtime evidence → `artifacts/evidence/*` (never the primary source of truth).

### CODEOWNERS Alignment

`CODEOWNERS` reflects the same boundaries so ownership is stable now and after repo split:

- `core/*` → platform core team.
- `backstage/*` → Backstage / developer experience team.
- `cloud-packs/azure/*` → Azure pack owners.
- `cloud-packs/aws/*` → AWS pack owners.
- `cloud-packs/gcp/*` → GCP pack owners.
- `cloud-packs/oci/*` → OCI pack owners.
- `products/*` → product enablement team.
- `compliance/*` → security and compliance team.

### CI Workflows

CI workflows are scoped to these boundaries:

- `core-ci.yml` – build and test core services and orchestration.
- `backstage-ci.yml` – build and test Backstage app, plugins, templates.
- `cloud-packs-*-ci.yml` – validate each cloud pack.
- `compliance-ci.yml` – validate OSCAL, mappings, and detection rules.
- `ci-persona-hybrid-validate.yml` – validates the Hybrid AI Persona artefacts in this ADR.

### Versioning and Releases

- The monorepo uses semantic version tags: `vX.Y.Z`.
- Each release tag defines a consistent snapshot of:
  - `core/` → downstream repo `ai-iaap-core`
  - `backstage/` → `ai-iaap-backstage`
  - `cloud-packs/azure/` → `ai-iaap-azure-pack`
  - `cloud-packs/aws/` → `ai-iaap-aws-pack`
  - `cloud-packs/gcp/` → `ai-iaap-gcp-pack`
  - `cloud-packs/oci/` → `ai-iaap-oci-pack`
  - `products/` → `ai-iaap-products`
  - `compliance/` → `ai-iaap-compliance-kit`
- Distribution repos are updated by:
  1. Checking out the monorepo at a tag.
  2. Exporting the appropriate subtree.
  3. Syncing to the distribution repo via `git subtree`, automation, or content mirroring.

Licensing (open‑core vs commercial) is handled at the distribution repo level; the monorepo stays private
and authoritative.

### Common Pitfalls & Mitigations

- **Cross‑boundary coupling.** Shared code must live in `core/lib/` and be versioned. Direct cross‑imports
  between `cloud-packs/*` and `backstage/*` are discouraged and should go through well‑documented libraries.
- **Policy duplication.** Core policy patterns live in `compliance/policy-lib/`. Cloud packs generate concrete
  policies from these patterns instead of duplicating JSON/YAML.
- **Evidence sprawl.** Only runtime evidence goes into `artifacts/evidence/*`. Authoritative mappings and
  control descriptions live in `compliance/` and are tracked like regular code.
- **Drift between monorepo and splits.** All changes originate in the monorepo. Downstream repos are mirrors
  plus packaging metadata only.

## Consequences

- Teams work in a single, well‑structured monorepo with clear ownership and evidence practices.
- AI personas have stable contracts and deterministic behaviour suitable for audits.
- Backstage remains the primary interface for developers while underlying infra is governed and testable.
- When commercialising, we can carve out `*-pack` repositories without restructuring the codebase.

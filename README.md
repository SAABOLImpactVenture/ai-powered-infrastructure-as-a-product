<p align="center">
  <a href="#governance--fedramp"><img src="https://img.shields.io/badge/FedRAMP-ready-blue" alt="FedRAMP ready"></a>
  <a href="#supply-chain-security"><img src="https://img.shields.io/badge/SBOM-SPDX-success" alt="SBOM SPDX"></a>
  <a href="#oscal-export"><img src="https://img.shields.io/badge/OSCAL-export-green" alt="OSCAL export"></a>
</p>

# AI-Powered Infrastructure-as-a-Product (IaaP)

An accelerator that treats **infrastructure as a product** with golden demos, operational evidence, and AI/observability hooks. Everything is self-contained—no external downloads required.

> Status: **Production-ready starter**. Cloud integrations are opt-in via environment variables and never block local runs.

## Why this exists

Most teams ship raw building blocks (VMs, clusters, networks) and stop there. Product teams, however, need a curated, **reliable experience** with documentation, SLAs, and evidence. This repo demonstrates how to:
- rehearse changes safely with a **Golden Demo**,
- produce **machine-readable evidence** for audits and SLOs,
- centralize **observability** using KQL, workbooks, and alert rules,
- and keep everything runnable **fully offline**.

## Architecture (at a glance)

![Architecture](docs/observability/diagrams/iaap-architecture.png)

**Control Plane (Azure)** provides policy/identity/conformance.
**Execution Planes** can be Azure, AWS, GCP, or on‑prem. Evidence flows back to a single pane of glass.

## Quickstart

Requires: Python 3.10+, Terraform (optional for demo), Docker (optional for containerized reference server).

```bash
# 1) Create & activate a venv
python -m venv .venv
. .venv/bin/activate  # Windows: .\.venv\Scripts\activate

# 2) Install demo deps (reference server)
pip install -r examples/golden-demo/reference-server/requirements.txt

# 3) Start the reference server (http://127.0.0.1:5000/health)
python examples/golden-demo/reference-server/app.py
```

In another terminal:

```bash
# 4) Validate local readiness
python scripts/validate_agents_readiness.py

# 5) Run the reference Terraform change
cd examples/golden-demo/reference-change
terraform init
terraform apply -auto-approve
```

### Optional: Emit to Azure Log Analytics

Set env vars (if you have a workspace):

- `LA_WORKSPACE_ID` – Log Analytics Workspace ID (GUID)
- `LA_SHARED_KEY` – Primary/Secondary shared key
- `LA_LOG_TYPE` – Custom log table name (defaults to `IaapInfraEvidence_CL`)
- `LA_ENDPOINT` – (optional) Data Collector API URL override

Then:

```bash
python scripts/emitters/infra-evidence/emit_evidence_to_log_analytics.py   --kind "validate" --status "success" --detail "Terraform reference change applied"
```

Without env vars, emitters run in **local mode**, printing the payload and writing to `./.local-outbox/`.

## CI/CD Workflows

See `.github/workflows/`:
- `golden-demo-e2e.yml` – PR + push flow running the full demo.
- `validators-hosted.yml` – quick hosted validations (lint-like checks).
- `validators-selfhosted.yml` – deep validation, including Terraform plan, for self‑hosted runners.

## Evidence & Observability

- **KQL:** `docs/observability/infra-evidence/kql/infra_evidence_queries.kql`
- **Workbook:** `docs/observability/infra-evidence/workbooks/infra-evidence-workbook.json`
- **Alerts:** drift freshness & verify failures; AOAI latency examples.

See diagram: ![Evidence Flow](docs/observability/diagrams/evidence-flow.png)

## Contents

- `scripts/` – readiness validator and emitters (Python + PowerShell).
- `docs/observability/` – KQL, alerts, workbook, ADRs, **diagrams**.
- `workloads/` – ADRs, glossary, reference notes.
- `examples/golden-demo/` – reference server, Backstage template, Terraform change.

## Troubleshooting

- **`terraform` not found**: install HashiCorp Terraform and ensure it’s on PATH.
- **Emitter fails**: missing `requests`? Install via `pip install requests` or rely on local mode.
- **Ports**: reference server binds to `127.0.0.1:5000`; ensure port is free.

## License

MIT.



## Governance & FedRAMP

This accelerator now ships **government-ready** packs and workflows:

- **FedRAMP baselines** for Azure/AWS/GCP/OCI under `policies/*/fedramp/`  
  - Azure policy initiative + diagnostics to Log Analytics  
  - AWS Config + Security Hub + org CloudTrail + WORM logging bucket  
  - GCP SCC enablement + Org Policies (no serial, no external IPs)  
  - OCI Cloud Guard + deny public storage
- **NSA/CISA K8s overlay**: Gatekeeper constraints that enforce RuntimeDefault seccomp, read-only root FS, no host PID/network, non-root, allowed registries.
- **Supply chain**: GitHub workflows for SBOM (SPDX) + cosign attestations, plus IaC scanning (tfsec/checkov) with SARIF.
- **OSCAL export**: `tools/oscal-export/export.py` converts evidence JSON → OSCAL assessment-results for ATO packages.

### Quickstarts

**FedRAMP (AWS example)**
```bash
terraform -chdir=policies/aws/fedramp init
terraform -chdir=policies/aws/fedramp apply -var="region=us-east-1" -var="org_account_id=<ID>" -var="s3_log_bucket=<UNIQUE>"
```

**K8s NSA/CISA overlay**
```bash
kubectl apply -f policies/kubernetes/gatekeeper/overlays/nsa-cisa/templates/
kubectl apply -f policies/kubernetes/gatekeeper/overlays/nsa-cisa/constraints/
```

**Supply chain (GitHub Actions)**
- `supply-chain.yml`: SBOM + cosign attestations  
- `iac-security.yml`: tfsec & checkov with SARIF upload

**OSCAL export**
```bash
python3 tools/oscal-export/export.py --paths evidence --out artifacts/oscal/assessment-results.json
```

### Control Coverage (examples)

| Capability | NIST 800-53r5 | Notes |
|---|---|---|
| Identity federation (OIDC/WIF) | AC-2, IA-2, IA-5 | Short‑lived tokens only |
| Logging & audit (CloudTrail/Diag to LA/SCC) | AU‑2/6/8, CA‑7 | Multi‑region, validated logs |
| Encryption at rest | SC‑12/SC‑13 | CMEK/HSM options per cloud |
| Preventive policy | CM‑2/CM‑6, SI‑7 | Azure Policy, Org Policies, Config, Cloud Guard |
| K8s hardening | CM‑7, SI‑7, SC‑7 | Gatekeeper overlay + Pod Security |
| Supply chain (SBOM/signing) | SA‑11, RA‑5, SR‑4 | SPDX, cosign attestations |
| Evidence & OSCAL export | AU‑6, CA‑2, CA‑7 | ATO/cATO friendly |


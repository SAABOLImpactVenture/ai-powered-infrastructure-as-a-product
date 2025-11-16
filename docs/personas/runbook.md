# Hybrid AI Persona Runbook

This runbook describes how infra products move from idea to Backstage template
using the Hybrid AI Persona Framework.

## High‑Level Flow

1. A requestor provides `product_name`, `target_clouds`, `data_classification`,
   `rto_target`, and `rpo_target` to the Prompt Flow run.
2. Prompt Flow orchestrates persona tools (ProductManager → CloudArchitect →
   SecurityCompliance → IaCEngineer → QA → BackstagePublisher → Approvals →
   EvidenceSink).
3. Persona tools call deterministic skills in `skills/semantic-kernel/python`
   when they need to render Terraform modules, policy packs, Backstage bundles,
   or OSCAL documents.
4. A human approval step (Approvals) confirms that outputs meet expectations
   before products are published to Backstage.
5. Evidence is logged under `artifacts/evidence/` and can be exported into an
   evidence store or ADX.

```mermaid
flowchart TD
  A[New infra product request] --> B[ProductManager]
  B --> C[CloudArchitect]
  C --> D[SecurityCompliance]
  D --> E[IaCEngineer]
  E --> F[QA]
  F --> G[BackstagePublisher]
  G --> H[Approvals (HITL)]
  H --> I[EvidenceSink]
  I --> J[Evidence Store / ADX]
  G --> K[Backstage Template + Catalog]
```

## Approvals

- The Approvals node uses `qa_verification.run` with an existing `qa_summary`.
- Approvers review:
  - IaC modules and policy packs,
  - QA test cases and acceptance criteria,
  - Backstage template structure.
- On approval, `qa_summary.status` is transitioned to `approved` and an approval
  record is logged in `artifacts/evidence/runs/Approvals.jsonl`.

## Evidence Locations

- Node logs: `artifacts/evidence/runs/*.jsonl`
- Bundle summary: `artifacts/evidence/bundles/<product-slug>`
- OSCAL documents (if generated): `artifacts/evidence/oscal/*.json`

## Troubleshooting

- **Prompt Flow fails early** – inspect node JSONL logs for validation errors,
  check that `target_clouds` only uses `azure`, `aws`, `gcp`, `oci`.
- **Terraform validation fails** – examine `iac/modules/secure-storage/*.tf` and
  adjust synthesis logic in `iac_synthesis.py` if required.
- **Backstage errors** – validate `backstage/templates/infra-product/*` with the
  Backstage CLI and ensure `spec.owner`, `spec.type`, and annotations match your
  environment.
- **OSCAL validation fails** – inspect OSCAL JSON under `artifacts/evidence/oscal/`
  and compare to the minimal schema in `oscal_packager.py` and CI workflow.

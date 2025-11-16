# Hybrid Persona Prompt Flow

This directory contains the Azure AI Prompt Flow that orchestrates AI personas
to turn infra services into infra products and Backstage templates.

The DAG is defined in `flow.dag.yaml` and executes these nodes in order:

1. ProductManager
2. CloudArchitect
3. SecurityCompliance
4. IaCEngineer
5. QA
6. BackstagePublisher
7. Approvals
8. EvidenceSink

Each node is implemented as a deterministic Python tool in `tools/`. All tools
emit JSON‑Lines records into `artifacts/evidence/runs/` for audit.

To dry‑run locally (after installing Prompt Flow and dependencies):

```bash
cd orchestration/promptflow
pf flow test --flow flow.dag.yaml --inputs '{
  "product_name": "secure-storage-product",
  "target_clouds": ["azure"],
  "data_classification": "sensitive",
  "rto_target": 60,
  "rpo_target": 15
}'
```

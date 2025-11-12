# 0004 — Policy-as-Code Layers

**Status**: Accepted  
**Layers**:
1. **Org Guardrails** (Azure Policy, AWS Config, GCP Policy Controller, OCI Cloud Guard).
2. **Product Baselines** (Kubernetes Gatekeeper + cloud policies).
3. **Workload Contracts** (OPA policies, IaC gates).
4. **Evidence Streaming** (ADX tables; OSCAL exports).

**Outcome**: Consistent enforcement with measurable, exportable conformance.

<p align="center">
  <img src="docs/assets/multicloud-hero.png" alt="AI-Powered Infrastructure as a Product across multiple clouds" width="980"/>
</p>

<h1 align="center">AI-Powered Infrastructure as a Product</h1>

<p align="center"><strong>IaaS is what we buy; infrastructure-as-a-product is what we build.</strong></p>

<p align="center">Composite AI • Crossplane • GitHub governance • deterministic policy • multi-cloud evidence</p>

---

## The modern accelerator

This repository is the **thesis, architecture, governance, operating-model, and evidence front door** for a modern Infrastructure-as-a-Product (IaaP) accelerator.

The maintained reference architecture is intentionally small and opinionated:

- **Infrastructure product contracts** define the consumer boundary.
- **Crossplane** is the product control plane and reconciliation layer.
- **Composite AI** interprets intent, proposes changes, explains policy, diagnoses sanitized status, and assembles evidence.
- **GitHub** governs product change, review, traceability, and evidence.
- **Deterministic policy and tests** decide what is valid.
- **Authorized people** approve material changes.
- **Cloud-native IAM and controls** remain the ultimate enforcement boundary.

Terraform/TFE, Azure Arc, Backstage, legacy execution MCP servers, and earlier cloud-specific accelerator implementations are **not maintained dependencies of this reference implementation**. Their prior implementation remains available in Git history and the recovery branch `archive/legacy-accelerator-v1`.

> **The accelerator demonstrates the product model without requiring the historical implementation stack.**

---

## Strategic architecture

```mermaid
flowchart TB
  C[Consumer intent and business metadata]
  AI[Bounded composite AI]
  GIT[GitHub proposal, tests, policy, approval, evidence]
  API[Stable infrastructure product API]
  XP[Crossplane product control plane]
  AWS[AWS]
  AZ[Azure]
  GCP[GCP]
  STATUS[Product status and evidence]

  C --> AI
  AI --> GIT
  GIT --> API
  API --> XP
  XP --> AWS
  XP --> AZ
  XP --> GCP
  AWS --> STATUS
  AZ --> STATUS
  GCP --> STATUS
  STATUS --> AI
```

The architectural center is the **product contract**, not a workspace, module, portal, pipeline, or execution engine.

### Authority chain

```mermaid
flowchart LR
  A[AI proposes and explains] --> D[Schema, policy, and tests validate]
  D --> H[Authorized people approve]
  H --> X[Crossplane reconciles]
  X --> C[Cloud-native controls enforce]
```

AI does not receive direct cloud administrator, Kubernetes administrator, Terraform/TFE, merge, approval, or unrestricted remediation authority.

---

## Foundation establishment model

The modern sequence is not "finish three landing zones, then productize them."

```mermaid
flowchart LR
  S[Minimal trusted seed] --> P[Product control plane]
  P --> F[Foundation capabilities as products]
  F --> M[Minimum viable multi-cloud foundation]
  M --> C[Consumer infrastructure products]
  C --> E[Evidence-led continuous evolution]
```

A minimal seed establishes only the irreducible trust boundary needed for Crossplane and governed delivery to operate. Foundation capabilities can then be established and evolved through product APIs.

---

## POC portfolio

This repository deliberately references bounded implementation POCs rather than duplicating them.

| Repository | Responsibility |
|---|---|
| [`crossplane-multicloud-seed-poc`](https://github.com/SAABOLImpactVenture/crossplane-multicloud-seed-poc) | Minimal trusted Crossplane seed. |
| [`multicloud-foundation-product-poc`](https://github.com/SAABOLImpactVenture/multicloud-foundation-product-poc) | Stable `CloudFoundationEnvironment` product API and cloud implementations. |
| [`composite-ai-infrastructure-product-poc`](https://github.com/SAABOLImpactVenture/composite-ai-infrastructure-product-poc) | Bounded request, review, operations, and evidence agents. |
| [`multicloud-foundation-poc-integration`](https://github.com/SAABOLImpactVenture/multicloud-foundation-poc-integration) | Credential-free integrated acceptance and evidence harness. |
| **This repository** | Thesis, architecture, decisions, operating model, evidence baseline, and investment framing. |

See [POC Portfolio](docs/poc-portfolio.md).

---

## Evidence already established

The frozen credential-free baseline passed across Kubernetes **1.34, 1.35, and 1.36**, with a **100/100** acceptance score on each matrix entry. It demonstrated:

- a bounded Crossplane 2.3.0 seed;
- enforced ingress and egress NetworkPolicy controls;
- one AWS/GCP infrastructure-product contract;
- deterministic rejection of unsafe requests;
- proposal-and-evidence-only composite-AI authority;
- prompt-injection containment;
- reconciliation to Ready simulated products; and
- teardown with zero simulated product-component orphans.

That proves **TFE is not mandatory for the demonstrated product path**. It does not yet prove live cloud provisioning or production readiness.

See [Credential-Free Baseline](docs/poc-baselines/2026-08-07-credential-free-multicloud-foundation.md) and [ADR-0004](adr/ADR-0004-tfe-optional-for-multicloud-foundation.md).

---

## What was superseded

The earlier accelerator contained useful exploration and implementation IP around Terraform, Azure Arc, Backstage, cloud-execution MCP servers, PromptFlow/Semantic Kernel implementations, and provider-specific automation.

Those components were removed from the maintained branch because carrying them beside the current architecture caused the repository to tell multiple architectural stories at once.

They are **not declared bad technologies**. They are simply no longer dependencies of this accelerator.

- Recovery branch: `archive/legacy-accelerator-v1`
- Frozen pre-supersession commit: `be5fa73c72f77043ac666d32868ec7b82f9e83b1`
- Decision record: [ADR-0005](adr/ADR-0005-supersede-legacy-implementation-stack.md)
- Detail: [Supersession Record](docs/SUPERSESSION.md)

---

## Enterprise interoperability

An enterprise may still use TFE, Terraform/OpenTofu, Backstage, Arc, cloud-native account factories, ticketing, CMDB, or other systems. The accelerator treats them as **external integrations or implementation choices**, not inherited product dependencies.

See [Interoperability](docs/INTEROPERABILITY.md).

---

## TFE investment question

The architecture no longer needs TFE to exist internally in order to evaluate TFE fairly.

The decision question is now:

> **After Crossplane, GitHub governance, deterministic policy, cloud-native identity, evidence, and composite AI supply the strategic infrastructure-product operating model, what remaining capabilities and workloads uniquely justify TFE's lifecycle cost?**

See [TFE Investment Evaluation](docs/TFE-INVESTMENT.md).

---

## Next evidence gate

```mermaid
flowchart LR
  G0[Credential-free integrated proof] --> G1[Live AWS sandbox]
  G1 --> G2[Live GCP sandbox]
  G2 --> G3[Live model adapter]
  G3 --> G4[Residual TFE comparison]
  G4 --> G5[Production pilot]
```

The next technical milestone is **live AWS sandbox reconciliation using workload identity**, followed by the same evidence pattern in GCP.

---

## Repository map

```text
.
├── README.md
├── docs/
│   ├── THESIS.md
│   ├── architecture/product-control-plane.md
│   ├── OPERATING-MODEL.md
│   ├── INTEROPERABILITY.md
│   ├── TFE-INVESTMENT.md
│   ├── SUPERSESSION.md
│   ├── poc-portfolio.md
│   └── poc-baselines/
├── adr/
├── policies/opa/
├── tests/agents-evals/
├── artifacts/poc-baselines/
└── .github/workflows/
```

The implementation repos contain the runtime code. This repository contains the durable product thesis and evidence architecture.

## License

Apache License 2.0. See [LICENSE](LICENSE).

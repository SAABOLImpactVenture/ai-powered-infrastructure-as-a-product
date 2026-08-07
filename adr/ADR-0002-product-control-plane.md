# ADR-0002: Adopt the Product Contract and Crossplane Control Plane as the Strategic Center

- **Status:** Proposed for program alignment
- **Date:** 2026-08-06
- **Decision owners:** Infrastructure product leadership, platform engineering, cloud architecture, security, and operations

## Context

The original AI-Powered Infrastructure-as-a-Product accelerator centered an Azure management plane, Azure Arc, Backstage, Terraform modules, plan/apply workflows, policy-as-code, MCP tools, and OSCAL evidence.

That architecture remains a useful implementation pattern. However, the program has since developed four bounded POC repositories that establish a broader product-control-plane model:

1. `crossplane-multicloud-seed-poc`;
2. `multicloud-foundation-product-poc`;
3. `composite-ai-infrastructure-product-poc`; and
4. `multicloud-foundation-poc-integration`.

The POCs are based on the following thesis:

> **IaaS is what we buy; infrastructure-as-a-product is what we build.**

The emerging model requires the product contract, not a particular execution engine, to become the stable architectural boundary. Crossplane provides custom product APIs, Composition-based implementation selection, continuous reconciliation, and product status. Composite AI provides bounded intent, review, diagnosis, and evidence capabilities. GitHub, deterministic policy, authorized reviewers, and cloud-native controls maintain governance and authority.

The program must also evaluate whether Terraform Enterprise remains worth platform-level investment if its residual role is limited to bootstrap, brownfield, specialized provider coverage, or implementation exceptions.

## Decision

The program will adopt the following strategic center:

```text
Consumer intent
→ bounded composite AI
→ GitHub proposal, deterministic validation, and human approval
→ stable infrastructure product API
→ Crossplane product control plane
→ replaceable cloud-specific implementation
→ live product status and evidence
```

### Product contract

The product contract will define consumer outcomes, profiles, required metadata, lifecycle, guarantees, exclusions, status, and versioning.

The consumer contract will not require knowledge of:

- TFE workspaces or Stacks;
- Terraform state backends;
- module topology;
- provider-native resources;
- Crossplane managed-resource internals; or
- execution-pipeline implementation details.

### Crossplane

Crossplane will be the default product control-plane mechanism for the bounded POCs and strategic product experiments when provider coverage, lifecycle behavior, and operations are sufficient.

Crossplane is not required to own resources that it cannot safely support.

### Composite AI

Composite AI may interpret intent, draft proposals, explain deterministic policy, diagnose sanitized status, and assemble redacted evidence.

Composite AI may not apply, delete, approve, merge, access secrets or unrestricted credentials, modify policy, or expand its own tools.

### Implementation optionality

The following may remain implementation options behind product contracts:

- Crossplane-native providers;
- OpenTofu or retained HCL;
- Terraform CLI;
- Terraform Enterprise by documented exception;
- cloud-native APIs or services;
- Azure Arc and GitOps;
- Backstage as an experience layer; and
- other approved automation.

### Resource ownership

One external resource must have one authoritative management engine. Crossplane, TFE, OpenTofu, Azure Arc/GitOps, and cloud-native automation must not actively co-manage the same resource.

### Previous architecture

The Azure Arc, Backstage, and Terraform architecture will be preserved as a V1 implementation pattern. It will no longer be presented as the universal target architecture.

## Consequences

### Positive

- Consumer contracts are decoupled from execution-engine topology.
- Multi-cloud implementations can evolve behind stable product APIs.
- Crossplane can participate in establishing the minimum viable foundation rather than only consuming a completed foundation.
- Composite AI operates over product intent and live status instead of broad infrastructure authority.
- TFE can be evaluated based on residual value rather than assumed necessity.
- Existing Terraform, Arc, Backstage, policy, observability, and OSCAL assets are preserved.
- POC claims can be separated into static, simulated, live, comparative, and investment evidence gates.

### Negative and tradeoffs

- The organization must operate a Kubernetes and Crossplane control plane.
- Provider, Function, package, identity, policy, upgrade, and support complexity remain real.
- Crossplane coverage may be weaker than Terraform for some resources.
- Two execution systems may coexist during transition, increasing operational complexity.
- Product APIs can become poor lowest-common-denominator abstractions if designed without provider-specific judgment.
- Composite-AI evaluations and sanitized status surfaces require dedicated engineering.
- Existing teams may need new product, control-plane, and operations skills.

### Risks

- Treating Crossplane as mandatory in the same way TFE was previously assumed mandatory.
- Allowing multiple engines to co-manage external resources.
- Exposing implementation details through the product API.
- Granting AI direct execution or credential authority.
- Claiming live-cloud or investment proof from simulated evidence.
- Deleting useful prior assets rather than preserving them as optional patterns.

## Alternatives considered

### Continue the Azure Arc and Terraform architecture as the universal target

Rejected as the universal target because it couples the product model to Azure, Backstage, Terraform plan/apply, and a specific management-plane design. Retained as a V1 implementation option.

### Make TFE the mandatory multi-cloud execution and governance layer

Not selected as an architectural default. TFE may remain valuable, but its necessity and investment must be demonstrated through residual capability, utilization, risk, cost, and comparison evidence.

### Use only cloud-native landing-zone and vending tools

Not selected as the entire product architecture. Cloud-native services remain valid implementations, but the program still requires a stable multi-cloud product, governance, evidence, and operations model.

### Allow composite AI to provision directly

Rejected because it collapses proposal, validation, approval, and execution authority into an untrusted probabilistic system.

## Validation plan

The decision will be validated through the following gates:

1. credential-free integrated POC;
2. live AWS and GCP sandbox product;
3. live model adapter with unchanged authority;
4. fair Crossplane, TFE, and retained-HCL comparison;
5. TFE residual-value investment analysis; and
6. bounded production pilot with authorization and support evidence.

## Revisit criteria

Revisit this ADR when:

- Crossplane provider or operational limitations prevent required product outcomes;
- the live comparison shows TFE or another platform provides materially better product value;
- product APIs prove unstable across providers;
- Kubernetes control-plane cost exceeds demonstrated benefit;
- regulatory requirements impose a different authoritative control boundary; or
- a new platform materially changes the economics or operating model.

## Related material

- [`docs/THESIS.md`](../docs/THESIS.md)
- [`docs/architecture/product-control-plane.md`](../docs/architecture/product-control-plane.md)
- [`docs/architecture/v1-azure-arc-terraform-pattern.md`](../docs/architecture/v1-azure-arc-terraform-pattern.md)
- [`docs/poc-portfolio.md`](../docs/poc-portfolio.md)
- [`ADR-0001-azure-arc-control-plane.md`](ADR-0001-azure-arc-control-plane.md)

# Product-Control-Plane Architecture

## Purpose

The current architecture makes the **infrastructure product contract** the stable boundary and Crossplane the maintained product control plane.

```mermaid
flowchart TB
  subgraph Experience[Consumer and Product Experience]
    C[Consumer intent]
    AI[Bounded composite AI]
    DOC[Product docs and runbooks]
    C --> AI
    DOC --> AI
  end

  subgraph Governance[Governance]
    PR[GitHub proposal]
    SCHEMA[Schema and contract validation]
    POLICY[Deterministic policy and tests]
    HUMAN[Authorized approval]
    AI --> PR --> SCHEMA --> POLICY --> HUMAN
  end

  subgraph ControlPlane[Product Control Plane]
    API[Product APIs]
    XP[Crossplane]
    COMP[Compositions and Functions]
    STATUS[Product conditions]
    HUMAN --> API --> XP --> COMP
    XP --> STATUS
    STATUS --> AI
  end

  subgraph Clouds[Cloud Implementations]
    AWS[AWS]
    AZ[Azure]
    GCP[GCP]
    COMP --> AWS
    COMP --> AZ
    COMP --> GCP
  end

  subgraph Evidence[Evidence]
    E[Requirements, tests, approvals, status, teardown]
    PR --> E
    POLICY --> E
    STATUS --> E
  end
```

## Layers

### Layer 0 — external trust prerequisites

A cloud organization/tenant relationship, billing, initial administration, approved management environment, audit path, and source repository may exist before Crossplane can operate.

### Layer 1 — minimal trusted seed

The seed installs Crossplane, establishes its namespace/security boundary, package/version controls, identity path, and basic auditability. The seed remains deliberately small and independently governed.

### Layer 2 — foundation products

Examples include account/project boundaries, workload identity, network zones, logging baselines, encryption baselines, security-monitoring connections, budget guardrails, and `CloudFoundationEnvironment`.

### Layer 3 — consumer infrastructure products

Application, Kubernetes, data, integration, AI workload, storage, and other supported environments build on the minimum viable foundation.

### Layer 4 — evidence-led product learning

Operational status, exceptions, demand, product adoption, and cost-to-serve identify new product candidates, weak abstractions, control friction, provider gaps, and retirement opportunities.

## Consumer boundary

Consumers should not need to understand:

- Crossplane managed-resource internals;
- provider resource kinds;
- cloud-specific naming conventions that do not affect the requested outcome;
- Terraform state/workspaces/modules;
- pipeline topology; or
- implementation migration details.

## Resource ownership

One external resource has one authoritative reconciler. Crossplane may observe dependencies owned elsewhere, but the accelerator does not support active co-management.

## GitHub role

GitHub is the product-development and change-governance plane: source, review, policy, tests, ADRs, releases, evidence, and compatibility records. It is not a replacement for every ticketing, CMDB, catalog, or records-management system.

## Evidence chain

```mermaid
flowchart LR
  R[Requirement] --> C[Product control]
  C --> I[Composition / implementation]
  I --> T[Test]
  T --> A[Approval]
  A --> X[Reconciliation]
  X --> S[Operational status]
  S --> E[Evidence bundle]
```

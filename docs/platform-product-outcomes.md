# Platform Product Outcomes

Infrastructure-as-a-Product should be measured by developer and business outcomes, not by engineering activity alone.

> **Productive by outcomes, not by activity.**

Terraform lines of code, Crossplane Compositions, modules, pipelines, pull requests, and tickets are implementation inputs. They can help teams manage engineering work, but they do not prove that an infrastructure product is useful, fast, adopted, or preferred.

This evidence model adds a product-outcome layer alongside architecture, security, policy, portability, reconciliation, and supply-chain evidence.

## Measurement hierarchy

| Class | Examples | What it answers |
|---|---|---|
| Engineering activity | IaC LOC, modules, PRs, pipelines, tickets | What did the team produce? |
| Platform health | reconciliation success, availability, policy compliance, MTTR, provisioning failures | Is the platform operating correctly? |
| **Product outcomes** | Developer NPS, Time-to-Provision, adoption, repeat consumption, exception/escape rate | Is the infrastructure product creating value for developers? |

Engineering activity is never a substitute for product outcomes.

## Core product metrics

### Developer Net Promoter Score (Developer NPS)

After a successfully delivered infrastructure product reaches `Ready`, ask the consuming developer:

> How likely are you to recommend this infrastructure product to another development team? (0-10)

Classification:

- Promoters: 9-10
- Passives: 7-8
- Detractors: 0-6

Formula:

```text
Developer NPS = % Promoters - % Detractors
```

Every reported Developer NPS must include the response count and response rate. No NPS is reported from synthetic POC runs or without actual developer responses.

### Time-to-Provision

At least two elapsed-time measures must be retained so platform latency and governance latency are not conflated.

```text
Order-to-Ready = readyAt - orderSubmittedAt
Approval-to-Ready = readyAt - approvedAt
```

- **Order-to-Ready** measures the developer experience.
- **Approval-to-Ready** measures the provisioning/control-plane portion after a real human approval.

When actual human approval is not present, the evidence must not label an encoded or simulated approval boundary as `approvedAt`.

A lower-level technical measure may also be retained:

```text
Desired-State-to-Ready = readyAt - desiredStateSubmittedAt
```

This is useful for control-plane performance but is not a substitute for developer-facing Order-to-Ready.

### Internal Adoption Rate

```text
Internal Adoption Rate = active eligible teams consuming the product / total eligible teams
```

The denominator must be defined before an adoption percentage is published. Repository clones, page views, catalog views, or test executions are not counted as adopted teams.

### Repeat Consumption Rate

```text
Repeat Consumption Rate = teams with 2+ successful product orders / teams with 1+ successful product orders
```

This helps distinguish one-time trial from durable product use.

### Exception / Escape Rate

```text
Exception Rate = approved bespoke/escape-path requests / total infrastructure requests
```

A falling exception rate can indicate that the paved road is covering more real developer needs. Exceptions should still be classified by reason so a low rate is not achieved by denying valid needs.

## Minimum telemetry contract

Each infrastructure product order should carry or emit a correlation identifier that can connect storefront, approval, control-plane, and outcome evidence without exposing cloud credentials or implementation internals.

Minimum lifecycle events:

| Event | Required fields |
|---|---|
| `order.submitted` | `correlationId`, `product`, `consumerTeam`, `environment`, `orderSubmittedAt` |
| `order.approval-required` | `correlationId`, `approvalBoundaryAt` |
| `order.approved` | `correlationId`, `approvedAt`, `approverType=human` |
| `desired-state.submitted` | `correlationId`, `desiredStateSubmittedAt` |
| `product.ready` | `correlationId`, `readyAt`, `result=success` |
| `product.failed` | `correlationId`, `failedAt`, `failureClass` |
| `developer.feedback` | `correlationId`, `score0to10`, `submittedAt` |
| `exception.requested` | `correlationId`, `reasonClass`, `submittedAt` |

The telemetry contract records product-level facts. It should not require Terraform/TFE workspace identifiers, ProviderConfigs, raw IAM documents, static cloud credentials, or AI execution authority.

## Evidence status model

Every metric must declare an observation status:

- `observed` - produced from the target environment and population.
- `poc-observed` - produced from a bounded POC and clearly labeled as such.
- `not-observed` - the contract exists but no valid population or environment exists yet.
- `not-applicable` - the metric does not apply to the evidence scope.

This prevents synthetic test activity from being presented as developer adoption or satisfaction.

## Current POC boundary

The current credential-free integration can produce technical timing evidence around desired-state submission and simulated reconciliation, but it does **not** have a real developer population, actual human approval event, or live-cloud product delivery.

Therefore, until a real pilot exists:

| Metric | Current status |
|---|---|
| Developer NPS | `not-observed` |
| Internal Adoption Rate | `not-observed` |
| Repeat Consumption Rate | `not-observed` |
| Exception / Escape Rate | `not-observed` for organizational behavior |
| Desired-State-to-Ready | eligible for `poc-observed` timing evidence |
| Order-to-Ready | `not-observed` as a real developer experience metric |
| Approval-to-Ready | `not-observed` until a real human approval event exists |

## Live-pilot requirement

Before the first live AWS sandbox is treated as product evidence, the order path should emit the lifecycle correlation/timing events needed to calculate Time-to-Provision. Developer NPS and adoption metrics begin only when actual developers and an explicitly defined eligible-team population exist.

The executive measurement shift is intentional:

> Do not ask how much Terraform the infrastructure team wrote. Ask whether developers adopted the product, how long it took them to receive it, whether it worked, and whether they would recommend using it again.

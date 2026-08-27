# Product Outcome Producer and Consumer Boundaries

The outcome layer measures IaaP without collapsing the authority boundaries between suite components.

| Concern | Authoritative producer | Consumer | Current capability | Gap to close |
|---|---|---|---|---|
| Approved demand timestamps | Guard / approved intake evidence | Forge, Console | Partial | Normalize approval event and source reference |
| Product Ready timestamps | Forge / product control plane | Guard, Console | Partial | Standardize Ready event export across live executors |
| Adoption | Forge outcome observations | Guard, Console | Present in Forge Phase 17 | Add reusable-product-contract reuse counter |
| Policy evaluations and rejections | Forge deterministic gates | Guard, Console | Partial | Emit stable rejection reason codes and counters |
| Exceptions | Guard and Forge evidence, by authority | Console, reassessment | Present in outcome model | Normalize request denominator and exception state |
| Reconciliation attempts/failures | Forge / customer-hosted control plane | Guard, Console | Synthetic successor evidence exists | Add live customer-hosted telemetry adapter |
| Recovery | Forge / runtime lifecycle evidence | Guard, Console | Synthetic retry/recovery evidence exists | Standardize production recovery event export |
| Evidence completeness | Guard and Forge evidence indexes | Console, audit/export | Strong | Add one deterministic completeness rollup contract |
| Upgrade/lifecycle | Forge lifecycle controller | Guard, Console | Strong contract/evidence foundation | Aggregate comparable success rates by product/version |
| Teardown/orphans | Forge / target executor | Guard, Console | Live/synthetic evidence exists by slice | Standardize teardown outcome and orphan declaration |
| Infrastructure cost | Cloud billing/FinOps and platform accounting | Forge outcome record, Console | Foundation cost ownership defined | Integrate tagged/allocation-ready cost observations |
| Platform/support labor | Support/operations systems | Forge outcome record, Console | Operating effort supported | Define normalized labor/case observation contract |
| Consumer NPS | Experience layer / survey source | Forge outcome record, Console | Present in Forge Phase 17 | Normalize period, population, and product linkage |
| Support demand | ITSM/support source | Console, product owner | Not standardized | Add support-case observation adapter and rate calculation |

## Suite responsibilities

### Forge

Forge is the principal producer of infrastructure-product operational facts. It may normalize observations from the control plane, cloud provider, cost systems, and approved support integrations. Forge does not fabricate absent data.

### Guard

Guard consumes immutable outcome evidence to reassess readiness, materiality, continuity, risks, and planning implications. Guard does not change the historical outcome record and does not convert a metric into authorization.

### Console

Console presents scorecards, drill-downs, trends, missing-instrumentation warnings, and evidence links. It may calculate display aggregates from the canonical formulas but must not create a competing source of truth.

### FoundationTarget

FoundationTarget contributes target lifecycle, reconciliation, retry, recovery, drift, and retirement observations when the relevant executor is authorized and instrumented. Synthetic evidence must remain visibly synthetic.

### Composite AI

Composite AI may summarize trends, explain deterministic results, identify likely instrumentation gaps, and propose investigation questions. It may not:

- alter raw observations;
- fill missing samples;
- redefine formulas;
- approve exceptions;
- change targets;
- declare compliance;
- or convert correlation into causation.

## Instrumentation maturity states

Every metric should expose one of these states:

- `OBSERVED` — required facts are available from an authoritative source;
- `PARTIAL` — some required facts are available but the metric cannot be fully calculated;
- `SYNTHETIC` — calculable from synthetic validation evidence only;
- `NOT_INSTRUMENTED` — the architecture supports the metric but no observation path is connected;
- `NOT_APPLICABLE` — the metric does not apply to the product or lifecycle stage.

This state travels with the metric so an executive dashboard cannot accidentally present architecture potential as demonstrated operating performance.

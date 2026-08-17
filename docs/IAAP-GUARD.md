# IaaP Guard V1

> **IaaS is what you buy. Infrastructure-as-a-Product is what you build. IaaP Guard makes sure you keep building it that way.**

IaaP Guard is the completed, bounded GitHub-native architecture and evidence product produced by this Infrastructure-as-a-Product program. The supported V1 release is [`v1.0.0`](https://github.com/SAABOLImpactVenture/iaap-guard/releases/tag/v1.0.0).

## Install and operate

- **App page:** https://github.com/apps/iaap-guard
- **Direct install:** https://github.com/apps/iaap-guard/installations/new
- **Product repository:** https://github.com/SAABOLImpactVenture/iaap-guard
- **Support policy:** https://github.com/SAABOLImpactVenture/iaap-guard/blob/v1.0.0/docs/SUPPORT.md
- **Upgrade and rollback:** https://github.com/SAABOLImpactVenture/iaap-guard/blob/v1.0.0/docs/UPGRADING.md
- **Known limits:** https://github.com/SAABOLImpactVenture/iaap-guard/blob/v1.0.0/docs/KNOWN-LIMITS.md
- **Frozen V1 contract:** https://github.com/SAABOLImpactVenture/iaap-guard/blob/v1.0.0/docs/V1-CONTRACT-FREEZE.md
- **Final validation:** https://github.com/SAABOLImpactVenture/iaap-guard/blob/v1.0.0/docs/PHASE-18-VALIDATION.md

## Product boundary

IaaP Guard evaluates repository and pull-request evidence through deterministic rules and publishes an `IaaP Guard / Architecture` Check. It requires only metadata read, contents read, pull-request read, and checks read/write permissions.

It does not require customer cloud, Kubernetes, Terraform/TFE, AI, or PAT credentials. It does not provision or reconcile infrastructure, execute repository code, mutate repositories, create or merge pull requests, auto-remediate findings, or make compliance, authorization, exception, deployment, or risk-acceptance decisions.

## Transition to Forge

Guard may supply deterministic findings, readiness, coverage, continuity, product-assessment, and evidence outputs to Forge as an input. Forge must preserve Guard's frozen schemas and authority boundary: Guard evidence can inform a proposal or block an unsafe transition, but it cannot grant infrastructure execution or approval authority.

Forge is the next product workstream. Its Crossplane and bounded Composite AI capabilities remain separate from Guard and preserve Guard's frozen authority boundary.

## Historical evidence

The former public-beta guide and commercial-discovery issues are superseded by the supported V1 release. Historical Phase 10–18 evidence remains available in the Guard repository. Closing those trackers records transition completion; it does not erase their history or reopen Guard.

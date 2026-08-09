# IaaP Guard Public Beta

> **IaaS is what you buy. Infrastructure-as-a-Product is what you build. IaaP Guard makes sure you keep building it that way.**

IaaP Guard is a GitHub-native Infrastructure-as-a-Product architecture and evidence guard. It evaluates pull-request changes through a deterministic rule catalog and publishes an `IaaP Guard / Architecture` Check directly in GitHub.

Its central question is:

> **Is this infrastructure actually being designed, delivered, and governed as a product?**

## Get the app

- **App page:** https://github.com/apps/iaap-guard
- **Direct install:** https://github.com/apps/iaap-guard/installations/new
- **Public beta feedback:** https://github.com/SAABOLImpactVenture/ai-powered-infrastructure-as-a-product/issues/111

GitHub Marketplace is not required for this public beta. The GitHub App itself is the distribution boundary.

## What happens after installation

1. Choose the repositories where IaaP Guard should be installed.
2. Open or update a pull request that changes architecture-relevant content.
3. IaaP Guard reads the pull-request metadata and the repository snapshot needed for deterministic analysis.
4. The existing deterministic Guard core evaluates the repository without executing repository code.
5. GitHub receives an `IaaP Guard / Architecture` Check with the conclusion, score, findings, rule IDs, evidence paths, and rule/scoring versions.

Current Check semantics:

- no relevant changes → `success`;
- Guard PASS → `success`;
- Guard WARNING → `neutral`;
- Guard FAIL → `failure`;
- experimental rules remain non-scoring and non-blocking.

## Permissions

The public beta requests only the repository permissions proven in Phase 10:

| Permission | Access | Why |
|---|---|---|
| Metadata | Read | Identify the installed repository. |
| Contents | Read | Read the immutable repository snapshot required for deterministic analysis. |
| Pull requests | Read | Read PR metadata and changed-file information. |
| Checks | Read/write | Publish and rerequest `IaaP Guard / Architecture` Checks. |

The App subscribes only to the bounded event surface needed by the beta:

- `pull_request` — opened, synchronize, reopened, ready-for-review behavior;
- `check_run` — rerequested behavior for manual reruns.

## What IaaP Guard does not receive or do

The beta does **not** require:

- cloud credentials;
- Kubernetes credentials;
- Terraform/TFE credentials or state access;
- AI/model credentials from the customer;
- broad PATs;
- Actions, Administration, Members, Issues, Deployments, Secrets, Workflows, or organization-management permissions.

The beta does **not**:

- provision or reconcile infrastructure;
- execute repository code;
- auto-remediate findings;
- create or merge pull requests;
- grant or change infrastructure privilege;
- administer branch protections or rulesets;
- produce AI-generated architecture verdicts.

Deterministic rules remain authoritative. Humans remain responsible for approval and merge decisions.

## What it is looking for

The V0 rule system is intentionally focused on Infrastructure-as-a-Product architecture/evidence boundaries rather than generic security scanning. Examples include:

- consumer contracts exposing implementation machinery such as Terraform/TFE workspace concepts;
- consumer-controlled platform lifecycle policy;
- storefront/experience layers directly provisioning infrastructure;
- AI receiving apply/delete/cloud-admin/credential authority;
- automation bypassing required human approval;
- storefront contracts broader than canonical product APIs;
- missing product abstraction, accountable ownership, deterministic governance evidence, or lifecycle/status/evidence paths;
- possible multiple-reconciler overlap as an experimental non-scoring signal.

IaaP Guard is not positioned as a replacement for Snyk, Checkov, GitHub Advanced Security, generic IaC vulnerability scanners, Crossplane, or Backstage.

## Proven beta behavior

Phase 10 proved the public GitHub App path on both an internal/private repository and a public repository using the same deterministic core. The evidence bundle is committed under [`artifacts/phase-10/`](../artifacts/phase-10/).

The live beta demonstrated:

- signed webhook delivery;
- GitHub App JWT authentication;
- short-lived repository-scoped installation tokens;
- repository snapshot acquisition;
- deterministic analysis with `iaap-guard/v0.1.2` and `coverage/v1`;
- PASS/success behavior;
- no-relevant-change/success behavior;
- WARNING/neutral behavior;
- critical FAIL/failure behavior;
- deterministic manual rerequest on the same immutable revision.

This proves installability and PR assessment. It does **not** prove production readiness, enterprise scale, regulatory authorization, live cloud provisioning, Marketplace readiness, or commercial demand.

## Public beta and commercial validation

Phase 11 is deliberately testing demand before building billing infrastructure or a larger SaaS control plane.

If you evaluate the beta, feedback on these questions is especially useful:

- Did the installation path make sense?
- Did the Check identify something architecturally useful?
- Were any findings false positives or false negatives?
- Would you keep IaaP Guard installed?
- What capability would make it substantially more valuable?
- Would you pay for expanded rule/evidence packs, organization-level visibility, governance integrations, support, an architecture assessment, or another capability?

Share safe feedback in the [public beta feedback issue](https://github.com/SAABOLImpactVenture/ai-powered-infrastructure-as-a-product/issues/111). Do not post secrets, private repository contents, confidential architecture, customer data, or personally identifying interview notes.

## Source and product boundary

The public `ai-powered-infrastructure-as-a-product` repository remains the thesis, architecture, governance, evidence, and acquisition front door. The IaaP Guard implementation repository can remain internal while the public GitHub App is independently installable.

The commercial moat is the accumulated Infrastructure-as-a-Product product knowledge, deterministic rules, evidence model, integrations, and operating model—not ownership of commodity GitHub, Crossplane, Backstage, Terraform, Kubernetes, or cloud technology.
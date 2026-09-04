# IaaP Guard Security and Compliance

This document describes the current security and compliance posture of the **IaaP Guard** public GitHub App beta.

It is intentionally limited to controls and boundaries that have been implemented and evidenced. It does **not** claim FedRAMP authorization, an ATO, SOC 2, ISO 27001, PCI DSS, HIPAA certification, or any other formal compliance certification.

## Security model

IaaP Guard is designed as a narrow GitHub-native architecture and evidence evaluator.

The App can:

- receive supported GitHub pull-request and Check Run webhook events;
- read repository metadata;
- read repository contents required for deterministic analysis;
- read pull-request metadata and changed-file information; and
- publish `IaaP Guard / Architecture` Check Runs.

The App does **not** receive authority to:

- write repository contents;
- create or merge pull requests;
- administer repositories, branch protections, rulesets, members, workflows, or Actions;
- access repository or organization secrets;
- provision or reconcile infrastructure;
- use customer cloud, Kubernetes, Terraform/TFE, or AI/model credentials; or
- produce AI-generated architecture verdicts.

Humans remain responsible for approval and merge decisions.

## GitHub permissions

The current public beta requests only:

| Permission | Access |
|---|---|
| Metadata | Read |
| Contents | Read |
| Pull requests | Read |
| Checks | Read/write |

No Actions, Administration, Members, Issues, Deployments, Secrets, Workflows, or organization-management permissions are requested.

## Authentication and tokens

IaaP Guard uses the GitHub App authentication model:

1. the service creates a signed GitHub App JWT;
2. GitHub issues a short-lived installation access token;
3. the token request is scoped to the repository being evaluated; and
4. the token is used only for the bounded GitHub API operations required for that evaluation.

The beta does not require a personal access token (PAT).

Installation access tokens are not committed to repositories and are not stored in a persistent customer database.

## Webhook integrity

Inbound GitHub webhook requests are verified using GitHub's `X-Hub-Signature-256` HMAC-SHA-256 signature before event processing.

Requests without a valid signature are rejected.

The webhook secret is stored outside the repository in AWS Secrets Manager.

## GitHub App private key

The GitHub App private key is stored in AWS Secrets Manager and is not committed to source control.

The runtime uses the private key only to sign the GitHub App JWT required to request short-lived installation tokens.

## Repository-content processing

IaaP Guard does not execute repository code.

For architecture-relevant pull requests, the service obtains the repository snapshot required by the deterministic scanner and evaluates supported configuration/document formats as data.

The current beta includes bounded snapshot guards, including limits on archive size, archive member count, and extracted size.

The service does not maintain a persistent customer-content database in the current beta architecture.

## Deterministic verdicts

Architecture verdicts are produced by a versioned deterministic rule catalog and scoring model.

AI is not used to determine PASS, WARNING, or FAIL results.

The Check output records the repository/revision identity and rule/scoring versions so results can be traced to an immutable input and a known evaluation contract.

## Runtime and service providers

The current beta runtime uses:

- **GitHub** for App installation, webhook delivery, repository and pull-request access, and Check Runs; and
- **Amazon Web Services (AWS)** for the stateless runtime and secret storage.

The current deployment does not require a persistent application database.

See the [IaaP Guard Privacy Policy](IAAP-GUARD-PRIVACY.md) for data-processing details.

## Incident handling

Security issues involving IaaP Guard should **not** be posted in the public beta feedback issue.

For a suspected vulnerability or security incident, use the publisher security/contact email configured in the GitHub Marketplace listing and clearly identify the report as an **IaaP Guard security report**. Do not include credentials, access tokens, private keys, or unnecessary customer repository contents in the initial report.

The publisher will investigate credible reports, contain confirmed issues, rotate affected credentials where necessary, and coordinate required notifications. For a confirmed security incident affecting the GitHub Marketplace integration, the operating objective is to notify GitHub within 24 hours in accordance with GitHub Marketplace security guidance.

## Dependency and change controls

IaaP Guard changes are developed through GitHub pull requests and validated by repository CI before merge.

The maintained program also records deterministic evidence for permissions, webhook validation, installation-token behavior, security boundaries, and live Check semantics.

Security fixes should correct the underlying defect rather than broaden permissions or weaken deterministic controls merely to make a test pass.

## Current compliance posture

The current public beta is **not represented as formally certified or authorized for regulated production use**.

In particular, the current beta does not claim:

- FedRAMP authorization;
- federal ATO;
- SOC 2 attestation;
- ISO 27001 certification;
- HIPAA certification;
- PCI DSS certification; or
- any agency-specific or industry-specific authorization.

Organizations remain responsible for evaluating IaaP Guard against their own security, privacy, procurement, risk-management, and authorization requirements before production use.

## Security boundary summary

```text
GitHub App
  = observe supported GitHub events
  + read bounded repository/PR data
  + publish architecture Check Runs

IaaP Guard deterministic core
  = classify artifacts
  + evaluate versioned rules
  + produce architecture/evidence verdict

Human
  = approve and merge

Crossplane / other infrastructure reconciler
  = reconcile infrastructure desired state

Cloud-native controls
  = enforce ultimate infrastructure authorization boundary
```

IaaP Guard intentionally remains outside the infrastructure provisioning authority chain.

## Related documents

- [IaaP Guard Public Beta](IAAP-GUARD.md)
- [IaaP Guard Privacy Policy](IAAP-GUARD-PRIVACY.md)
- [Phase 10 security-boundary evidence](https://github.com/InfrastructureProductWorks/ai-powered-infrastructure-as-a-product/blob/main/artifacts/phase-10/security-boundary.json)
- [Phase 10 app-permissions evidence](https://github.com/InfrastructureProductWorks/ai-powered-infrastructure-as-a-product/blob/main/artifacts/phase-10/app-permissions.json)
- [Phase 10 installation-token evidence](https://github.com/InfrastructureProductWorks/ai-powered-infrastructure-as-a-product/blob/main/artifacts/phase-10/installation-token-evidence.json)

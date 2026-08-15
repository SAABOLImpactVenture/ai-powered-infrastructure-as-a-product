# IaaP Guard Privacy Policy

**Effective date:** August 8, 2026

This Privacy Policy describes how the current **IaaP Guard public beta** processes information when the IaaP Guard GitHub App is installed on a GitHub account or organization and evaluates pull requests.

IaaP Guard is operated through the `SAABOLImpactVenture` GitHub organization. The current beta is intentionally narrow: it evaluates repository architecture/evidence using deterministic rules and publishes an `IaaP Guard / Architecture` Check in GitHub.

## 1. Information IaaP Guard processes

To provide the service, IaaP Guard may process the GitHub information necessary to identify an installation, evaluate a pull request, and publish a Check Run, including:

- GitHub installation, account, organization, and repository identifiers and names;
- pull-request numbers, refs, head revisions/commit SHAs, and event/action metadata;
- changed-file names and related pull-request metadata;
- repository file contents needed to create the immutable repository snapshot used for deterministic analysis;
- IaaP Guard Check Run identifiers, conclusions, scores, rule IDs, findings, and evidence paths;
- GitHub webhook delivery identifiers and request metadata; and
- limited operational or diagnostic information generated while processing a request.

IaaP Guard does **not** ask customers to provide cloud, Kubernetes, Terraform/TFE, or AI/model credentials.

## 2. GitHub permissions

The current beta requests only these repository permissions:

| Permission | Access | Purpose |
|---|---|---|
| Metadata | Read | Identify the installed repository and installation context. |
| Contents | Read | Read the repository snapshot required for deterministic analysis. |
| Pull requests | Read | Read pull-request metadata and changed-file information. |
| Checks | Read/write | Publish and support rerequest of `IaaP Guard / Architecture` Checks. |

The beta is not granted Actions, Administration, Members, Issues, Deployments, Secrets, Workflows, or organization-management permissions.

## 3. How information is used

IaaP Guard uses the information it processes to:

- verify and handle supported GitHub webhook events;
- obtain the repository and pull-request content needed for analysis;
- classify architecture/evidence artifacts;
- evaluate the versioned deterministic IaaP Guard rule catalog;
- publish PASS, WARNING, FAIL, or no-relevant-change Check results in GitHub;
- support manual Check rerequests; and
- operate, troubleshoot, secure, and improve the beta service.

The current beta does not use AI-generated verdicts. Repository contents are evaluated by the deterministic IaaP Guard core.

## 4. What IaaP Guard does not do

The current beta does **not**:

- execute repository source code;
- provision or reconcile infrastructure;
- create or merge pull requests;
- auto-remediate findings;
- administer branch protections or repository rulesets;
- request broad personal access tokens from customers;
- access customer cloud, Kubernetes, Terraform/TFE, or AI/model credentials;
- maintain a persistent customer-content database; or
- sell customer repository content or personal information.

## 5. Storage and retention

The current V0 runtime is stateless and does not maintain a persistent customer database.

Repository snapshots required for a scan are fetched for analysis and processed in temporary runtime storage. The service is designed to discard that temporary analysis workspace after processing rather than retaining repository snapshots as a customer data store.

GitHub Check results and pull-request information remain in GitHub according to GitHub's own product behavior and retention policies.

The hosting environment may create operational logs for reliability, security, and troubleshooting. Those logs may contain limited metadata such as delivery identifiers, repository identifiers, pull-request numbers, processing status, and error information. Log retention is governed by the current hosting configuration and may be adjusted as the service evolves.

## 6. Authentication and secrets

IaaP Guard uses the GitHub App authentication model:

- the App authenticates to GitHub using its App identity;
- repository access uses GitHub-issued, short-lived installation tokens scoped to the installed repository; and
- customer personal access tokens are not required.

The App private key and webhook secret are stored in AWS Secrets Manager and are not committed to the public evidence repository.

## 7. Service providers

The current beta relies on service providers necessary to operate the GitHub App, including:

- **GitHub**, for App installation, repository and pull-request access, webhook delivery, authentication, and Check Runs; and
- **Amazon Web Services (AWS)**, for the current stateless runtime and secret storage.

Those providers process information under their own terms and privacy practices.

## 8. Security controls

The current beta uses controls intended to keep its authority narrow, including:

- GitHub webhook signature verification;
- short-lived, repository-scoped installation tokens;
- least-privilege GitHub permissions;
- no repository code execution;
- no customer infrastructure credentials;
- no merge or repository administration authority; and
- bounded repository-snapshot size and extraction guards.

No internet service can guarantee absolute security, but the beta is designed to minimize the data and authority required to perform its function.

## 9. Uninstalling IaaP Guard

You may remove or restrict the IaaP Guard installation through GitHub's App installation settings.

After uninstalling the App, IaaP Guard can no longer use that installation to obtain new repository content or publish new Checks. Historical Check results and pull-request records that already exist in GitHub may remain in GitHub according to GitHub's behavior and repository settings.

## 10. Privacy and deletion requests

For non-sensitive product questions or beta feedback, use the public feedback thread:

https://github.com/SAABOLImpactVenture/ai-powered-infrastructure-as-a-product/issues/111

**Do not post sensitive personal information, private repository content, credentials, or confidential architecture in a public GitHub issue.**

For a sensitive privacy, access, or deletion request, use the contact email published with the IaaP Guard GitHub App or GitHub Marketplace listing.

Depending on your jurisdiction, you may have rights relating to personal information, including access, correction, deletion, or restriction. Requests will be evaluated based on the information actually controlled by IaaP Guard and the responsibilities of GitHub or other service providers.

## 11. Changes to this policy

This policy describes the current public-beta architecture. If IaaP Guard materially changes how it collects, stores, uses, or shares information, this policy will be updated before or with that material change.

A future Marketplace listing, paid plan, analytics capability, persistent customer data store, or materially broader product surface may require additional privacy disclosures and controls.

## 12. Current product boundary

This Privacy Policy does not claim that IaaP Guard is production-certified, FedRAMP authorized, compliance-certified, or suitable for every regulated workload. The public beta proves GitHub-native installability and deterministic pull-request assessment within the documented least-privilege boundary.

For product behavior and installation details, see [IaaP Guard Public Beta](IAAP-GUARD.md).

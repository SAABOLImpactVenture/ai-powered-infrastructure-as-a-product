SPDX-License-Identifier: Apache-2.0

# Security Policy

## Supported branches

* `main`: actively maintained; security fixes released via patch tags.
* Release branches `release/*`: supported for 6 months after cut.

## Reporting a vulnerability

Please email **[security@saabolimpactventure.org](mailto:security@saabolimpactventure.org)** with:

* Affected component/path and version/commit
* Reproduction steps or PoC
* Impact assessment (CIA), CVSS (if available)

We commit to:

* Triage within **3 business days**
* Provide a remediation plan within **10 business days**
* Credit reporters if desired

## Disclosure

We follow **coordinated disclosure**. We will publish advisories via GitHub Security Advisories and tag patched releases.

## Hardening & protections

* **Branch protection**: required reviews; required checks (lint, tests, policy gates); signed commits.
* **Secret scanning**: GitHub secret scanning and `gitleaks` in CI.
* **Dependency security**: Dependabot/`pip-audit`/`npm audit` as applicable; fail builds on high/critical vulns.
* **Build provenance**: Artifact signing with **Cosign**; SBOM generation with `syft` uploaded to releases.
* **Runtime**: No plaintext secrets; KMS-managed keys; least privilege IAM; network egress control.

## Vulnerability remediation SLAs

* **Critical**: patch or mitigation within **72 hours**
* **High**: within **14 days**
* **Medium**: within **30 days**
* **Low**: best effort

## Cryptographic signing

Container images and release artifacts are signed with **Sigstore Cosign**. Verify:

```bash
cosign verify ghcr.io/saabolimpactventure/ai-powered-infrastructure-as-a-product:<tag>
```

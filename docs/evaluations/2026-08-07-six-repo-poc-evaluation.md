# Six-Repository Infrastructure-as-a-Product POC Evaluation

- **Evaluation date:** 2026-08-07
- **Scope:** complete six-repository POC estate
- **Evaluation type:** source, contract, boundary, CI, evidence, reproducibility, and documentation review
- **Production-readiness claim:** **No.** Scores below measure POC quality and architectural evidence, not authorization or production readiness.
- **Reference successful run:** [`31210928432`](https://github.com/SAABOLImpactVenture/multicloud-foundation-poc-integration/actions/runs/31210928432)
- **Tested integration commit:** `3984c0dde508be10b0e07ddcdac319bd996efcde`

## Executive conclusion

The six repositories now tell a coherent Infrastructure-as-a-Product story:

> **Backstage captures product intent; bounded composite AI interprets and proposes; deterministic policy decides admissibility; people own approval; Crossplane owns reconciliation; cloud-native services realize the product; GitHub and the integration harness preserve evidence.**

The architecture supports the existing decision that Terraform Enterprise is **not mandatory for the demonstrated credential-free product path**. Nothing found in this evaluation reverses that conclusion.

The system is nevertheless **not ready to move directly from the current POC to a production claim**. The strongest remaining issues are not about whether Crossplane works. They are about **contract consistency, proof semantics, comparison neutrality, and supply-chain reproducibility**.

The most important finding is that a request can currently be valid in the Backstage storefront but invalid in the AI/product contract. The integration scenarios do not exercise those boundary values, so the overall 100/100 score does not detect the mismatch. This is exactly why a portfolio-level evaluation is necessary in addition to per-repository CI.

## Evaluation rubric

Each repository is assessed across five equal dimensions, 20 points each:

1. **Role clarity and architecture** — bounded responsibility and alignment to the product-system model.
2. **Security and authority** — credential boundaries, least privilege, fail-closed behavior, and execution separation.
3. **Contract and dependency integrity** — stable interfaces, compatibility, dependency direction, and drift resistance.
4. **Validation and evidence** — meaningful tests, negative cases, runtime proof, evidence quality, and teardown.
5. **Reproducibility and maintainability** — immutable dependencies, documentation currency, ownership clarity, and operational sustainability.

The score is a POC engineering-quality indicator only. It is not a compliance, ATO, security certification, or production-readiness score.

## Repository scorecard

| Repository | Score | Assessment | Primary reason it is not higher |
|---|---:|---|---|
| `crossplane-multicloud-seed-poc` | **88/100** | Strong | Tool-download supply-chain integrity and one stale handoff example. |
| `multicloud-foundation-product-poc` | **80/100** | Good, with material corrections required | Product-contract leakage/validation gaps and biased example TFE comparison data. |
| `composite-ai-infrastructure-product-poc` | **87/100** | Strong | Deterministic provider only, duplicated contract rules, and some stale portfolio language. |
| `backstage-infrastructure-product-storefront-poc` | **76/100** | Good POC, weakest contract alignment | Storefront/product schema mismatch; no real Backstage/PR/status runtime proof yet. |
| `multicloud-foundation-poc-integration` | **90/100** | Strongest evidence repository | Approval is asserted, not exercised; build dependencies are not fully immutable. |
| `ai-powered-infrastructure-as-a-product` | **88/100** | Strong program/governance hub | The successful Backstage-inclusive baseline is not yet frozen and some gate language is stale. |

**Portfolio POC engineering-quality score: 85/100.**

The portfolio score should not be increased by adding more features. The fastest route upward is to remove ambiguity and close the contract/evidence defects listed below.

---

## 1. `crossplane-multicloud-seed-poc` — 88/100

**Current HEAD:** `2afa74322adddda5b24f6ad1dc04ec05de0d7aa0`

### What is strong

The seed has a disciplined boundary. It installs the Crossplane runtime and a POC namespace, but explicitly refuses to own product XRDs, Compositions, cloud credentials, production, an AI runtime, a portal, or a mandatory TFE path. The composite-AI service account is deliberately created without useful API authority or a token mount. The seed also distinguishes declaration of a `NetworkPolicy` from actual dataplane enforcement and includes active ingress/egress probes.

The portability proof is meaningful: Kubernetes 1.34, 1.35, and 1.36 Kind node images are digest-pinned, and the integration baseline exercises the seed on all three versions with network-policy validation in `require` mode.

### Findings

**P1 — downloaded tool binaries are version-pinned but not integrity-verified.** `scripts/install-tools.sh` downloads Kind, kubectl, and Helm directly and executes them without checksum/signature verification. Version pinning is not the same as artifact integrity. This matters because the integration harness depends on the same installer.

**P2 — CI dependencies are not fully immutable.** GitHub Actions are referenced by major tags, PyYAML is installed without an exact version/hash, and the network probe uses `busybox:1.36.1` without a digest. This weakens repeatability relative to the otherwise strong immutable-upstream story.

**P2 — default network-policy mode is `warn`.** The documentation correctly explains the difference, and the integration harness overrides it to `require`, so this is not a failure. It is still important that standalone seed evidence never be described as proof of isolation unless `require` was used.

**P2 — the seed-to-product README example is stale.** It shows `profile: standard`; the actual product XRD accepts only `standard-dev`.

### Disposition

Keep the seed small. Do not add product functionality here. Harden its artifact verification and correct the handoff example.

---

## 2. `multicloud-foundation-product-poc` — 80/100

**Current HEAD:** `164fe8d9d5e7698770f056e5daac3125d9a2c247`

### What is strong

This repository has the clearest product-control-plane implementation. `CloudFoundationEnvironment` is namespaced, development-only, AWS/GCP bounded, and protected by schema/CEL validation plus admission tests. The simulated implementation is separated from the live-sandbox implementation, and the repository includes runbooks, known-error records, contract tests, runtime tests, and teardown support.

The product contract is demonstrably independent of Terraform/TFE. The successful integration baseline proves reconciliation and lifecycle behavior without cloud credentials.

### Findings

**P1 — the public product API leaks platform implementation fields.** `networkCidr`, `subnetCidr`, and `deletionPolicy` are writable fields on the XRD even though the product story says ordinary consumers should not choose raw network implementation details. Backstage hides those fields, but API/CLI consumers can still set them. If these are platform-owned concerns, they should move behind profile/IPAM/lifecycle policy rather than remain part of the stable consumer contract.

**P1 — CIDR validation is syntactic but not semantically safe.** The regular expressions permit octets such as `999`, and the schema does not prove that the subnet is contained by the network. This is harmless in the ConfigMap simulation but can fail late in a live provider path.

**P1 — the TFE comparison example violates the repository's own evidence rule.** `docs/TFE_OPTIONALITY_EXPERIMENT.md` says every metric must come from an observed run and that scores must not be awarded from preference. However, `comparison/scenario-results.example.yaml` pre-scores Crossplane and TFE while much of its evidence literally says `Replace with ...`. `tests/test_comparison.py` treats any non-empty evidence string as sufficient, and `make compare` computes the weighted scores. This creates avoidable methodological bias and could undermine the credibility of the TFE investment conclusion. The example should use `null`/unscored values until observed evidence exists, or be unmistakably labeled synthetic and rejected by the production scoring path.

**P2 — live workload identity is a placeholder, not a proven workload path.** The AWS role has a deny-all trust policy; the GCP service account has no workload identity binding. That is an appropriate safe placeholder, but documentation must not imply functional workload identity has been proven.

**P2 — encryption is not explicitly configured in the live composition.** Cloud defaults may provide encryption at rest, but the composition does not create explicit encryption configuration/evidence. Any regulated/live claim should distinguish reliance on provider defaults from an explicit product guardrail.

**P2 — package references use semantic-version tags rather than content digests.** This is acceptable for exploration but weaker than the evidence model's otherwise immutable posture.

**P2 — AI ownership overlaps the dedicated AI repository.** The product repo still carries an `ai/` tree with prompt/tool-boundary material while the portfolio says the composite-AI repository owns agent contracts and evaluations. Keep only the product-facing interface contract here or explicitly define which AI artifacts are normative.

### Disposition

This repository should remain the owner of the infrastructure product contract. The next changes should **reduce** consumer-visible implementation detail and make the comparison experiment evidence-neutral before live-cloud testing.

---

## 3. `composite-ai-infrastructure-product-poc` — 87/100

**Current HEAD:** `08af22093ee69c683948175512ca800f75fecab9`

### What is strong

The authority model is excellent for a POC. Allowed and denied tools are explicit; kubectl, Helm, Terraform/OpenTofu, TFE runs, cloud-admin operations, secret reads, resource apply/delete, approval, merge, and PR creation are denied. Tests cover prompt injection, secret redaction, missing metadata, unsafe regions/production, path traversal, and authority expansion.

The repository also makes an important methodological choice explicit: CI uses an **offline deterministic agent provider** so security and policy behavior can be proven independently of model drift and credentials.

### Findings

**P1 — this proves the AI control architecture, not live-model quality.** No live LLM/model adapter participates in the successful baseline. Claims should therefore say that the bounded agent/orchestration/authority design is proven. Model usefulness, hallucination behavior, latency, cost, and model-specific prompt-injection resistance remain future evidence gates.

**P1 — contract rules are duplicated across repositories.** Cloud/region rules, owner/cost-center constraints, and product request shapes are separately implemented in the product, AI, storefront, and integration repositories. The current storefront mismatch proves that manual duplication has already drifted. The AI layer should validate against a generated or shared product contract rather than independently restating it wherever practical.

**P2 — portfolio language is stale.** The README still describes this as the "fourth piece" and refers to a later TFE experiment, while the current portfolio includes the independent Backstage storefront, the completed integration run, and an accepted TFE optionality ADR.

**P2 — evidence hashes are not signed attestations.** SHA-256 hashes support integrity checks after collection but do not prove who produced the evidence or protect against an actor who can rewrite both evidence and hashes. Signed provenance belongs in a later live/production gate.

**P2 — CI references mutable action tags and `ubuntu-latest`.** The same reproducibility issue appears here as elsewhere in the portfolio.

### Disposition

Preserve the no-execution boundary when a live model adapter is introduced. A model adapter should be replaceable without changing tool authority or deterministic policy.

---

## 4. `backstage-infrastructure-product-storefront-poc` — 76/100

**Current HEAD:** `2c3ea43cabb57de016b9a6bcbb8cf14ea4fde0eb`

### What is strong

The repository has the right architectural role: it is a storefront, not a provisioner. The template exposes only product/business inputs, the renderer fails closed on unknown fields, and the repository contains no cloud/Kubernetes/TFE execution path. The design correctly separates an `InfrastructureProductOrder` from the runtime `CloudFoundationEnvironment` API.

### Findings

**P1 — storefront-valid values can be invalid downstream.** This is the most concrete cross-repo defect found in the audit:

- Storefront `owner` validation permits a two-character value; the product XRD requires at least three characters.
- Storefront `costCenter` permits two characters and allows `.`, while the product XRD requires at least three characters and permits only letters, numbers, `_`, and `-`.
- The AI policy also rejects the dot character.

Therefore a developer can submit an order that is valid according to the storefront but is later rejected by AI policy or Kubernetes admission. The existing happy-path integration scenarios do not cover these boundary values.

**P1 — actual Backstage execution is not yet proven.** CI validates the YAML/template and local renderer, but it does not start Backstage, import the template into a Backstage instance, execute `publish:github:pull-request`, or verify the resulting PR. The POC proves the **storefront contract and template design**, not a deployed Backstage runtime.

**P1 — tracking is still a target design.** The developer-experience document correctly labels the status view as the target product experience. There is no implemented read-only Backstage status/evidence plugin or adapter yet. The demonstrated capabilities are currently **browse/configure/order contract**, not full browse/configure/order/track runtime behavior.

**P2 — the lock file has confused dependency direction.** `config/upstreams.lock.json` records the seed, product, AI, integration, and coordinating architecture. In particular, it pins the integration repository even though integration consumes the storefront. This creates a conceptual dependency cycle and the pinned integration/architecture commits are already stale. Split true build/runtime dependencies from historical evidence/baseline references.

**P2 — orders are written into the storefront source repository.** This is acceptable for a POC but couples storefront code governance to order-record churn. A scaled design should use a dedicated orders/desired-state repository or strongly protected path/branch policy.

**P2 — real GitHub publication credentials are not modeled.** A deployed Backstage instance will need permission to open PRs. That permission is less powerful than cloud execution but is still a credentialed mutation boundary and should have an explicit least-privilege design.

**P2 — region support is intentionally narrower than the product contract.** Storefront supports one region per cloud while the product/AI allow two. That can be a valid product choice, but it should be described as an intentional storefront subset rather than an accidental mismatch.

### Disposition

Before adding more catalog products, make one order contract genuinely canonical and add schema-conformance tests that prove every storefront-valid order is valid for the AI/product layer.

---

## 5. `multicloud-foundation-poc-integration` — 90/100

**Current HEAD:** `207357972bad7b44e8e7a8ae962dda89620255d0`

**Runtime-tested baseline commit:** `3984c0dde508be10b0e07ddcdac319bd996efcde`

The five commits after the tested baseline are documentation and manifest updates only (`README.md`, `docs/BOUNDARIES.md`, `docs/GITHUB_SETUP.md`, and `MANIFEST.sha256`). Runtime behavior has not changed since the successful run.

### What is strong

This is the strongest evidence repository in the portfolio. Run `31210928432` passed Kubernetes 1.34, 1.35, and 1.36 at **100/100** with exact upstream locks, active network-policy probes, storefront-to-AI handoff, deterministic denials, AI authority checks, simulated product reconciliation, evidence collection, and zero-orphan teardown.

The current evidence artifacts are:

| Kubernetes | Artifact ID | SHA-256 |
|---|---:|---|
| 1.34 | `9006702474` | `15d9377ec8183e93867cdd9c8614cee97e8d2cb8a0d9f4ef1a9b63ccd9e2b839` |
| 1.35 | `9006703569` | `6f4e158851895afb2b76a550d055f596dc3469ea55e91665194d449b7659d379` |
| 1.36 | `9006705030` | `baae3ded10ec9fcb9aa349e48dc3b58128f42303bfa345e3c4a3fb0c6c130542` |

### Findings

**P1 — human approval is asserted, not exercised.** `verify_storefront_handoff.py` proves that the AI result says `human-required` and that the PR proposal requires human approval. The integration script then directly executes `kubectl apply` on the generated manifest. This is correct for an automated credential-free test harness, but it does **not** prove an actual GitHub approval/merge event or a human-gated GitOps reconciler. Evidence language should say **"human-approval boundary encoded and preserved"**, not "human approval executed end-to-end."

**P1 — the actual Backstage PR action is not in the end-to-end path.** The harness imports the storefront renderer directly from source. It does not run Backstage or consume a real PR created by `publish:github:pull-request`.

**P1 — immutable source commits do not yet mean an immutable build.** The workflow uses `actions/checkout@v4`, `actions/setup-python@v5`, `actions/upload-artifact@v4`, `ubuntu-latest`, and an unpinned PyYAML install. The seed then downloads Kind/kubectl/Helm without checksum verification. A future run at the same six source SHAs can therefore execute different third-party bits.

**P2 — the scorecard does not include cross-schema conformance.** The storefront/product owner and cost-center mismatch passed unnoticed because the matrix uses valid example values. Add generated boundary/fuzz cases or a formal schema-compatibility control.

**P2 — evidence is retention-bound and unsigned.** Digests preserve identity after GitHub Actions artifacts expire, but the bytes themselves are not durably preserved in this repository and there is no signed provenance/attestation.

### Disposition

Retain this repository as the executable evidence authority. Do not turn it into a source-of-truth implementation repository. Add controls only when they prove a portfolio boundary that cannot be proven within a component repo.

---

## 6. `ai-powered-infrastructure-as-a-product` — 88/100

**Current HEAD:** `2063967124f70ca7dd78c7a0ac68714fac329697`

### What is strong

The coordinating repository has improved materially. The legacy embedded Terraform/TFE/Arc/Backstage/MCP implementation stack is no longer carried beside the modern reference architecture on `main`; it is preserved on `archive/legacy-accelerator-v1`. ADR-0005 clearly records the supersession decision. The current README, thesis, interoperability model, TFE investment framing, and portfolio boundaries now tell one architectural story.

The repository is appropriately the front door for thesis, architecture, decisions, portfolio boundaries, and frozen evidence rather than another runtime monolith.

### Findings

**P1 — the newest successful baseline is not frozen here.** The existing immutable baseline still points to run `31136204337`, before the independent Backstage storefront was part of the matrix. The newer run `31210928432` is the first successful 1.34/1.35/1.36 **storefront-inclusive** end-to-end proof and should be preserved as a new baseline rather than overwriting the old historical record.

**P1 — evidence-gate documentation is behind reality.** `docs/poc-portfolio.md` says storefront-to-product integration is implemented and should be validated as part of the current matrix. That validation has now passed. The gate should be marked passed with the exact run/commit/artifact evidence.

**P2 — some architecture language describes target responsibility rather than demonstrated runtime behavior.** In particular, "track" and "human approval" should distinguish target/encoded boundaries from executed Backstage status and real approval events.

**P2 — CI action references are tag-based rather than SHA-pinned.** The program hub has stronger dependency hygiene than most component repos, but GitHub Actions themselves remain mutable references.

### Disposition

Freeze the new storefront-inclusive baseline, preserve the earlier baseline as historical proof, and use this evaluation as the gate between **credential-free architecture proof** and the next live evidence program.

---

# Cross-repository findings

## P1. Establish one canonical contract and compatibility test

The current system has at least four manually maintained representations of the same product intent:

- Backstage order/template/renderer rules;
- composite-AI request schema and deterministic policy;
- `CloudFoundationEnvironment` XRD/CEL schema;
- integration adapter/contract comparison code.

The first real drift has already occurred in `owner` and `costCenter` constraints. The portfolio should define a canonical source or generated compatibility layer so **every storefront-valid order is guaranteed to be acceptable by the downstream contract**.

A useful acceptance rule is:

> For every value accepted by the storefront schema, either the AI/product schema accepts it or the storefront explicitly narrows it before submission. No downstream rejection may exist solely because schemas drifted.

## P1. Make the evidence language match the actual proof

The current POC proves:

- an importable Backstage template and bounded order contract;
- a storefront-to-AI adapter path;
- an encoded human-approval requirement;
- deterministic AI/policy authority boundaries using an offline provider;
- Crossplane reconciliation to simulated AWS/GCP product components;
- clean teardown.

It does **not** yet prove:

- a deployed Backstage runtime;
- successful execution of the real GitHub PR scaffolder action;
- an actual human approval/merge event;
- a GitOps controller consuming that approved PR;
- a live model adapter;
- live AWS/GCP infrastructure;
- production authorization.

These are not weaknesses in the architecture. They are evidence gates that must remain explicit.

## P1. Harden supply-chain reproducibility before the live-cloud gate

At minimum:

- verify Kind/kubectl/Helm downloads by published checksum/signature;
- pin GitHub Actions to immutable commit SHAs;
- pin Python dependencies and preferably hashes;
- digest-pin probe/container/package artifacts where practical;
- capture tool/package versions and digests in the evidence bundle.

The current exact repository SHAs are strong, but they do not by themselves make a run reproducible.

## P1. Remove synthetic bias from the TFE comparison

The comparison methodology says evidence must be observed, but the example result file contains favorable Crossplane scores and lower TFE scores before the TFE lane has been measured. Replace that example with unscored/null data, or make the scorer reject evidence strings containing placeholders such as `Replace with`.

The architecture has already proven that TFE is not mandatory for the simulated path. The remaining investment comparison will be more credible if it is visibly neutral.

## P1. Freeze the Backstage-inclusive baseline

Create a new immutable baseline in the coordinating repository for:

- integration commit `3984c0dde508be10b0e07ddcdac319bd996efcde`;
- workflow run `31210928432`;
- storefront `2c3ea43cabb57de016b9a6bcbb8cf14ea4fde0eb`;
- seed `2afa74322adddda5b24f6ad1dc04ec05de0d7aa0`;
- product `164fe8d9d5e7698770f056e5daac3125d9a2c247`;
- composite AI `08af22093ee69c683948175512ca800f75fecab9`;
- all three artifact IDs and SHA-256 digests recorded above.

Do not overwrite `credential-free-multicloud-foundation-v1`; retain it as the pre-storefront historical baseline.

## P2. Clean the dependency graph

The intended graph is acyclic:

```text
seed ───────┐
product ────┼─> integration ─> coordinating evidence baseline
AI ─────────┤
storefront ─┘

storefront -> product contract
storefront -> AI request contract (integration boundary)
```

The storefront should not treat the integration harness as an upstream dependency. Historical evidence references belong in a separate baseline/evidence section rather than an `upstreams.lock.json` used to imply build dependency.

## P2. Decide which consumer fields are truly product-level

`networkCidr`, `subnetCidr`, and possibly `deletionPolicy` should be reviewed against the product thesis. If platform teams own IPAM and lifecycle defaults, those values should be hidden behind a product profile/policy rather than exposed on the stable consumer API.

## P2. Add durable, signed evidence later

For the live AWS/GCP gates, add provenance beyond plain hashes:

- GitHub artifact attestations or equivalent signed provenance;
- durable evidence retention outside expiring workflow artifacts;
- explicit tool/package digests;
- linkage from order/change/approval to runtime evidence.

---

# Recommended gate sequence after corrections

1. **Portfolio contract/reproducibility correction gate** — fix P1 findings in this evaluation and rerun the credential-free matrix.
2. **Backstage runtime smoke gate** — launch a real Backstage instance, import the template, open a real order PR, and prove read-only status/evidence presentation without infrastructure authority.
3. **Live AWS sandbox gate** — workload identity, namespaced ProviderConfig, real Crossplane reconciliation, policy/evidence, and deterministic teardown.
4. **Live GCP sandbox gate** — repeat only after AWS is repeatable.
5. **Live model adapter gate** — preserve the same tool/authority policy while measuring model quality, cost, latency, and injection behavior.
6. **Residual TFE comparison** — run observed TFE and Crossplane scenarios with neutral scoring and actual cost/operational evidence.
7. **Production pilot decision** — authorization, identity, recovery, SLOs, support model, audit, evidence retention, and ownership.

# Final assessment

The portfolio has crossed an important line: it is no longer a collection of architecture claims. It is an **executable, evidence-producing product-system POC** with clean separation between experience, intelligence, product contract, control plane, bootstrap, governance, and acceptance.

The next maturity gain should come from tightening the seams, not adding more technology.

> **The architecture is strong enough to continue. The evidence is strong enough to defend the POC conclusion. The contracts and supply chain now need to become as disciplined as the architecture.**

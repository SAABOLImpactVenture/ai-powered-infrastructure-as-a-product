# CI + IaC Hardening Fixes (Ready to Commit)

This pack replaces brittle patterns and encodes secure defaults across CI, Terraform, Kubernetes, and evidence handling.

## Validate jobs: no backend access
All validate steps now use:
```
terraform init -input=false -backend=false
terraform validate
```

## Scanners are gates (no `|| true`)
`tflint`, `checkov`, and `conftest` **fail** the job on violations; Checkov uploads **SARIF** to Code Scanning.

## No curl-pipe installs
Pinned setup actions or checksum-verified downloads across workflows (see `ci-matrix.yml`, `conftest-docker.yml`, `e2e-suite.yml`).

## Job hardening everywhere
Each job adds:
```
permissions:
  contents: read
  id-token: write
concurrency: ci-${{ github.workflow }}-${{ github.ref }}
```

## No auto-approve applies
`policy-aws.yml` / `policy-oci.yml` split into `plan` → `apply` with a **protected environment** (no `-auto-approve`).

## Kubernetes policy apply
`policy-k8s.yml` authenticates via **OIDC** (AKS example) and retries `kubectl apply`; waits for admission controllers.

## Provider pinning
Pinned to `~> 5.62` for AWS examples; commit `.terraform.lock.hcl` after first init.

## Remote state: persistent and locked
Added backend blocks under `stacks/*/backend.tf`. Use CMK/KMS-backed backends provisioned by your platform stacks.

## Composite action: signed requests
`.github/actions/plan-policy-apply/` requires **Bearer** token; no unauthenticated curl calls.

## Bicep toolchain pinned
`ci-bicep-validate.yml` pins Bicep `0.31.92` before build.

## K8s deployment hardening
`k8s/examples/deployment-hardened.yaml` shows secure defaults: probes, resources, non-root, RO FS, PDB, digest deploys.

## Evidence bucket KMS-backed
`evidence/immutable/aws/main.tf` now uses **SSE-KMS** with rotation and **Object Lock** (COMPLIANCE, 365d).

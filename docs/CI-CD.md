# H. CI/CD for Backstage itself

This pack delivers CI, Release, Deploy, and Evidence workflows for the Backstage monorepo.

## Workflows
- `backstage-ci.yml`: lint/test -> build images (app+backend) -> SBOM -> Trivy SARIF -> Cosign sign.
- `backstage-release.yml`: on tag `v*.*.*`, build/push versioned images, sign, and attach repo SBOM to the GitHub Release.
- `backstage-deploy.yml`: Helm upgrade using the chart in `charts/backstage`, supports `dev|stage|prod` values, emits rollout evidence.
- `backstage-evidence.yml`: consolidates SARIF -> OSCAL and commits under `evidence/latest`.

## Registry
Defaults to **GHCR** (`ghcr.io/<org>`). To use another registry, set:
- `REGISTRY` (e.g., `index.docker.io`)
- `REGISTRY_USERNAME`, `REGISTRY_PASSWORD` (repo or org secrets)

## Kubernetes access
Provide `KUBECONFIG_B64` as a base64-encoded kubeconfig secret for the target cluster/namespace.
The deploy workflow will run Helm diff/upgrade and wait for rollout.

## Evidence
Artifact downloads + `scripts/oscal/sarif_to_oscal.py` (from earlier steps) generate an OSCAL POA&M JSON.

## Secrets required
- For CI/Release: (optional) `REGISTRY`, `REGISTRY_USERNAME`, `REGISTRY_PASSWORD`
- For Deploy: `KUBECONFIG_B64`
- For TechDocs publishing (separate workflow from step E): `TECHDOCS_*`

## Usage
1. Push a branch/PR -> `backstage-ci` runs and pushes `:sha` and `:latest` images if on main/master.
2. Tag a release `vX.Y.Z` -> `backstage-release` builds & signs `:X.Y.Z` images and publishes SBOM.
3. Run `backstage-deploy` (workflow dispatch) with `environment=prod`, `imageTag=X.Y.Z` -> Helm upgrade in the cluster.
4. `backstage-evidence` collects reports and updates `evidence/latest`.

These workflows adhere to FedRAMP/NIST controls (supply chain transparency, vulnerability management, change control, and evidence generation).

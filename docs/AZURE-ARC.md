# Azure Arc Enablement for Kubernetes (Repo Integration)

This pack adds Azure Arc support so your Kubernetes cluster (AKS or non-AKS) is connected to Azure for:
- **GitOps** with Flux v2 (managed by Azure Arc)
- **Azure Policy** at cluster scope
- **Azure Monitor** Container Insights (AMA)
- Placement in this repo that dovetails with your Backstage, Gatekeeper, and AKS assets

## Folder Structure
- `scripts/arc/`
  - `connect-k8s.sh` — Connects the current kubecontext cluster to **Azure Arc**.
  - `enable-gitops-flux.sh` — Installs Flux extension and creates **k8s-configuration** objects pointing to this repo’s `gitops/arc/*` paths.
  - `enable-azure-policy.sh` — Installs Azure Policy extension and assigns a built-in or custom initiative.
  - `enable-azure-monitor.sh` — Installs Azure Monitor (AMA) containers extension and binds to a **Log Analytics Workspace**.
- `gitops/arc/`
  - `cluster/` — Baseline namespaces and labels; hooks in **Gatekeeper** base and existing bootstrap resources.
  - `apps/` — Flux `GitRepository` + `Kustomization` for **Backstage HelmRelease** and other app-level syncs.
  - `manifests/` — Minimal manifest scaffolding referenced by `cluster/` kustomization.
- `terraform/infra/azure-arc/policy/` — Terraform with **azapi** to assign Azure Policy at the Arc-connected cluster scope.
- `docs/AZURE-ARC.md` — this file.

## Prerequisites
- `az` CLI authenticated (Cloud: Azure Public or Azure Government as appropriate).
- Cluster **kubeconfig** is current context; cluster has **cluster-admin** perms for onboarding.
- Resource group in Azure (the scripts will create if missing).
- Optional: Log Analytics Workspace for monitoring.

## 1) Connect cluster to Azure Arc
```bash
AZ_SUBSCRIPTION_ID=<sub> AZ_RESOURCE_GROUP=<rg> ARC_CLUSTER_NAME=<arc-name> LOCATION=<region> CONNECT_TAGS='Program=AI-PIaP System=Platform Environment=Prod Data-Class=Internal' scripts/arc/connect-k8s.sh
```

## 2) Enable GitOps (Flux) and point to this repo
Edit URLs in:
- `gitops/arc/apps/source-git.yaml` and `gitops/arc/apps/backstage-helmrelease.yaml` (`REPLACE_ORG/REPLACE_REPO`)

Then run:
```bash
AZ_SUBSCRIPTION_ID=<sub> AZ_RESOURCE_GROUP=<rg> ARC_CLUSTER_NAME=<arc-name> LOCATION=<region> GIT_URL=https://github.com/<org>/<repo>.git GIT_BRANCH=main GIT_PATHS=gitops/arc/cluster,gitops/arc/apps scripts/arc/enable-gitops-flux.sh
```

## 3) Enable Azure Policy
Pick a Policy **initiative** ID (e.g., Kubernetes baseline initiative) and assign:
```bash
AZ_SUBSCRIPTION_ID=<sub> AZ_RESOURCE_GROUP=<rg> ARC_CLUSTER_NAME=<arc-name> POLICY_ASSIGNMENT_NAME=k8s-baseline POLICY_DEFINITION_ID=/providers/Microsoft.Authorization/policySetDefinitions/<initiative-id> scripts/arc/enable-azure-policy.sh
```
Or use Terraform under `terraform/infra/azure-arc/policy` for IaC-based assignment.

## 4) Enable Azure Monitor (Container Insights)
```bash
AZ_SUBSCRIPTION_ID=<sub> AZ_RESOURCE_GROUP=<rg> ARC_CLUSTER_NAME=<arc-name> LAW_RESOURCE_ID="/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.OperationalInsights/workspaces/<law>" scripts/arc/enable-azure-monitor.sh
```

## 5) Verify Flux sync
```bash
kubectl -n flux-system get gitrepositories,kustomizations,helmreleases
```

## Security & Compliance Notes
- **Evidence**: Flux and Arc resources in Azure provide change history; combine with your CI/CD evidence bundle.
- **Policy**: Azure Policy audit/deny can complement Gatekeeper; both can run together (Gatekeeper already included in repo).
- **Zero Trust**: No long-lived cluster credentials are persisted in Azure; Arc agents use short-lived tokens.
- **Logging**: AMA forwards container logs/metrics/traces to Log Analytics; integrate with Sentinel or SIEM as needed.

## Updating Backstage via GitOps
Backstage’s Helm chart (`charts/backstage`) and values live in-repo. The **HelmRelease** will pick up changes on commit.

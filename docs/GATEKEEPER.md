# Gatekeeper in this repo — What’s included and how it maps to requirements

This pack provides a **complete Gatekeeper setup** to enforce Kubernetes security and compliance guardrails in AKS.
It includes Helm values, synchronization config, a curated set of **ConstraintTemplates**, and **Constraints** that
map to FedRAMP/NIST baselines and CISA Kubernetes hardening guidance.

## Contents
- `helm/gatekeeper/values.yaml` — hardened Gatekeeper deployment (replicas, resource limits, non-root, no mutation).
- `k8s/policy/gatekeeper/config.yaml` — synchronization config and namespace exclusions.
- `k8s/policy/gatekeeper/templates/*` — ConstraintTemplates:
  - PSP replacements: non-root, readOnlyRootFS, no privileged, no hostNetwork/hostPath, seccomp, capabilities allowlist.
  - Supply chain: deny `:latest`, image registry allowlist.
  - Hygiene: required probes & resource limits.
  - Network & exposure: deny NodePort/LoadBalancer; require Ingress class `private` and TLS; require NetworkPolicy.
  - Governance: required Namespace labels (`Program`, `System`, `Environment`, `Data-Class`), deny workloads in `default`.
  - **Prod mTLS**: require `backstage-mtls` secret volume for Deployments in namespaces labeled `workload.env=prod`.
- `k8s/policy/gatekeeper/constraints/*` — the corresponding Constraint objects (namespaced matches/selectors included).
- `k8s/policy/gatekeeper/base/kustomization.yaml` — applies config/templates/constraints in one shot.
- `scripts/gatekeeper/install-and-apply.sh` — Helm install + Kustomize apply.

## Usage
```bash
# Install and apply all policies
scripts/gatekeeper/install-and-apply.sh
```

Label production namespaces so the prod-only constraint applies:
```bash
kubectl label namespace backstage workload.env=prod --overwrite
```

## Notes and exceptions
- System namespaces are excluded by `config.yaml` (`kube-system`, `gatekeeper-system`, `kube-public`).
- If you need per-namespace relaxations, clone the Constraint with a `namespaceSelector` or add `excludedNamespaces`.
- The **Ingress class `private`** must exist (provided by your internal NGINX controller). Change `allowedClass` if needed.
- The **image registry allowlist** defaults to `ghcr.io/` and `mcr.microsoft.com/`; extend as appropriate (e.g., ACR).
- NetworkPolicy requirement checks existence via Gatekeeper inventory; ensure CRDs for NetworkPolicy are present (they are in Kubernetes).

## Control mapping (examples)
- **AC-6 Least Privilege / CM-6 Configuration Settings**: non-root, readOnlyFS, dropped caps, deny host access.
- **SC-7 Boundary**: deny NodePort/LB, require private ingress + TLS, require NetworkPolicy.
- **SC-28 Protection of Information at Rest / SC-13 Trust**: prod mTLS secret requirement + CA trust chain (enforced by separate checks).
- **SI-2 Flaw Remediation / RA-5 Vulnerability Scanning**: deny `:latest`, restrict registries (enables provenance and scanning gates).

This configuration is intended to be applied in tandem with AKS Pod Security labels (baseline) and Azure Policy assignments
already provided elsewhere in the repo, forming layered defense-in-depth.

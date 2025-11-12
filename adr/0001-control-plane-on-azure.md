# 0001 — Control Plane on Azure; Execution on AWS/GCP/OCI

**Status**: Accepted  
**Context**: We require a single source of governance for identity, policy, and evidence. Azure offers Entra ID with PIM/JIT, Azure Policy, Azure Monitor, and Azure Arc for hybrid/Kubernetes governance.  
**Decision**: Use **Azure as the control plane**; deploy workloads to **AWS/GCP/OCI** as execution planes.  
**Consequences**:
- Centralize identity, policy, and evidence in Azure.
- Federate CI/CD and workloads into AWS/GCP/OCI via OIDC-based federation.
- Maintain multi-cloud portability and DR via anycast fronting and cross-cloud DNS.


# NSA/CISA Kubernetes Hardening Overlay

Gatekeeper policies aligned with the NSA/CISA K8s Hardening Guide:
- Deny hostPID/hostNetwork
- Require seccomp (RuntimeDefault)
- Enforce readOnlyRootFilesystem
- Enforce non-root
- Restrict image registries

Apply after installing Gatekeeper:
```bash
kubectl apply -f templates/
kubectl apply -f constraints/
```

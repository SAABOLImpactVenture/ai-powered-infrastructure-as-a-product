# OPA Policy Pack

Policies:
- `required_labels.rego` — require `parameters.labels` on K8s objects
- `deny_privileged.rego` — block privileged containers

## Test locally
```bash
curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64 && chmod +x opa
./opa test governance/opa -v
```

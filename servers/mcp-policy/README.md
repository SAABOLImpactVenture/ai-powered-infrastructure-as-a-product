
# MCP Policy Servers

HTTP services that perform policy checks and emit JSON evidence.

## Targets
- `aws`, `gcp`, `oci`: run `terraform plan -detailed-exitcode` in the policy pack dir.
- `k8s`: uses `kubectl` to aggregate Gatekeeper constraint violations.

## Endpoints
- `POST /policy/check` with optional body `{ "path": "<policy-dir>" }`

## Docker
Build & run (AWS example):
```bash
cd servers/mcp-policy/aws
docker build -t mcp-policy-aws .
docker run --rm -p 8081:8081 -v $PWD/../../..:/work mcp-policy-aws
# POST http://localhost:8081/policy/check -d '{"path":"/work/policies/aws/config"}'
```

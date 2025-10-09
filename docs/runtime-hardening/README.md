# Distroless Runtime Hardening

This folder adds distroless Dockerfiles for **all clouds** (Azure, AWS, GCP, OCI) for both MCP and Policy servers.
They run **non-root**, minimize CVE surface, and are ready for **read-only** filesystems.

## Paths
- `servers/mcp/<cloud>/Dockerfile.distroless` (Python/uvicorn)
- `servers/mcp-policy/<cloud>/Dockerfile.distroless` (Node.js)

## Build locally
```bash
docker build -f servers/mcp/aws/Dockerfile.distroless -t mcp-aws:distroless servers/mcp/aws
docker run --rm -p 8080:8080 mcp-aws:distroless
```

## Kubernetes securityContext (example)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata: { name: mcp-aws, namespace: platform }
spec:
  replicas: 1
  selector: { matchLabels: { app: mcp-aws } }
  template:
    metadata: { labels: { app: mcp-aws } }
    spec:
      containers:
        - name: mcp
          image: mcp-aws:distroless
          ports: [{ containerPort: 8080 }]
          securityContext:
            runAsNonRoot: true
            readOnlyRootFilesystem: true
            allowPrivilegeEscalation: false
            seccompProfile: { type: RuntimeDefault }
      # Combine with Gatekeeper NSA/CISA overlay and NetworkPolicy deny egress.
```

> Note: Ensure your app writes logs to stdout/stderr and avoids writing to root FS; use an emptyDir or /tmp volume if needed.

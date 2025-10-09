# Distroless via Compose & Trivy CI

## Run locally with distroless images
Option A — standalone:
```bash
docker compose -f docker/docker-compose.distroless.yml up --build
```

Option B — merge with your base compose (if you have one):
```bash
docker compose -f docker/docker-compose.yml -f docker/docker-compose.distroless.yml --profile distroless up --build
```

## CI vulnerability scanning
The workflow `.github/workflows/trivy-scan-distroless.yml` builds **8 images** (MCP + policy for Azure/AWS/GCP/OCI) and scans them with **Trivy**.
Results are uploaded as **SARIF** to the Security tab.

Policy recommendation:
- Block merge on **CRITICAL** (and HIGH if desired).
- Rebuild images weekly to pick up base fixes.

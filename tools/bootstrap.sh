#!/usr/bin/env bash
set -euo pipefail

echo "==> Preflight"
command -v docker >/dev/null || { echo "Docker is required"; exit 1; }
command -v docker compose >/dev/null || { echo "Docker Compose V2 is required"; exit 1; }

echo "==> Bringing up agents & dashboard"
docker compose -f docker/docker-compose.yml up -d --build

echo "==> Seeding example evidence (if none)"
if [ ! -d evidence/seed ]; then
  mkdir -p evidence/seed
  cat > evidence/seed/example-plan.json <<'JSON'
{"kind":"plan","status":"OK","ts":"2025-01-01T00:00:00Z","source":"seed","detail":"seed plan","summary":"seed"}
JSON
fi

echo "==> Done. Open:"
echo "   - MCP Azure:     http://localhost:8080/healthz"
echo "   - Policy UI:     http://localhost:8090"

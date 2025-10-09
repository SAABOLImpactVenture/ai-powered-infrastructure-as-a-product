# Next Phase Additions

## Makefile include
Add this line near the top of your `Makefile` to enable `make up-distroless`:
```make
-include make-includes/*.mk
```

Then run:
```bash
make up-distroless
```

## Distroless dashboard preference
When you start with the distroless profile and this override:
```bash
docker compose -f docker/docker-compose.distroless.yml -f docker/docker-compose.distroless.dashboard.yml --profile distroless up --build
```
the **policy-dashboard** container will aggregate from the **distroless** policy services automatically (via service DNS).

## Multi-arch builds
Trigger the workflow:
```bash
gh workflow run buildx-distroless-multiarch
```
Artifacts will include OCI archives for linux/amd64 and linux/arm64 per image.

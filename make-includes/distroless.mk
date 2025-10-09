
# Include me from your Makefile:  -include make-includes/*.mk

up-distroless:
	docker compose -f docker/docker-compose.distroless.yml up --build

down-distroless:
	docker compose -f docker/docker-compose.distroless.yml down -v

scan-distroless:
	gh workflow run trivy-scan-distroless

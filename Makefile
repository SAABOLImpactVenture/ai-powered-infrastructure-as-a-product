
.PHONY: up down plan policy bootstrap
up:
	docker compose -f docker/docker-compose.yml up --build
down:
	docker compose -f docker/docker-compose.yml down -v
bootstrap:
	bash tools/bootstrap.sh
plan:
	curl -sS -X POST http://localhost:8080/plan -H 'content-type: application/json' -d '{"path":"platform/azure/observability/log_analytics"}' | jq
policy:
	curl -sS -X POST http://localhost:8181/policy/check -H 'content-type: application/json' -d '{}' | jq


.PHONY: up down plan policy bootstrap pr-list pr-check pr-approve-all pr-merge-all pr-help
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

# Pull Request Management
pr-list:
	@echo "Listing open pull requests..."
	@./scripts/pr_batch_ops.sh list

pr-check:
	@echo "Checking pull request status..."
	@python3 scripts/check_pr_status.py

pr-approve-all:
	@echo "Approving all open pull requests..."
	@./scripts/pr_batch_ops.sh approve-all

pr-merge-all:
	@echo "Merging all ready pull requests..."
	@./scripts/pr_batch_ops.sh merge-all squash

pr-help:
	@echo "Pull Request Management Commands:"
	@echo "  make pr-list        - List all open pull requests"
	@echo "  make pr-check       - Check detailed status of all PRs"
	@echo "  make pr-approve-all - Approve all open PRs (requires confirmation)"
	@echo "  make pr-merge-all   - Merge all ready PRs (requires confirmation)"
	@echo ""
	@echo "For more options, see: docs/PR_MANAGEMENT.md"

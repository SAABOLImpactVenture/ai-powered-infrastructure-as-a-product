SHELL := /bin/bash

.PHONY: validate docs policy guard

validate: guard policy docs

guard:
	@./scripts/validate-modern-accelerator.sh

policy:
	@command -v opa >/dev/null 2>&1 && opa check policies/opa || echo "opa not installed; CI performs policy validation"

docs:
	@command -v mkdocs >/dev/null 2>&1 && mkdocs build --strict || echo "mkdocs not installed; CI performs docs validation"

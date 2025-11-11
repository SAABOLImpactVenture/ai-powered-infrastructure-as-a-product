SHELL := /bin/bash

.PHONY: all init validate tflint checkov conftest k8s gitleaks sbom evidence pre-commit

all: init validate tflint checkov conftest k8s gitleaks

init:
	@if [ -d terraform ]; then terraform -chdir=terraform init -backend=false; fi

validate:
	@if [ -d terraform ]; then terraform -chdir=terraform validate; fi

tflint:
	@if command -v tflint >/dev/null 2>&1; then tflint -f compact; else echo "tflint not installed"; fi

checkov:
	@mkdir -p reports
	@checkov -d . -o sarif --output-file-path reports/checkov.local.sarif

conftest:
	@if [ -d policies ]; then conftest test terraform/ -p policies/ || true; fi

k8s:
	@if [ -d k8s ]; then conftest test k8s -p policies/ || true; fi

gitleaks:
	@gitleaks detect -v --no-banner --config .gitleaks.toml

sbom:
	@syft dir:. -o cyclonedx-json=sbom.local.cdx.json || echo "syft not installed"

evidence:
	@python3 scripts/oscal/sarif_to_oscal.py reports artifacts/oscal/poam.local.json || true

pre-commit:
	@pre-commit run --all-files || true

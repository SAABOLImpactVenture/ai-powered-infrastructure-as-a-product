SPDX-License-Identifier: Apache-2.0

# Contributing Guide

Thanks for contributing! This project treats **infrastructure as a product**—code quality, security, and compliance are first-class.

## Ground rules

* Follow the **DCO** (Developer Certificate of Origin). Sign commits with `-s`.
* Use SPDX headers: `SPDX-License-Identifier: Apache-2.0`.
* Write tests for new features; keep coverage ≥ 80% for touched code.
* Run pre-commit hooks locally before pushing.

## Workflow

1. **Issue first**: open an issue describing the problem/feature with acceptance criteria.
2. **Branch**: `feat/<short>`, `fix/<short>`, or `docs/<short>`.
3. **Code style**: Terraform (tflint, fmt), Python (black, flake8), YAML (yamllint).
4. **Policy gates**: Checkov/Conftest must pass locally and in CI.
5. **Tests**: `make test` runs unit/static/policy tests. Add integration tests under `tests/`.
6. **PR**: link to the issue, include a changelog entry, and describe risk & rollback.
7. **Review**: at least one maintainer review; CI must be green.

## Development setup

```bash
make bootstrap
pre-commit run --all-files
make test
```

## Release

* Use Conventional Commits; releases are generated from `CHANGELOG.md`.
* Tag as `vMAJOR.MINOR.PATCH`. Patches should be security/bug fixes only.

## Code of Conduct

See **CODE_OF_CONDUCT.md**—we follow the Contributor Covenant.

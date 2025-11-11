# F. Scaffolder (Golden Paths)

This pack provides five production-ready Scaffolder templates and two custom actions:

## Custom Actions
- `aipiap:validate:tags` — verifies Program/System/Environment/Data-Class inputs are provided.
- `aipiap:evidence:notify` — notifies an external **policy-evidence-adapter** (`aipiap.evidence.adapterUrl` in `app-config`) with the new PR for harvesting.

The backend wires these via `packages/backend/src/scaffolder/actions/*` and exposes them to Scaffolder.

## Templates
1. **new-service** — Creates a new service repo with Terraform skeleton, CI policy gates (Checkov/TFLint/Conftest/Gitleaks), TechDocs, CODEOWNERS, policies, and registration in the catalog.
2. **landing-zone-addon** — Bootstraps a repo/module to extend an existing landing zone; includes policy gates and baseline policies.
3. **network-tier** — Sets up a network tier repo for DR strategies; includes policy gates and Terraform placeholders.
4. **observability** — Scaffolds OpenTelemetry Collector config and CI gates.
5. **policy-evidence** — Raises a PR to inject policy gates and evidence workflows into an existing repo.

## Setup
- Ensure your `app-config.*.yaml` has a GitHub integration for `publish:github` / `publish:github:pull-request`.
- Optionally set `aipiap.evidence.adapterUrl` in `app-config.production.yaml` to enable evidence notifications.

## Register Templates
Add `backstage/templates/catalog-info.yaml` to your Catalog locations in `app-config.yaml`.

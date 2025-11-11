# E. TechDocs — Azure Blob Publisher + CI

This pack enables TechDocs publishing to **Azure Blob Storage** via GitHub Actions using `@techdocs/cli`.

## What’s included
- `.github/workflows/techdocs-publish.yml` — builds and publishes TechDocs sites on changes.
- `scripts/techdocs/find_sites.py` — finds TechDocs-enabled directories.
- `docs/techdocs-template/` — skeleton `mkdocs.yml` and `docs/index.md` for new services.
- `catalog/components/sample-service/` — example Backstage Component with `techdocs-ref: dir:.` and a minimal site.

## Secrets required (in GitHub repo/org)
- `TECHDOCS_AZURE_ACCOUNT_NAME` — Azure Storage account name
- `TECHDOCS_AZURE_ACCOUNT_KEY` — Access key
- `TECHDOCS_CONTAINER_NAME` — Container (e.g., `techdocs`)

These should match the **Backstage** `techdocs.publisher.azureBlob` settings in your `app-config.production.yaml`.

## How it works
1. On pushes to `main`/`master`, the workflow finds all directories containing `mkdocs.yml` or `catalog-info.yaml` with a `docs/` folder.
2. For each site, `techdocs-cli generate` builds static docs.
3. `techdocs-cli publish` uploads the site to the Azure Blob container, keyed by the entity reference.

## Developing new docs
- Copy `docs/techdocs-template` into your service repo/path.
- Ensure your `catalog-info.yaml` includes:
  ```yaml
  metadata:
    annotations:
      backstage.io/techdocs-ref: dir:.
  ```
- Commit and push; the CI will publish on merge.

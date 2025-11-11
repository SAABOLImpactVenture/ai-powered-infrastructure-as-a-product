# G. Plugins — GitHub Actions + FinOps + Custom Plugin Wiring

This pack adds:
- **GitHub Actions plugin**: routes at `/ci` to see runs for the current entity/repo.
- **FinOps custom plugin**: `/finops` page with a backend router `/finops/costs` that serves CSV-based costs (switch to your export path in `app-config.plugins.merge.yaml`).
- **Sample custom plugin**: starter frontend page you can adapt.
- **Backend** wiring for FinOps; existing routers remain intact.

## Apply
1. Merge the files at repo root (replace `package.json` and the two `packages/*/package.json` files with the ones provided here).
2. Merge `app-config.plugins.merge.yaml` into your `app-config.production.yaml` (and set `GITHUB_TOKEN` as needed).
3. `yarn install` at repo root.
4. `yarn dev` to start the app.

## Notes
- The FinOps backend reads CSV from `packages/backend/data/finops/sample-costs.csv` by default; change `finops.csvPath` in `app-config` to point at your export (or implement S3/Blob fetch if desired).
- GitHub Actions plugin relies on Backstage’s GitHub integration; ensure your catalog entities have `github.com` locations or annotations to link runs.

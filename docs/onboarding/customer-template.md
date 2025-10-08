# Customer Onboarding — Template

Follow these steps to set up a new customer repo using this accelerator.

## 1) Create Template Repo
- Click **Use this template** in the marketplace edition (Phase 4).
- Enable **Actions** and **Pages (optional)**.

## 2) Configure OIDC Federation (Azure)
1. In Entra ID, create an **App registration** (or reuse an existing one).
2. Add a **Federated credential**:
   - Entity type: GitHub Actions
   - Organization/repo: `your-org/your-repo`
   - Branch: `main`
   - Name: `gha-oidc`
3. In GitHub repo → **Settings → Secrets and variables → Actions**:
   - `AZURE_TENANT_ID`
   - `AZURE_SUBSCRIPTION_ID`
   - `AZURE_CLIENT_ID` (from App registration)

## 3) Run Example Workflow
- Trigger `Example OIDC to Azure` via **Actions → Run workflow**.
- It will run `terraform init/validate` against the Log Analytics module.

## 4) Golden Path Demo
- On a developer machine: `scripts/golden_path/run_golden_demo.sh`
- Observe evidence in `.local-outbox/` (offline) or Workbooks (cloud).

## 5) Alert Drill
- Run `scripts/drills/simulate_failure.sh`.
- Verify alerts in Azure Monitor if cloud ingestion is enabled.

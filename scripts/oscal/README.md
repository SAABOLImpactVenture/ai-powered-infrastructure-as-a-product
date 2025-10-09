# OSCAL Conversion

This repo includes a GitHub Actions workflow `ga-plan-policy-evidence-apply.yml` that:
1) Produces a Terraform JSON plan
2) Runs Checkov (SARIF) + OPA policy gates
3) Converts SARIF + plan to OSCAL assessment-results via `scripts/oscal/sarif_to_oscal.py`
4) Uploads results to an **immutable** Azure Storage container (CMK + immutability policy)
5) Gates `apply` on success, with **protected environment**

To run locally:
```
terraform show -json tfplan.bin > tfplan.json
python3 scripts/oscal/sarif_to_oscal.py --repository org/repo --run-id 123 --sarif checkov.sarif --plan tfplan.json --out artifacts/oscal/assessment-results.json
```

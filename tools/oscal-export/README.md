
# OSCAL Export

Converts repository evidence JSON into an OSCAL-aligned `assessment-results` document.

## Usage
```bash
python3 tools/oscal-export/export.py --paths evidence servers/mcp/azure/evidence --out artifacts/oscal/assessment-results.json
```
Outputs to `artifacts/oscal/assessment-results.json`.

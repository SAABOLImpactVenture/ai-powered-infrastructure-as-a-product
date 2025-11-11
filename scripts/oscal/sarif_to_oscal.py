#!/usr/bin/env python3
# Convert Checkov SARIF to a minimal OSCAL-like POA&M JSON
import json, sys, os, time

if len(sys.argv) < 3:
    print("Usage: sarif_to_oscal.py <input.sarif> <output.json>")
    sys.exit(1)

inp, outp = sys.argv[1], sys.argv[2]
with open(inp, "r", encoding="utf-8") as f:
    sarif = json.load(f)

results = []
for run in sarif.get("runs", []):
    tool = run.get("tool", {}).get("driver", {}).get("name", "unknown")
    for r in run.get("results", []):
        rid = r.get("ruleId") or r.get("rule", {}).get("id")
        sev = r.get("level", "warning")
        msg = r.get("message", {}).get("text", "")
        results.append({
            "tool": tool,
            "ruleId": rid,
            "severity": sev,
            "finding": msg
        })

oscal = {
  "metadata": {
    "title": "POA&M from SARIF",
    "last-modified": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
  },
  "items": [
    {
      "id": i+1,
      "vulnerability-id": f"{r['tool']}::{r['ruleId']}",
      "risk": r["severity"],
      "description": r["finding"],
      "status": "open"
    } for i, r in enumerate(results)
  ]
}

os.makedirs(os.path.dirname(outp), exist_ok=True)
with open(outp, "w", encoding="utf-8") as f:
    json.dump(oscal, f, indent=2)
print(f"Wrote {outp}")

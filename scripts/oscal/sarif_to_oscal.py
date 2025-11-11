#!/usr/bin/env python3
import json, os, sys, time, glob

if len(sys.argv) < 3:
    print("Usage: sarif_to_oscal.py <reports_dir> <output.json>")
    sys.exit(1)

reports_dir, outp = sys.argv[1], sys.argv[2]
sarif_files = glob.glob(os.path.join(reports_dir, "*.sarif"))
items = []
for path in sarif_files:
    try:
        with open(path, "r", encoding="utf-8") as f:
            sarif = json.load(f)
    except Exception as e:
        print(f"[warn] failed to read {path}: {e}")
        continue
    for run in sarif.get("runs", []):
        tool = run.get("tool", {}).get("driver", {}).get("name", "unknown")
        for r in run.get("results", []):
            rid = r.get("ruleId") or r.get("rule", {}).get("id")
            sev = r.get("level", "warning")
            msg = r.get("message", {}).get("text", "")
            items.append({
                "tool": tool,
                "ruleId": rid,
                "severity": sev,
                "finding": msg
            })

os.makedirs(os.path.dirname(outp), exist_ok=True)
oscal = {
  "metadata": {
    "title": "POA&M from consolidated SARIF",
    "last-modified": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
  },
  "items": [
    {
      "id": i+1,
      "vulnerability-id": f"{r['tool']}::{r['ruleId']}",
      "risk": r["severity"],
      "description": r["finding"],
      "status": "open"
    } for i, r in enumerate(items)
  ]
}
with open(outp, "w", encoding="utf-8") as f:
  json.dump(oscal, f, indent=2)
print(f"[oscal] wrote {outp} with {len(items)} findings")

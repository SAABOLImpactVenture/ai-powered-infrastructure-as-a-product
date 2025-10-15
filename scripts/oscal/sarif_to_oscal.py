import os
#!/usr/bin/env python3
import argparse
import datetime
import json
import uuid


def load_sarif(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

def build_oscal(repo, run_id, sarif, plan_json):
    now = datetime.datetime.utcnow().replace(microsecond=0).isoformat()+"Z"
    results = []
    # Minimal mapping: each SARIF result becomes an observation
    for run in sarif.get("runs", []):
        tool = run.get("tool", {}).get("driver", {}).get("name", "scanner")
        for res in run.get("results", []):
            rule_id = res.get("ruleId", "unknown")
            level = (res.get("level") or "note").upper()
            status = "PASS" if level in ["NOTE", "INFO"] else "FAIL"
            msg = res.get("message", {}).get("text", "")
            locations = res.get("locations", [])
            target = locations[0].get("physicalLocation", {}).get("artifactLocation", {}).get("uri", "") if locations else ""
            results.append({
                "uuid": str(uuid.uuid4()),
                "title": f"{tool}:{rule_id}",
                "description": msg,
                "props": [
                    {"name":"repository","value":repo},
                    {"name":"github-run-id","value":str(run_id)},
                    {"name":"target","value":target},
                ],
                "status": status,
                "observations": [{"description": msg}]
            })
    # OSCAL assessment-results (subset)
    return {
      "assessment-results": {
        "uuid": str(uuid.uuid4()),
        "metadata": {
          "title": f"Assessment Results for {repo} run {run_id}",
          "last-modified": now,
          "version": "1.0.0",
          "oscal-version": "1.0.4",
        },
        "results": [{
          "uuid": str(uuid.uuid4()),
          "title": "Automated scan results",
          "start": now,
          "end": now,
          "reviewed-controls": [],
          "findings": [{
            "uuid": r["uuid"],
            "title": r["title"],
            "description": r["description"],
            "implementation-statement-uuids": [],
            "related-observations": [{"observation-uuid": r["uuid"]}]
          } for r in results],
          "observations": [{
            "uuid": r["uuid"],
            "description": r["description"],
            "props": r["props"]
          } for r in results]
        }]
      }
    }

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--repository", required=True)
    ap.add_argument("--run-id", required=True)
    ap.add_argument("--sarif", required=True)
    ap.add_argument("--plan", required=True)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()

    sarif = load_sarif(args.sarif)
    with open(args.plan, 'r', encoding='utf-8') as f:
        plan = json.load(f)

    oscal_doc = build_oscal(args.repository, args.run_id, sarif, plan)

    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    with open(args.out, 'w', encoding='utf-8') as f:
        json.dump(oscal_doc, f, indent=2)

if __name__ == "__main__":
    main()


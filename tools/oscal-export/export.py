
#!/usr/bin/env python3
import argparse, json, glob, os, hashlib, datetime, uuid

def load_evidence(paths):
  ev = []
  for p in paths:
    for fp in glob.glob(os.path.join(p, '**', '*.json'), recursive=True):
      try:
        with open(fp,'r') as f:
          ev.append(json.load(f))
      except Exception:
        pass
  return ev

def to_assessment_results(evidence, system_uuid=None):
  now = datetime.datetime.utcnow().replace(microsecond=0).isoformat()+'Z'
  sys_id = system_uuid or str(uuid.uuid4())
  results = []
  for i, e in enumerate(evidence):
    control_ids = e.get('controls') or []
    res = {
      "uuid": str(uuid.uuid4()),
      "title": f"Evidence {i+1}: {e.get('kind','unknown')}",
      "description": e.get('summary') or e.get('detail','')[:200],
      "start": now,
      "end": now,
      "reviewed-controls": [ { "control-id": c } for c in control_ids ],
      "collected-evidence": [{
        "description": e.get('detail','')[:500],
        "prop": [
          { "name":"status", "value": e.get('status','UNKNOWN') },
          { "name":"source", "value": e.get('source','') },
          { "name":"path", "value": e.get('path','') }
        ]
      }]
    }
    results.append(res)
  doc = {
    "component-definition": {
      "uuid": str(uuid.uuid4()),
      "metadata": {
        "title": "IaaP Accelerator Assessment Results",
        "last-modified": now,
        "version": "1.0.0"
      }
    },
    "assessment-results": [{
      "uuid": str(uuid.uuid4()),
      "metadata": {
        "title": "Continuous Assessment Results",
        "last-modified": now,
        "version": "1.0.0"
      },
      "results": results
    }]
  }
  return doc

def main():
  ap = argparse.ArgumentParser()
  ap.add_argument('--paths', nargs='+', default=['evidence'])
  ap.add_argument('--out', default='artifacts/oscal/assessment-results.json')
  args = ap.parse_args()

  ev = load_evidence(args.paths)
  os.makedirs(os.path.dirname(args.out), exist_ok=True)
  doc = to_assessment_results(ev)
  with open(args.out,'w') as f:
    json.dump(doc, f, indent=2)
  print(f"Wrote {args.out} with {len(ev)} evidence records.")

if __name__ == '__main__':
  main()

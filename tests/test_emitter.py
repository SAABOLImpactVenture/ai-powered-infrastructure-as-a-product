import json
import pathlib
import subprocess
import sys


def test_emitter_local(tmp_path):
  p = pathlib.Path("scripts/emitters/infra-evidence/emit_evidence_to_log_analytics.py")
  r = subprocess.run([sys.executable, str(p), "--kind","test","--status","success","--detail","ok"],
                     capture_output=True, text=True)
  assert r.returncode == 0, r.stderr
  out = json.loads(r.stdout)
  assert out["mode"] == "local"
  saved = pathlib.Path(out["saved"])
  assert saved.exists(), f"Missing local evidence file: {saved}"

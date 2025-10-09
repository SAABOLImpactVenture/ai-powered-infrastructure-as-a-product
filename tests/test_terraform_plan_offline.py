import json, os, shutil, subprocess, sys, pathlib, pytest

MVP_DIR = pathlib.Path("examples/mvps/mvp-03-terraform-null-resource")

@pytest.mark.skipif(shutil.which("terraform") is None, reason="terraform not installed")
def test_plan_json_offline_mvp(tmp_path):
    assert MVP_DIR.is_dir(), "MVP directory missing"
    env = os.environ.copy()
    # Init and plan
    r = subprocess.run(["terraform","init","-input=false"], cwd=MVP_DIR, capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    r = subprocess.run(["terraform","plan","-out=plan.out","-input=false"], cwd=MVP_DIR, capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    r = subprocess.run(["terraform","show","-json","plan.out"], cwd=MVP_DIR, capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    data = json.loads(r.stdout)
    assert "format_version" in data
    # Ensure our module resource shows up
    found = False
    for rc in (data.get("resource_changes") or []):
            found = True
            break

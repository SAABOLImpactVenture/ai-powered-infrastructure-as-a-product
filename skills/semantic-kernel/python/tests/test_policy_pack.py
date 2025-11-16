from pathlib import Path
import importlib.util


def load_module(rel_path: str, name: str):
    root = Path(__file__).resolve().parents[1]
    path = root / rel_path
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module

import json


def test_policy_pack_contains_expected_files():
    mod = load_module("skills/policy_pack.py", "policy_pack")
    pack = mod.build_policy_pack("testproduct")
    assert "policy/azure/initiative.json" in pack
    assert "policy/aws/conformance-pack.yaml" in pack
    azure = json.loads(pack["policy/azure/initiative.json"])
    assert azure["properties"]["displayName"].startswith("testproduct")
    assert len(azure["properties"]["policyDefinitions"]) >= 3

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

def test_backstage_scaffolder_generates_bundle():
    mod = load_module("skills/backstage_scaffolder.py", "backstage_scaffolder")
    bundle = mod.generate_backstage_bundle("Secure Storage Product", "github.com/example/repo")
    keys = list(bundle.keys())
    assert any(k.endswith("template.yaml") for k in keys)
    assert any(k.endswith("catalog-info.yaml") for k in keys)
    assert any(k.endswith("README.md") for k in keys)

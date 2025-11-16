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

from jsonschema import validate


def test_oscal_packager_builds_valid_doc():
    mod = load_module("skills/oscal_packager.py", "oscal_packager")
    qa_summary = {
        "test_cases": [
            {
                "id": "unit-1",
                "name": "Unit test 1",
                "description": "Ensures behaviour.",
                "type": "unit",
                "mandatory": True,
            }
        ]
    }
    doc = mod.build_assessment_results("system-123", qa_summary)
    validate(instance=doc, schema=mod.OSCAL_MINIMAL_SCHEMA)
    assert doc["metadata"]["title"].startswith("QA Assessment Results")

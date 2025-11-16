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

from typing import Dict


def test_synthesize_secure_storage_module():
    mod = load_module("skills/iac_synthesis.py", "iac_synthesis")
    files: Dict[str, str] = mod.synthesize_secure_storage_module("Secure Storage Product")
    assert "iac/modules/secure-storage/main.tf" in files
    main_tf = files["iac/modules/secure-storage/main.tf"]
    assert 'resource "azurerm_storage_account" "this"' in main_tf
    assert "allow_blob_public_access = false" in main_tf
    assert "enable_https_traffic_only = true" in main_tf
    # Deterministic
    assert files == mod.synthesize_secure_storage_module("Secure Storage Product")

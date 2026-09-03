from __future__ import annotations

import importlib.util
import json
import shutil
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "scripts" / "verify_portfolio_provenance.py"
SPEC = importlib.util.spec_from_file_location("portfolio_provenance", SCRIPT)
assert SPEC and SPEC.loader
provenance = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(provenance)


class PortfolioProvenanceTests(unittest.TestCase):
    def copied_root(self, temporary_directory: str) -> Path:
        target = Path(temporary_directory)
        relative_paths = set(provenance.EXPECTED_COVERED_PATHS)
        relative_paths.update(provenance.PROVENANCE_SURFACES)
        for relative in relative_paths:
            source = ROOT / relative
            destination = target / relative
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(source, destination)
        return target

    def load_manifest(self, root: Path) -> dict:
        return json.loads((root / provenance.MANIFEST_RELATIVE).read_text())

    def write_manifest(self, root: Path, manifest: dict) -> None:
        unsigned = {
            key: value for key, value in manifest.items() if key != "integrity"
        }
        manifest["integrity"]["digest"] = provenance.hashlib.sha256(
            provenance.canonical_json(unsigned)
        ).hexdigest()
        (root / provenance.MANIFEST_RELATIVE).write_text(
            json.dumps(manifest, indent=2) + "\n",
            encoding="utf-8",
        )

    def test_current_gate_verifies_offline(self):
        result = provenance.verify(ROOT)
        self.assertEqual(result["result"], "PASS")
        self.assertFalse(result["networkUsed"])
        self.assertFalse(result["authorityAdded"])

    def test_covered_artifact_tamper_fails_closed(self):
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = self.copied_root(temporary_directory)
            with (root / "README.md").open("a", encoding="utf-8") as handle:
                handle.write("\ntampered\n")
            with self.assertRaises(provenance.ProvenanceError):
                provenance.verify(root)

    def test_verifier_tamper_fails_closed(self):
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = self.copied_root(temporary_directory)
            with (root / "scripts/verify_portfolio_provenance.py").open(
                "a", encoding="utf-8"
            ) as handle:
                handle.write("\n# tampered\n")
            with self.assertRaises(provenance.ProvenanceError):
                provenance.verify(root)

    def test_recomputed_marker_substitution_fails_closed(self):
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = self.copied_root(temporary_directory)
            manifest = self.load_manifest(root)
            manifest["fingerprint"]["marker"] = "COPIED-PORTFOLIO"
            manifest["fingerprint"]["markerSha256"] = provenance.hashlib.sha256(
                b"COPIED-PORTFOLIO"
            ).hexdigest()
            self.write_manifest(root, manifest)
            with self.assertRaises(provenance.ProvenanceError):
                provenance.verify(root)

    def test_recomputed_author_substitution_fails_closed(self):
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = self.copied_root(temporary_directory)
            manifest = self.load_manifest(root)
            manifest["authorship"]["assertedAuthor"] = "Substitute Author"
            self.write_manifest(root, manifest)
            with self.assertRaises(provenance.ProvenanceError):
                provenance.verify(root)

    def test_refresh_refuses_author_substitution(self):
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = self.copied_root(temporary_directory)
            manifest = self.load_manifest(root)
            manifest["authorship"]["assertedAuthor"] = "Substitute Author"
            self.write_manifest(root, manifest)
            with self.assertRaises(provenance.ProvenanceError):
                provenance.refresh_manifest(root)

    def test_recomputed_origin_substitution_fails_closed(self):
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = self.copied_root(temporary_directory)
            manifest = self.load_manifest(root)
            manifest["origin"]["canonicalRepository"] = "https://example.com/copy"
            self.write_manifest(root, manifest)
            with self.assertRaises(provenance.ProvenanceError):
                provenance.verify(root)

    def test_recomputed_ai_disruption_claim_fails_closed(self):
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = self.copied_root(temporary_directory)
            manifest = self.load_manifest(root)
            manifest["claims"]["aiSafety"]["modelDisruptionIntent"] = True
            self.write_manifest(root, manifest)
            with self.assertRaises(provenance.ProvenanceError):
                provenance.verify(root)

    def test_hidden_unicode_fails_closed(self):
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = self.copied_root(temporary_directory)
            with (root / "docs/PORTFOLIO-PROVENANCE.md").open(
                "a", encoding="utf-8"
            ) as handle:
                handle.write("\u200b")
            with self.assertRaises(provenance.ProvenanceError):
                provenance.verify(root)

    def test_duplicate_json_keys_fail_closed(self):
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = self.copied_root(temporary_directory)
            path = root / provenance.MANIFEST_RELATIVE
            text = path.read_text(encoding="utf-8")
            path.write_text(
                text.replace(
                    "{\n",
                    '{\n  "schemaVersion": "substitution",\n',
                    1,
                ),
                encoding="utf-8",
            )
            with self.assertRaises(provenance.ProvenanceError):
                provenance.verify(root)

    def test_recomputed_path_set_reduction_fails_closed(self):
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = self.copied_root(temporary_directory)
            manifest = self.load_manifest(root)
            manifest["coveredArtifacts"].pop()
            self.write_manifest(root, manifest)
            with self.assertRaises(provenance.ProvenanceError):
                provenance.verify(root)


if __name__ == "__main__":
    unittest.main()

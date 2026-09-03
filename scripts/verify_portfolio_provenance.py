#!/usr/bin/env python3
"""Verify or refresh the passive Portfolio Provenance Gate."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path, PurePosixPath
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
MANIFEST_RELATIVE = Path("provenance/portfolio-provenance.json")
SCHEMA_RELATIVE = Path("provenance/portfolio-provenance.schema.json")

MARKER = "SAABOL-IaaP-PORTFOLIO-ORIGIN-v1"
MARKER_SHA256 = hashlib.sha256(MARKER.encode("utf-8")).hexdigest()

EXPECTED_COVERED_PATHS = [
    ".github/workflows/ci.yml",
    "CITATION.cff",
    "LICENSE",
    "Makefile",
    "README.md",
    "docs/PORTFOLIO-PROVENANCE.md",
    "docs/PUBLICATION-BOUNDARY.md",
    "docs/THESIS.md",
    "docs/poc-portfolio.md",
    "provenance/portfolio-provenance.schema.json",
    "scripts/verify_portfolio_provenance.py",
    "tests/test_portfolio_provenance.py",
]

PROVENANCE_SURFACES = [
    "CITATION.cff",
    "docs/PORTFOLIO-PROVENANCE.md",
    "provenance/portfolio-provenance.json",
    "provenance/portfolio-provenance.schema.json",
]

EXPECTED_STATIC: dict[str, Any] = {
    "schemaVersion": "saabol.portfolio-provenance/v1",
    "statementId": "urn:saabol:iaap:portfolio-provenance:v1",
    "fingerprint": {
        "marker": MARKER,
        "markerSha256": MARKER_SHA256,
    },
    "authorship": {
        "assertedAuthor": "Larry Cureton",
        "githubLogin": "GEP-V",
        "assertionBasis": [
            "maintainer assertion",
            "public repository history",
        ],
        "humanIdentityCryptographicallyVerified": False,
        "legalOwnershipDetermined": False,
    },
    "origin": {
        "canonicalRepository": (
            "https://github.com/SAABOLImpactVenture/"
            "ai-powered-infrastructure-as-a-product"
        ),
        "organization": "SAABOLImpactVenture",
        "publisher": "SAABOL Impact Venture",
        "baselineRevision": "3586d41345dea2bdb1a51e53c83c8fb6f78bf5f0",
        "assertedAt": "2026-09-03",
        "publicSource": True,
    },
    "portfolioChain": {
        "model": "guard-console-human-selection-forge-vanguard/v1",
        "stages": [
            {
                "sequence": 1,
                "stage": "guard",
                "responsibility": "deterministic assessment and evidence",
            },
            {
                "sequence": 2,
                "stage": "console",
                "responsibility": (
                    "customer-hosted evidence and selection experience"
                ),
            },
            {
                "sequence": 3,
                "stage": "human-selection",
                "responsibility": "authorized selection and approval boundary",
            },
            {
                "sequence": 4,
                "stage": "forge",
                "responsibility": "governed product-building lifecycle",
            },
            {
                "sequence": 5,
                "stage": "vanguard",
                "responsibility": "authority, custody, and continuous assurance",
            },
        ],
    },
    "claims": {
        "scope": (
            "authorship and canonical origin of this public portfolio record "
            "and its digest-bound artifacts"
        ),
        "license": {
            "spdx": "Apache-2.0",
            "changedByStatement": False,
        },
        "aiSafety": {
            "hiddenUnicodeMarkers": False,
            "modelDisruptionIntent": False,
            "promptInjectionContent": False,
            "runtimeInterference": False,
            "telemetryOrPhoneHome": False,
            "trainingDataPoisoningIntent": False,
        },
        "authority": {
            "cloudAccessAdded": False,
            "credentialsAdded": False,
            "liveDataAuthorized": False,
            "pilotAuthorized": False,
            "productionAuthorized": False,
            "repositoryWriteAuthorityAdded": False,
            "spendingAuthorized": False,
        },
    },
}

EXPECTED_SCHEMA_ID = (
    "https://raw.githubusercontent.com/SAABOLImpactVenture/"
    "ai-powered-infrastructure-as-a-product/main/provenance/"
    "portfolio-provenance.schema.json"
)
SHA256_PATTERN = re.compile(r"^[0-9a-f]{64}$")
FORBIDDEN_TEXT_FRAGMENTS = ("<!--", "<script", "<style", "<iframe", "<object")


class ProvenanceError(ValueError):
    """Raised when the provenance record fails closed."""


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ProvenanceError(message)


def reject_duplicate_keys(pairs: list[tuple[str, Any]]) -> dict[str, Any]:
    value: dict[str, Any] = {}
    for key, child in pairs:
        if key in value:
            raise ProvenanceError(f"duplicate JSON key: {key}")
        value[key] = child
    return value


def reject_constant(value: str) -> None:
    raise ProvenanceError(f"non-finite JSON number: {value}")


def validate_visible_text(text: str, label: str) -> None:
    for index, character in enumerate(text):
        codepoint = ord(character)
        if character in "\t\n\r":
            continue
        if codepoint < 0x20 or 0x7F <= codepoint <= 0x9F:
            raise ProvenanceError(
                f"{label}: control character U+{codepoint:04X} at offset {index}"
            )
        if (
            codepoint == 0x061C
            or 0x200B <= codepoint <= 0x200F
            or 0x202A <= codepoint <= 0x202E
            or 0x2060 <= codepoint <= 0x206F
            or codepoint == 0xFEFF
        ):
            raise ProvenanceError(
                f"{label}: hidden or bidirectional Unicode U+{codepoint:04X}"
            )

    lowered = text.casefold()
    for fragment in FORBIDDEN_TEXT_FRAGMENTS:
        if fragment in lowered:
            raise ProvenanceError(
                f"{label}: hidden or executable markup is not allowed"
            )


def read_text(path: Path, label: str) -> str:
    require(path.is_file(), f"{label}: required file is missing")
    require(not path.is_symlink(), f"{label}: symbolic links are not allowed")
    try:
        text = path.read_text(encoding="utf-8")
    except (OSError, UnicodeError) as error:
        raise ProvenanceError(f"{label}: cannot read strict UTF-8") from error
    validate_visible_text(text, label)
    return text


def load_json(path: Path, label: str) -> dict[str, Any]:
    text = read_text(path, label)
    try:
        value = json.loads(
            text,
            object_pairs_hook=reject_duplicate_keys,
            parse_constant=reject_constant,
        )
    except json.JSONDecodeError as error:
        raise ProvenanceError(f"{label}: invalid JSON") from error
    require(isinstance(value, dict), f"{label}: root must be an object")
    return value


def canonical_json(value: Any) -> bytes:
    return json.dumps(
        value,
        allow_nan=False,
        ensure_ascii=False,
        separators=(",", ":"),
        sort_keys=True,
    ).encode("utf-8")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def safe_artifact_path(root: Path, relative: str) -> Path:
    pure = PurePosixPath(relative)
    require(not pure.is_absolute(), f"artifact path is absolute: {relative}")
    require(".." not in pure.parts, f"artifact path escapes root: {relative}")
    require(str(pure) == relative, f"artifact path is not canonical: {relative}")
    candidate = root.joinpath(*pure.parts)
    cursor = root
    for part in pure.parts:
        cursor = cursor / part
        require(not cursor.is_symlink(), f"covered artifact is linked: {relative}")
    require(candidate.is_file(), f"covered artifact is missing: {relative}")
    try:
        candidate.resolve().relative_to(root.resolve())
    except ValueError as error:
        raise ProvenanceError(f"artifact path escapes root: {relative}") from error
    return candidate


def validate_static_contract(manifest: dict[str, Any]) -> None:
    expected_keys = set(EXPECTED_STATIC) | {"coveredArtifacts", "integrity"}
    require(set(manifest) == expected_keys, "manifest field set changed")
    for key, expected in EXPECTED_STATIC.items():
        require(manifest.get(key) == expected, f"manifest {key} contract changed")

    artifacts = manifest.get("coveredArtifacts")
    require(isinstance(artifacts, list), "coveredArtifacts must be an array")
    require(
        [item.get("path") for item in artifacts if isinstance(item, dict)]
        == EXPECTED_COVERED_PATHS,
        "covered artifact path set or order changed",
    )
    require(
        all(
            isinstance(item, dict)
            and set(item) == {"path", "sha256"}
            and isinstance(item["sha256"], str)
            for item in artifacts
        ),
        "covered artifact entry shape changed",
    )

    integrity = manifest.get("integrity")
    require(
        isinstance(integrity, dict)
        and set(integrity) == {"algorithm", "canonicalization", "digest"}
        and integrity.get("algorithm") == "sha256"
        and integrity.get("canonicalization") == "python-json-sort-keys-v1"
        and isinstance(integrity.get("digest"), str),
        "manifest integrity contract changed",
    )


def validate_schema(root: Path) -> None:
    schema = load_json(root / SCHEMA_RELATIVE, str(SCHEMA_RELATIVE))
    require(
        schema.get("$schema") == "https://json-schema.org/draft/2020-12/schema",
        "schema draft changed",
    )
    require(schema.get("$id") == EXPECTED_SCHEMA_ID, "schema canonical ID changed")
    require(schema.get("type") == "object", "schema root type changed")
    require(schema.get("additionalProperties") is False, "schema root became open")
    required = schema.get("required")
    require(
        isinstance(required, list)
        and set(required)
        == set(EXPECTED_STATIC) | {"coveredArtifacts", "integrity"},
        "schema required field set changed",
    )


def validate_citation(root: Path) -> None:
    text = read_text(root / "CITATION.cff", "CITATION.cff")
    required_lines = {
        "cff-version: 1.2.0",
        "    given-names: Larry",
        "  - family-names: Cureton",
        "    alias: GEP-V",
        'repository-code: "https://github.com/SAABOLImpactVenture/ai-powered-infrastructure-as-a-product"',
        "license: Apache-2.0",
    }
    lines = set(text.splitlines())
    require(required_lines <= lines, "citation authorship or origin changed")


def validate_surface_text(root: Path) -> None:
    for relative in PROVENANCE_SURFACES:
        read_text(root / relative, relative)


def refresh_manifest(root: Path = ROOT) -> dict[str, Any]:
    path = root / MANIFEST_RELATIVE
    manifest = load_json(path, str(MANIFEST_RELATIVE))
    validate_static_contract(manifest)
    validate_surface_text(root)
    validate_schema(root)
    validate_citation(root)

    manifest["coveredArtifacts"] = [
        {
            "path": relative,
            "sha256": sha256_file(safe_artifact_path(root, relative)),
        }
        for relative in EXPECTED_COVERED_PATHS
    ]
    unsigned = {key: value for key, value in manifest.items() if key != "integrity"}
    manifest["integrity"]["digest"] = hashlib.sha256(
        canonical_json(unsigned)
    ).hexdigest()
    path.write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    return manifest


def verify(root: Path = ROOT) -> dict[str, Any]:
    manifest = load_json(root / MANIFEST_RELATIVE, str(MANIFEST_RELATIVE))
    validate_static_contract(manifest)
    validate_surface_text(root)
    validate_schema(root)
    validate_citation(root)

    for artifact in manifest["coveredArtifacts"]:
        require(
            SHA256_PATTERN.fullmatch(artifact["sha256"]) is not None,
            f"invalid SHA-256 for {artifact['path']}",
        )
        actual = sha256_file(safe_artifact_path(root, artifact["path"]))
        require(
            actual == artifact["sha256"],
            f"artifact digest changed: {artifact['path']}",
        )

    integrity = manifest["integrity"]
    require(
        SHA256_PATTERN.fullmatch(integrity["digest"]) is not None,
        "manifest integrity digest is not SHA-256",
    )
    unsigned = {key: value for key, value in manifest.items() if key != "integrity"}
    expected_digest = hashlib.sha256(canonical_json(unsigned)).hexdigest()
    require(
        integrity["digest"] == expected_digest,
        "manifest integrity check failed",
    )

    return {
        "schemaVersion": "saabol.portfolio-provenance-verification/v1",
        "result": "PASS",
        "fingerprint": MARKER,
        "coveredArtifacts": len(manifest["coveredArtifacts"]),
        "networkUsed": False,
        "credentialsUsed": False,
        "authorityAdded": False,
    }


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--refresh",
        action="store_true",
        help="refresh artifact and statement digests after an authorized change",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv or sys.argv[1:])
    try:
        if args.refresh:
            refresh_manifest()
            print(f"refreshed {MANIFEST_RELATIVE}")
        result = verify()
    except (OSError, ProvenanceError) as error:
        raise SystemExit(
            f"portfolio provenance verification failed closed: {error}"
        ) from error
    print(json.dumps(result, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

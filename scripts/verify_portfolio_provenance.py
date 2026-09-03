#!/usr/bin/env python3
"""Verify or refresh the passive Portfolio Provenance Gate."""

from __future__ import annotations

import argparse
import hashlib
import html
import json
import re
import sys
import unicodedata
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
EXPECTED_SCHEMA_SHA256 = (
    "6bd22d7525ecf09d4d5d1f04f0bd84ce4039a4f074bd09aa0c689b84a79e7cff"
)
EXPECTED_CITATION: dict[str, Any] = {
    "cff-version": "1.2.0",
    "message": (
        "If you use this portfolio, please cite the canonical repository "
        "and named author."
    ),
    "title": "AI-Powered Infrastructure as a Product",
    "type": "software",
    "authors": [
        {
            "family-names": "Cureton",
            "given-names": "Larry",
            "alias": "GEP-V",
        }
    ],
    "abstract": (
        "A governed portfolio for Infrastructure-as-a-Product architecture, "
        "product boundaries, and sanitized evidence."
    ),
    "repository-code": (
        "https://github.com/SAABOLImpactVenture/"
        "ai-powered-infrastructure-as-a-product"
    ),
    "url": (
        "https://saabolimpactventure.github.io/"
        "ai-powered-infrastructure-as-a-product/"
    ),
    "license": "Apache-2.0",
    "keywords": [
        "infrastructure-as-a-product",
        "platform-engineering",
        "provenance",
        "governed-evidence",
    ],
}
EXPECTED_ARTIFACT_SCHEMA_DEFINITIONS = [
    "ciWorkflowArtifact",
    "citationArtifact",
    "licenseArtifact",
    "makefileArtifact",
    "readmeArtifact",
    "provenanceDocArtifact",
    "publicationBoundaryArtifact",
    "thesisArtifact",
    "portfolioArtifact",
    "schemaArtifact",
    "verifierArtifact",
    "testArtifact",
]
SHA256_PATTERN = re.compile(r"^[0-9a-f]{64}$")
ACTIVE_MARKDOWN_FENCE_PATTERN = re.compile(
    r"(?:`{3,}|~{3,})[ \t]*mermaid\b",
    flags=re.IGNORECASE,
)


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


def validate_characters(text: str, label: str) -> None:
    for index, character in enumerate(text):
        codepoint = ord(character)
        if character in " \t\n\r":
            continue
        category = unicodedata.category(character)
        name = unicodedata.name(character, "")
        if (
            codepoint < 0x20
            or 0x7F <= codepoint <= 0x9F
            or character.isspace()
            or category in {"Cf", "Cs", "Co", "Cn", "Mn", "Me"}
            or "FILLER" in name
            or name == "BRAILLE PATTERN BLANK"
        ):
            raise ProvenanceError(
                f"{label}: non-rendering or unsafe Unicode U+{codepoint:04X} "
                f"at offset {index}"
            )


def validate_visible_text(text: str, label: str) -> None:
    validate_characters(text, label)

    if "<" in text or ">" in text:
        raise ProvenanceError(f"{label}: raw HTML or XML markup is not allowed")

    if PurePosixPath(label).suffix == ".md":
        # Provenance Markdown is intentionally limited to passive constructs.
        # Broad source-level rules avoid partial parsing of Markdown extensions
        # and remain effective even if the site renderer changes later.
        if "![" in text:
            raise ProvenanceError(
                f"{label}: Markdown embedded resources are not allowed"
            )
        if "{" in text or "}" in text:
            raise ProvenanceError(
                f"{label}: Markdown attribute lists are not allowed"
            )
        if ACTIVE_MARKDOWN_FENCE_PATTERN.search(text):
            raise ProvenanceError(
                f"{label}: active Markdown renderers are not allowed"
            )

        decoded = html.unescape(text)
        validate_characters(decoded, f"{label}: entity-decoded text")
        normalized = decoded.casefold().translate(
            {ord(character): None for character in "\\\t\n\r"}
        )
        for active_scheme in ("data:", "javascript:", "vbscript:"):
            if active_scheme in normalized:
                raise ProvenanceError(
                    f"{label}: active URI schemes are not allowed"
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
    schema_path = root / SCHEMA_RELATIVE
    require(
        sha256_file(schema_path) == EXPECTED_SCHEMA_SHA256,
        "complete schema bytes changed without a gate version update",
    )
    schema = load_json(schema_path, str(SCHEMA_RELATIVE))
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
    definitions = schema.get("$defs")
    require(isinstance(definitions, dict), "schema definitions are missing")
    properties = schema.get("properties")
    require(isinstance(properties, dict), "schema properties are missing")
    fingerprint_schema = properties.get("fingerprint", {}).get("properties", {})
    require(
        fingerprint_schema.get("markerSha256") == {"const": MARKER_SHA256},
        "schema fingerprint digest became variable",
    )
    claims_schema = properties.get("claims", {}).get("properties", {})
    require(
        claims_schema.get("aiSafety") == {"$ref": "#/$defs/aiSafetyFlags"}
        and claims_schema.get("authority")
        == {"$ref": "#/$defs/authorityFlags"},
        "schema claim references changed",
    )
    expected_false_contracts = {
        "aiSafetyFlags": set(EXPECTED_STATIC["claims"]["aiSafety"]),
        "authorityFlags": set(EXPECTED_STATIC["claims"]["authority"]),
    }
    for definition_name, expected_fields in expected_false_contracts.items():
        definition = definitions.get(definition_name)
        require(
            isinstance(definition, dict)
            and definition.get("type") == "object"
            and definition.get("additionalProperties") is False
            and set(definition.get("required", [])) == expected_fields
            and set(definition.get("properties", {})) == expected_fields
            and all(
                value == {"const": False}
                for value in definition.get("properties", {}).values()
            ),
            f"schema {definition_name} contract changed",
        )

    covered_schema = properties.get("coveredArtifacts", {})
    require(
        covered_schema.get("type") == "array"
        and covered_schema.get("items") is False
        and covered_schema.get("minItems") == len(EXPECTED_COVERED_PATHS)
        and covered_schema.get("maxItems") == len(EXPECTED_COVERED_PATHS)
        and covered_schema.get("prefixItems")
        == [
            {"$ref": f"#/$defs/{definition_name}"}
            for definition_name in EXPECTED_ARTIFACT_SCHEMA_DEFINITIONS
        ],
        "schema covered artifact sequence changed",
    )
    for definition_name, expected_path in zip(
        EXPECTED_ARTIFACT_SCHEMA_DEFINITIONS,
        EXPECTED_COVERED_PATHS,
        strict=True,
    ):
        require(
            definitions.get(definition_name)
            == {
                "$ref": "#/$defs/artifact",
                "properties": {"path": {"const": expected_path}},
            },
            f"schema artifact path changed: {definition_name}",
        )

    stage_schema = (
        properties.get("portfolioChain", {})
        .get("properties", {})
        .get("stages", {})
    )
    stage_items = stage_schema.get("prefixItems")
    require(
        isinstance(stage_items, list)
        and stage_schema.get("items") is False
        and stage_schema.get("minItems") == 5
        and stage_schema.get("maxItems") == 5
        and len(stage_items) == 5,
        "schema portfolio stage sequence changed",
    )
    observed_stages = []
    for item in stage_items:
        require(
            isinstance(item, dict)
            and item.get("type") == "object"
            and item.get("additionalProperties") is False
            and set(item.get("required", []))
            == {"sequence", "stage", "responsibility"},
            "schema portfolio stage shape changed",
        )
        stage_properties = item.get("properties", {})
        observed_stages.append(
            {
                key: stage_properties.get(key, {}).get("const")
                for key in ("sequence", "stage", "responsibility")
            }
        )
    require(
        observed_stages == EXPECTED_STATIC["portfolioChain"]["stages"],
        "schema portfolio stage values changed",
    )


def validate_citation(root: Path) -> None:
    citation = load_json(root / "CITATION.cff", "CITATION.cff")
    require(
        citation == EXPECTED_CITATION,
        "complete CFF 1.2 citation contract changed",
    )


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

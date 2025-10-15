#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Simple OSCAL-ish exporter.

This script demonstrates a minimal, well-formed CLI that can be linted and extended later.
It writes a small JSON document to stdout or to a file. Replace the `build_payload`
implementation with your real export logic when ready.
"""

from __future__ import annotations

import argparse
import json
import sys
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, Optional


def build_payload(system_id: str, title: Optional[str]) -> Dict[str, Any]:
    """Return a tiny OSCAL-like JSON structure."""
    now = datetime.utcnow().isoformat(timespec="seconds") + "Z"
    payload: Dict[str, Any] = {
        "metadata": {
            "title": title or f"System {system_id}",
            "last-modified": now,
            "version": "0.1.0",
        },
        "system-characteristics": {
            "system-ids": [{"identifier-type": "custom", "id": system_id}],
            "props": [
                {"name": "exporter", "value": "tools/oscal-export/export.py"},
                {"name": "generated-at", "value": now},
            ],
        },
    }
    return payload


def parse_args(argv: Optional[list[str]] = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Export a minimal OSCAL-like JSON document.")
    parser.add_argument(
        "--system-id",
        required=True,
        help="Identifier for the system being exported.",
    )
    parser.add_argument(
        "--title",
        default=None,
        help="Optional document title (defaults to 'System <system-id>').",
    )
    parser.add_argument(
        "-o",
        "--out",
        default="-",
        help="Output file path or '-' for stdout (default: '-').",
    )
    parser.add_argument(
        "--indent",
        type=int,
        default=2,
        help="Indent level for JSON output (default: 2).",
    )
    return parser.parse_args(argv)


def write_output(payload: Dict[str, Any], out_path: str, indent: int) -> None:
    data = json.dumps(payload, indent=indent, sort_keys=False)
    if out_path == "-" or out_path.strip() == "":
        print(data)
        return

    path = Path(out_path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(data + "\n", encoding="utf-8")


def main(argv: Optional[list[str]] = None) -> int:
    args = parse_args(argv)
    payload = build_payload(system_id=args.system_id, title=args.title)
    try:
        write_output(payload, args.out, args.indent)
    except OSError as exc:
        sys.stderr.write(f"error: failed to write output: {exc}\n")
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

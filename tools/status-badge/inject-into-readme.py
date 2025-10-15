#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Inject or update workflow status badges inside README.md between two markers.

Usage:
    python tools/status-badge/inject-into-readme.py \
        --readme README.md \
        --marker-start "<!-- BADGES:START -->" \
        --marker-end "<!-- BADGES:END -->" \
        --badges "[![Build](https://example/badge.svg)](https://example/actions)"

The script is intentionally conservative: if markers are missing, it appends a new block
to the top of the README.
"""

from __future__ import annotations

import argparse
from pathlib import Path
from typing import Tuple

DEFAULT_START = "<!-- BADGES:START -->"
DEFAULT_END = "<!-- BADGES:END -->"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Inject workflow badges into README.md.")
    parser.add_argument(
        "--readme",
        default="README.md",
        help="Path to README file (default: README.md).",
    )
    parser.add_argument(
        "--marker-start",
        default=DEFAULT_START,
        help=f"Start marker (default: {DEFAULT_START})",
    )
    parser.add_argument(
        "--marker-end",
        default=DEFAULT_END,
        help=f"End marker (default: {DEFAULT_END})",
    )
    parser.add_argument(
        "--badges",
        required=True,
        help="Markdown to place between the markers (badge lines).",
    )
    return parser.parse_args()


def inject_block(content: str, start: str, end: str, badges_md: str) -> Tuple[str, bool]:
    """
    Return updated README content and a flag indicating whether markers existed.
    """
    start_idx = content.find(start)
    end_idx = content.find(end)

    block = f"{start}\n{badges_md.rstrip()}\n{end}\n"

    if start_idx != -1 and end_idx != -1 and end_idx > start_idx:
        # Replace existing block
        before = content[:start_idx]
        after = content[end_idx + len(end) :]
        updated = f"{before}{block}{after}"
        return updated, True

    # No markers found; prepend a new block with a trailing newline
    updated_content = f"{block}\n{content}"
    return updated_content, False


def main() -> int:
    args = parse_args()
    readme_path = Path(args.readme)

    if not readme_path.exists():
        readme_path.write_text("", encoding="utf-8")

    original = readme_path.read_text(encoding="utf-8")
    updated, replaced = inject_block(original, args.marker_start, args.marker_end, args.badges)
    readme_path.write_text(updated, encoding="utf-8")

    action = "updated existing" if replaced else "inserted new"
    print(f"Status badge block {action} section in {readme_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

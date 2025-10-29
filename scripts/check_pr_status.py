#!/usr/bin/env python3
"""
check_pr_status.py

Prints a concise status report for open PRs, highlights blockers, and recommends next steps.
Requires GitHub CLI (`gh`) authenticated for the repo.
"""

from __future__ import annotations

import json
import shutil
import subprocess
import sys
from dataclasses import dataclass
from typing import Any, Dict, List, Optional


@dataclass
class PRStatus:
    number: int
    title: str
    is_draft: bool
    head_ref: str
    mergeable: Optional[str]
    review_decision: Optional[str]
    state: str
    failing_checks: int
    pending_checks: int
    successful_checks: int
    required_failing: int
    blockers: List[str]

    def ready_to_merge(self) -> bool:
        if self.state != "OPEN":
            return False
        if self.is_draft:
            return False
        if self.review_decision not in {"APPROVED", "REVIEW_REQUIRED"}:
            return False
        if self.required_failing > 0:
            return False
        if self.failing_checks > 0:
            return False
        if self.pending_checks > 0:
            return False
        if self.mergeable not in {"MERGEABLE", "MERGEABLE_STATE_UNKNOWN", None}:
            return False
        return True


def run_gh(args: List[str]) -> Any:
    cmd = ["gh"] + args
    try:
        out = subprocess.check_output(cmd, text=True)
        return out
    except subprocess.CalledProcessError as e:
        print(f"ERROR: gh command failed: {' '.join(cmd)}", file=sys.stderr)
        print(e.output, file=sys.stderr)
        sys.exit(1)


def gh_json(args: List[str]) -> Any:
    out = run_gh(args)
    try:
        return json.loads(out)
    except json.JSONDecodeError:
        print("ERROR: failed to parse gh JSON output", file=sys.stderr)
        sys.exit(1)


def list_open_prs() -> List[Dict[str, Any]]:
    fields = [
        "number",
        "title",
        "isDraft",
        "headRefName",
        "mergeable",
        "reviewDecision",
        "author",
        "state",
    ]
    return gh_json(["pr", "list", "--state", "open", "--json", ",".join(fields)])


def pr_checks(number: int) -> Dict[str, Any]:
    fields = ["statusCheckRollup"]
    return gh_json(["pr", "view", str(number), "--json", ",".join(fields)])


def summarize_checks(rollup: Optional[List[Dict[str, Any]]]) -> Dict[str, int]:
    failing = 0
    pending = 0
    success = 0
    required_failing = 0

    if not rollup:
        return {
            "failing": failing,
            "pending": pending,
            "success": success,
            "required_failing": required_failing,
        }

    for item in rollup:
        # GitHub may give either a checkRun or a statusContext shape
        item.get("name") or ""
        required = bool(item.get("required", False))
        conclusion = item.get("conclusion")
        status = item.get("status")

        # Normalize state
        state = None
        if conclusion:
            state = conclusion.upper()
        elif status:
            state = status.upper()

        if state in {"FAILURE", "FAILED", "ERROR", "CANCELLED", "TIMED_OUT"}:
            failing += 1
            if required:
                required_failing += 1
        elif state in {"PENDING", "EXPECTED", "IN_PROGRESS", "QUEUED"}:
            pending += 1
        elif state in {"SUCCESS", "NEUTRAL", "SKIPPED"}:
            # Count NEUTRAL/SKIPPED as success for summary purposes
            success += 1
        else:
            # Unknown states are treated as pending
            pending += 1

    return {
        "failing": failing,
        "pending": pending,
        "success": success,
        "required_failing": required_failing,
    }


def recommend(pr: PRStatus) -> List[str]:
    recs: List[str] = []
    if pr.is_draft:
        recs.append("Convert from Draft when ready.")
    if pr.review_decision == "REVIEW_REQUIRED":
        recs.append("Request/collect required reviews.")
    if pr.required_failing > 0:
        recs.append("Fix failing *required* checks.")
    if pr.failing_checks > 0 and pr.required_failing == 0:
        recs.append("Fix failing optional checks or de-scope CI to relevant paths.")
    if pr.pending_checks > 0:
        recs.append("Wait for pending checks to complete or reduce CI scope.")
    if pr.ready_to_merge():
        recs.append("Enable auto-merge (squash).")
    if not recs:
        recs.append("No action needed.")
    return recs


def format_row(cols: List[str], widths: List[int]) -> str:
    parts = []
    for i, col in enumerate(cols):
        w = widths[i]
        if len(col) > w:
            col = col[: w - 1] + ""
        parts.append(col.ljust(w))
    return " | ".join(parts)


def main() -> int:
    if shutil.which("gh") is None:
        print("ERROR: GitHub CLI (gh) not found on PATH.", file=sys.stderr)
        return 2

    prs = list_open_prs()

    headers = ["#", "Draft", "Reviews", "Checks F/P/S/R*", "Title"]
    widths = [5, 7, 9, 17, 60]
    print(format_row(headers, widths))
    print("-" * (sum(widths) + 3 * (len(widths) - 1)))

    any_blockers = False

    for pr in prs:
        number = pr["number"]
        title = pr["title"]
        is_draft = bool(pr.get("isDraft", False))
        head_ref = pr.get("headRefName", "")
        mergeable = pr.get("mergeable")
        review_decision = pr.get("reviewDecision")
        state = pr.get("state", "")

        view = pr_checks(number)
        rollup = view.get("statusCheckRollup")
        sums = summarize_checks(rollup)

        status = PRStatus(
            number=number,
            title=title,
            is_draft=is_draft,
            head_ref=head_ref,
            mergeable=mergeable,
            review_decision=review_decision,
            state=state,
            failing_checks=sums["failing"],
            pending_checks=sums["pending"],
            successful_checks=sums["success"],
            required_failing=sums["required_failing"],
            blockers=[],
        )

        if is_draft:
            status.blockers.append("draft")
        if review_decision == "REVIEW_REQUIRED":
            status.blockers.append("reviews")
        if status.required_failing > 0:
            status.blockers.append("required checks")
        if status.failing_checks > 0:
            status.blockers.append("checks")

        any_blockers = any_blockers or bool(status.blockers)

        checks_cell = (
            f"{status.failing_checks}/"
            f"{status.pending_checks}/"
            f"{status.successful_checks}/"
            f"{status.required_failing}"
        )
        reviews_cell = review_decision or "-"

        row = [
            f"#{number}",
            "yes" if is_draft else "no",
            reviews_cell,
            checks_cell,
            title,
        ]
        print(format_row(row, widths))

        recs = recommend(status)
        for r in recs:
            print(f"  - {r}")

    print()
    print("* R* = required failing checks")
    if any_blockers:
        print("One or more PRs have blockers. See recommendations above.")
    else:
        print("All open PRs appear merge-ready.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

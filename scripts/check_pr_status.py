#!/usr/bin/env python3
"""
Pull Request Status Checker

This script checks the status of open pull requests and provides
recommendations for approval and merging.

Usage:
    python scripts/check_pr_status.py

Requirements:
    - GitHub CLI (gh) installed and authenticated
    OR
    - GITHUB_TOKEN environment variable set
"""

import json
import os
import subprocess
import sys
from typing import Dict, List, Optional


def run_gh_command(args: List[str]) -> Optional[str]:
    """Run a GitHub CLI command and return the output."""
    try:
        result = subprocess.run(
            ["gh"] + args,
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"Error running gh command: {e}")
        print(f"stderr: {e.stderr}")
        return None
    except FileNotFoundError:
        print("GitHub CLI (gh) not found. Please install it or set GITHUB_TOKEN.")
        return None


def get_open_prs() -> List[Dict]:
    """Get list of open pull requests."""
    output = run_gh_command([
        "pr", "list",
        "--json", "number,title,author,state,isDraft,mergeable,reviewDecision,statusCheckRollup,commits",
        "--state", "open"
    ])
    
    if output:
        return json.loads(output)
    return []


def get_pr_details(pr_number: int) -> Optional[Dict]:
    """Get detailed information about a specific PR."""
    output = run_gh_command([
        "pr", "view", str(pr_number),
        "--json", "number,title,author,state,isDraft,mergeable,reviewDecision,statusCheckRollup,files,additions,deletions"
    ])
    
    if output:
        return json.loads(output)
    return None


def check_pr_readiness(pr: Dict) -> Dict[str, any]:
    """Check if a PR is ready to be merged."""
    issues = []
    ready = True
    
    # Check if PR is draft
    if pr.get("isDraft", False):
        issues.append("PR is marked as draft")
        ready = False
    
    # Check mergeable status
    mergeable = pr.get("mergeable", "UNKNOWN")
    if mergeable == "CONFLICTING":
        issues.append("PR has merge conflicts")
        ready = False
    elif mergeable == "UNKNOWN":
        issues.append("Mergeable status is unknown")
        ready = False
    
    # Check review decision
    review_decision = pr.get("reviewDecision")
    if review_decision == "CHANGES_REQUESTED":
        issues.append("Changes requested in review")
        ready = False
    elif review_decision != "APPROVED":
        issues.append(f"Review status: {review_decision or 'No reviews yet'}")
        if review_decision != "APPROVED":
            ready = False
    
    # Check status checks
    status_rollup = pr.get("statusCheckRollup", [])
    if status_rollup:
        failed_checks = [
            check for check in status_rollup
            if check.get("conclusion") == "FAILURE" or check.get("state") == "FAILURE"
        ]
        pending_checks = [
            check for check in status_rollup
            if check.get("conclusion") == "PENDING" or check.get("state") == "PENDING"
        ]
        
        if failed_checks:
            issues.append(f"{len(failed_checks)} status check(s) failed")
            ready = False
        if pending_checks:
            issues.append(f"{len(pending_checks)} status check(s) pending")
    
    return {
        "ready": ready,
        "issues": issues,
        "mergeable": mergeable,
        "review_decision": review_decision
    }


def print_pr_summary(pr: Dict):
    """Print a summary of the PR status."""
    details = get_pr_details(pr["number"])
    if not details:
        details = pr
    
    readiness = check_pr_readiness(details)
    
    print(f"\n{'='*80}")
    print(f"PR #{pr['number']}: {pr['title']}")
    print(f"{'='*80}")
    print(f"Author: {pr['author'].get('login', 'Unknown')}")
    print(f"State: {pr['state']}")
    print(f"Draft: {'Yes' if pr.get('isDraft') else 'No'}")
    
    if details:
        additions = details.get('additions', 'Unknown')
        deletions = details.get('deletions', 'Unknown')
        files = len(details.get('files', []))
        print(f"Changes: +{additions} -{deletions} across {files} file(s)")
    
    print(f"\nMergeable: {readiness['mergeable']}")
    print(f"Review Decision: {readiness['review_decision'] or 'None'}")
    
    if readiness['ready']:
        print(f"\n✅ Status: READY TO MERGE")
    else:
        print(f"\n❌ Status: NOT READY")
        print(f"\nIssues:")
        for issue in readiness['issues']:
            print(f"  - {issue}")
    
    print(f"\nRecommendation:")
    if readiness['ready']:
        print(f"  This PR can be merged. Run: gh pr merge {pr['number']}")
    else:
        if "No reviews yet" in str(readiness['issues']):
            print(f"  Request a review or approve: gh pr review {pr['number']} --approve")
        if "merge conflicts" in str(readiness['issues']).lower():
            print(f"  Resolve merge conflicts in the PR branch")
        if "status check" in str(readiness['issues']).lower():
            print(f"  Wait for status checks to complete or fix failing checks")
        if "draft" in str(readiness['issues']).lower():
            print(f"  Mark PR as ready for review: gh pr ready {pr['number']}")


def main():
    """Main function."""
    print("Checking Pull Request Status...")
    print("="*80)
    
    prs = get_open_prs()
    
    if not prs:
        print("No open pull requests found.")
        return 0
    
    print(f"Found {len(prs)} open pull request(s)\n")
    
    ready_to_merge = []
    needs_attention = []
    
    for pr in prs:
        print_pr_summary(pr)
        
        readiness = check_pr_readiness(pr)
        if readiness['ready']:
            ready_to_merge.append(pr['number'])
        else:
            needs_attention.append(pr['number'])
    
    # Summary
    print(f"\n{'='*80}")
    print("SUMMARY")
    print(f"{'='*80}")
    print(f"Total Open PRs: {len(prs)}")
    print(f"Ready to Merge: {len(ready_to_merge)}")
    print(f"Needs Attention: {len(needs_attention)}")
    
    if ready_to_merge:
        print(f"\nPRs ready to merge: {', '.join(f'#{n}' for n in ready_to_merge)}")
    
    if needs_attention:
        print(f"\nPRs needing attention: {', '.join(f'#{n}' for n in needs_attention)}")
    
    return 0


if __name__ == "__main__":
    sys.exit(main())

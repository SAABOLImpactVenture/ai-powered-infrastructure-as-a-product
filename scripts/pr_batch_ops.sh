#!/bin/bash
# PR Batch Operations Script
# This script helps with batch operations on pull requests

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if gh CLI is installed
check_gh_cli() {
    if ! command -v gh &> /dev/null; then
        print_error "GitHub CLI (gh) is not installed"
        print_info "Install it from: https://cli.github.com/"
        exit 1
    fi
    
    # Check if authenticated
    if ! gh auth status &> /dev/null; then
        print_error "GitHub CLI is not authenticated"
        print_info "Run: gh auth login"
        exit 1
    fi
}

# List all open PRs
list_prs() {
    print_info "Fetching open pull requests..."
    gh pr list --state open --json number,title,author,isDraft,reviewDecision,mergeable \
        --template '{{range .}}PR #{{.number}}: {{.title}}
  Author: {{.author.login}}
  Draft: {{.isDraft}}
  Review: {{.reviewDecision}}
  Mergeable: {{.mergeable}}
{{end}}'
}

# Approve a single PR
approve_pr() {
    local pr_number=$1
    print_info "Approving PR #${pr_number}..."
    
    if gh pr review "$pr_number" --approve; then
        print_info "✅ PR #${pr_number} approved successfully"
    else
        print_error "❌ Failed to approve PR #${pr_number}"
        return 1
    fi
}

# Approve all open PRs
approve_all() {
    print_warning "This will approve ALL open pull requests"
    read -p "Are you sure? (yes/no): " confirm
    
    if [ "$confirm" != "yes" ]; then
        print_info "Operation cancelled"
        return 0
    fi
    
    # Get all PR numbers
    pr_numbers=$(gh pr list --state open --json number --jq '.[].number')
    
    if [ -z "$pr_numbers" ]; then
        print_info "No open PRs found"
        return 0
    fi
    
    for pr in $pr_numbers; do
        approve_pr "$pr" || true
        sleep 1  # Rate limiting
    done
}

# Merge a single PR
merge_pr() {
    local pr_number=$1
    local merge_method=${2:-merge}  # merge, squash, or rebase
    
    print_info "Merging PR #${pr_number} using ${merge_method} method..."
    
    case "$merge_method" in
        merge)
            gh pr merge "$pr_number" --merge --auto
            ;;
        squash)
            gh pr merge "$pr_number" --squash --auto
            ;;
        rebase)
            gh pr merge "$pr_number" --rebase --auto
            ;;
        *)
            print_error "Invalid merge method: $merge_method"
            print_info "Valid methods: merge, squash, rebase"
            return 1
            ;;
    esac
    
    if [ $? -eq 0 ]; then
        print_info "✅ PR #${pr_number} merge initiated successfully"
    else
        print_error "❌ Failed to merge PR #${pr_number}"
        return 1
    fi
}

# Merge all ready PRs
merge_all() {
    local merge_method=${1:-merge}
    
    print_warning "This will attempt to merge ALL mergeable pull requests"
    print_info "Merge method: ${merge_method}"
    read -p "Are you sure? (yes/no): " confirm
    
    if [ "$confirm" != "yes" ]; then
        print_info "Operation cancelled"
        return 0
    fi
    
    # Get PR numbers that are mergeable and approved
    pr_numbers=$(gh pr list --state open --json number,mergeable,reviewDecision \
        --jq '.[] | select(.mergeable=="MERGEABLE" and .reviewDecision=="APPROVED") | .number')
    
    if [ -z "$pr_numbers" ]; then
        print_info "No PRs ready to merge found"
        return 0
    fi
    
    print_info "Found $(echo "$pr_numbers" | wc -l) PR(s) ready to merge"
    
    for pr in $pr_numbers; do
        merge_pr "$pr" "$merge_method" || true
        sleep 2  # Rate limiting
    done
}

# Check PR status using Python script
check_status() {
    if [ -f "$REPO_ROOT/scripts/check_pr_status.py" ]; then
        python3 "$REPO_ROOT/scripts/check_pr_status.py"
    else
        print_error "check_pr_status.py not found"
        exit 1
    fi
}

# Show usage
usage() {
    cat << EOF
PR Batch Operations Script

Usage: $0 <command> [options]

Commands:
    list                 List all open pull requests
    check               Check status of all PRs (detailed)
    approve <PR#>       Approve a specific PR
    approve-all         Approve all open PRs
    merge <PR#> [method] Merge a specific PR (method: merge|squash|rebase)
    merge-all [method]  Merge all ready PRs (method: merge|squash|rebase)
    help                Show this help message

Examples:
    $0 list
    $0 check
    $0 approve 59
    $0 approve-all
    $0 merge 59 squash
    $0 merge-all merge

Note: This script requires GitHub CLI (gh) to be installed and authenticated.
EOF
}

# Main script
main() {
    check_gh_cli
    
    case "${1:-help}" in
        list)
            list_prs
            ;;
        check)
            check_status
            ;;
        approve)
            if [ -z "$2" ]; then
                print_error "PR number required"
                usage
                exit 1
            fi
            approve_pr "$2"
            ;;
        approve-all)
            approve_all
            ;;
        merge)
            if [ -z "$2" ]; then
                print_error "PR number required"
                usage
                exit 1
            fi
            merge_pr "$2" "${3:-merge}"
            ;;
        merge-all)
            merge_all "${2:-merge}"
            ;;
        help)
            usage
            ;;
        *)
            print_error "Unknown command: $1"
            usage
            exit 1
            ;;
    esac
}

main "$@"

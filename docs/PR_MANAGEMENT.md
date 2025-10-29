# Pull Request Management

This directory contains tools and documentation for managing pull requests in this repository.

## 📋 Overview

The repository currently has multiple open pull requests that need review and approval. This document provides guidance on how to efficiently manage these PRs.

## 🛠️ Available Tools

### 1. PR Status Checker (`scripts/check_pr_status.py`)

A Python script that checks the status of all open PRs and provides recommendations.

**Usage:**
```bash
python3 scripts/check_pr_status.py
```

**Features:**
- Lists all open PRs
- Checks mergeable status
- Verifies review status
- Identifies blocking issues
- Provides actionable recommendations

**Requirements:**
- GitHub CLI (`gh`) installed and authenticated
- OR `GITHUB_TOKEN` environment variable set

### 2. PR Batch Operations (`scripts/pr_batch_ops.sh`)

A bash script for performing batch operations on PRs.

**Usage:**
```bash
# List all open PRs
./scripts/pr_batch_ops.sh list

# Check detailed status
./scripts/pr_batch_ops.sh check

# Approve a specific PR
./scripts/pr_batch_ops.sh approve 59

# Approve all open PRs
./scripts/pr_batch_ops.sh approve-all

# Merge a specific PR
./scripts/pr_batch_ops.sh merge 59 squash

# Merge all ready PRs
./scripts/pr_batch_ops.sh merge-all merge
```

**Merge Methods:**
- `merge`: Create a merge commit (default)
- `squash`: Squash and merge
- `rebase`: Rebase and merge

## 📖 Documentation

### [PR Review Guide](../docs/PR_REVIEW_GUIDE.md)

Comprehensive guide covering:
- Review process
- Approval workflow
- Merge strategies
- Best practices
- Troubleshooting

## 🚀 Quick Start

### Prerequisites

1. **Install GitHub CLI:**
   ```bash
   # macOS
   brew install gh

   # Linux
   sudo apt install gh  # Debian/Ubuntu
   sudo dnf install gh  # Fedora

   # Windows
   winget install --id GitHub.cli
   ```

2. **Authenticate:**
   ```bash
   gh auth login
   ```

### Workflow

1. **Check PR Status:**
   ```bash
   python3 scripts/check_pr_status.py
   ```

2. **Review Each PR:**
   - Read the changes
   - Check for security issues
   - Verify tests pass
   - Ensure documentation is updated

3. **Approve PRs:**
   ```bash
   # Single PR
   gh pr review <PR-NUMBER> --approve

   # Or use batch script
   ./scripts/pr_batch_ops.sh approve <PR-NUMBER>
   ```

4. **Merge PRs:**
   ```bash
   # Single PR
   gh pr merge <PR-NUMBER> --squash

   # Or use batch script
   ./scripts/pr_batch_ops.sh merge <PR-NUMBER> squash
   ```

## 📊 Current PR Status

To get the latest status of all open PRs, run:

```bash
python3 scripts/check_pr_status.py
```

### Known Open PRs

- **PR #59**: Add files via upload (AI-IAAP package)
- **PR #60**: Add files via upload
- **PR #61**: Add files via upload
- **PR #62**: Add files via upload
- **PR #63**: Add files via upload

**Note:** All PRs are currently in "blocked" state and need review/approval.

## ⚙️ Automation

### GitHub Actions Workflow

You can also create a GitHub Actions workflow for automated PR management. Example:

```yaml
name: Auto-approve dependabot PRs
on: pull_request_target

jobs:
  auto-approve:
    runs-on: ubuntu-latest
    if: github.actor == 'dependabot[bot]'
    steps:
      - uses: hmarr/auto-approve-action@v3
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

### Pre-commit Hooks

Ensure pre-commit hooks are installed:

```bash
pre-commit install
pre-commit run --all-files
```

## 🔒 Security Considerations

Before approving any PR:

1. **Review dependencies**: Check for known vulnerabilities
2. **Scan for secrets**: Ensure no credentials are committed
3. **Verify author**: Confirm the PR author is trusted
4. **Check for malicious code**: Look for suspicious patterns

## 📝 PR Template Checklist

Ensure each PR includes:

- [ ] Clear summary of changes
- [ ] Type of change identified (Feature/Fix/Docs/Chore)
- [ ] Testing approach documented
- [ ] Lint checks passing
- [ ] All tests passing
- [ ] Documentation updated (if applicable)

## 🤝 Contributing

For questions or improvements to the PR management process:

1. Open an issue for discussion
2. Submit a PR with your proposed changes
3. Tag relevant maintainers for review

## 🆘 Troubleshooting

### PRs are blocked

**Possible causes:**
- Branch protection requires approvals
- Status checks haven't completed
- Merge conflicts exist
- PR is in draft state

**Solutions:**
- Review and approve the PR
- Wait for CI/CD to complete
- Resolve conflicts in the PR branch
- Mark draft PRs as ready for review

### Cannot merge

**Possible causes:**
- Insufficient permissions
- Required reviews pending
- Failing status checks

**Solutions:**
- Contact repository administrators
- Request additional reviews
- Fix failing tests/checks

### Script errors

**Issue**: `gh: command not found`
**Solution**: Install GitHub CLI (see Prerequisites)

**Issue**: `gh auth status` fails
**Solution**: Run `gh auth login` to authenticate

## 📚 Resources

- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [GitHub PR Best Practices](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests)
- [Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches)

## 📞 Support

For assistance with PR management:
- Review the [PR Review Guide](../docs/PR_REVIEW_GUIDE.md)
- Check existing issues
- Contact repository maintainers
- Open a discussion in the repository

---

**Last Updated:** 2025-10-29
**Maintainer:** Repository Team

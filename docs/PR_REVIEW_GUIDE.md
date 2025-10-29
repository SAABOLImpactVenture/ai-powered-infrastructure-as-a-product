# Pull Request Review and Merge Guide

## Overview
This guide provides instructions for reviewing and merging pull requests in this repository.

## Current Open Pull Requests

As of the last check, the following PRs are open:

- **PR #59**: Add files via upload (AI-IAAP package) - 821 additions, 61 files changed
- **PR #60**: Add files via upload - Additions pending review
- **PR #61**: Add files via upload - 821 additions, 61 files changed  
- **PR #62**: Add files via upload - 36 additions, 1 file changed
- **PR #63**: Add files via upload - 114 additions, 12 files changed

## PR Status

All PRs are currently in a **"blocked"** mergeable state, which means they cannot be merged until certain requirements are met.

## Common Blocking Reasons

1. **Required Reviews**: Branch protection may require approval from code owners or specific reviewers
2. **Status Checks**: CI/CD pipelines must pass before merging
3. **Merge Conflicts**: The PR branch may have conflicts with the base branch
4. **Branch Protection Rules**: Repository settings may enforce specific rules

## Steps to Approve and Merge PRs

### 1. Review the Changes

For each PR:
1. Navigate to the PR on GitHub
2. Review the files changed
3. Check for:
   - Code quality
   - Security concerns
   - Breaking changes
   - Documentation updates
   - Test coverage

### 2. Run Required Checks

Ensure the following checks pass:
- `pre-commit` linting
- All tests pass on matrix versions (3.11, 3.13)
- Documentation is updated if needed
- Security scans (CodeQL, secret scanning) pass

### 3. Approve the PR

If you have approval rights:
1. Go to the "Files changed" tab
2. Click "Review changes"
3. Select "Approve"
4. Submit your review

### 4. Merge the PR

Once all requirements are met:
1. Ensure all status checks are green
2. Resolve any merge conflicts
3. Click "Merge pull request"
4. Choose merge strategy (squash, merge commit, or rebase)
5. Confirm the merge

## Automation Options

### GitHub CLI
```bash
# Approve a PR
gh pr review <PR-NUMBER> --approve

# Merge a PR
gh pr merge <PR-NUMBER> --merge
```

### Using the GitHub API
```bash
# Approve a PR
curl -X POST \
  -H "Authorization: token YOUR_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR-NUMBER/reviews \
  -d '{"event":"APPROVE"}'

# Merge a PR
curl -X PUT \
  -H "Authorization: token YOUR_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR-NUMBER/merge
```

## Best Practices

1. **Review Thoroughly**: Always review code changes before approving
2. **Test Locally**: For significant changes, pull the branch and test locally
3. **Check Dependencies**: Verify that new dependencies don't introduce vulnerabilities
4. **Update Documentation**: Ensure documentation reflects code changes
5. **Communicate**: Add comments if you have questions or suggestions

## Required PR Template Checklist

Before merging, ensure the PR template is completed:
- [ ] Summary section filled out
- [ ] Type of change selected (Feature/Fix/Docs/Chore)
- [ ] Testing details provided
- [ ] Lint check passed
- [ ] Tests pass on all matrix versions
- [ ] Docs updated (if needed)

## Troubleshooting

### PR is Blocked
- Check branch protection rules in repository settings
- Verify all required reviewers have approved
- Ensure all status checks have passed
- Resolve any merge conflicts

### Status Checks Failing
- Review the CI/CD logs
- Fix any linting errors
- Ensure all tests pass
- Update code if security vulnerabilities are found

### Merge Conflicts
```bash
# Update your branch with main
git checkout <branch-name>
git fetch origin
git merge origin/main
# Resolve conflicts
git add .
git commit
git push
```

## Contact

For questions or assistance with PR reviews, contact the repository maintainers or open a discussion.

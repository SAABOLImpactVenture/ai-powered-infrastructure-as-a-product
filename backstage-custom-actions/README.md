
# Backstage Custom Action: repo:addLabels

Adds approval labels to a PR (used by the **agent-governance** workflow).

## Example scaffolder step
```yaml
- id: approvals
  name: Add role approval labels
  action: repo:addLabels
  input:
    owner: my-org
    repo: my-repo
    pullNumber: 123
    labels: [approved-pm, approved-da]
```

# Job hardening header (apply to all workflows)

```yaml
permissions:
  contents: read
  id-token: write
concurrency: ci-${{ github.workflow }}-${{ github.ref }}
```

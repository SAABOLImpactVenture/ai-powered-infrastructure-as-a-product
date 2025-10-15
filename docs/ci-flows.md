# CI Flows (GitHub Actions)

This document describes how our GitHub Actions workflow (`.github/workflows/ci.yml`) runs, how to read its output, how to re‑run or inspect jobs with the GitHub CLI, and how to extend the pipeline safely.

---

## At-a-glance

- **Workflow file**: `.github/workflows/ci.yml`
- **Jobs**: `lint`, `tests (3.11)`, `tests (3.12)`, `tests (3.13)`
- **Python**: 3.11 for linting; test matrix: 3.11–3.13
- **Key tools**: `pre-commit` (autoflake, isort, black, flake8), `pytest`
- **Runners**: `ubuntu-24.04` (hosted)
- **Caching**: `actions/setup-python@v5` pip cache + `pre-commit` cache
- **Typical status**: All green → mergeable
- **PR Checks**: CI must pass before merge (branch protection recommended)

---

## 1) When does CI run?

The workflow is triggered on:
- **Push** to branches (including feature branches).
- **Pull Requests** targeting the default branch.
- Optional **manual dispatch** from the Actions tab.

Each push to a branch will create a new “run” composed of the jobs below.

> Tip: If only docs or non-Python files change, jobs still run fast thanks to caching.

---

## 2) Jobs / Stages

### a) `lint`

- Sets up **Python 3.11**.
- Installs **pre-commit** and restores **~/.cache/pre-commit** with `actions/cache@v4`.
- Runs `pre-commit run -a` which includes:
  - **autoflake** — remove unused imports/vars
  - **isort** — import sorting
  - **black** — code formatter
  - **flake8** — style and quality checks

**Why this matters**: fast feedback and consistent style before tests.

**Logs**: In the job view you’ll see explicit “Passed” lines for each hook:

```
autoflake..........................Passed
isort..............................Passed
black..............................Passed
flake8.............................Passed
```

### b) `tests (3.11)` / `tests (3.12)` / `tests (3.13)`

- Sets up the matching Python version.
- Installs dev deps from **`requirements-dev.txt`** (pytest, flake8, black, etc.).
- Detects tests and runs **pytest**:
  - Globs: `tests/test_*.py` or `*_test.py`.
  - If no tests are found, the job prints *“No tests detected; skipping pytest.”* and succeeds.
- Example summary:
```
1 passed, 1 skipped in 0.31s
```

**Why this matters**: compatibility across the supported Python versions.

---

## 3) Caching

- **pip cache**: handled by `actions/setup-python@v5`.
- **pre-commit cache**: `~/.cache/pre-commit` keyed by Python version + hook revisions.
- Cache hits are indicated in the logs (e.g., “Cache hit for: setup-python…”, “Cache restored successfully”).

This keeps CI fast even on cold runners.

---

## 4) Inspecting & re-running with GitHub CLI (`gh`)

Install `gh` and authenticate (`gh auth login`). The snippets below are PowerShell‑friendly and were validated from the maintainer’s console logs you may have seen earlier.

### Get the latest run ID for a workflow + branch
```powershell
function Get-LatestRunId {
  param(
    [Parameter(Mandatory=$true)][string]$Workflow,
    [Parameter(Mandatory=$true)][string]$Branch,
    [ValidateSet('all','queued','in_progress','completed','success','failure','cancelled')]
    [string]$Status = 'all'
  )
  $args = @('run','list','--workflow', $Workflow, '--branch', $Branch, '--limit','1','--json','databaseId')
  if ($Status -ne 'all') { $args += @('--status', $Status) }
  $runs = gh @args | ConvertFrom-Json
  if (-not $runs -or -not $runs[0].databaseId) { throw "No runs for '$Workflow' on '$Branch' (status=$Status)." }
  return $runs[0].databaseId
}
```

### List jobs in a run
```powershell
function Get-RunJobs {
  param([Parameter(Mandatory=$true)][long]$RunId)
  $j = gh run view $RunId --json jobs | ConvertFrom-Json
  if (-not $j -or -not $j.jobs) { throw "No jobs found in run $RunId." }
  $j.jobs | Select-Object name, id, databaseId, status, conclusion, startedAt, completedAt
}
```

### Resolve a job ID by (fuzzy) name
> PowerShell doesn’t support `??`; use an explicit fallback.
```powershell
function Get-JobId {
  param(
    [Parameter(Mandatory=$true)][long]$RunId,
    [Parameter(Mandatory=$true)][string]$Name,
    [switch]$Exact
  )
  $jobs = Get-RunJobs -RunId $RunId
  $match = if ($Exact) {
    $jobs | Where-Object { $_.name -eq $Name }
  } else {
    $jobs | Where-Object { $_.name -like "*$Name*" }
  }

  if (-not $match) { throw "Job '$Name' not found in run $RunId.`nAvailable: $($jobs.name -join ', ')" }
  if ($match.Count -gt 1) { throw "Multiple jobs match '$Name': $($match.name -join ', ')" }

  if ($match.databaseId) { return $match.databaseId }
  elseif ($match.id) { return $match.id }
  else { throw "No usable job identifier for '$($match.name)'." }
}
```

### Show job logs (optionally only failed steps)
```powershell
function Show-JobLogs {
  param(
    [Parameter(Mandatory=$true)][string]$Workflow,
    [Parameter(Mandatory=$true)][string]$Branch,
    [Parameter(Mandatory=$true)][string]$JobName,
    [switch]$FailedOnly,
    [string]$Status = 'all'
  )
  $runId = Get-LatestRunId -Workflow $Workflow -Branch $Branch -Status $Status
  $jobId = Get-JobId -RunId $runId -Name $JobName
  if ($FailedOnly) { gh run view --job $jobId --log-failed } else { gh run view --job $jobId --log }
}
```

### Re-run the latest failed run (only failed jobs)
```powershell
function Rerun-LatestFailed {
  param([Parameter(Mandatory=$true)][string]$Workflow,[Parameter(Mandatory=$true)][string]$Branch)
  try { $rid = Get-LatestRunId -Workflow $Workflow -Branch $Branch -Status failure }
  catch { "No failed runs for '$Workflow' on '$Branch'."; return }
  gh run rerun $rid --failed
}
```

**Quick examples**
```powershell
$runId = Get-LatestRunId -Workflow 'ci.yml' -Branch 'feature/my-branch'
Get-RunJobs $runId | Format-Table name,status,conclusion
Show-JobLogs -Workflow 'ci.yml' -Branch 'feature/my-branch' -JobName 'tests (3.12)'
Rerun-LatestFailed 'ci.yml' 'feature/my-branch'
```

---

## 5) Local reproduction

- Lint locally:
  ```bash
  pip install pre-commit
  pre-commit run -a
  ```
- Run tests locally:
  ```bash
  python -m pip install -r requirements-dev.txt
  pytest -q
  ```
- Match CI Python versions via `pyenv` or local interpreters (3.11–3.13).

---

## 6) Common issues & fixes

- **PowerShell null‑coalescing syntax**: `??` is not valid. Use explicit `if/elseif` to fall back from `databaseId` to `id` (see function above).
- **No tests detected**: The CI will skip pytest if no files match `tests/test_*.py` or `*_test.py`. Ensure your test file names follow that pattern.
- **Rerun behavior**: `gh run rerun <run_id> --failed` re‑executes only failed jobs; omit `--failed` to rerun all.
- **Cache misses**: First run on a new Python version or updated hooks may be slower.

---

## 7) Extending the workflow

- **Add a Python version** to the test matrix:
  ```yaml
  strategy:
    matrix:
      python-version: [ '3.11', '3.12', '3.13', '3.14' ]
  ```
- **Add type checking** (e.g., mypy) via a new pre-commit hook or a new job.
- **Integration tests**: Add another job that depends on lint and unit tests.
- **Artifacts**: Use `actions/upload-artifact` for test reports or coverage XML/HTML.

> Keep `lint` fast; keep slow/optional jobs as separate steps or jobs.

---

## 8) Branch protection (recommended)

In repo settings, enable **Branch protection rules** for the default branch to require the CI checks to pass before merge. This enforces quality gates automatically.

---

## 9) Status badges

Add a badge to your README:
```md
![CI](https://github.com/<org>/<repo>/actions/workflows/ci.yml/badge.svg)
```

---

_Last updated: 2025-10-15_

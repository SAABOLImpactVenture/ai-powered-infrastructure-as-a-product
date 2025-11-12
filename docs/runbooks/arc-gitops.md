SPDX-License-Identifier: Apache-2.0
# Runbook — Azure Arc GitOps

## Preconditions
- Arc-connected cluster is `Healthy`.
- Flux `GitRepository` and `Kustomization` objects exist for the target environment.

## Procedure
1. Fetch Flux status and perform `kubectl diff` against repo manifests.
2. If drift detected, open a PR with the minimal change set.
3. Validate PR: Gatekeeper audit clean; pre-commit & policy checks pass.
4. Merge and observe Flux apply; confirm `Ready=True` and no degradations.
5. Record evidence: commit, timestamps, Flux status JSON, operator/agent identity.

## Rollback
- Revert PR or pin previous revision in `Kustomization.spec.sourceRef`.

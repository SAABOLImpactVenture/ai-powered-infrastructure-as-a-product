SPDX-License-Identifier: Apache-2.0
# Repo Quality Controls

- **SPDX compliance**: all newly added text/code has SPDX headers.
- **Pre-commit hooks**: trailing whitespace, end-of-file, merge conflict markers; REUSE compliance.
- **Markdown**: lint and link check in CI.
- **Policy gates**: Conftest/Checkov enforced on PRs.
- **Branch protections**: required checks; signed commits; CODEOWNERS for sensitive paths.
- **CI artifacts**: stored with SHA256; referenced by OSCAL exports.

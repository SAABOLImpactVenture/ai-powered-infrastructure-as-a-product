# Composite-AI Security Evaluations

These fixtures preserve deterministic negative tests for the bounded AI authority model.

- `tool-abuse/danger-verb-without-approval.json` must be denied by `agents.actions`.
- `ssrf/url-compose.json` must be denied by `agents.ssrf`.
- `prompt-injection/hidden-html.md` must retain obvious injection indicators for detection tests.

The tests do not grant the model any execution authority. They verify that proposed tool actions remain bounded by deterministic controls.

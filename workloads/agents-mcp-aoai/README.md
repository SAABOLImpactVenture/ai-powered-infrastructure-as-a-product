
# Agents · MCP · AOAI

This workload shows an **agentic loop**:
Backstage Template → MCP Plan → Policy Check → (optional) AOAI Summarize → Apply → Evidence.

- `service/agent-orchestrator.ts`: Orchestrates the loop. If AOAI env is present, it generates a natural-language summary for change review.
- `prompts/plan-summary.md`: Prompt used by AOAI for summarization.
- `routes/backstage-template.yaml`: Example Backstage step invoking this orchestrator via a container action.
- `ci/agent-plan.yml`: CI workflow to run plans in PRs with OIDC.
- `evidence/kql.md`: KQL snippets to query records emitted by the orchestrator.

## Environment
- `MCP_ENDPOINT` (e.g., http://mcp-azure:8080)
- `POLICY_ENDPOINT` (e.g., http://mcp-policy-aws:8081/policy/check)
- `AOAI_ENDPOINT`, `AOAI_DEPLOYMENT`, `AOAI_API_KEY` (optional)

If AOAI vars are absent, the orchestrator still runs and produces evidence without LLM calls.

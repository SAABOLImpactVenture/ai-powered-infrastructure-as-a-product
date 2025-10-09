
import { createTemplateAction } from '@backstage/plugin-scaffolder-node';
import fetch from 'node-fetch';

/**
 * Calls MCP server /plan and returns evidence path.
 * Register this action with the Scaffolder backend.
 */
export const mcpPlanAction = createTemplateAction<{
  cloud: 'azure' | 'aws' | 'gcp' | 'oci',
  path: string,
  endpoint?: string
}>({
  id: 'mcp:plan',
  description: 'Run Terraform plan through the MCP server for a given cloud and path.',
  schema: {
    input: {
      type: 'object',
      required: ['cloud', 'path'],
      properties: {
        cloud: { type: 'string', enum: ['azure','aws','gcp','oci'] },
        path: { type: 'string' },
        endpoint: { type: 'string', description: 'Override MCP endpoint. Default http://mcp-<cloud>:8080' }
      }
    },
    output: {
      type: 'object',
      properties: {
        evidence: { type: 'string' }
      }
    }
  },
  async handler(ctx) {
    const base = ctx.input.endpoint ?? `http://mcp-${ctx.input.cloud}:8080`;
    const res = await fetch(`${base}/plan`, {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ path: ctx.input.path }),
    });
    if (!res.ok) {
      throw new Error(`MCP plan failed: ${await res.text()}`);
    }
    const body = await res.json();
    ctx.logger.info(`MCP evidence at ${body.evidence}`);
    ctx.output('evidence', body.evidence);
  },
});

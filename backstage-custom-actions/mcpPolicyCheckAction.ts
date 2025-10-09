
import { createTemplateAction } from '@backstage/plugin-scaffolder-node';
import fetch from 'node-fetch';

/**
 * Calls MCP Policy server /policy/check and returns evidence path & status.
 */
export const mcpPolicyCheckAction = createTemplateAction<{
  target: 'aws' | 'gcp' | 'oci' | 'k8s',
  endpoint?: string,
  path?: string
}>({
  id: 'mcp:policyCheck',
  description: 'Run policy checks via MCP policy servers.',
  schema: {
    input: {
      type: 'object',
      required: ['target'],
      properties: {
        target: { type: 'string', enum: ['aws','gcp','oci','k8s'] },
        endpoint: { type: 'string', description: 'Override server endpoint' },
        path: { type: 'string', description: 'Path to policy pack (tf-based targets)' },
      }
    },
    output: {
      type: 'object',
      properties: {
        evidence: { type: 'string' },
        status: { type: 'string' }
      }
    }
  },
  async handler(ctx) {
    const defaultPorts = { aws: 8081, gcp: 8081, oci: 8081, k8s: 8082 };
    const host = `http://mcp-policy-${ctx.input.target}:${defaultPorts[ctx.input.target]}`;
    const base = ctx.input.endpoint ?? host;
    const res = await fetch(`${base}/policy/check`, {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ path: ctx.input.path }),
    });
    const text = await res.text();
    if (!res.ok) throw new Error(`Policy check failed: ${text}`);
    const data = JSON.parse(text);
    ctx.output('evidence', data.evidence);
    ctx.output('status', data.status || 'UNKNOWN');
  },
});

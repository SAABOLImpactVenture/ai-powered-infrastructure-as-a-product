
import fetch from 'node-fetch';
import fs from 'fs';
import path from 'path';

type PlanInput = { cloud: 'azure'|'aws'|'gcp'|'oci', tfPath: string };
type Evidence = {
  kind: 'plan'|'policy'|'apply';
  status: 'OK'|'ERROR'|'DRIFT'|'VIOLATIONS';
  ts: string;
  source: string;
  detail?: string;
  summary?: string;
  path?: string;
  controls?: string[];
};

async function callJSON(url: string, body: any) {
  const res = await fetch(url, { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify(body) });
  const text = await res.text();
  if (!res.ok) throw new Error(`HTTP ${res.status}: ${text}`);
  return JSON.parse(text);
}

async function mcpPlan(mcpBase: string, tfPath: string) {
  return callJSON(`${mcpBase}/plan`, { path: tfPath });
}
async function policyCheck(policyUrl: string, tfPath?: string) {
  return callJSON(policyUrl, tfPath ? { path: tfPath } : {});
}

async function aoaiSummarize(planText: string): Promise<string|undefined> {
  const ep = process.env.AOAI_ENDPOINT;
  const dep = process.env.AOAI_DEPLOYMENT;
  const key = process.env.AOAI_API_KEY;
  if (!ep || !dep || !key) return undefined;

  const url = `${ep}/openai/deployments/${dep}/chat/completions?api-version=2024-02-15-preview`;
  const body = {
    messages: [
      { role: 'system', content: 'You summarize Terraform plans into risk-aware executive summaries.' },
      { role: 'user', content: fs.readFileSync(path.join(process.cwd(), 'workloads/agents-mcp-aoai/prompts/plan-summary.md'), 'utf-8') + '\n\nPLAN:\n' + planText.slice(0, 10000) }
    ],
    temperature: 0.2
  };
  const res = await fetch(url, { method: 'POST', headers: { 'api-key': key, 'content-type': 'application/json' }, body: JSON.stringify(body) });
  const json = await res.json();
  const content = json?.choices?.[0]?.message?.content;
  return typeof content === 'string' ? content : undefined;
}

export async function run(input: PlanInput) {
  const mcpBase = process.env.MCP_ENDPOINT || 'http://localhost:8080';
  const policyUrl = process.env.POLICY_ENDPOINT || 'http://localhost:8181/policy/check';

  const plan = await mcpPlan(mcpBase, input.tfPath);
  const planEvidence: Evidence = { kind: 'plan', status: 'OK', ts: new Date().toISOString(), source: `agent:${input.cloud}`, detail: JSON.stringify(plan).slice(0,4000), path: input.tfPath };

  // Optional AOAI summary
  const summary = await aoaiSummarize(planEvidence.detail || '');
  if (summary) planEvidence.summary = summary;

  const policy = await policyCheck(policyUrl, input.tfPath);
  const polEvidence: Evidence = { kind: 'policy', status: policy.status || 'OK', ts: new Date().toISOString(), source: `agent:${input.cloud}`, detail: JSON.stringify(policy).slice(0,4000), path: input.tfPath };

  // emit evidence files
  const outDir = path.join(process.cwd(), 'evidence', 'agent', input.cloud);
  fs.mkdirSync(outDir, { recursive: true });
  const f1 = path.join(outDir, `${Date.now()}-plan.json`);
  fs.writeFileSync(f1, JSON.stringify(planEvidence, null, 2));
  const f2 = path.join(outDir, `${Date.now()}-policy.json`);
  fs.writeFileSync(f2, JSON.stringify(polEvidence, null, 2));
  return { planEvidence: f1, policyEvidence: f2, summary: planEvidence.summary };
}

// CLI
if (require.main === module) {
  const [,, cloud, tfPath] = process.argv;
  run({ cloud: cloud as any, tfPath }).then(r => {
    console.log(JSON.stringify(r, null, 2));
  }).catch(e => {
    console.error(e);
    process.exit(1);
  });
}

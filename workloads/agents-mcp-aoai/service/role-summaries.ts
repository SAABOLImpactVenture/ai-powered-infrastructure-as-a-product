
import fs from 'fs';
import path from 'path';
import fetch from 'node-fetch';

type Evidence = {
  kind: string;
  status: 'OK'|'ERROR'|'DRIFT'|'VIOLATIONS';
  ts: string;
  source: string;
  detail?: string;
  summary?: string;
  path?: string;
  controls?: string[];
  role?: string;
};

const ROLES = ['product-manager','delivery-architect','responsible-engineer','security-identity-expert'] as const;
type Role = typeof ROLES[number];

function now() { return new Date().toISOString(); }

function parsePlanText(planText: string) {
  const counts = { add: 0, change: 0, destroy: 0 };
  try {
    const obj = JSON.parse(planText);
    const summary = obj?.summary || obj?.plan?.resource_changes || obj?.resource_changes;
    if (Array.isArray(summary)) {
      for (const rc of summary) {
        const a = rc.change?.actions || [];
        if (a.includes('create')) counts.add += 1;
        if (a.includes('update')) counts.change += 1;
        if (a.includes('delete')) counts.destroy += 1;
      }
      return counts;
    }
  } catch {}
  // text heuristic
  const addMatch = planText.match(/(\d+)\s+to add/); if (addMatch) counts.add = Number(addMatch[1]);
  const changeMatch = planText.match(/(\d+)\s+to change/); if (changeMatch) counts.change = Number(changeMatch[1]);
  const destroyMatch = planText.match(/(\d+)\s+to destroy/); if (destroyMatch) counts.destroy = Number(destroyMatch[1]);
  return counts;
}

function heuristicSummary(role: Role, planText: string) {
  const c = parsePlanText(planText);
  const common = `Plan deltas — add: ${c.add}, change: ${c.change}, destroy: ${c.destroy}.`;
  switch (role) {
    case 'product-manager':
      return `${common} Validate business impact, data classification, and rollback window.`;
    case 'delivery-architect':
      return `${common} Check network posture, encryption-by-default, and landing zone alignment.`;
    case 'responsible-engineer':
      return `${common} Ensure tests, rollout/rollback plan, and observability hooks are in place.`;
    case 'security-identity-expert':
      return `${common} Verify OIDC/WIF, key scope/rotation, and policy pack coverage (FedRAMP/NSA-CISA).`;
  }
}

async function aoai(role: Role, planText: string): Promise<string|undefined> {
  const ep = process.env.AOAI_ENDPOINT;
  const dep = process.env.AOAI_DEPLOYMENT;
  const key = process.env.AOAI_API_KEY;
  if (!ep || !dep || !key) return undefined;
  const promptPath = path.join(process.cwd(), 'workloads/agents-mcp-aoai/roles/prompts', `${role}.md`);
  const prompt = fs.existsSync(promptPath) ? fs.readFileSync(promptPath, 'utf-8') : 'Summarize.';
  const url = `${ep}/openai/deployments/${dep}/chat/completions?api-version=2024-02-15-preview`;
  const body = { messages: [
    { role: 'system', content: 'You produce risk-aware, role-specific infra change summaries.' },
    { role: 'user', content: `${prompt}\n\nPLAN:\n${planText.slice(0, 10000)}` }
  ], temperature: 0.2 };
  const res = await fetch(url, { method: 'POST', headers: { 'api-key': key, 'content-type': 'application/json' }, body: JSON.stringify(body) });
  const json = await res.json(); return json?.choices?.[0]?.message?.content;
}

async function main() {
  const [,, planEvidencePath, cloud='azure'] = process.argv;
  if (!planEvidencePath) throw new Error('Usage: node role-summaries.js <path-to-plan-evidence.json> [cloud]');
  const text = fs.readFileSync(planEvidencePath, 'utf-8');
  const outDir = path.join(process.cwd(), 'evidence', 'agent', cloud);
  fs.mkdirSync(outDir, { recursive: true });

  for (const role of ROLES) {
    const content = (await aoai(role, text)) || heuristicSummary(role, text);
    const ev: Evidence = {
      kind: 'summary',
      status: 'OK',
      ts: now(),
      source: `role-summary:${role}`,
      detail: text.slice(0, 2000),
      summary: content,
      role,
      controls: role === 'security-identity-expert' ? ['AC-2','IA-2','CM-6','SI-7','SC-7'] : undefined
    };
    const fp = path.join(outDir, `${Date.now()}-summary-${role}.json`);
    fs.writeFileSync(fp, JSON.stringify(ev, null, 2));
    console.log('wrote', fp);
  }
}

if (require.main === module) {
  main().catch(e => { console.error(e); process.exit(1); });
}

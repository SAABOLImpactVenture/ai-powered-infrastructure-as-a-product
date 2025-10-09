import assert from 'assert';
import fs from 'fs';
import path from 'path';
import { execSync } from 'child_process';

// Prepare a fake plan evidence and run role-summaries
const EVIDENCE_DIR = path.join(process.cwd(), 'evidence', 'agent', 'aws');
fs.mkdirSync(EVIDENCE_DIR, { recursive: true });
const planPath = path.join(EVIDENCE_DIR, 'test-plan.json');
fs.writeFileSync(planPath, JSON.stringify({
  kind: 'plan', status:'OK', ts: new Date().toISOString(), source:'test',
  detail: 'Plan: 2 to add, 1 to change, 0 to destroy.'
}, null, 2));

// Build summaries
execSync(`node --experimental-modules workloads/agents-mcp-aoai/service/role-summaries.ts ${planPath} aws`, { stdio: 'inherit' });

// Assert summaries exist
const files = fs.readdirSync(EVIDENCE_DIR).filter(f => f.includes('summary-'));
assert(files.length >= 4, 'Expected at least 4 role summary files');
console.log('OK: generated role summaries:', files);

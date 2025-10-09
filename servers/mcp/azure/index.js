import { spawn } from 'child_process';
import fs from 'fs';
import path from 'path';

function sh(cmd, args, cwd) {
  return new Promise((resolve, reject) => {
    const p = spawn(cmd, args, { cwd, stdio: ['ignore','pipe','pipe'] });
    let out='', err='';
    p.stdout.on('data', d => out += d.toString());
    p.stderr.on('data', d => err += d.toString());
    p.on('close', code => { if (code===0) resolve({out, err}); else reject(new Error(err||out)); });
  });
}

async function plan(dir) {
  await sh('terraform', ['init','-backend=false'], dir);
  const res = await sh('terraform', ['plan','-out=plan.tfplan'], dir);
  return res.out;
}

function emitEvidence(kind, status, detail) {
  const rec = { kind, status, detail, ts: new Date().toISOString(), source: 'mcp-azure' };
  const outDir = path.join(process.cwd(), 'evidence');
  fs.mkdirSync(outDir, { recursive: true });
  const fp = path.join(outDir, `${Date.now()}-${kind}.json`);
  fs.writeFileSync(fp, JSON.stringify(rec, null, 2));
  return fp;
}

async function selfTest() {
  const dir = process.env.TF_DIR || 'platform/azure/observability/log_analytics';
  try {
    const p = await plan(dir);
    const ev = emitEvidence('plan', 'OK', p.slice(0,200));
    console.log(JSON.stringify({ ok:true, evidence: ev }));
  } catch (e) {
    const ev = emitEvidence('plan', 'ERROR', String(e));
    console.log(JSON.stringify({ ok:false, evidence: ev }));
    process.exit(1);
  }
}

if (process.argv.includes('--self-test')) { selfTest(); }
else { console.log('MCP server entrypoint.'); }


import { spawn } from 'child_process';
import http from 'http';
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

async function apply(dir) {
  const res = await sh('terraform', ['apply','-auto-approve','plan.tfplan'], dir);
  return res.out;
}

function emitEvidence(kind, status, detail) {
  const rec = { kind, status, detail, ts: new Date().toISOString(), source: 'mcp-gcp' };
  const outDir = path.join(process.cwd(), 'evidence', 'mcp-gcp');
  fs.mkdirSync(outDir, { recursive: true });
  const fp = path.join(outDir, `${Date.now()}-${kind}.json`);
  fs.writeFileSync(fp, JSON.stringify(rec, null, 2));
  return fp;
}

function readJson(req) {
  return new Promise((resolve, reject) => {
    let body='';
    req.on('data', chunk => body += chunk);
    req.on('end', () => {
      try { resolve(JSON.parse(body || '{}')); } catch(e) { reject(e); }
    });
  });
}

const srv = http.createServer(async (req, res) => {
  try {
    if (req.method === 'POST' && req.url === '/plan') {
      const body = await readJson(req);
      const dir = body.path || process.env.TF_DIR || '.';
      const out = await plan(dir);
      const ev = emitEvidence('plan','OK', out.slice(0, 2000));
      res.writeHead(200, { 'content-type': 'application/json' });
      return res.end(JSON.stringify({ ok:true, evidence: ev }));
    }
    if (req.method === 'POST' && req.url === '/apply') {
      const body = await readJson(req);
      const dir = body.path || process.env.TF_DIR || '.';
      const out = await apply(dir);
      const ev = emitEvidence('apply','OK', out.slice(0, 2000));
      res.writeHead(200, { 'content-type': 'application/json' });
      return res.end(JSON.stringify({ ok:true, evidence: ev }));
    }
    res.writeHead(404, { 'content-type': 'application/json' });
    res.end(JSON.stringify({ ok:false, error:'Not found' }));
  } catch (e) {
    const ev = emitEvidence('error','ERROR', String(e));
    res.writeHead(500, { 'content-type': 'application/json' });
    res.end(JSON.stringify({ ok:false, error:String(e), evidence: ev }));
  }
});

const PORT = process.env.PORT ? Number(process.env.PORT) : 8080;
srv.listen(PORT, () => console.log('MCP server (mcp-gcp) listening on', PORT));

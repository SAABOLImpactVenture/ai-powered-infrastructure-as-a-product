
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

function emitEvidence(source, payload) {
  const outDir = path.join(process.cwd(), 'evidence', source);
  fs.mkdirSync(outDir, { recursive: true });
  const file = path.join(outDir, `${Date.now()}-policy.json`);
  fs.writeFileSync(file, JSON.stringify(payload, null, 2));
  return file;
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

async function kubectl(args) {
  const res = await sh('kubectl', args, process.cwd());
  return res.out;
}

function parseGatekeeperViolations(jsonStr) {
  try {
    const obj = JSON.parse(jsonStr);
    const items = obj.items || [];
    const findings = [];
    for (const it of items) {
      const st = it.status || {};
      if (Array.isArray(st.violations) && st.violations.length > 0) {
        findings.push({
          kind: it.kind,
          name: it.metadata?.name,
          ns: it.metadata?.namespace || 'cluster',
          violations: st.violations.map(v => ({ msg: v.message, ns: v.namespace, name: v.name })),
        });
      }
    }
    return findings;
  } catch (e) {
    return [{ error: 'Failed to parse Gatekeeper JSON', detail: String(e) }];
  }
}

const srv = http.createServer(async (req, res) => {
  if (req.method === 'POST' && req.url === '/policy/check') {
    try {
      // List all constraint kinds, then fetch them
      const kindsRaw = await kubectl(['api-resources', '--api-group=constraints.gatekeeper.sh', '-o', 'name']);
      const kinds = kindsRaw.split('\n').map(s => s.trim()).filter(Boolean);
      let findings = [];
      for (const k of kinds) {
        const data = await kubectl(['get', k, '-A', '-o', 'json']);
        findings = findings.concat(parseGatekeeperViolations(data));
      }
      const status = findings.length === 0 ? 'OK' : 'VIOLATIONS';
      const payload = { kind:'policy', status, ts: new Date().toISOString(), source:'mcp-k8s', findings };
      const ev = emitEvidence('mcp-k8s', payload);
      res.writeHead(200, { 'content-type': 'application/json' });
      return res.end(JSON.stringify({ ok:true, status, evidence: ev, findingsCount: findings.length }));
    } catch (e) {
      const payload = { kind:'policy', status:'ERROR', ts: new Date().toISOString(), source:'mcp-k8s', detail:String(e) };
      const ev = emitEvidence('mcp-k8s', payload);
      res.writeHead(500, { 'content-type': 'application/json' });
      return res.end(JSON.stringify({ ok:false, error:String(e), evidence: ev }));
    }
  }
  res.writeHead(404, { 'content-type': 'application/json' });
  res.end(JSON.stringify({ ok:false, error:'Not found' }));
});

const PORT = process.env.PORT ? Number(process.env.PORT) : 8082;
srv.listen(PORT, () => console.log('Policy server (mcp-k8s) listening on', PORT));

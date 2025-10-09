
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

const srv = http.createServer(async (req, res) => {
  if (req.method === 'POST' && req.url === '/policy/check') {
    try {
      const body = await readJson(req);
      const dir = body.path || 'policies/gcp/org-policy';
      // terraform plan -detailed-exitcode to detect drift/compliance divergence
      await sh('terraform', ['init','-backend=false'], dir);
      const p = spawn('terraform', ['plan','-detailed-exitcode'], { cwd: dir });
      let out='', err=''; let code = 0;
      p.stdout.on('data', d => out += d.toString());
      p.stderr.on('data', d => err += d.toString());
      p.on('close', c => { code = c; done(); });
      function done() {
        let status = 'OK'; let summary = 'No changes required';
        if (code === 2) { status = 'DRIFT'; summary = 'Changes required (policy drift detected)'; }
        else if (code !== 0) { status = 'ERROR'; summary = err || out; }
        const payload = {
          kind: 'policy', status, ts: new Date().toISOString(), source: 'mcp-policy-gcp',
          detail: (out || err).slice(0, 4000), summary, path: dir, exitCode: code
        };
        const ev = emitEvidence('mcp-policy-gcp', payload);
        res.writeHead(status==='ERROR'?500:200, { 'content-type': 'application/json' });
        res.end(JSON.stringify({ ok: status!=='ERROR', status, evidence: ev, summary }));
      }
    } catch (e) {
      const payload = { kind:'policy', status:'ERROR', ts: new Date().toISOString(), source:'mcp-policy-gcp', detail:String(e) };
      const ev = emitEvidence('mcp-policy-gcp', payload);
      res.writeHead(500, { 'content-type': 'application/json' });
      res.end(JSON.stringify({ ok:false, error:String(e), evidence: ev }));
    }
    return;
  }
  res.writeHead(404, { 'content-type': 'application/json' });
  res.end(JSON.stringify({ ok:false, error:'Not found' }));
});

const PORT = process.env.PORT ? Number(process.env.PORT) : 8081;
srv.listen(PORT, () => console.log('Policy server (mcp-policy-gcp) listening on', PORT));


import { request as httpRequest } from 'http';
import fs from 'fs';

function call(target) {
  return new Promise(resolve => {
    try {
      const u = new URL(target.url);
      const data = JSON.stringify(target.body || {});
      const opts = {
        hostname: u.hostname,
        port: u.port || (u.protocol === 'https:' ? 443 : 80),
        path: u.pathname + (u.search || ''),
        method: target.method || 'POST',
        headers: { 'content-type': 'application/json', 'content-length': Buffer.byteLength(data) }
      };
      const req = httpRequest(opts, res => {
        let buf='';
        res.on('data', d => buf += d.toString());
        res.on('end', () => {
          try { resolve({ name: target.name, statusCode: res.statusCode, body: JSON.parse(buf) }); }
          catch { resolve({ name: target.name, statusCode: res.statusCode, body: buf }); }
        });
      });
      req.on('error', err => resolve({ name: target.name, error: String(err) }));
      req.write(data);
      req.end();
    } catch (e) {
      resolve({ name: target.name, error: String(e) });
    }
  });
}

function row(r) {
  const status = r.body?.status || (r.statusCode===200 ? 'OK' : 'ERROR');
  const evidence = r.body?.evidence || '';
  return `<tr><td>${r.name}</td><td>${status}</td><td>${evidence}</td><td><pre>${escapeHtml(JSON.stringify(r.body).slice(0,400))}</pre></td></tr>`;
}

function escapeHtml(str){return str.replace(/[&<>"]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));}

async function main() {
  const targets = JSON.parse(process.env.TARGETS_JSON || '[]');
  const results = await Promise.all(targets.map(call));
  const rows = results.map(row).join('\n');
  const html = `<!DOCTYPE html><html><head><meta charset="utf-8"><title>Policy Dashboard Snapshot</title>
<style>body{font-family:sans-serif;margin:2rem} table{border-collapse:collapse;width:100%} td,th{border:1px solid #ccc;padding:.5rem} pre{white-space:pre-wrap;word-wrap:break-word}</style>
</head><body><h1>Policy Dashboard Snapshot</h1>
<table><thead><tr><th>Target</th><th>Status</th><th>Evidence</th><th>Details</th></tr></thead><tbody>${rows}</tbody></table>
</body></html>`;
  fs.mkdirSync('dist', { recursive: true });
  fs.writeFileSync('dist/index.html', html);
  console.log('Snapshot written to dist/index.html');
}

main().catch(e => { console.error(e); process.exit(1); });

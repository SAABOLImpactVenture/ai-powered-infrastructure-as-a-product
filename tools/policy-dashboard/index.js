
import http from 'http';
import { request as httpRequest } from 'http';
import url from 'url';
import fs from 'fs';

const PORT = process.env.PORT ? Number(process.env.PORT) : 8090;

function callEndpoint(target) {
  return new Promise((resolve) => {
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

async function render() {
  let targets = [];
  try { targets = JSON.parse(process.env.TARGETS_JSON || '[]'); } catch {}
  const results = await Promise.all(targets.map(callEndpoint));
  const rows = results.map(r => {
    const status = r.body?.status || (r.statusCode===200 ? 'OK' : 'ERROR');
    const evidence = r.body?.evidence || '';
    return `<tr><td>${r.name}</td><td>${status}</td><td>${evidence}</td><td><pre>${escapeHtml(JSON.stringify(r.body).slice(0,400))}</pre></td></tr>`;
  }).join('\n');
  return `<!DOCTYPE html>
<html><head><meta charset="utf-8"><title>Policy Dashboard</title>
<style>body{font-family:sans-serif;margin:2rem} table{border-collapse:collapse;width:100%} td,th{border:1px solid #ccc;padding:.5rem} pre{white-space:pre-wrap;word-wrap:break-word}</style>
</head><body>
<h1>Policy Dashboard</h1>
<p>Aggregated status from MCP policy servers.</p>
<table><thead><tr><th>Target</th><th>Status</th><th>Evidence</th><th>Details</th></tr></thead><tbody>${rows}</tbody></table>
</body></html>`;
}

function escapeHtml(str){return str.replace(/[&<>"]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));}

const server = http.createServer(async (req, res) => {
  if (req.url === '/healthz') { res.writeHead(200); return res.end('ok'); }
  const html = await render();
  res.writeHead(200, { 'content-type': 'text/html' });
  res.end(html);
});

server.listen(PORT, () => console.log(`Policy dashboard listening on ${PORT}`));

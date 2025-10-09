import express from 'express';
import fetch from 'node-fetch';

const app = express();
const PORT = process.env.PORT || 8090;

// Prefer distroless policy services when provided (compose.distroless sets these)
const policies = {
  azure: process.env.POLICY_AZURE || 'http://localhost:8181/policy/check',
  aws:   process.env.POLICY_AWS   || 'http://localhost:8182/policy/check',
  gcp:   process.env.POLICY_GCP   || 'http://localhost:8183/policy/check',
  oci:   process.env.POLICY_OCI   || 'http://localhost:8184/policy/check',
};

app.get('/api/policy/aggregate', async (_req, res) => {
  try {
    const entries = await Promise.all(Object.entries(policies).map(async ([cloud, url]) => {
      try {
        const r = await fetch(url, { method: 'POST', headers: { 'content-type':'application/json' }, body: JSON.stringify({}) });
        const t = await r.text();
        let j; try { j = JSON.parse(t); } catch { j = { raw: t }; }
        return [cloud, { ok: r.ok, status: r.status, body: j }];
      } catch (e) {
        return [cloud, { ok: false, status: 0, error: String(e) }];
      }
    }));
    res.json(Object.fromEntries(entries));
  } catch (e) {
    res.status(500).json({ error: String(e) });
  }
});

app.get('/', (_req, res) => {
  res.type('html').send(`<!doctype html>
  <html><head><meta charset="utf-8"><title>Policy Dashboard</title>
  <style>body{font-family:system-ui,Arial;margin:2rem;} .ok{color:#0a0;} .bad{color:#a00;} table{border-collapse:collapse} td,th{padding:.5rem;border:1px solid #ddd}</style>
  </head><body>
    <h1>Policy Dashboard (Distroless Profile)</h1>
    <p>Aggregates policy statuses from Azure/AWS/GCP/OCI policy services.</p>
    <table id="t"><thead><tr><th>Cloud</th><th>Status</th><th>Detail</th></tr></thead><tbody></tbody></table>
    <script>
      async function load(){
        const r = await fetch('/api/policy/aggregate'); const j = await r.json();
        const tb = document.querySelector('#t tbody'); tb.innerHTML='';
        for (const [cloud,info] of Object.entries(j)){
          const tr = document.createElement('tr');
          const s = info.ok ? 'OK' : 'ERROR';
          tr.innerHTML = '<td>'+cloud.toUpperCase()+'</td><td class="'+(info.ok?'ok':'bad')+'">'+s+'</td><td><pre>'+JSON.stringify(info.body||info.error,null,2)+'</pre></td>';
          tb.appendChild(tr);
        }
      }
      load(); setInterval(load, 5000);
    </script>
  </body></html>`);
});

app.listen(PORT, () => console.log('policy dashboard on http://localhost:'+PORT));

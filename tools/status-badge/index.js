import express from 'express';
import fetch from 'node-fetch';

const app = express();
const PORT = process.env.PORT || 8091;
const AGG_URL = process.env.AGGREGATE_URL || 'http://localhost:8090/api/policy/aggregate';

function svg(label, message, color) {
  // Simple shields-like SVG
  const lbl = String(label);
  const msg = String(message);
  const lw = 6 * lbl.length + 20;
  const mw = 6 * msg.length + 20;
  const w = lw + mw;
  return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="${w}" height="20" role="img" aria-label="${lbl}: ${msg}">
  <linearGradient id="s" x2="0" y2="100%"><stop offset="0" stop-color="#fff" stop-opacity=".7"/><stop offset=".1" stop-opacity=".1"/><stop offset=".9" stop-opacity=".3"/><stop offset="1" stop-opacity=".5"/></linearGradient>
  <mask id="m"><rect width="${w}" height="20" rx="3" fill="#fff"/></mask>
  <g mask="url(#m)">
    <rect width="${lw}" height="20" fill="#555"/>
    <rect x="${lw}" width="${mw}" height="20" fill="${color}"/>
    <rect width="${w}" height="20" fill="url(#s)"/>
  </g>
  <g fill="#fff" text-anchor="middle" font-family="DejaVu Sans,Verdana,Geneva,sans-serif" font-size="11">
    <text x="${Math.floor(lw/2)}" y="15">${lbl}</text>
    <text x="${lw + Math.floor(mw/2)}" y="15">${msg}</text>
  </g>
</svg>`;
}

app.get('/badge.svg', async (_req, res) => {
  try {
    const r = await fetch(AGG_URL);
    const j = await r.json();
    const clouds = Object.keys(j);
    const statuses = clouds.map(c => (j[c]?.ok ? 'OK' : 'BAD'));
    const ok = statuses.every(s => s === 'OK');
    const color = ok ? '#2ea44f' : '#d73a49';
    const msg = ok ? 'OK' : 'VIOLATIONS';
    res.type('image/svg+xml').send(svg('policy', msg, color));
  } catch (e) {
    res.type('image/svg+xml').send(svg('policy', 'UNKNOWN', '#9e9e9e'));
  }
});

app.listen(PORT, () => console.log('status badge on http://localhost:'+PORT+'/badge.svg'));

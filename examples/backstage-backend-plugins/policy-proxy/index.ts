
import express, { Request, Response, Router } from 'express';
import http from 'http';
import https from 'https';
import { URL } from 'url';

type Target = { name: string; url: string; method?: string; body?: any; headers?: Record<string,string> };
type Options = { targets?: Target[]; timeoutMs?: number; allowedHosts?: string[] };

function httpCall(target: Target, timeoutMs: number): Promise<{ name: string; statusCode?: number; body?: any; error?: string; }> {
  return new Promise(resolve => {
    try {
      const u = new URL(target.url);
      const data = JSON.stringify(target.body || {});
      const isHttps = u.protocol === 'https:';
      const mod = isHttps ? https : http;
      const req = mod.request({
        hostname: u.hostname,
        port: Number(u.port || (isHttps ? 443 : 80)),
        path: u.pathname + (u.search || ''),
        method: target.method || 'POST',
        headers: { 'content-type': 'application/json', 'content-length': Buffer.byteLength(data), ...(target.headers || {}) },
        timeout: timeoutMs,
      }, res => {
        let buf = '';
        res.on('data', d => buf += d.toString());
        res.on('end', () => {
          try { resolve({ name: target.name, statusCode: res.statusCode, body: JSON.parse(buf) }); }
          catch { resolve({ name: target.name, statusCode: res.statusCode, body: buf }); }
        });
      });
      req.on('timeout', () => { req.destroy(new Error('timeout')); });
      req.on('error', err => resolve({ name: target.name, error: String(err) }));
      req.write(data);
      req.end();
    } catch (e: any) {
      resolve({ name: target.name, error: String(e) });
    }
  });
}

function inAllowlist(u: string, allowedHosts?: string[]): boolean {
  if (!allowedHosts || allowedHosts.length === 0) return true;
  try {
    const host = new URL(u).hostname;
    return allowedHosts.includes(host);
  } catch {
    return false;
  }
}

export async function createPolicyProxyRouter(opts?: Options): Promise<Router> {
  const router = express.Router();
  router.use(express.json());

  const timeoutMs = opts?.timeoutMs ?? 15000;
  const allowedHosts = opts?.allowedHosts ?? (process.env.ALLOWED_HOSTS ? process.env.ALLOWED_HOSTS.split(',').map(s => s.trim()) : undefined);

  router.get('/healthz', (_req: Request, res: Response) => res.status(200).send('ok'));

  router.get('/aggregate', async (_req: Request, res: Response) => {
    try {
      const targets: Target[] = opts?.targets ?? JSON.parse(process.env.TARGETS_JSON || '[]');
      const filtered = targets.filter(t => inAllowlist(t.url, allowedHosts));
      const results = await Promise.all(filtered.map(t => httpCall(t, timeoutMs)));
      const mapped = results.map(r => ({
        name: r.name,
        status: (r.body && typeof r.body === 'object' && 'status' in r.body) ? (r.body.status as string) :
                (r.statusCode === 200 ? 'OK' : 'ERROR'),
        evidence: (r.body && typeof r.body === 'object' && 'evidence' in r.body) ? (r.body.evidence as string) : undefined,
        raw: r.body,
        error: r.error,
      }));
      res.json({ ok: true, results: mapped });
    } catch (e: any) {
      res.status(500).json({ ok: false, error: String(e) });
    }
  });

  router.post('/aggregate', async (req: Request, res: Response) => {
    try {
      const body = req.body || {};
      const targets: Target[] = Array.isArray(body.targets) ? body.targets : [];
      const filtered = targets.filter(t => inAllowlist(t.url, allowedHosts));
      const results = await Promise.all(filtered.map(t => httpCall(t, timeoutMs)));
      const mapped = results.map(r => ({
        name: r.name,
        status: (r.body && typeof r.body === 'object' && 'status' in r.body) ? (r.body.status as string) :
                (r.statusCode === 200 ? 'OK' : 'ERROR'),
        evidence: (r.body && typeof r.body === 'object' && 'evidence' in r.body) ? (r.body.evidence as string) : undefined,
        raw: r.body,
        error: r.error,
      }));
      res.json({ ok: true, results: mapped });
    } catch (e: any) {
      res.status(500).json({ ok: false, error: String(e) });
    }
  });

  return router;
}

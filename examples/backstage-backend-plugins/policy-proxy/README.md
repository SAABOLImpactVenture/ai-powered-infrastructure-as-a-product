
# Backstage Backend Policy Proxy

An Express router that aggregates policy status from MCP Policy servers (or any HTTP targets)
and exposes a JSON API for frontend components.

## Endpoints
- `GET /healthz` — liveness
- `POST /aggregate` — body: `{ "targets": [ { "name":"aws", "url":"http://...", "method":"POST", "body":{}} ] }`
- `GET /aggregate` — reads JSON from env `TARGETS_JSON` if body is empty

Response:
```json
{ "ok": true, "results": [ { "name":"aws", "status":"OK|DRIFT|VIOLATIONS|ERROR", "evidence":"...", "raw": { /* original server payload */ } } ] }
```

## Wiring into Backstage backend
```ts
// packages/backend/src/plugins/policy.ts
import { createPolicyProxyRouter } from '../../../backstage-backend-plugins/policy-proxy';

export default async function createPlugin(env: { logger: any, router: any }) {
  const targets = [
    { name: 'aws', url: 'http://mcp-policy-aws:8081/policy/check', method: 'POST', body: {} },
    { name: 'gcp', url: 'http://mcp-policy-gcp:8081/policy/check', method: 'POST', body: {} },
    { name: 'oci', url: 'http://mcp-policy-oci:8081/policy/check', method: 'POST', body: {} },
    { name: 'k8s', url: 'http://mcp-policy-k8s:8082/policy/check', method: 'POST', body: {} },
  ];
  env.router.use('/policy', await createPolicyProxyRouter({ targets, timeoutMs: 15000 }));
}
```

Then register the plugin router where you compose your backend (e.g., in `packages/backend/src/index.ts`):
```ts
import createPolicyPlugin from './plugins/policy';
const policyRouter = await createPolicyPlugin({ logger, router: express.Router() });
app.use('/api', policyRouter);
```

## Config (optional)
- Environment variable `TARGETS_JSON` (JSON array same shape as above) used by GET `/aggregate`.
- `ALLOWED_HOSTS` (comma-separated) allowlist of hostnames/IPs; if set, proxy refuses targets outside this set.

## Standalone (for quick tests)
```bash
TARGETS_JSON='[{"name":"aws","url":"http://localhost:8181/policy/check","method":"POST","body":{}}]'   node backstage-backend-plugins/policy-proxy/standalone.js
# -> Listen on :7070; GET http://localhost:7070/aggregate
```


import express from 'express';
import { createPolicyProxyRouter } from './index.js';

const PORT = process.env.PORT ? Number(process.env.PORT) : 7070;

const targetsEnv = process.env.TARGETS_JSON || '[]';

(async () => {
  const app = express();
  const targets = JSON.parse(targetsEnv);
  app.use('/', await createPolicyProxyRouter({ targets }));
  app.listen(PORT, () => console.log(`Policy proxy listening on ${PORT}`));
})().catch(e => { console.error(e); process.exit(1); });

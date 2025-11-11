import express from 'express';
import { Logger } from 'winston';
import { Config } from '@backstage/config';
import fs from 'fs';
import path from 'path';
import { parse } from 'csv-parse/sync';

type Options = {
  logger: Logger;
  config: Config;
};

export async function createFinOpsRouter({ logger, config }: Options): Promise<express.Router> {
  const router = express.Router();
  router.use(express.json());

  // Configurable CSV path or S3/Blob URL (for demo uses local file)
  const csvPath = config.getOptionalString('finops.csvPath') || 'data/finops/sample-costs.csv';

  router.get('/health', (_, res) => res.json({ status: 'ok' }));

  router.get('/costs', async (_req, res) => {
    try {
      const full = path.resolve(csvPath);
      const csv = fs.readFileSync(full, 'utf-8');
      const records = parse(csv, { columns: true, skip_empty_lines: true });
      res.json({ items: records });
    } catch (e: any) {
      logger.error(`Failed to load FinOps CSV: ${e.message}`);
      res.status(500).json({ error: 'Failed to load FinOps data' });
    }
  });

  return router;
}

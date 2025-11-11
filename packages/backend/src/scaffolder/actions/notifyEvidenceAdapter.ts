import { createTemplateAction } from '@backstage/plugin-scaffolder-node';
import fetch from 'node-fetch';
import { Logger } from 'winston';
import { Config } from '@backstage/config';

export const createNotifyEvidenceAdapterAction = ({ logger, config }: { logger: Logger, config: Config }) => {
  return createTemplateAction<{ prUrl: string, entityRef?: string }>({
    id: 'aipiap:evidence:notify',
    description: 'Notify the policy-evidence-adapter about a new PR for evidence harvesting',
    schema: {
      input: {
        type: 'object',
        required: ['prUrl'],
        properties: {
          prUrl: { type: 'string', description: 'Pull Request URL' },
          entityRef: { type: 'string', description: 'Backstage entity ref', default: '' },
        },
      },
    },
    async handler(ctx) {
      const endpoint = config.getOptionalString('aipiap.evidence.adapterUrl');
      if (!endpoint) {
        ctx.logger.warn('evidence adapter URL not configured; skipping notify');
        return;
      }
      const body = { prUrl: ctx.input.prUrl, entityRef: ctx.input.entityRef || '' };
      ctx.logger.info(`Notifying evidence adapter at ${endpoint}`);
      const res = await fetch(`${endpoint}/notify`, {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify(body),
      });
      if (!res.ok) {
        const t = await res.text();
        throw new Error(`Evidence notify failed: ${res.status} ${t}`);
      }
      ctx.logger.info('Evidence adapter notified');
    },
  });
};

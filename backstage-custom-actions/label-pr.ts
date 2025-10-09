
import { createTemplateAction } from '@backstage/plugin-scaffolder-node';
import fetch from 'node-fetch';

export const labelPullRequestAction = () => createTemplateAction<{
  owner: string; repo: string; pullNumber: number;
  labels: string[]; token?: string;
}>({
  id: 'repo:addLabels',
  description: 'Add approval labels to a pull request (e.g., approved-pm, approved-da, approved-re, approved-sie).',
  schema: {
    input: {
      required: ['owner','repo','pullNumber','labels'],
      type: 'object',
      properties: {
        owner: { type: 'string' },
        repo: { type: 'string' },
        pullNumber: { type: 'number' },
        labels: { type: 'array', items: { type: 'string' } },
        token: { type: 'string' }
      },
    },
  },
  async handler(ctx) {
    const gh = 'https://api.github.com';
    const t = ctx.input.token || process.env.GITHUB_TOKEN;
    if (!t) throw new Error('Missing token: set input.token or GITHUB_TOKEN');
    const url = `${gh}/repos/${ctx.input.owner}/${ctx.input.repo}/issues/${ctx.input.pullNumber}/labels`;
    const res = await fetch(url, { method: 'POST', headers: { 'authorization': `Bearer ${t}`, 'content-type': 'application/json' }, body: JSON.stringify({ labels: ctx.input.labels }) });
    if (!res.ok) {
      const txt = await res.text();
      throw new Error(`GitHub API error ${res.status}: ${txt}`);
    }
    ctx.logger.info('Labels added successfully');
  },
});

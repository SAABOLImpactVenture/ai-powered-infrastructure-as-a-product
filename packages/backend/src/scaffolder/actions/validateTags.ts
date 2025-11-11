import { createTemplateAction } from '@backstage/plugin-scaffolder-node';

export const createValidateTagsAction = () => {
  return createTemplateAction<{ tags: Record<string, string> }>({
    id: 'aipiap:validate:tags',
    description: 'Validates presence of required governance tags',
    schema: {
      input: {
        type: 'object',
        required: ['tags'],
        properties: {
          tags: {
            type: 'object',
            description: 'Key/value tags to validate',
          },
        },
      },
    },
    async handler(ctx) {
      const required = ['Program','System','Environment','Data-Class'];
      const missing = required.filter(k => !(k in ctx.input.tags) || !ctx.input.tags[k]);
      if (missing.length > 0) {
        throw new Error(`Missing required tags: ${missing.join(', ')}`);
      }
      ctx.logger.info('Required tags present');
    },
  });
};

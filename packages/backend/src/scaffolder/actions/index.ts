import { createRouter } from '@backstage/plugin-scaffolder-backend';
import { Router } from 'express';
import { Logger } from 'winston';
import { CatalogClient } from '@backstage/catalog-client';
import { PluginTaskScheduler, UrlReader } from '@backstage/backend-common';
import { Config } from '@backstage/config';
import { createValidateTagsAction } from './validateTags';
import { createNotifyEvidenceAdapterAction } from './notifyEvidenceAdapter';

export async function createScaffolderRouterWithCustomActions(options: {
  logger: Logger;
  config: Config;
  reader: UrlReader;
  catalogClient: CatalogClient;
}): Promise<Router> {
  const { logger, config, reader, catalogClient } = options;

  const actions = [
    createValidateTagsAction(),
    createNotifyEvidenceAdapterAction({ logger, config }),
  ];

  return await createRouter({
    logger,
    config,
    reader,
    catalogClient,
    actions,
  });
}

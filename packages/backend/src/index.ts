import { createServiceBuilder, loadBackendConfig, ServerTokenManager, CacheManager, UrlReader, HostDiscovery, SingleHostDiscovery, TokenManager } from '@backstage/backend-common';
import { Logger } from 'winston';
import { Server } from 'http';
import { createRouter as createAppRouter } from '@backstage/plugin-app-backend';
import { createRouter as createProxyRouter } from '@backstage/plugin-proxy-backend';
import { createRouter as createAuthRouter } from '@backstage/plugin-auth-backend';
import { createRouter as createCatalogRouter } from '@backstage/plugin-catalog-backend';
import { createRouter as createScaffolderRouter } from '@backstage/plugin-scaffolder-backend';
import { createRouter as createTechdocsRouter } from '@backstage/plugin-techdocs-backend';
import { createRouter as createKubernetesRouter } from '@backstage/plugin-kubernetes-backend';
import { createRouter as createPermissionRouter } from '@backstage/plugin-permission-backend';
import { ServerPermissionPolicy } from './permission/ServerPermissionPolicy';

import express from 'express';

async function main() {
  const logger: Logger = (await import('@backstage/backend-common')).getRootLogger();
  const config = await loadBackendConfig({ logger });
  const app = express();

  const discovery = HostDiscovery.fromConfig(config);
  const cache = CacheManager.fromConfig(config).forPlugin('core');
  const tokenManager = ServerTokenManager.fromConfig(config, { logger });

  // App (static assets proxy)
  app.use(await createAppRouter({ logger, config }));

  // Auth (OIDC/GitHub configured via app-config)
  app.use('/auth', await createAuthRouter({ logger, config, discovery, tokenManager }));

  // Permission Framework
  app.use('/permission', await createPermissionRouter({
    config,
    logger,
    discovery,
    policy: new ServerPermissionPolicy(),
    tokenManager,
  }));

  // Proxy
  app.use('/proxy', await createProxyRouter({ logger, config }));

  // Catalog
  app.use('/catalog', await createCatalogRouter({ logger, config }));

  // Scaffolder
  app.use('/scaffolder', await createScaffolderRouter({ logger, config }));

  // TechDocs
  app.use('/techdocs', await createTechdocsRouter({ logger, config }));

  // Kubernetes
  app.use('/kubernetes', await createKubernetesRouter({ logger, config }));

  const service = createServiceBuilder(module)
    .setPort(Number(process.env.PORT || 7007))
    .addRouter('', app);

  let server: Server | undefined;
  try {
    server = await service.start().catch(err => {
      logger.error(err);
      process.exit(1);
    });
    logger.info('Backstage backend started');
  } catch (error) {
    logger.error(`Backend failed to start: ${error}`);
    process.exit(1);
  }

  function shutdown() {
    logger.info('Shutting down gracefully...');
    server?.close();
    process.exit(0);
  }
  process.on('SIGINT', shutdown);
  process.on('SIGTERM', shutdown);
}

main().catch(err => {
  // eslint-disable-next-line no-console
  console.error(err);
  process.exit(1);
});

import React from 'react';
import { createApp } from '@backstage/app-defaults';
import { AlertDisplay, OAuthRequestDialog } from '@backstage/core-components';
import { apis as appApis } from './apis';
import { FlatRoutes } from '@backstage/core-app-api';
import { Route } from 'react-router';
import { CatalogIndexPage, CatalogEntityPage } from '@backstage/plugin-catalog';
import { ApiExplorerPage } from '@backstage/plugin-api-docs';
import { ScaffolderPage } from '@backstage/plugin-scaffolder';
import { TechDocsIndexPage, TechDocsReaderPage } from '@backstage/plugin-techdocs';
import { KubernetesClusterPage } from '@backstage/plugin-kubernetes';

const app = createApp({
  apis: appApis,
});

const AppProvider = app.getProvider();
const AppRoutes = app.getRoutes();

export default function App() {
  return (
    <AppProvider>
      <AlertDisplay />
      <OAuthRequestDialog />
      <FlatRoutes>
        <Route path="/" element={<CatalogIndexPage />} />
        <Route path="/catalog/*" element={<CatalogIndexPage />} />
        <Route path="/entity/*" element={<CatalogEntityPage />} />
        <Route path="/api-docs" element={<ApiExplorerPage />} />
        <Route path="/create" element={<ScaffolderPage />} />
        <Route path="/techdocs" element={<TechDocsIndexPage />} />
        <Route path="/docs/*" element={<TechDocsReaderPage />} />
        <Route path="/kubernetes" element={<KubernetesClusterPage />} />
        <Route path="/*" element={<AppRoutes />} />
      </FlatRoutes>
    </AppProvider>
  );
}

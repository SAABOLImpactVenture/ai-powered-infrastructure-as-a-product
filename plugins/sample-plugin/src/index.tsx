import React from 'react';
import { Page, Header, Content } from '@backstage/core-components';

export const SamplePluginPage = () => (
  <Page themeId="tool">
    <Header title="Sample Plugin" subtitle="Drop-in example" />
    <Content>
      <p>Replace this with your plugin UI.</p>
    </Content>
  </Page>
);

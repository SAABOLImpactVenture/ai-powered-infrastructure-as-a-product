import {
  githubAuthApiRef,
  gitlabAuthApiRef,
  microsoftAuthApiRef,
} from '@backstage/core-plugin-api';
import { ApiHolder } from '@backstage/core-app-api';

export const apis: ApiHolder[] = [
  // Auth providers are configured via app-config*.yaml at runtime.
];

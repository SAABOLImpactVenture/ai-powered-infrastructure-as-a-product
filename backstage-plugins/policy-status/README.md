
# Policy Status Card (Backstage)

A lightweight React component to display policy status from the Policy Dashboard
(or directly from MCP policy servers).

## Usage

1. Copy this folder into your repo.
2. In your Backstage app frontend (`packages/app`), import and place the card
   on a page (e.g., in Home or a custom overview page).

```tsx
// packages/app/src/components/home/HomePage.tsx
import React from 'react';
import { PolicyStatusCard } from '../../../backstage-plugins/policy-status/PolicyStatusCard';

export const HomePage = () => (
  <>
    <PolicyStatusCard dashboardUrl={process.env.POLICY_DASHBOARD_URL || '/api/proxy/policy-dashboard'} />
  </>
);
```

### Option A: Call dashboard directly
Set an environment variable in the frontend:
```
POLICY_DASHBOARD_URL=http://localhost:8090
```

### Option B: Use Backstage proxy (recommended)
Add this to `app-config.yaml`:
```yaml
proxy:
  '/policy-dashboard':
    target: 'http://localhost:8090'
```

Then pass `/api/proxy/policy-dashboard` to the component (as shown above).

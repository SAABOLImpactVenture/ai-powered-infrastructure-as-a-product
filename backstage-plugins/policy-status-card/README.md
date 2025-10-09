# Backstage Policy Status Card

A minimal Backstage UI card that polls the policy aggregator (`/api/policy/aggregate`) and displays cloud statuses.

## Usage
```tsx
import { PolicyStatusCard } from '@your-org/policy-status-card';

<PolicyStatusCard endpoint="/api/policy/aggregate" title="Policy Status" />
```
Build with `yarn tsc -p backstage-plugins/policy-status-card/tsconfig.json` or integrate into your Backstage app package.json.
